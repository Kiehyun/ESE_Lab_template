# 한국교원대학교 학위논문 Beamer 발표 LaTeX 템플릿

이 폴더는 한국교원대학교 석사/박사 학위논문 발표를 위한 Beamer 기반 LaTeX 템플릿입니다.
`sub/preamble_beamer.tex`에서 변수만 바꾸면 논문 프로포절 발표와 논문 결과발표를 모두 같은 양식으로 사용할 수 있습니다.

This folder provides a Beamer-based LaTeX template for KNUE master's thesis and doctoral dissertation presentations.
By changing variables in `sub/preamble_beamer.tex`, the same template can be used for proposal presentations and result presentations.

## 주요 파일 / Main Files

| 파일 또는 폴더 / File or Folder | 역할 / Purpose |
| --- | --- |
| `KNUE_beamer_main.tex` | 발표 전체를 조립하는 메인 파일입니다. / Main file that assembles the presentation. |
| `KNUE_beamer_class.cls` | KNUE 로고, 색상, 사이드바, 글꼴, 제목 페이지를 정의하는 Beamer 클래스입니다. / Beamer class for the KNUE logo, colors, sidebar, fonts, and title page. |
| `sub/preamble_beamer.tex` | 석사/박사, 프로포절/결과발표, 제목, 저자, 지도교수, 소속, 참고문헌, 발표자 노트 설정을 입력합니다. / Shared degree, stage, metadata, bibliography, and speaker-note settings. |
| `sub/1-Intro_beamer.tex` | 서론과 연구 문제 슬라이드입니다. / Introduction and research-question slides. |
| `sub/2-Theoretical_background_beamer.tex` | 이론적 배경과 분석틀 슬라이드입니다. / Theoretical background and framework slides. |
| `sub/3-Methods_beamer.tex` | 연구 설계, 자료 수집, 분석 방법 슬라이드입니다. / Research design, data collection, and analysis slides. |
| `sub/4-Results_beamer.tex` | 프로포절에서는 예상 결과, 결과발표에서는 연구 결과 슬라이드로 동작합니다. / Expected-results slides in proposal mode and research-results slides in result mode. |
| `sub/5-Conclusion_beamer.tex` | 결론 요약과 질의응답 슬라이드입니다. / Summary and Q&A slides. |
| `sub/references.bib` | 한국어/영어 문헌을 함께 넣는 BibTeX 파일입니다. 한국어 문헌은 `kor_` 접두어와 `langid = {korean}`, 영어 문헌은 `eng_` 접두어와 `langid = {english}`를 사용합니다. / BibTeX database for Korean and English references. |
| `logo/` | 발표 표지와 사이드바에 사용할 로고 파일입니다. / Logo files used in the title slide and sidebar. |

## 처음 수정할 곳 / First Places to Edit

처음 사용할 때는 `sub/preamble_beamer.tex`의 정보를 먼저 바꿉니다.
석사/박사 구분은 논문 템플릿과 같이 `\degreeProgramKor`에서 선택합니다.

```tex
\providecommand{\degreeProgramKor}{박사}       % 석사 또는 박사
\providecommand{\presentationStage}{proposal} % proposal 또는 result
\providecommand{\BeamerTitleKor}{학위논문 발표 제목}
\providecommand{\BeamerTitleEng}{Thesis or Dissertation Presentation Title}
\providecommand{\BeamerAuthor}{홍 길 동}
\providecommand{\BeamerAdvisor}{지도교수: 성 춘 향}
\providecommand{\BeamerInstitute}{한국교원대학교 지구과학교육전공}
```

Use `proposal` for a thesis/dissertation proposal presentation and `result` for a result or defense presentation.
After editing these values, replace the placeholder slides in `sub/` with your own presentation content.

## 참고문헌과 인용 / References and Citations

참고문헌은 논문 템플릿과 같은 방식으로 한국어 문헌과 영어 문헌을 나누어 관리합니다.

| 문헌 언어 / Language | 파일 / File | 인용 명령 / Citation Commands |
| --- | --- | --- |
| 한국어 문헌 / Korean | `sub/references.bib` | `\ktextcite{kor_key}`, `(\kparencite{kor_key})` |
| 영어 문헌 / English | `sub/references.bib` | `\textcite{eng_key}`, `(\parencite{eng_key})` |

`references.bib`에는 한국어와 영어 문헌을 함께 넣습니다. 한국어 문헌에는 `kor_` 접두어와 `langid = {korean}`을, 영어 문헌에는 `eng_` 접두어와 `langid = {english}`를 넣습니다.

