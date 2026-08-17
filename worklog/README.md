# AI Session Logs (AI 작업 세션 기록)

AI 보조 세션의 주요 분석 결과·코드 변경·검증 결과를 이곳에 남깁니다.
세션이 끊겨도 **어떤 AI(회사/모델)가, 어떤 요청을 받아, 무엇을 실행했는지** 추적하기 위함입니다.
여러 인공지능 회사·언어모델을 함께 쓰므로, 각 로그에 사용한 AI를 반드시 명시합니다.

## 파일명 규칙 / File naming
- `YYYY-MM-DD_HH-mm.md`  (예: `2026-07-04_12-49.md`)
- 같은 날 여러 세션이면 시각으로 구분됩니다.

## 로그 필수 항목 / Required fields
프론트매터(머리말)에 **AI 신원**을 적습니다:
- `인공지능(에이전트)` — 예: Claude Code, ChatGPT, Gemini, Cursor 등
- `회사` — 예: Anthropic, OpenAI, Google, Alibaba 등
- `모델` — 예: Claude Opus 4.8, GPT-x, Gemini-x 등
- `보조 로컬 모델` — (있으면) 예: qwen3:8b, deepseek-r1:32b (Ollama)

본문에는 **요청사항 → 실행사항 → 결과**를 표로 정리하고, 필요한 상세를 덧붙입니다.
언어는 **한국어**로 작성합니다.

## 템플릿 / Template
```markdown
---
날짜: YYYY-MM-DD HH:mm (KST)
프로젝트: EXOTransit
인공지능(에이전트): <예: Claude Code>
회사: <예: Anthropic>
모델: <예: Claude Opus 4.8>
보조 로컬 모델: <예: qwen3:8b (Ollama) — 용도>
---

# AI 세션 로그 — YYYY-MM-DD HH:mm

## 요청사항 → 실행사항
| # | 요청사항(사용자) | 실행사항(AI) | 결과 |
|---|---|---|---|
| 1 | ... | ... | ... |

## 상세 기록
- ...

## 남은 작업 / follow-up
- [ ] ...
```
