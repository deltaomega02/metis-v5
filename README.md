# METIS V5 — 규칙 기반 현물 자동운용 (아카이브)

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)

BTC/ETH 추세추종 + BTC 펀딩 캐리(마켓 중립)를 병행하는 규칙 기반 시스템.

## 이 버전의 의미: AI를 제거한 결정

METIS 라인은 본래 AI가 매매를 판단하는 시스템이었다. 그러나 누적 거래 데이터를 분석한 결과
**AI 판단이 규칙 기반 전략 대비 우위가 없다**고 판명돼, **판단 경로에서** AI를 빼고
백테스트로 검증 가능한 규칙으로 전환했다. "AI를 쓰는 것"이 목적이 되지 않도록 도구를 데이터로 재평가한 결정.

> **정확히 하면** — "AI를 전부 제거"는 과한 표현이다. 매매 판단에서는 빠졌지만
> 일일 리포트 생성에는 `gemini-3.5-flash` 가 남아 있다(`src/daily_report.py:103`).
> 판단 경로와 보고 경로를 나눠서 읽어야 한다.

> **저장소 이름 주의** — 이 저장소의 실행 경로·systemd 유닛은 전부 `metis-v4` 를 가리킨다
> (`src/run_bot.sh:2`, `src/metis-v4-bot.service`). 내용물은 [metis](https://github.com/deltaomega02/metis)
> 저장소의 `v4/` 에 해당하고, 거기 있는 `v5/` 는 Gemini 스캘퍼라 **서로 다른 시스템이 같은 이름을 쓰고 있다.**

## 기술 스택

Python · Bybit API (현물 + 선물 헤지) · systemd (서비스 운영) · 자체 백테스트 (research/)

## 전략 구성과 동작 방식

서로 무상관인 두 전략을 50:50으로 병행한다. 무차입(레버리지 0).

| 전략 | 수익 원천 | 동작 |
|---|---|---|
| 추세추종 (`trend_bot.py`) | 상승장 추세 캡처 | 추세 지표 충족 시 현물 매수, 이탈 시 매도 — 단순한 규칙만 사용 |
| 펀딩 캐리 (`carry_bot.py`) | 가격과 무관한 펀딩비 수취 | 현물 매수 + 동량 선물 숏 (델타 중립) → 펀딩 정산 수취 |

추세 전략이 상승장을 잡고, 캐리 전략이 횡보·하락장에서 현금흐름을 만든다 — 시장 국면별 상호 보완.

```
[운영] systemd 서비스 (src/*.service)
  ├── trend_bot     # 라이브 운영
  ├── carry_bot     # 캐리 전략
  ├── dashboard     # 모니터링
  └── daily_report  # 일일 리포트 (systemd timer)
```

## 검증

- 전략 채택 전 `research/bt_*.py` 백테스트로 검증: 장기 히스토리(`bt_longhist`), 스트레스 구간(`bt_stress`), 전략 토너먼트(`bt_tournament`), 조합 효과(`bt_combine`, `bt_mix`) 등
- 결론과 근거 데이터: [`docs/findings.md`](docs/findings.md)
- 페이퍼 트레이딩 모드(`paper_*.py`)로 실자금 투입 전 검증

## 프로젝트 구조

```
metis-v5/
├── src/         # trend_bot / carry_bot / dashboard / daily_report + systemd 유닛
├── research/    # 백테스트 스크립트 + 전략 리서치 노트 (R1~R4)
└── docs/        # findings.md — 검증 데이터 정리
```

## 면책

연구·학습 목적의 개인 프로젝트입니다.
