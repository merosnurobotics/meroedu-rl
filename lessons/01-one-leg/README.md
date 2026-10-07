# 01 · Kimodo 참조를 이용한 Microban 한 발 서기

이미 생성된 Kimodo G1 모션에서 한 발 자세를 추출해 Microban에 맞추고, MuJoCo에서 PPO 정책을 학습합니다. 첫 실습에서는 작은 CPU 실행으로 데이터→참조→학습 연결을 확인합니다. 전체 GPU 학습은 별도 단계입니다.

## 개념과 범위

- 참조: 따라가고 싶은 자세입니다. 이 회차는 2–5초 구간의 중앙값 자세를 추출한 **정적 자세 변환**입니다. 전체 시간 모션을 추종하는 리타기팅이 아닙니다.
- 관측: 정책이 읽는 상태(70차원). 행동: 19개 관절의 목표 각도 보정. 보상: 자세·균형·발 높이 등을 잘 유지할수록 받는 점수.
- PPO: 시뮬레이션에서 행동과 보상을 모아 정책을 조금씩 수정하는 방법입니다.
- CPU MuJoCo와 GPU MuJoCo Warp는 서로 다른 실행 경로입니다. CPU에서 정책 네트워크만 CUDA로 바꾸는 것은 GPU 물리 시뮬레이션이 아닙니다.
- 분석적 균형 피드백과 신경망을 함께 쓰는 제어기입니다. 모터는 이상적인 position actuator이며 실제 로봇 배포는 이번 회차 범위에 포함하지 않습니다.
- 저장된 CSV는 실제 NVIDIA 공개 서비스의 문장 생성 출력입니다. 이 실습은 서비스를 다시 호출하지 않습니다. 원 요청의 모델명·서비스 코드 커밋·문장은 최소 JSON으로 보존했습니다.

## 환경

Linux/WSL, Git, Python 3.12. CPU부터 시작할 수 있습니다. GPU 확장에는 CUDA를 지원하는 NVIDIA GPU/드라이버가 필요합니다. 기준 패키지 버전은 requirements 파일에 고정합니다.

```bash
# 이 README가 있는 lessons/01-one-leg에서 실행
bash scripts/setup.sh cpu
source .venv/bin/activate
bash scripts/practice.sh reference
bash scripts/practice.sh smoke
```

`setup.sh`는 Rhoban/mjlab_microban의 `d594a6088bb7b6600fe8098321169031fbca680c` 로봇 모델을 다운로드하고 XML 템플릿의 경로를 현재 위치로 채웁니다. 물리 파라미터는 바꾸지 않습니다. 새 위치에서 참조를 재생성하므로 옛 결과의 해시를 그대로 재현한다고 주장하지 않습니다.

참조 출력은 `runs/reference/reference.json`, 첫 1회 PPO 출력은 `runs/smoke/policy_final.pt`입니다. **1회 업데이트로 균형 성능을 기대하지 마세요.** 실행 연결 확인용입니다. 참조 폴더가 이미 있으면 스크립트가 재생성을 거부합니다. 기존 작업을 보존하고 새 출력 경로를 사용하세요.

## GPU 학습·CPU 교차 평가

CPU smoke는 실행 확인용입니다. 사이트의 본 학습은 CPU 정책에서 추가 학습하는 방식이 아니라, 미학습 신경망과 균형 피드백에서 시작한 GPU PPO 400회입니다.

```bash
# GPU용 환경을 선택해서 설치합니다.
bash scripts/setup.sh gpu
bash scripts/practice.sh initialize
bash scripts/practice.sh train
bash scripts/practice.sh evaluate
```

initialize는 seed 731로 신경망을 새로 만들고 해석적 균형 계수를 기록합니다. train은 MuJoCo Warp 물리 환경 64개, rollout32, 학습률0.0001, seed75401로 PPO400회(819,200 transitions)를 실행합니다. 균형 피드백은 고정하고 신경망 잔차·가치함수·행동 분포를 학습합니다. 외력은 넣지 않습니다.

evaluate는 다른 seed75501의 64개 초기 상태로 양발→왼발 전환을 GPU와 Native MuJoCo에서 각각 18초 평가합니다. 넘어짐·발 접촉·토크·평가 조건을 함께 확인합니다. 결과는 runs/gpu, runs/eval-gpu, runs/eval-native에 저장합니다. 사이트의64/64는 보존된 원 실험 결과이며 이 패키징에서 다시 측정한 수치가 아닙니다. 하드웨어 검증 결과도 아닙니다.

CSV는 G1 MuJoCo rest-zero 변환본을 사용하고, 자세 변환의 lift-scale은2.8입니다. 경로가 다른 새 머신에서 참조를 재생성하므로 가중치나 참조의 바이트 단위 동일성을 보장하지 않습니다. 작은 smoke와 달리 GPU 본 학습은 장시간 작업이므로 장비를 먼저 확인하세요.

## 읽을 코드

| 파일 | 역할 |
|---|---|
| `scripts/one_leg_text_reference.py` | 이름별 관절 대응, 지지 다리 최적화, 참조 생성 |
| `src/microban_rl/one_leg.py` | CPU 환경, 관측/보상, 정책, PPO, 평가 |
| `src/microban_rl/one_leg_warp.py` | GPU 물리 실행과 PPO |
| `scripts/one_leg_run.py`, `one_leg_warp_run.py` | 실행 인자 |

영상·웹페이지는 저장소 밖의 교육 사이트에서 읽습니다. 실행에 필요한 소스와 입력만 담았습니다. 원 NPZ는 해시 확인에만 쓰여 제외했고, 원본 해시 값은 참조 생성 코드에 유지했습니다. 서비스 전체 기록도 필요한 세 필드만 남겼습니다. 입력 CSV 출처 및 코드 SHA256은 `UPSTREAM.json`, 라이선스는 루트의 THIRD_PARTY_NOTICES.md를 확인합니다. 로봇 모델은 원본 Apache-2.0 고지를 그대로 유지합니다.

패키징 검증은 소스 컴파일과 XML 경로 검사, 참조 재생성, CPU 1회 PPO에 한정합니다. 전체 GPU 400회 학습이나 새 실제 로봇 검증을 완료했다는 뜻은 아닙니다.
