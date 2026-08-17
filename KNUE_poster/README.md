# KNUE Poster Template

이 문서는 `KNUE_poster` 폴더의 A0 세로형 3단/2단 포스터 템플릿 사용법을 설명합니다.
This document explains how to use the A0 portrait three-column and two-column poster templates in `KNUE_poster`.

## 한국어 안내

### 폴더 구성

```text
KNUE_poster/
├── KNUE_poster_3cols.tex      # 3단 포스터 템플릿
├── KNUE_poster_2cols.tex      # 2단 포스터 템플릿
├── KNUE_poster_fonts.tex    # 운영체제별 명조/고딕 글꼴 설정
├── .latexmkrc               # LuaLaTeX + biber 빌드 설정
├── KNUE_baposter.cls        # 포스터 레이아웃 클래스
├── sub/references.bib       # 참고문헌 BibTeX 데이터베이스
├── images/                  # 그림, 표 이미지, 그래프 파일
├── logo/                    # 학교/기관 로고
├── appendix/                # 부록, 데이터, 노트북 자료
├── code/                    # 참고문헌 PDF 관리 Python 스크립트
├── ref/                     # 참고문헌 원본 PDF (code 스크립트가 사용)
└── Documents/               # 빌드된 PDF 산출물 보관
```

### 템플릿 선택하기

`KNUE_poster`에는 같은 디자인을 쓰는 3단/2단 템플릿이 함께 들어 있습니다. 발표 내용의 밀도와 그림 크기에 맞춰 하나를 선택해서 사용하면 됩니다.

| 원하는 포스터 형태 | 사용할 파일 | 추천 상황 |
| --- | --- | --- |
| 3단 포스터 | `KNUE_poster_3cols.tex` | 짧은 섹션을 많이 나누고, 정보량을 촘촘하게 배치할 때 |
| 2단 포스터 | `KNUE_poster_2cols.tex` | 그림, 표, 결과 해석을 더 넓게 보여 주고 가독성을 높이고 싶을 때 |

두 파일은 서로 독립적인 템플릿입니다. 한쪽 파일을 수정해도 다른 템플릿에는 자동 반영되지 않으므로, 실제로 제출할 형식을 먼저 고른 뒤 해당 `.tex` 파일을 편집하는 것을 권장합니다.

### 빠른 시작

1. 위 표에서 3단 또는 2단 템플릿을 선택한 뒤 해당 `.tex` 파일을 엽니다.
2. `Template Fields` 영역에서 제목, 저자, 소속, 프로젝트 URL을 수정합니다.
3. `Poster Content Template` 영역의 각 `posterbox` 안에 내용을 작성합니다.
4. 그림 파일은 `images/` 폴더에 넣고 `\includegraphics`로 연결합니다.
5. 참고문헌이 필요하면 `sub/references.bib`에 `langid`가 포함된 항목을 추가하고 References 박스의 예시 cite key를 실제 문헌으로 바꿉니다.
6. 아래 명령으로 PDF를 빌드합니다.

```bash
cd KNUE_poster
latexmk -pdf -lualatex KNUE_poster_3cols.tex
# 또는 2단 템플릿
latexmk -pdf -lualatex KNUE_poster_2cols.tex
```

### 빌드 환경

이 템플릿은 `baposter` 클래스를 사용하지만, 운영체제별 명조/고딕 글꼴을 안정적으로 쓰기 위해 기본 빌드 엔진은 `LuaLaTeX`입니다.
`KNUE_poster/.latexmkrc`가 `LuaLaTeX + biber` 조합을 지정하므로 Windows, macOS, Ubuntu/Dev Container에서 같은 글꼴 탐색 순서를 사용합니다.

글꼴 설정은 `KNUE_poster_fonts.tex`에 있습니다. 논문 템플릿과 같이 Windows에서는 `Batang`/`Malgun Gothic`, macOS에서는 `AppleMyungjo`/`Apple SD Gothic Neo`, Ubuntu/Dev Container에서는 `NanumMyeongjo`/`NanumGothic`을 우선 사용하고, 없으면 Noto CJK 또는 Un 계열 글꼴을 찾습니다.

권장 방법:

