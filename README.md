# 한국교원대학교 지구과학교육 연구실 LaTeX 템플릿 모음

이 저장소는 한국교원대학교 지구과학교육 연구실에서 사용하는 LaTeX 문서 템플릿과 초보자용 작업 안내문을 모아 둔 공간입니다.

> 🗺️ **볼트 지도(MOC):** 볼트 전체를 한눈에 탐색하려면 [_MOC.md](_MOC.md)를 여세요. (Obsidian에서 열면 그래프로 연결됩니다.)

> **권장 사용 방식 — Obsidian 볼트로 열기.** 이 저장소는 그 자체로 하나의 **Obsidian 볼트**입니다(볼트 설정 `.obsidian/`이 함께 들어 있어 내려받으면 바로 볼트가 됩니다). 내려받은 뒤 **Obsidian에서 폴더째 "Open folder as vault"로 여는 것을 기본 사용 방식으로 권장합니다.** 그러면 템플릿·안내문·문헌 노트·연구 일지·AI 작업 일지가 한 화면에서 연결됩니다. LaTeX 편집과 빌드는 그대로 VS Code나 Overleaf에서 하면 되고, 두 도구를 함께 열어 두어도 충돌하지 않습니다. 자세한 방법은 [4-OBSIDIAN_VAULT_SETUP.md](manual/4-OBSIDIAN_VAULT_SETUP.md)를 참고하세요.

처음 사용하는 경우에는 아래 순서대로 문서를 확인하면 됩니다.

## 빠른 시작

| 목적 | 먼저 볼 문서 |
| --- | --- |
| Overleaf에서 학위논문 프로젝트 만들기 | [1-OVERLEAF_THESIS_PROJECT.md](manual/1-OVERLEAF_THESIS_PROJECT.md) |
| Windows 개인 PC에 LaTeX을 설치해서 학위논문 작성하기 | [2-VSCODE_TeXLive_SETUP.md](manual/2-VSCODE_TeXLive_SETUP.md) |
| Python, conda, VS Code로 데이터 분석 환경 만들기 | [3-PYTHON_CONDA_VSCODE_SETUP.md](manual/3-PYTHON_CONDA_VSCODE_SETUP.md) |
| 이 저장소를 Obsidian 볼트로 열어 문헌 노트·연구 일지 관리하기 | [4-OBSIDIAN_VAULT_SETUP.md](manual/4-OBSIDIAN_VAULT_SETUP.md) |
| VS Code PowerShell에서 Claude Code(AI 코딩 에이전트) 설치·사용하기 | [5-CLAUDE_CODE_SETUP.md](manual/5-CLAUDE_CODE_SETUP.md) |
| 이 볼트를 사람+AI가 함께 쓰는 위키(llmwiki)로 활용하기 | [6-LLMWIKI_GUIDE.md](manual/6-LLMWIKI_GUIDE.md) |
| KNUE_thesis 템플릿 파일 구조·빌드·석사박사 전환 등 양식 사용법 | [7-KNUE_THESIS_TEMPLATE_USAGE.md](manual/7-KNUE_THESIS_TEMPLATE_USAGE.md) |
| 한국교원대학교 학위논문 템플릿 파일별 작성법 보기 | [KNUE_thesis/Readme__KNUEthesis.md](KNUE_thesis/Readme__KNUEthesis.md) |

처음 학위논문을 작성한다면 **1번 Overleaf 방식**으로 먼저 PDF를 만들어 보는 것을 권장합니다. 개인 PC에 LaTeX을 직접 설치해 장기적으로 관리하려면 2번 문서를 따라가면 됩니다. 논문 자료 분석이나 그래프 작성에 Python을 사용할 때는 3번 문서를 참고합니다.

## 포함된 템플릿

| 폴더 | 내용 |
| --- | --- |
| `KNUE_thesis/` | 한국교원대학교 석사/박사 학위논문 LaTeX 템플릿 |
| `KNUE_beamer/` | 학위논문 발표용 Beamer 슬라이드 템플릿 |
| `KNUE_poster/` | 학술 포스터 LaTeX 템플릿 |
| `JKASE_template/` | 한국과학교육학회지 투고 원고 템플릿 |
| `JKESS_template/` | 한국지구과학회지 투고 원고 템플릿 |
| `TPT_template/` | *The Physics Teacher* 투고 원고 템플릿 |
| `RISE_template/` | *Research in Science Education* (Springer) 투고 원고 템플릿 |

