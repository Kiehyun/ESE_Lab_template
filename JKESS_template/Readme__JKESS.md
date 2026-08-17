# JKESS Submission Template

한국지구과학회지(JKESS, Journal of the Korean Earth Science Society) 투고용 LaTeX 템플릿입니다. 기존 논문 내용은 제거하고, 새 원고를 작성할 때 필요한 학술지 정보와 편집 안내를 넣어 두었습니다.

> **빌드 한 번에 세 가지 원고가 나옵니다.** `.\JKESS_main_build.cmd`를 인자 없이 실행하면 **투고본(submission)·수정본(review)·최종본(final)** PDF가 한 번에 모두 생성됩니다. 특정 모드만 필요하면 인자(`submission`/`review`/`final`)를 붙입니다. 자세한 내용은 아래 Build 절을 참고하세요.

## 투고·심사 규정 (Documents/)

한국지구과학회 공식 투고규정 사본이 들어 있습니다(참고용 — 최신본은 학회 홈페이지 확인).
심사 절차(심사위원 구성·심사 기간·게재 판정 등)는 투고규정 문서 안에 함께 규정되어 있습니다.

- 투고규정(심사 절차 포함): [Documents/투고규정-지구과학회지.md](Documents/투고규정-지구과학회지.md)
- 온라인 투고·심사 시스템: <http://www.kess64.kr/>

## Journal and Society

JKESS는 한국지구과학회가 발행하는 학술지이며, 지구과학 및 지구과학교육 관련 연구를 다룹니다. 대기, 해양, 지질, 천문, 환경, 지구시스템 과학 연구와 지구과학 교수학습, 교육과정, 평가, 자료 해석, 모델링 연구에 적합합니다.

폴더 안의 `Documents/투고규정-지구과학회지.md`에는 투고규정 참고 문서를 남겨 두었습니다. 이 문서에는 온라인 투고, 원고 종류, 초록과 주요어, 표/그림 작성, 심사 및 교정 절차 같은 항목이 정리되어 있습니다. 실제 제출 전에는 한국지구과학회의 최신 공식 투고규정을 직접 찾아 다시 확인하세요.

## Submission Notes

- 원고가 어떤 지구 시스템, 관측 자료, 지구과학 개념, 또는 지구과학교육 문제와 연결되는지 서론에서 명확히 제시합니다.
- 온라인 투고 시스템, 원고 종류, 쪽수 제한, 초록과 주요어 길이, 저자소개 요구사항은 최신 규정을 확인합니다.
- 인간대상연구, 수업 적용 연구, 설문/면담 연구라면 IRB 승인 또는 심의면제 여부를 확인합니다.
- 그림과 표는 학회 규정에 맞추어 간결하게 작성하고, 축 이름, 단위, 자료 출처, 분석 기간을 빠뜨리지 않습니다.
- 제출 직전에는 학술지 홈페이지 또는 온라인 투고 시스템에서 최신 투고규정, 원고 양식, 표/그림 요구사항을 다시 확인합니다.
- 게재 확정 후 최종 제출 단계에서는 학회 요청에 맞추어 최종본을 아래아한글(HWP) 파일로 변환해 제출해야 할 수 있으므로, 최신 투고규정과 편집위원회 안내를 확인합니다.
- 투고본과 심사본에는 저자명, 소속, 연구비 정보, 사사 문구처럼 익명성을 해칠 수 있는 내용을 넣지 않습니다.

## Editing Notes

- 국문/영문 제목, 초록, 주제어는 `JKESS_main.tex`에서 한 번에 관리합니다.
- `DocMode`를 `submission`, `review`, `final`로 바꾸어 투고본, 수정본, 최종본을 생성할 수 있습니다.
- `submission`/`review` 모드에서는 저자 정보가 비워지고, `final` 모드에서만 저자 정보가 표시됩니다.
- 본문은 `sub/` 폴더의 장별 파일로 분리되어 있어 서론, 방법, 결과, 논의를 독립적으로 편집할 수 있습니다.
- 표와 그림 파일을 별도로 요구받을 수 있으므로, 원본 그림 파일과 데이터 출처를 제출 전 함께 정리합니다.
- 한국지구과학회지는 최종 조판에서 2단 편집을 사용하므로, 표와 그림은 `1.0\textwidth` 또는 `0.5\textwidth` 중 하나의 폭을 기준으로 그리는 것을 권장합니다. 지도, 복합 패널, 넓은 표는 `1.0\textwidth`, 한 단 안에서 읽히는 단순 그래프와 작은 표는 `0.5\textwidth`를 기준으로 잡으면 축 라벨, 단위, 범례의 가독성을 지키기 쉽습니다.

