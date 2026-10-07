# 원본 출처와 라이선스 고지

이 파일은 사용한 주요 원본과 그 원본이 명시한 라이선스를 기록합니다. 적용 범위와 원문은 각 저장소·설치 패키지에 포함된 라이선스 파일에서 확인할 수 있습니다.

| 원본 | 적용 범위와 라이선스 | 원문 출처 |
|---|---|---|
| Microban, Marc Duclusaud/Rhoban | 제어 소프트웨어 GPL-3.0; `cad/` 하드웨어 설계 CC-BY-NC-SA-4.0 | [저장소 LICENSE](https://github.com/Rhoban/microban/blob/d0a128d180ecfce69eaaf31b295a0fce31280bfd/LICENSE), [CAD LICENSE](https://github.com/Rhoban/microban/blob/d0a128d180ecfce69eaaf31b295a0fce31280bfd/cad/LICENSE) |
| mjlab_microban, Rhoban | Apache-2.0 | [LICENSE](https://github.com/Rhoban/mjlab_microban/blob/d594a6088bb7b6600fe8098321169031fbca680c/LICENSE) |
| Kimodo, NVIDIA Corporation & Affiliates | 추론 코드 Apache-2.0; 포함된 LLM2Vec 코드의 파일 헤더는 McGill NLP MIT | [LICENSE](https://github.com/nv-tlabs/kimodo/blob/58e781898b3d7e328a676a75d3e338c45dce3ad9/LICENSE), [LLM2Vec 파일 헤더](https://github.com/nv-tlabs/kimodo/blob/58e781898b3d7e328a676a75d3e338c45dce3ad9/kimodo/model/llm2vec/llm2vec.py) |
| Kimodo-G1-RP-v1 체크포인트, NVIDIA | NVIDIA Open Model License | [고정 revision의 모델 카드](https://huggingface.co/nvidia/Kimodo-G1-RP-v1/blob/3020ad8c419c244e0429d360163730c63c4ed011/README.md), [라이선스 원문](https://www.nvidia.com/en-us/agreements/enterprise-software/nvidia-open-model-license/) |
| Better Actuator Models, Rhoban | Apache-2.0 | [BAM LICENSE](https://github.com/Rhoban/bam/blob/0007411bd82c48f1bc12ae8382f98e4d8b879c95/LICENSE) |
| mjlab | Apache-2.0 | [mjlab LICENSE](https://github.com/mujocolab/mjlab/blob/v1.3.0/LICENSE); 설치 패키지 `mjlab-1.3.0.dist-info/licenses/LICENSE` |
| MuJoCo / MuJoCo Warp | Apache-2.0, 각 패키지의 추가 third-party 고지 포함 | [MuJoCo](https://github.com/google-deepmind/mujoco/blob/main/LICENSE), [MuJoCo Warp](https://github.com/google-deepmind/mujoco_warp/blob/main/LICENSE) |
| NVIDIA Warp | Apache-2.0, 번들 구성요소의 별도 고지 포함 | [Warp LICENSE](https://github.com/NVIDIA/warp/blob/main/LICENSE.md); 설치 패키지의 `licenses/` |
| PyTorch | BSD-3-Clause와 번들 구성요소 고지 | [PyTorch LICENSE](https://github.com/pytorch/pytorch/blob/v2.7.0/LICENSE); 설치 패키지의 `LICENSE`, `NOTICE` |
| Transformers / PEFT / Hugging Face Hub | Apache-2.0 | 각 설치 패키지의 `*.dist-info/licenses/LICENSE` |
| ImageIO / PyAV | ImageIO BSD-2-Clause; PyAV BSD-3-Clause와 영상 코덱의 별도 라이선스 | 각 설치 패키지의 `LICENSE` 또는 `LICENSE.txt` |

Microban와 mjlab_microban 원본은 `vendor/`에 그대로 보존했습니다. 이 프로젝트의 변경된 시뮬레이션 모델은 원본 모델의 출처와 수정 내역을 별도 audit JSON으로 기록합니다. 개별 원본의 라이선스 적용 경로는 그대로 유지됩니다.

## 교육용 묶음의 범위

이 교육 저장소의 한 발 서기 환경·PPO 소스와 설명은 Apache-2.0으로 제공합니다. XML 템플릿은 위의 고정 mjlab_microban 모델에서 변형한 모델이며, 기존 물리 설정을 보존하고 배포 시 경로를 템플릿으로 바꿨습니다. 원 모델 저작권: Rhoban / Marc Duclusaud. 원본 라이선스는 설치 시 가져오는 vendor/mjlab_microban/LICENSE에도 보존합니다.

`lessons/01-one-leg/data/kimodo_text_oneleg/oneleg_text_00.csv`는 NVIDIA 공식 Kimodo 공개 서비스에서 생성한 참조 출력입니다. 사전학습 모델 가중치는 재배포하지 않으며 모델의 라이선스가 위 고지에 기록되어 있습니다. 나머지 입력 JSON은 이 출력을 읽기 위한 열 이름과 최소 생성 요청 기록입니다. 원본 NPZ는 포함하지 않고 SHA256만 기록합니다.
