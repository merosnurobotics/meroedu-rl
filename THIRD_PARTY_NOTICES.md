# 원본 출처와 라이선스 고지

이 교육 저장소의 한 발 서기 환경·PPO 소스와 설명은 Apache-2.0으로 제공합니다. 외부 원본과 데이터의 적용 범위는 아래와 같습니다. 각 설치 패키지의 추가 고지도 그대로 유지합니다.

| 원본 | 사용 범위 | 라이선스·출처 |
|---|---|---|
| mjlab_microban, Rhoban / Marc Duclusaud | Microban 로봇 모델과 메시. XML 템플릿은 경로만 교육 폴더에 맞춰 바꾼 변형 모델이며 기존 물리 설정을 보존합니다. | [고정 커밋의 Apache-2.0 LICENSE](https://github.com/Rhoban/mjlab_microban/blob/d594a6088bb7b6600fe8098321169031fbca680c/LICENSE). 설치 시 원본 고지를 vendor/mjlab_microban/LICENSE에 유지합니다. |
| NVIDIA Kimodo 공개 서비스 | 문장으로 생성한 G1 참조 CSV. 모델 가중치나 추론 코드 전체는 재배포하지 않습니다. | [모델 카드](https://huggingface.co/nvidia/Kimodo-G1-RP-v1/blob/3020ad8c419c244e0429d360163730c63c4ed011/README.md), [NVIDIA Open Model License](https://www.nvidia.com/en-us/agreements/enterprise-software/nvidia-open-model-license/) |
| MuJoCo / MuJoCo Warp / NVIDIA Warp | 설치되는 CPU/GPU 물리 엔진 | Apache-2.0 및 각 패키지의 별도 third-party 고지 |
| PyTorch | 설치되는 정책 네트워크·학습 런타임 | BSD-3-Clause 및 번들 고지 |
| NumPy / SciPy | 수치 계산·자세 최적화 | 각 설치 패키지의 BSD 계열 고지 |
| ImageIO / Pillow / 영상 코덱 | 선택적 영상 렌더링 기능의 설치 의존성 | 각 설치 패키지의 LICENSE 및 코덱별 고지 |

`lessons/01-one-leg/data/kimodo_text_oneleg/oneleg_text_00_mujoco_rest_zero.csv`는 NVIDIA 공식 Kimodo 공개 서비스에서 생성한 참조 출력입니다. 원본 NPZ는 포함하지 않고 SHA256만 기록합니다. 입력 JSON은 CSV 열 이름과 최소 생성 요청(모델명·서비스 코드 커밋·문장)입니다. 서비스의 정확한 런타임 모델 바이트 해시는 공개되지 않아 서비스 커밋과 모델명만으로 그 해시를 증명하지 않습니다.