## Main Files

- `JKESS_main.tex`: 제목, 저자, 초록, 주제어, 문서 모드 설정
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

설치 방법은 [2-VSCODE_TeXLive_SETUP.md](../manual/2-VSCODE_TeXLive_SETUP.md)를 참고합니다. Windows에서는 `.\JKESS_main_build.cmd`를, macOS/Linux에서는 `./JKESS_main_build.sh`를 사용합니다.

## Build

```powershell
.\JKESS_main_build.cmd
```

전체 빌드를 실행하면 투고본, 수정본, 최종본 PDF가 각각 생성됩니다.

- `JKESS_main_submission.pdf`: 투고본
- `JKESS_main_review.pdf`: 수정본
- `JKESS_main_final.pdf`: 최종본

최종본 PDF는 원고 점검과 공유를 위한 산출물입니다. 실제 최종 제출은 학회 안내에 따라 아래아한글(HWP) 파일 변환본을 요구할 수 있으므로, 게재 확정 후 반드시 최신 투고규정과 편집위원회 안내를 확인하세요.

빌드 부산물 정리:

```powershell
.\JKESS_main_build.cmd clean
```

## 참고문헌 PDF 도구 (저장소 루트 `code/` 폴더)

저장소 루트의 공용 `code/` 폴더에 참고문헌 PDF를 관리하는 Python 스크립트 두 개가 들어 있습니다.

| 파일 | 역할 |
| --- | --- |
| `../code/rename_ref_pdfs_by_bib.py` | `sub/references.bib`의 BibTeX 항목과 `ref/` 폴더의 PDF를 대조하여, PDF 파일명을 `저자. (연도). 제목. 학술지.pdf` 형태의 읽기 쉬운 이름으로 정리합니다. 매칭, 미매칭, 누락 결과를 CSV 보고서로 남깁니다. |
| `../code/download_missing_ref_pdfs.py` | `references.bib`에는 있지만 `ref/` 폴더에 없는 참고문헌 PDF를 공개 접근(Open Access), DOI, 그리고 연구실 논문 검색 서버에서 자동으로 내려받습니다. |

### 필요한 모듈 설치

두 스크립트는 아래 Python 패키지를 사용합니다.

- `pymupdf` — PDF 본문 텍스트 추출 (파일명 매칭용)
- `pypdf` — PyMuPDF 실패 시 보조 텍스트 추출
- `requests` — 논문 다운로드 (download 스크립트 전용)

Python 3.10 이상에서 아래처럼 설치합니다. 이 저장소의 [3-PYTHON_CONDA_VSCODE_SETUP.md](../manual/3-PYTHON_CONDA_VSCODE_SETUP.md)를 따라 만든 `knue-python` conda 환경에서 실행하는 것을 권장합니다.

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
python ../code/rename_ref_pdfs_by_bib.py --dry-run
# 실제로 이름 변경
python ../code/rename_ref_pdfs_by_bib.py

# 2) 빠진 참고문헌 PDF 내려받기 (먼저 후보만 확인)
python ../code/download_missing_ref_pdfs.py --dry-run
# 실제로 내려받기
python ../code/download_missing_ref_pdfs.py
```

`--bib`, `--ref-dir` 등 전체 옵션은 `--help`로 확인합니다.

```powershell
python ../code/rename_ref_pdfs_by_bib.py --help
python ../code/download_missing_ref_pdfs.py --help
```

### 연구실 논문 검색 서버 비밀번호

`download_missing_ref_pdfs.py`는 공개 출처와 함께 연구실 논문 검색 서버(`parksparks`)도 확인합니다. 이 서버는 로그인이 필요하며, 비밀번호는 코드에 적지 않고 아래 두 방법 중 하나로 제공합니다.

- 환경 변수 `PARKSPARKS_PASSWORD`에 비밀번호를 설정합니다.
- 또는 `../code/.parksparks_secret` 파일에 비밀번호를 한 줄로 저장합니다. 이 파일은 `.gitignore`에 등록되어 있어 저장소에는 올라가지 않습니다.

비밀번호를 제공하지 않거나 틀리면, 검색 서버는 건너뛰고 공개 출처만으로 다운로드를 계속 시도합니다. 비밀번호는 연구실 담당자에게 확인하세요.