### 하나의 볼트에서 연구의 전 과정을 함께

이 저장소는 템플릿을 하나씩 떼어 쓰기 위한 모음이라기보다, **연구의 전 과정을 하나의 Obsidian 볼트 안에서** 이어가도록 설계되었습니다. 연구 계획서(프로포절) → 중간·결과 발표 → 학위논문 작성 → 학술지 투고·발표까지 같은 볼트 안에서 단계별로 진행되며, 각 단계에서 알맞은 템플릿 폴더를 **그 자리에서** 사용합니다.

| 연구 단계 | 사용하는 폴더 |
| --- | --- |
| 연구 계획서·중간/결과 발표 슬라이드 | `KNUE_beamer/` |
| 학술 포스터 | `KNUE_poster/` |
| 학위논문 작성 | `KNUE_thesis/` |
| 학술지 투고 (국내) | `JKASE_template/`, `JKESS_template/` |
| 학술지 투고 (해외) | `TPT_template/`, `RISE_template/` |

- **참고문헌은 한곳에 모읍니다.** 읽은 논문 PDF는 공용 폴더(`References/`) 하나에 모으고, APA7 방식으로 `저자_연도-논문제목.pdf`(파일명은 70바이트 이내)로 이름을 정한 뒤, **같은 이름의 `.md` 파일**에 논문 요약을 적어 둡니다. 이렇게 하면 Obsidian 볼트에서 문헌을 연결·검색하고 인용키와 연동하기 좋습니다.
- **AI 작업은 worklog에 정리합니다.** Claude Code·GPT Codex·GitHub Copilot 등 AI의 도움으로 작성·분석한 내역은 `worklog/`에 **어떤 AI가 무엇을 했는지** 체계적으로 남깁니다(연구윤리의 생성형 AI 사용 명시 근거로도 쓰입니다).
- **AI를 쓰려면 Python 환경부터 준비합니다.** Claude Code·GPT Codex·GitHub Copilot 같은 AI 도구의 도움을 원활히 받으려면, 먼저 **Python을 설치하고 가상환경(conda 등)을 구성**해 두는 것이 좋습니다 → [3-PYTHON_CONDA_VSCODE_SETUP.md](manual/3-PYTHON_CONDA_VSCODE_SETUP.md).
- **Claude Code 설치·사용법**은 Windows VS Code PowerShell 기준으로 정리해 두었습니다 → [5-CLAUDE_CODE_SETUP.md](manual/5-CLAUDE_CODE_SETUP.md).

> 볼트 전체를 그대로 두고 작업하는 것을 권장하지만, 특정 양식만 따로 관리하거나 Overleaf에 올리려면 해당 폴더만 복사해 별도 작업 폴더로 써도 됩니다. 이때는 그 폴더 안의 파일과 폴더가 프로젝트 최상위에 오도록 준비합니다(각 템플릿 폴더는 단독으로도 빌드됩니다).

볼트 활용법(문헌 노트·연구 일지·AI 작업 일지)의 자세한 안내는 [4-OBSIDIAN_VAULT_SETUP.md](manual/4-OBSIDIAN_VAULT_SETUP.md)를 참고하세요.

## 학위논문 작성

한국교원대학교 학위논문 작성은 `KNUE_thesis/` 템플릿을 기준으로 합니다.

처음 프로젝트를 만들 때:

- Overleaf 사용: [1-OVERLEAF_THESIS_PROJECT.md](manual/1-OVERLEAF_THESIS_PROJECT.md)
- Windows 로컬 설치 사용: [2-VSCODE_TeXLive_SETUP.md](manual/2-VSCODE_TeXLive_SETUP.md)

템플릿 내부 파일을 수정할 때:

- 장별로 무엇을 써야 하는지(과학교육 논문 작성법): [KNUE_thesis/Readme__KNUEthesis.md](KNUE_thesis/Readme__KNUEthesis.md)
- 파일 구조, 빌드 방법, 석사/박사 전환, 인용·표·그림 LaTeX 명령(양식 사용법): [manual/7-KNUE_THESIS_TEMPLATE_USAGE.md](manual/7-KNUE_THESIS_TEMPLATE_USAGE.md)
- 메인 파일: `KNUE_thesis/KNUE_thesis_main.tex`
- 기본 정보 입력: `KNUE_thesis/sub/0-preamble.tex`
- 참고문헌 파일: `KNUE_thesis/sub/references.bib`

