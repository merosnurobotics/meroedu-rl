# MERO 교육 · 강화학습

로봇 제어를 실습으로 배우는 강화학습 시리즈입니다. 회차마다 필요한 코드와 환경을 독립적으로 제공합니다.

| 회차 | 주제 | 시작점 |
|---|---|---|
| 01 | Kimodo 참조를 이용한 Microban 한 발 서기 | [실습 안내](lessons/01-one-leg/README.md) |

```bash
git clone https://github.com/merosnurobotics/meroedu-rl.git
cd meroedu-rl/lessons/01-one-leg
```

개념·실험 영상은 [MERO 교육](https://mero-website-one.vercel.app/education/reinforcement-learning/kimodo-mjwarp)에서 봅니다. 사이트 배포 전에는 이 링크가 열리지 않을 수 있습니다.

다음 회차는 `lessons/02-주제/`에 추가합니다. 현재 구현한 회차는 01뿐입니다. [회차 추가 규칙](CONTRIBUTING.md)을 따릅니다.

필요한 환경, 제어/학습 코드와 작은 참조 입력만 포함합니다. 영상, 과거 실험 결과, 정책 체크포인트, Kimodo 모델 가중치와 전체 외부 저장소는 넣지 않습니다. 필요한 외부 로봇 모델은 고정 커밋에서 설치 단계에 받습니다.
