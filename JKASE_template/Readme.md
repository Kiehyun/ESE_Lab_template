# JKASE Submission Template

한국과학교육학회지(JKASE, Journal of the Korean Association for Science Education) 투고용 LaTeX 템플릿입니다. 기존 논문 내용은 제거하고, 새 원고를 작성할 때 필요한 학술지 정보와 편집 안내를 넣어 두었습니다.

## Journal and Society

JKASE는 한국과학교육학회가 발행하는 과학교육 분야 학술지입니다. 과학 교수학습, 교육과정, 평가, 교사교육, 과학영재교육, 과학문화, 과학교육 정책, 학습자의 개념 이해와 탐구 역량처럼 과학교육 전반의 연구에 적합합니다.

투고 전에는 한국과학교육학회와 JKASE JAMS의 최신 투고규정을 직접 찾아 확인하세요. 원고 유형, 초록 요구사항, 참고문헌 양식, 익명 심사본 제출 방식, 연구윤리 및 저작권 확인 절차는 최신 학회 안내가 우선합니다.

## Submission Notes

- 원고가 JKASE 독자에게 어떤 과학교육 문제를 해결하거나 설명하는지 서론에서 분명히 드러냅니다.
- 투고본과 심사본에는 학교명, 지역명, 연구자 이름, 연구비 정보, 사사 문구처럼 저자를 추정할 수 있는 표현을 넣지 않습니다.
- 국문/영문 제목, 초록, 주제어는 `JKASE_main.tex`에서 한 번에 관리합니다.
- 참고문헌은 본문 인용과 목록이 1:1로 대응되는지 제출 전에 확인합니다.
- 제출 직전에는 학술지 홈페이지 또는 온라인 투고 시스템에서 최신 투고규정, 원고 양식, 표/그림 요구사항을 다시 확인합니다.
- 게재 확정 후 최종 제출 단계에서는 학회 요청에 맞추어 최종본을 아래아한글(HWP) 파일로 변환해 제출해야 할 수 있으므로, 최신 투고규정과 편집위원회 안내를 확인합니다.
- 최종 제출 전에는 온라인 투고 시스템의 파일 형식, 저자 정보 입력, 저작권 동의, 연구윤리 확인 항목을 다시 점검합니다.

## Editing Notes

- `DocMode`를 `submission`, `review`, `final`로 바꾸어 투고본, 수정본, 최종본을 생성할 수 있습니다.
- `submission`/`review` 모드에서는 저자 정보가 비워지고, `final` 모드에서만 저자 정보가 표시됩니다.
- 본문은 `sub/` 폴더의 장별 파일로 분리되어 있어 서론, 방법, 결과, 논의를 독립적으로 편집할 수 있습니다.
- 표와 그림은 본문에서 반드시 언급하고, 제목, 주석, 단위, 약어 설명을 일관되게 작성합니다.
- 한국과학교육학회지는 최종 조판에서 2단 편집을 사용하므로, 표와 그림은 `1.0\textwidth` 또는 `0.5\textwidth` 중 하나의 폭을 기준으로 그리는 것을 권장합니다. 두 단 폭이 필요한 복잡한 그림과 표는 `1.0\textwidth`, 한 단 안에서 읽히는 작은 그림과 표는 `0.5\textwidth`를 기준으로 잡으면 조판 후 가독성을 지키기 쉽습니다.
- 최종본으로 넘어갈 때 저자 정보, 사사, 연구비 과제번호, 부록, 보충자료 링크를 복원합니다.

## Main Files

- `JKASE_main.tex`: 제목, 저자, 초록, 주제어, 문서 모드 설정
- `sub/0-preamble.tex`: 패키지, 글꼴, 표/그림, 참고문헌 설정
- `sub/1-Introduction.tex`: 서론 및 연구 목적
- `sub/3-Methods.tex`: 연구 방법
- `sub/4-Results.tex`: 연구 결과
- `sub/5-Discussion.tex`: 논의 및 결론
- `sub/references.bib`: 참고문헌 BibLaTeX 항목

## 빌드 준비물 (Prerequisites)

이 템플릿은 **LuaLaTeX**와 **biber**로 빌드합니다. `pdfLaTeX`나 `XeLaTeX`로는 한글 글꼴과 참고문헌이 제대로 처리되지 않습니다. 빌드 전에 아래가 준비되어 있어야 합니다.

- TeX Live(전체 설치 권장) 또는 MiKTeX 같은 LaTeX 배포판
- `lualatex`, `biber`, `latexmk`가 PATH에 등록되어 있을 것 (빌드 스크립트가 이 셋을 먼저 확인하고 없으면 멈춥니다)

