# 패키징 검증 · 2026-10-08

- 포함 Python 소스 구문 검사와 Bash 문법 검사 통과.
- 고정 커밋의 mjlab_microban 모델을 교육 폴더에 새로 clone.
- 새 폴더에서 XML 템플릿 처리 후 참조 재생성 통과: 관절 범위 위반 0, 자기 충돌 없음.
- CPU 물리, 환경 2개, PPO 1회 실제 실행으로 runs/smoke/policy_final.pt 생성.
- 실행에는 기존 검증 환경을 사용: Python 3.12, torch 2.7.0+cu128, numpy 2.3.5, scipy 1.18.1, mujoco 3.8.1. 패키지를 새로 내려받는 CPU 설치 전체는 실행하지 않음.
- 전체 GPU400회 학습, 실물 로봇 성능은 이번 패키징에서 다시 측정하지 않음.
- runs/vendor/가상환경/생성 XML/가중치는 커밋하지 않음.

- 최신 rest-zero CSV/lift-scale2.8 참조 재생성도 통과: 관절 범위 위반0, 자기 충돌 없음.
