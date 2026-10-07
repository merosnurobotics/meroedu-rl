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

## 학습·평가

```bash
bash scripts/practice.sh train
bash scripts/practice.sh evaluate
```

train은 CPU 물리 환경 64개, PPO 460회입니다. 오래 걸릴 수 있습니다. 처음에는 `scripts/one_leg_run.py --help`를 읽고 적은 반복 수와 새 출력 폴더를 쓰세요.

평가는 학습과 다른 seed 74201의 64개 초기조건에서 18초와 1N 외란을 사용합니다. 성공률뿐 아니라 넘어진 시점·발 접촉·토크·평가 조건도 함께 확인합니다. 모델과 reference의 SHA256을 저장하므로 다른 참조를 무심코 섞으면 실행을 거부합니다.

```bash
# 별도 GPU 환경으로 시작하려면 setup 단계부터 gpu를 선택합니다.
bash scripts/setup.sh gpu
# CPU 학습으로 초기 정책을 만든 뒤 실제 GPU 물리에서 추가 학습
bash scripts/practice.sh gpu
```

GPU 단계는 `runs/native/policy_final.pt`에서 120회 추가 학습하며 `runs/gpu/policy_final.pt`를 만듭니다. 이는 사이트에 보존된 사례를 따라가는 학습 절차이며 같은 수치 성능이나 바이트 단위 재현을 보장하지 않습니다. 사이트의 예전 외란 전·후 영상에는 피드백 계수 변경도 포함되어 있어 외란 학습 단독 효과로 해석하지 않습니다.

## 읽을 코드

| 파일 | 역할 |
|---|---|
| `scripts/one_leg_text_reference.py` | 이름별 관절 대응, 지지 다리 최적화, 참조 생성 |
| `src/microban_rl/one_leg.py` | CPU 환경, 관측/보상, 정책, PPO, 평가 |
| `src/microban_rl/one_leg_warp.py` | GPU 물리 실행과 PPO |
| `scripts/one_leg_run.py`, `one_leg_warp_run.py` | 실행 인자 |

영상·웹페이지는 저장소 밖의 교육 사이트에서 읽습니다. 실행에 필요한 소스와 입력만 담았습니다. 원 NPZ는 해시 확인에만 쓰여 제외했고, 원본 해시 값은 참조 생성 코드에 유지했습니다. 서비스 전체 기록도 필요한 세 필드만 남겼습니다. 입력 CSV 출처 및 코드 SHA256은 `UPSTREAM.json`, 라이선스는 루트의 THIRD_PARTY_NOTICES.md를 확인합니다. 로봇 모델은 원본 Apache-2.0 고지를 그대로 유지합니다.

패키징 검증은 소스 컴파일과 XML 경로 검사, 참조 재생성, CPU 1회 PPO에 한정합니다. 전체 460회/120회 학습이나 새 실제 로봇 검증을 완료했다는 뜻은 아닙니다.