설치 방법은 [2-VSCODE_TeXLive_SETUP.md](../2-VSCODE_TeXLive_SETUP.md)를 참고합니다. Windows에서는 `.\JKASE_main_build.cmd`를, macOS/Linux에서는 `./JKASE_main_build.sh`를 사용합니다.

## Build

```powershell
.\JKASE_main_build.cmd
```

전체 빌드를 실행하면 투고본, 수정본, 최종본 PDF가 각각 생성됩니다.

- `JKASE_main_submission.pdf`: 투고본
- `JKASE_main_review.pdf`: 수정본
- `JKASE_main_final.pdf`: 최종본

최종본 PDF는 원고 점검과 공유를 위한 산출물입니다. 실제 최종 제출은 학회 안내에 따라 아래아한글(HWP) 파일 변환본을 요구할 수 있으므로, 게재 확정 후 반드시 최신 투고규정과 편집위원회 안내를 확인하세요.

빌드 부산물 정리:

```powershell
.\JKASE_main_build.cmd clean
```

## 참고문헌 PDF 도구 (code 폴더)

`code/` 폴더에는 참고문헌 PDF를 관리하는 Python 스크립트 두 개가 들어 있습니다.

| 파일 | 역할 |
| --- | --- |
| `code/rename_ref_pdfs_by_bib.py` | `sub/references.bib`의 BibTeX 항목과 `ref/` 폴더의 PDF를 대조하여, PDF 파일명을 `저자. (연도). 제목. 학술지.pdf` 형태의 읽기 쉬운 이름으로 정리합니다. 매칭, 미매칭, 누락 결과를 CSV 보고서로 남깁니다. |
| `code/download_missing_ref_pdfs.py` | `references.bib`에는 있지만 `ref/` 폴더에 없는 참고문헌 PDF를 공개 접근(Open Access), DOI, 그리고 연구실 논문 검색 서버에서 자동으로 내려받습니다. |

### 필요한 모듈 설치

두 스크립트는 아래 Python 패키지를 사용합니다.

- `pymupdf` — PDF 본문 텍스트 추출 (파일명 매칭용)
- `pypdf` — PyMuPDF 실패 시 보조 텍스트 추출
- `requests` — 논문 다운로드 (download 스크립트 전용)

Python 3.10 이상에서 아래처럼 설치합니다. 이 저장소의 [3-PYTHON_CONDA_VSCODE_SETUP.md](../3-PYTHON_CONDA_VSCODE_SETUP.md)를 따라 만든 `knue-python` conda 환경에서 실행하는 것을 권장합니다.

```powershell
conda activate knue-python
pip install pymupdf pypdf requests
```

conda를 쓰지 않는다면, 사용 중인 Python에 같은 명령으로 설치합니다.

```powershell
pip install pymupdf pypdf requests
```

Windows에서 `python` 입력 시 Microsoft Store 안내 창만 열리고 실행되지 않으면, conda 환경을 활성화했는지 또는 Python이 설치되어 PATH에 등록되어 있는지 확인합니다.

### 실행 방법

템플릿 폴더를 작업 폴더로 열고 그 위치에서 실행합니다. 처음에는 파일을 실제로 바꾸지 않는 `--dry-run`으로 먼저 확인하는 것이 안전합니다.

```powershell
# 1) ref 폴더 PDF 이름 정리 (먼저 미리보기)
python code/rename_ref_pdfs_by_bib.py --dry-run
# 실제로 이름 변경
python code/rename_ref_pdfs_by_bib.py

# 2) 빠진 참고문헌 PDF 내려받기 (먼저 후보만 확인)
python code/download_missing_ref_pdfs.py --dry-run
# 실제로 내려받기
python code/download_missing_ref_pdfs.py
```

`--bib`, `--ref-dir` 등 전체 옵션은 `--help`로 확인합니다.

```powershell
python code/rename_ref_pdfs_by_bib.py --help
python code/download_missing_ref_pdfs.py --help
```

### 연구실 논문 검색 서버 비밀번호

`download_missing_ref_pdfs.py`는 공개 출처와 함께 연구실 논문 검색 서버(`parksparks`)도 확인합니다. 이 서버는 로그인이 필요하며, 비밀번호는 코드에 적지 않고 아래 두 방법 중 하나로 제공합니다.

- 환경 변수 `PARKSPARKS_PASSWORD`에 비밀번호를 설정합니다.
- 또는 `code/.parksparks_secret` 파일에 비밀번호를 한 줄로 저장합니다. 이 파일은 `.gitignore`에 등록되어 있어 저장소에는 올라가지 않습니다.

비밀번호를 제공하지 않거나 틀리면, 검색 서버는 건너뛰고 공개 출처만으로 다운로드를 계속 시도합니다. 비밀번호는 연구실 담당자에게 확인하세요.