```tex
% 한국어 문헌
\ktextcite{kor_seo2009science}
(\kparencite{kor_seo2009science})

% 영어 문헌
\textcite{eng_nrc2012framework}
(\parencite{eng_nrc2012framework})

% 한국어와 영어 문헌을 함께 인용
(\kparencite{kor_seo2009science}; \parencite{eng_nrc2012framework})
```

이 템플릿에서는 논문 템플릿과 동일하게 `\kparencite`와 `\parencite`가 바깥 괄호를 자동으로 출력하지 않습니다. 여러 문헌을 한 괄호 안에 섞어 쓸 수 있도록 괄호는 슬라이드 본문에서 직접 입력합니다.

References are managed together in `sub/references.bib`, following the thesis template. In this template, `\kparencite` and `\parencite` do not print outer parentheses automatically, so write parentheses directly in the slide text when needed.

## 발표 종류 변수 / Presentation Stage Variable

| 원하는 발표 / Presentation | 설정값 / Value | 자동 반영되는 문구 / Automatic Labels |
| --- | --- | --- |
| 논문 프로포절 발표 / Proposal presentation | `\providecommand{\presentationStage}{proposal}` | `연구계획 발표`, `예상 결과`, `예상 산출물`, `연구 일정`, `기대 효과` |
| 논문 결과발표 / Result presentation | `\providecommand{\presentationStage}{result}` | `결과발표`, `연구 결과`, `주요 결과`, `결과 해석`, `논의와 시사점` |

## 석사/박사 변수 / Degree Variable

| 원하는 학위과정 / Degree Program | 설정값 / Value | 자동 반영되는 문구 / Automatic Labels |
| --- | --- | --- |
| 석사학위논문 / Master's thesis | `\providecommand{\degreeProgramKor}{석사}` | `석사학위논문`, `Master's Thesis` |
| 박사학위논문 / Doctoral dissertation | `\providecommand{\degreeProgramKor}{박사}` | `박사학위논문`, `Doctoral Dissertation` |

## 빌드 방법 / Build

이 템플릿은 LuaLaTeX와 biber를 사용합니다.

```bash
cd KNUE_beamer
latexmk -pdf -lualatex KNUE_beamer_main.tex
```

글꼴은 논문 템플릿과 같은 운영체제별 탐색 방식을 사용합니다. Windows에서는 `Times New Roman`/`Arial`과 `Batang`/`Malgun Gothic`, macOS에서는 `Times New Roman`/`Helvetica`와 `AppleMyungjo`/`Apple SD Gothic Neo`, Ubuntu/Dev Container에서는 Liberation 계열과 `NanumMyeongjo`/`NanumGothic`을 우선 사용하고, 없으면 Noto CJK 또는 Un 계열 글꼴을 찾습니다.

The font setup follows the thesis template's OS-aware lookup. It prefers `Times New Roman`/`Arial` and `Batang`/`Malgun Gothic` on Windows, `Times New Roman`/`Helvetica` and `AppleMyungjo`/`Apple SD Gothic Neo` on macOS, and Liberation fonts with `NanumMyeongjo`/`NanumGothic` on Ubuntu/Dev Containers, then falls back to Noto CJK or Un-family fonts.

또는 제공된 빌드 스크립트를 사용할 수 있습니다.

```bash
./KNUE_beamer_main_build.sh build
./KNUE_beamer_main_build.sh watch
./KNUE_beamer_main_build.sh clean
```

Windows에서는 다음 명령을 사용할 수 있습니다.

```cmd
KNUE_beamer_main_build.cmd build
KNUE_beamer_main_build.cmd watch
KNUE_beamer_main_build.cmd clean
```

## 발표자 노트 / Speaker Notes

기본 설정에서는 발표자 노트를 PDF에 출력하지 않습니다. Pympress 같은 듀얼 모니터 발표 도구에서 노트를 함께 보려면 `KNUE_beamer_main.tex`에서 아래 줄의 주석을 해제합니다.

```tex
% \enablenotes
```

When notes are enabled, build the PDF and open it with a note-aware presenter such as Pympress.

## 참고문헌 PDF 도구 / Reference PDF Tools (저장소 루트 `code/` 폴더 / repo-root `code/` folder)

저장소 루트의 공용 `code/` 폴더에 참고문헌 PDF를 관리하는 Python 스크립트 두 개가 있습니다. `../code/rename_ref_pdfs_by_bib.py`는 `sub/references.bib`의 BibTeX 항목과 `ref/` 폴더의 PDF를 대조하여 파일명을 `저자. (연도). 제목. 학술지.pdf` 형태로 정리하고 CSV 보고서를 남깁니다. `../code/download_missing_ref_pdfs.py`는 `references.bib`에는 있지만 `ref/` 폴더에 없는 PDF를 공개 접근(Open Access), DOI, 연구실 논문 검색 서버에서 내려받습니다.

The `code/` folder has two Python scripts for reference PDFs. `../code/rename_ref_pdfs_by_bib.py` matches the BibTeX entries in `sub/references.bib` against the PDFs in `ref/`, renames them to `Author. (Year). Title. Journal.pdf`, and writes CSV reports. `../code/download_missing_ref_pdfs.py` downloads PDFs that are in `references.bib` but missing from `ref/`, using open-access sources, DOIs, and the lab paper-search server.

### 필요한 모듈 설치 / Installing the required modules

두 스크립트는 `pymupdf`, `pypdf`(PDF 텍스트 추출)와 `requests`(다운로드 전용)를 사용합니다. Python 3.10 이상에서 설치하며, 저장소의 [4-PYTHON_CONDA_VSCODE_SETUP.md](../manual/4-PYTHON_CONDA_VSCODE_SETUP.md)로 만든 `knue-python` conda 환경 사용을 권장합니다.

The scripts use `pymupdf` and `pypdf` (PDF text extraction) plus `requests` (download only). Install on Python 3.10+, ideally inside the `knue-python` conda environment from [4-PYTHON_CONDA_VSCODE_SETUP.md](../manual/4-PYTHON_CONDA_VSCODE_SETUP.md).

```powershell
conda activate knue-python
pip install pymupdf pypdf requests
```

conda를 쓰지 않으면 사용 중인 Python에 `pip install pymupdf pypdf requests`로 설치합니다. Windows에서 `python`이 Microsoft Store 창만 연다면 conda 환경 활성화 또는 PATH 등록을 확인합니다.

If you do not use conda, run `pip install pymupdf pypdf requests` in your Python. On Windows, if `python` only opens the Microsoft Store page, check that the conda environment is active or that Python is on your PATH.

### 실행 방법 / Running the scripts

`KNUE_beamer` 폴더에서 실행합니다. 처음에는 파일을 바꾸지 않는 `--dry-run`으로 확인합니다. Run from the `KNUE_beamer` folder, and preview first with `--dry-run`.

```powershell
python ../code/rename_ref_pdfs_by_bib.py --dry-run
python ../code/rename_ref_pdfs_by_bib.py