```bash
latexmk -pdf -lualatex KNUE_poster_3cols.tex
# 또는
latexmk -pdf -lualatex KNUE_poster_2cols.tex
```

보조 파일을 정리하려면:

```bash
latexmk -C KNUE_poster_3cols.tex
# 또는
latexmk -C KNUE_poster_2cols.tex
```

Windows, macOS, Ubuntu 환경 차이를 줄이려면 저장소 루트의 Dev Container를 사용합니다. VS Code에서 저장소 루트를 열고 `Dev Containers: Reopen in Container`를 실행하면 같은 Ubuntu/TeX Live 환경에서 빌드할 수 있습니다.

### VS Code에서 빌드

저장소 루트 또는 `KNUE_poster` 폴더를 VS Code로 열 수 있습니다. 루트에서 열면 공유된 `.vscode` 설정이 적용됩니다.

권장 확장:

| 확장 | 용도 |
| --- | --- |
| LaTeX Workshop | LaTeX 빌드, PDF 미리보기, 오류 확인 |
| Dev Containers | 고정된 Linux/TeX Live 환경 사용 |

LaTeX Workshop에서 빌드가 Windows 전용 `cmd.exe`를 찾는 오류를 내면, 기본 recipe가 `latexmk (current file)`인지 확인합니다.

VS Code 작업 메뉴에서는 다음 task 중 하나를 선택해 빌드할 수 있습니다.

| Task | 빌드되는 템플릿 |
| --- | --- |
| `Build KNUE Poster (3 Columns)` | `KNUE_poster_3cols.tex` |
| `Build KNUE Poster (2 Columns)` | `KNUE_poster_2cols.tex` |

### 템플릿에서 먼저 수정할 곳

`KNUE_poster_3cols.tex` 또는 `KNUE_poster_2cols.tex`의 `Template Fields` 영역을 먼저 수정합니다.

```tex
\newcommand{\PosterTitle}{...}
\newcommand{\PosterAuthors}{...}
\newcommand{\PosterAffiliations}{...}
\newcommand{\ProjectURL}{...}
```

이 명령들은 포스터 상단 헤더와 정보 박스에서 반복해서 사용됩니다. 명령 이름은 그대로 두고 중괄호 안의 내용만 바꾸는 것이 안전합니다.

### posterbox 배치 이해하기

포스터 본문은 여러 개의 `posterbox`로 구성됩니다.

```tex
\begin{posterbox}[name=abstract,column=0,row=0,span=2]{Abstract}
...
\end{posterbox}
```

주요 옵션:

| 옵션 | 의미 |
| --- | --- |
| `name=abstract` | 다른 박스가 참조하는 내부 이름 |
| `column=0` | 박스를 놓을 열 지정. 3단은 0, 1, 2 / 2단은 0, 1 |
| `row=0` | 해당 박스를 맨 위에서 시작 |
| `below=abstract` | `abstract` 박스 아래에 배치 |
| `span=2` | 두 개의 열을 가로질러 배치 |
| `above=bottom` | 박스 아래쪽을 포스터 하단에 맞춤 |

박스 제목을 바꾸는 것은 안전하지만, `name=`을 바꿀 때는 다른 박스의 `below=` 참조도 함께 수정해야 합니다.

### 현재 박스 배치

3단 템플릿 `KNUE_poster_3cols.tex`는 3개의 세로 열을 사용합니다. 열 번호는 왼쪽부터 `0`, `1`, `2`입니다.

| 열 | 위에서 아래로 배치된 박스 |
| --- | --- |
| `column=0` | `Abstract`의 왼쪽 부분 → `Introduction` → `Figures / Tables` |
| `column=1` | `Abstract`의 오른쪽 부분 → `Methods` → `Discussion & Conclusions` |
| `column=2` | `Poster Info` → `Box Layout Guide` → `Results` → `References` |

`Abstract`는 `span=2`를 사용하므로 `column=0`에서 시작해 `column=1`까지 두 열을 차지합니다.

2단 템플릿 `KNUE_poster_2cols.tex`는 2개의 세로 열을 사용합니다. 열 번호는 왼쪽부터 `0`, `1`입니다.