## Python 데이터 분석

논문 작성 중 자료 분석, 그래프 작성, ENA 스타일 네트워크 예제 실행, AI 확장으로 Python 코드 요청하기는 [3-PYTHON_CONDA_VSCODE_SETUP.md](manual/3-PYTHON_CONDA_VSCODE_SETUP.md)를 확인합니다.

이 문서에는 다음 내용이 들어 있습니다.

- Miniconda 또는 Anaconda 설치
- VS Code와 Python 확장 설치
- conda 가상환경 만들기
- Python 파일 작성과 실행
- `matplotlib` 그래프 예제
- AI 확장에게 분석 코드 요청하기
- ENA 스타일 네트워크 그림 예제

## 발표, 포스터, 학술지 템플릿

각 템플릿의 자세한 사용법은 해당 폴더의 README 또는 메인 `.tex` 파일 상단 안내를 확인합니다.

| 템플릿 | 안내 문서 |
| --- | --- |
| `KNUE_beamer/` | [KNUE_beamer/Readme__KNUEbeamer.md](KNUE_beamer/Readme__KNUEbeamer.md) |
| `KNUE_poster/` | [KNUE_poster/README__KNUEposter.md](KNUE_poster/README__KNUEposter.md) |
| `JKASE_template/` | [JKASE_template/Readme__JKASE.md](JKASE_template/Readme__JKASE.md) |
| `JKESS_template/` | [JKESS_template/Readme__JKESS.md](JKESS_template/Readme__JKESS.md) |
| `TPT_template/` | [TPT_template/Readme__TPT.md](TPT_template/Readme__TPT.md) |
| `RISE_template/` | [RISE_template/Readme__RISE.md](RISE_template/Readme__RISE.md) |

투고 전에는 각 학술지의 최신 공식 투고규정, 연구윤리 지침, 저작권 요구사항을 직접 확인해야 합니다. 이 저장소의 템플릿은 원고 작성을 돕는 출발점입니다.

## 저장소 구조

```text
ESE_Lab_template/
├─ README.md             # 저장소 소개 · 길잡이 (지금 이 문서)
├─ manual/               # 사용 설명서 모음 (아래 안내 문서를 한곳에)
│   ├─ 1-OVERLEAF_THESIS_PROJECT.md
│   ├─ 2-VSCODE_TeXLive_SETUP.md
│   ├─ 3-PYTHON_CONDA_VSCODE_SETUP.md
│   ├─ 4-OBSIDIAN_VAULT_SETUP.md
│   ├─ 5-CLAUDE_CODE_SETUP.md
│   ├─ 6-LLMWIKI_GUIDE.md
│   └─ 7-KNUE_THESIS_TEMPLATE_USAGE.md
├─ .obsidian/            # Obsidian 볼트 설정 (이 저장소 = 하나의 볼트)
├─ worklog/              # 연구·작업 일지 · AI 작업 일지 (날짜별 .md)
├─ References/            # 공용 참고문헌 (저자_연도-제목.pdf + 같은 이름 요약 .md)
├─ code/                 # 공용 파이썬 도구 (참고문헌 PDF 정리·다운로드 등, 원고 폴더에서 실행)
├─ KNUE_thesis/
├─ KNUE_beamer/
├─ KNUE_poster/
├─ JKASE_template/
├─ JKESS_template/
├─ TPT_template/
└─ RISE_template/
```

> 이 저장소 전체는 하나의 **Obsidian 볼트**이기도 합니다. 마크다운 노트로 문헌 정리와
> 연구 일지를 관리하는 방법은 [4-OBSIDIAN_VAULT_SETUP.md](manual/4-OBSIDIAN_VAULT_SETUP.md)를
> 참고하세요.

## 공식 링크

- 이 저장소: https://github.com/Kiehyun/ESE_Lab_template
- Overleaf: https://www.overleaf.com/
- TeX Live: https://tug.org/texlive/
- VS Code: https://code.visualstudio.com/
- Miniconda: https://www.anaconda.com/docs/getting-started/miniconda/install