python ../code/download_missing_ref_pdfs.py --dry-run
python ../code/download_missing_ref_pdfs.py
```

전체 옵션은 `--help`로 확인합니다. See all options with `--help`.

### 연구실 논문 검색 서버 비밀번호 / Lab paper-search server password

`download_missing_ref_pdfs.py`가 사용하는 논문 검색 서버(`parksparks`)는 로그인이 필요합니다. 비밀번호는 코드에 적지 않고, 환경 변수 `PARKSPARKS_PASSWORD`에 설정하거나 `.gitignore`에 등록된 `../code/.parksparks_secret` 파일에 한 줄로 저장합니다. 비밀번호가 없거나 틀리면 검색 서버는 건너뛰고 공개 출처만 사용합니다. 비밀번호는 연구실 담당자에게 확인하세요.

The paper-search server (`parksparks`) used by `download_missing_ref_pdfs.py` requires a login. The password is not stored in the code: set it in the `PARKSPARKS_PASSWORD` environment variable, or save it as a single line in `../code/.parksparks_secret`, which is git-ignored. Without a valid password the script skips the server and uses only public sources. Ask the lab administrator for the password.

## Git에 포함하지 않는 파일 / Files Not Tracked

`KNUE_beamer/.gitignore`는 빌드 산출물, 개인 발표 PDF/HWP, 예전 초안, 로컬 디버깅 스크립트를 제외합니다.
템플릿으로 공유할 때는 `.tex`, `.cls`, `.bib`, 빌드 스크립트, 로고처럼 재사용 가능한 소스 파일만 포함합니다.

The local `.gitignore` excludes generated PDFs, personal documents, old drafts, and local debugging scripts.
Only reusable source files such as `.tex`, `.cls`, `.bib`, build scripts, and logos should be committed.