| 열 | 위에서 아래로 배치된 박스 |
| --- | --- |
| `column=0` | `Abstract`의 왼쪽 부분 → `Introduction` → `Methods` → `Discussion & Conclusions` |
| `column=1` | `Abstract`의 오른쪽 부분 → `Poster Info` → `Layout Guide` → `Results` → `Figures / Tables` → `References` |

2단 템플릿에서도 `Abstract`는 `span=2`를 사용해 두 열 전체를 가로지릅니다.

### 박스 위치를 바꾸는 예시

맨 위에 새 박스를 놓으려면 `row=0`을 사용합니다.

```tex
\begin{posterbox}[name=newtopbox,column=1,row=0]{New Top Box}
...
\end{posterbox}
```

기존 박스 아래에 새 박스를 놓으려면 `below=기존name`을 사용합니다.

```tex
\begin{posterbox}[name=teachingimplications,column=1,below=methods]{Teaching Implications}
...
\end{posterbox}
```

박스를 포스터 하단까지 늘리고 싶으면 `above=bottom`을 함께 사용합니다.

```tex
\begin{posterbox}[name=appendix,column=1,below=results,above=bottom]{Appendix}
...
\end{posterbox}
```

두 열을 가로지르는 넓은 박스를 만들려면 `span=2`를 사용합니다.

```tex
\begin{posterbox}[name=widefigure,column=0,below=abstract,span=2]{Wide Figure}
...
\end{posterbox}
```

주의할 점:

1. 같은 `name=`을 두 번 쓰지 않습니다.
2. `below=`에는 화면에 보이는 제목이 아니라 내부 이름인 `name=` 값을 씁니다.
3. 어떤 박스의 `name=`을 바꾸면 그 이름을 참조하는 모든 `below=`도 함께 바꿉니다.
4. `above=bottom`을 여러 박스에 쓸 수 있지만, 같은 열에서 박스 순서가 꼬이면 겹칠 수 있습니다.
5. 박스가 겹치거나 너무 길어지면 텍스트를 줄이거나, 다른 열로 옮기거나, `span`을 조정합니다.

### 그림과 표 넣기

그림 파일은 `images/` 폴더에 넣는 것을 권장합니다.

```tex
\includegraphics[width=\linewidth]{images/example.pdf}
```

포스터에서는 그림이 핵심 메시지를 빠르게 전달해야 하므로, 가능한 한 축 번호, 단위, 범례, 캡션을 간결하게 정리합니다.

### 참고문헌 사용

참고문헌은 APA 7판 형식을 기본으로 사용하며 `sub/references.bib`에 추가합니다. 한국어 문헌은 `langid={korean}`, 영어 문헌은 `langid={english}`를 넣습니다. 기본 템플릿은 아래 예시처럼 sample cite key를 출력하므로, 실제 포스터에서는 cite key를 자신의 문헌으로 바꿉니다.

```tex
\nocite{kor_sample_reference,eng_sample_reference}
\printbibliography[heading=none]
```

특정 문헌만 출력하려면 예시 key 대신 실제 cite key를 넣습니다. 본문에서 한국어 문헌은 `\ktextcite{kor_key}` 또는 `(\kparencite{kor_key})`, 영어 문헌은 `\textcite{eng_key}` 또는 `(\parencite{eng_key})`처럼 인용합니다. 논문 템플릿과 동일하게 `\kparencite`와 `\parencite`는 바깥 괄호를 자동으로 출력하지 않으므로 필요한 괄호는 본문에서 직접 입력합니다.

### 자주 생기는 문제

| 증상 | 확인할 것 |
| --- | --- |
| `latexmk`를 찾을 수 없음 | TeX Live/MacTeX 설치와 PATH 설정 확인 |
| `cmd.exe ENOENT` | Windows 전용 recipe가 선택되지 않았는지 확인 |
| active editor가 `latex_workshop_log`라고 나옴 | 출력 로그 탭이 아니라 `KNUE_poster_3cols.tex` 또는 `KNUE_poster_2cols.tex` 탭을 클릭한 뒤 빌드하거나, VS Code task 실행 |
| 그림이 보이지 않음 | 파일 경로와 대소문자, 확장자 확인 |
| 참고문헌이 비어 있음 | `sub/references.bib`, cite key, `langid`, `\printbibliography` 포함 여부 확인 |
| 글자가 박스 밖으로 넘침 | 문장 줄이기, 글꼴 크기 조정, 박스 위치/높이 조정 |

### 참고문헌 PDF 도구 (code 폴더)

`code/` 폴더에는 참고문헌 PDF를 관리하는 Python 스크립트 두 개가 있습니다.

| 파일 | 역할 |
| --- | --- |
| `code/rename_ref_pdfs_by_bib.py` | `sub/references.bib`의 BibTeX 항목과 `ref/` 폴더의 PDF를 대조하여, 파일명을 `저자. (연도). 제목. 학술지.pdf` 형태로 정리하고 CSV 보고서를 남깁니다. |
| `code/download_missing_ref_pdfs.py` | `references.bib`에는 있지만 `ref/` 폴더에 없는 PDF를 공개 접근(Open Access), DOI, 연구실 논문 검색 서버에서 내려받습니다. |

필요한 모듈은 `pymupdf`, `pypdf`(PDF 텍스트 추출)와 `requests`(다운로드 전용)입니다. Python 3.10 이상에서, 저장소의 [3-PYTHON_CONDA_VSCODE_SETUP.md](../3-PYTHON_CONDA_VSCODE_SETUP.md)로 만든 `knue-python` conda 환경 사용을 권장합니다.

```powershell
conda activate knue-python
pip install pymupdf pypdf requests
```

`KNUE_poster` 폴더에서 실행하며, 처음에는 파일을 바꾸지 않는 `--dry-run`으로 확인합니다. 전체 옵션은 `--help`로 볼 수 있습니다.

```powershell
python code/rename_ref_pdfs_by_bib.py --dry-run
python code/download_missing_ref_pdfs.py --dry-run
```

`download_missing_ref_pdfs.py`가 사용하는 논문 검색 서버(`parksparks`)는 로그인이 필요합니다. 비밀번호는 코드에 적지 않고, 환경 변수 `PARKSPARKS_PASSWORD`에 설정하거나 `.gitignore`에 등록된 `code/.parksparks_secret` 파일에 한 줄로 저장합니다. 비밀번호가 없거나 틀리면 검색 서버는 건너뛰고 공개 출처만 사용합니다. 비밀번호는 연구실 담당자에게 확인하세요.

## English Guide

### Folder Structure

```text
KNUE_poster/
├── KNUE_poster_3cols.tex      # Three-column poster template
├── KNUE_poster_2cols.tex      # Two-column poster template
├── KNUE_poster_fonts.tex    # OS-aware Myeongjo/Gothic font setup
├── .latexmkrc               # LuaLaTeX + biber build configuration
├── KNUE_baposter.cls        # Poster layout class
├── sub/references.bib       # BibTeX bibliography database
├── images/                  # Figures, table images, and plots
├── logo/                    # School or institution logos
└── appendix/                # Appendices, data, and notebooks
```

### Choosing a Template

`KNUE_poster` includes both three-column and two-column templates with the same visual style. Choose one based on the density of your content and the size of your figures.

| Poster Type | File to Use | Best For |
| --- | --- | --- |
| Three-column poster | `KNUE_poster_3cols.tex` | Many short sections and a dense information layout |
| Two-column poster | `KNUE_poster_2cols.tex` | Wider figures, tables, results, and more readable text blocks |

The two files are independent templates. Edits to one file are not automatically copied to the other, so choose the final submission format first and then edit that `.tex` file.

### Quick Start

1. Choose either the three-column or two-column template above, then open that `.tex` file.
2. Edit title, authors, affiliations, and project URL in `Template Fields`.
3. Write your content inside each `posterbox` in `Poster Content Template`.
4. Put figure files in `images/` and include them with `\includegraphics`.
5. If you need references, add entries with `langid` to `sub/references.bib` and replace the sample cite keys in the References box with your sources.
6. Build the PDF with:

```bash
cd KNUE_poster
latexmk -pdf -lualatex KNUE_poster_3cols.tex
# or the two-column template
latexmk -pdf -lualatex KNUE_poster_2cols.tex
```

### Build Environment

This template uses the `baposter` class, but the default engine is `LuaLaTeX` so OS-native Myeongjo/Gothic fonts can be selected reliably.
`KNUE_poster/.latexmkrc` selects the `LuaLaTeX + biber` workflow, so Windows, macOS, and Ubuntu/Dev Container builds use the same font lookup order.

The font setup lives in `KNUE_poster_fonts.tex`. Matching the thesis template, it prefers `Batang`/`Malgun Gothic` on Windows, `AppleMyungjo`/`Apple SD Gothic Neo` on macOS, and `NanumMyeongjo`/`NanumGothic` on Ubuntu/Dev Containers, then falls back to Noto CJK or Un-family fonts.

Recommended command:

```bash
latexmk -pdf -lualatex KNUE_poster_3cols.tex
# or
latexmk -pdf -lualatex KNUE_poster_2cols.tex
```

To clean generated files:

```bash
latexmk -C KNUE_poster_3cols.tex
# or
latexmk -C KNUE_poster_2cols.tex
```

To reduce differences between Windows, macOS, and Ubuntu, use the Dev Container in the repository root. Open the repository root in VS Code and run `Dev Containers: Reopen in Container` to build inside the same Ubuntu/TeX Live environment.

### Building in VS Code

You can open either the repository root or the `KNUE_poster` folder in VS Code. Opening the root applies the shared `.vscode` settings.

Recommended extensions:

| Extension | Purpose |
| --- | --- |
| LaTeX Workshop | LaTeX build, PDF preview, and error inspection |
| Dev Containers | Fixed Linux/TeX Live environment |

If LaTeX Workshop reports a Windows-only `cmd.exe` error, check that the default recipe is `latexmk (current file)`.

In the VS Code task menu, choose one of the following build tasks.

| Task | Template Built |
| --- | --- |
| `Build KNUE Poster (3 Columns)` | `KNUE_poster_3cols.tex` |
| `Build KNUE Poster (2 Columns)` | `KNUE_poster_2cols.tex` |

### First Places to Edit

Start with the `Template Fields` section in `KNUE_poster_3cols.tex` or `KNUE_poster_2cols.tex`.

```tex
\newcommand{\PosterTitle}{...}
\newcommand{\PosterAuthors}{...}
\newcommand{\PosterAffiliations}{...}
\newcommand{\ProjectURL}{...}
```

These commands are reused in the poster header and information box. It is safest to keep the command names unchanged and edit only the text inside braces.

### Understanding posterbox Layout

The poster body is made of several `posterbox` blocks.

```tex
\begin{posterbox}[name=abstract,column=0,row=0,span=2]{Abstract}
...
\end{posterbox}
```

Main options:

| Option | Meaning |
| --- | --- |
| `name=abstract` | Internal anchor used by other boxes |
| `column=0` | Places the box in a column. 3-column: 0, 1, 2 / 2-column: 0, 1 |
| `row=0` | Starts the box at the top |
| `below=abstract` | Places the box below `abstract` |
| `span=2` | Stretches the box across two columns |
| `above=bottom` | Extends the box toward the bottom of the poster |

Changing the visible box title is safe, but if you change `name=`, also update any matching `below=` references.

### Current Box Layout

The three-column template `KNUE_poster_3cols.tex` uses three vertical columns. Column numbers start from the left: `0`, `1`, and `2`.

| Column | Boxes from Top to Bottom |
| --- | --- |
| `column=0` | Left part of `Abstract` → `Introduction` → `Figures / Tables` |
| `column=1` | Right part of `Abstract` → `Methods` → `Discussion & Conclusions` |
| `column=2` | `Poster Info` → `Box Layout Guide` → `Results` → `References` |

`Abstract` uses `span=2`, so it starts at `column=0` and stretches across both `column=0` and `column=1`.

The two-column template `KNUE_poster_2cols.tex` uses two vertical columns. Column numbers start from the left: `0` and `1`.

| Column | Boxes from Top to Bottom |
| --- | --- |
| `column=0` | Left part of `Abstract` → `Introduction` → `Methods` → `Discussion & Conclusions` |
| `column=1` | Right part of `Abstract` → `Poster Info` → `Layout Guide` → `Results` → `Figures / Tables` → `References` |

In the two-column template, `Abstract` also uses `span=2` and stretches across both columns.

### Examples for Moving Boxes

Use `row=0` to place a new box at the top of a column.

```tex
\begin{posterbox}[name=newtopbox,column=1,row=0]{New Top Box}
...
\end{posterbox}
```

Use `below=existingname` to place a new box under an existing box.

```tex
\begin{posterbox}[name=teachingimplications,column=1,below=methods]{Teaching Implications}
...
\end{posterbox}
```

Use `above=bottom` if the box should extend down to the poster bottom.

```tex
\begin{posterbox}[name=appendix,column=1,below=results,above=bottom]{Appendix}
...
\end{posterbox}
```

Use `span=2` to create a wide box across two columns.

```tex
\begin{posterbox}[name=widefigure,column=0,below=abstract,span=2]{Wide Figure}
...
\end{posterbox}
```

Things to watch:

1. Do not reuse the same `name=` twice.
2. `below=` uses the internal `name=`, not the visible box title.
3. If you rename a box, update every `below=` reference that points to it.
4. You can use `above=bottom` in multiple boxes, but boxes in the same column may overlap if their order is inconsistent.
5. If boxes overlap or become too tall, shorten text, move a box to another column, or adjust `span`.

### Adding Figures and Tables

Put figure files in the `images/` folder when possible.

```tex
\includegraphics[width=\linewidth]{images/example.pdf}
```

On a poster, figures should communicate the main message quickly. Keep axis labels, units, legends, and captions concise.

### Using References

References use APA 7th edition formatting by default. Add entries to `sub/references.bib` with `langid={korean}` for Korean sources and `langid={english}` for English sources. The default template prints sample cite keys as shown below; replace them with your own cite keys in an actual poster.

```tex
\nocite{kor_sample_reference,eng_sample_reference}
\printbibliography[heading=none]
```

To print only selected references, replace the sample keys with your actual cite keys. Cite Korean sources with `\ktextcite{kor_key}` or `(\kparencite{kor_key})`, and English sources with `\textcite{eng_key}` or `(\parencite{eng_key})`. As in the thesis template, `\kparencite` and `\parencite` do not print outer parentheses automatically, so type the parentheses directly in the poster text when needed.

### Common Issues

| Symptom | What to Check |
| --- | --- |
| `latexmk` cannot be found | TeX Live/MacTeX installation and PATH |
| `cmd.exe ENOENT` | A Windows-only recipe may be selected |
| Active editor is `latex_workshop_log` | Click the `KNUE_poster_3cols.tex` or `KNUE_poster_2cols.tex` tab before building, or run a VS Code build task |
| Figure is missing | File path, capitalization, and extension |
| References are empty | `sub/references.bib`, cite keys, `langid`, and the presence of `\printbibliography` |
| Text overflows a box | Shorten text, adjust font size, or revise box layout |

### Reference PDF Tools (code folder)

The `code/` folder has two Python scripts for reference PDFs.

| File | Purpose |
| --- | --- |
| `code/rename_ref_pdfs_by_bib.py` | Matches the BibTeX entries in `sub/references.bib` against the PDFs in `ref/`, renames them to `Author. (Year). Title. Journal.pdf`, and writes CSV reports. |
| `code/download_missing_ref_pdfs.py` | Downloads PDFs that are in `references.bib` but missing from `ref/`, using open-access sources, DOIs, and the lab paper-search server. |

The required modules are `pymupdf` and `pypdf` (PDF text extraction) plus `requests` (download only). Install on Python 3.10+, ideally inside the `knue-python` conda environment from [3-PYTHON_CONDA_VSCODE_SETUP.md](../3-PYTHON_CONDA_VSCODE_SETUP.md).

```powershell
conda activate knue-python
pip install pymupdf pypdf requests
```

Run from the `KNUE_poster` folder, and preview first with `--dry-run`. See all options with `--help`.

```powershell
python code/rename_ref_pdfs_by_bib.py --dry-run
python code/download_missing_ref_pdfs.py --dry-run
```

The paper-search server (`parksparks`) used by `download_missing_ref_pdfs.py` requires a login. The password is not stored in the code: set it in the `PARKSPARKS_PASSWORD` environment variable, or save it as a single line in `code/.parksparks_secret`, which is git-ignored. Without a valid password the script skips the server and uses only public sources. Ask the lab administrator for the password.
