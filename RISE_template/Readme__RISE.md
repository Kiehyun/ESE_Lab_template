# RISE Submission Template

*Research in Science Education* (Springer) 투고용 LaTeX 템플릿입니다. Springer 공식
클래스 `sn-jnl.cls`(sn-jnl v3.x)를 기반으로 하며, 실제 논문 내용은 넣지 않고 각 절에
무엇을 쓰는지 안내만 담은 빈 스켈레톤으로 구성했습니다.

## 투고·심사 규정 (Documents/)

*Research in Science Education*(Springer) 공식 Submission Guidelines 사본이 들어 있습니다
(영문 원문 + 국문 번역, 참고용 — 최신본은 공식 페이지 확인). 동료심사(peer review)·연구윤리·
생성형 AI 정책 등이 포함됩니다.

- 투고규정/제출 안내: [Documents/RISE_투고규정_submission-guidelines.md](Documents/RISE_투고규정_submission-guidelines.md)
- 공식 페이지: <https://link.springer.com/journal/11165/submission-guidelines>

## Journal

*Research in Science Education* 은 Springer가 발행하는 과학교육 분야 국제 학술지입니다.
과학 교수학습, 교육과정, 평가, 교사교육, 과학영재교육 등 과학교육 전반의 실증·이론
연구에 적합합니다. 투고 전에는 저널의 최신 **Instructions for Authors** 에서 원고 유형,
초록/키워드 요구사항, 그림·표 규격, 윤리·이해상충 선언 항목을 반드시 확인하세요.

## 이 템플릿의 특징

- **Springer 공식 클래스**: `sn-jnl.cls` 와 APA 참고문헌 스타일 `sn-apacite.bst` 를 폴더에
  함께 넣어 두었습니다. 별도 설치 없이 그대로 컴파일됩니다.
- **엔진/참고문헌**: pdfLaTeX + 고전 BibTeX(biber/biblatex 아님). `sn-apa` 옵션이
  `sn-apacite.bst`(APA)를 자동 지정합니다.
- **biblatex 인용 호환**: 본문에서 `\parencite{...}` / `\textcite{...}` 를 쓰면 natbib 의
  `\citep` / `\citet` 로 매핑되는 shim 이 `RISE_main.tex` 에 들어 있습니다.
- **ORCID**: `sn-jnl` 의 `\orcidlogo`(EPS 필요)를 풀고 `orcidlink`(TikZ, EPS 불필요)로
  대체했습니다. `\orcidlink{0000-...}` 로 저자 ORCID 아이콘/링크를 출력합니다.

## 산출물 (한 번의 빌드 = 4개 PDF)

`RISE_main_build`(아래 참조)를 인자 없이 실행하면 아래 네 개 PDF 가 순서대로 생성됩니다.

| PDF | 내용 | 엔진 |
| --- | --- | --- |
| `RISE_main.pdf` | ① 영문 원고 (저자 포함, 정식 원고) | pdfLaTeX + BibTeX |
| `RISE_main_anon.pdf` | ② 익명 투고본 (저자·소속·이메일·ORCID 제거) | pdfLaTeX + BibTeX |
| `title-page.pdf` | ③ 별도 표지 (저자 신원·소속·선언문) | pdfLaTeX |
| `RISE_main_kr.pdf` | ④ 한글 번역본 | LuaLaTeX + BibTeX |

- **이중 익명(double-blind) 투고**: `RISE_main_anon.pdf` + `title-page.pdf` 를 함께
  업로드합니다. 익명본에는 저자 정보가 없고, 저자 신원은 별도 표지로만 전달됩니다.
- ② 익명본은 `RISE_main.tex` 안의 `\ifRISEanon` 토글을 이용합니다. 빌드가
  `\def\ANON{}\input{RISE_main.tex}` 로 컴파일하면 저자 블록이 자동으로
  "withheld for double-blind review" 로 치환됩니다(원본 `RISE_main.tex` 는 그대로).
- ④ 한글본은 sn-jnl/pdfLaTeX 가 한글을 렌더링하지 못하므로, `article` 클래스 +
  **LuaLaTeX** + `fontspec`(Noto Serif KR → NanumMyeongjo → Batang → Malgun Gothic
  순 폴백)로 **독립** 구성했습니다. 참고문헌은 영문본과 **동일한**
  `sub/references-sn.bib` 를 `apalike`(APA 스타일 author-year)로 조판합니다.

### 생성 과정 (빌드가 하는 일)

`RISE_main_build`(인자 없음)는 아래 네 단계를 순서대로 실행합니다. 각 단계는 서로 독립이며,
익명본·표지·한글본은 **원본 `RISE_main.tex` 를 손대지 않고** 자동으로 만들어집니다.

1. **① 영문 원고** — `pdflatex RISE_main` → `bibtex` → `pdflatex` ×2. 저자 정보가 포함된
   정식 원고 `RISE_main.pdf` 를 만듭니다. (`\ifRISEanon` 이 거짓이므로 실제 저자 블록 출력)
2. **② 익명 투고본** — 같은 `RISE_main.tex` 를 `-jobname=RISE_main_anon` 으로,
   `\def\ANON{}\input{RISE_main.tex}` 형태로 컴파일합니다. 앞부분의 `\def\ANON{}` 가
   `\ifRISEanon` 토글을 켜서, 저자·소속·이메일·ORCID 블록이 "withheld for double-blind
   review" 로 치환된 `RISE_main_anon.pdf` 가 나옵니다. 원본 파일은 전혀 바뀌지 않습니다.
3. **③ 별도 표지** — `pdflatex title-page`. 참고문헌이 없으므로 1회만 돌려 저자 신원·소속·
   교신저자·선언문이 담긴 `title-page.pdf` 를 만듭니다. (익명 원고와 짝을 이루는 비익명 표지)
4. **④ 한글 번역본** — `lualatex RISE_main_kr` → `bibtex` → `lualatex` ×2. `RISE_main_kr.tex`
   는 한글을 렌더링할 수 있는 `article`+LuaLaTeX 독립 문서로, `sub/kr-1..5-*.tex` 를 불러와
   `RISE_main_kr.pdf` 를 만듭니다.

> 특정 산출물만 다시 만들려면 `RISE_main_build anon`(익명본), `RISE_main_build title`(표지),
> `RISE_main_build kr`(한글본)처럼 하위 명령을 씁니다. **이중 익명 투고 시에는 ②
> `RISE_main_anon.pdf` 와 ③ `title-page.pdf` 를 함께 업로드**합니다.

## 주요 파일

| 파일 | 역할 |
| --- | --- |
| `RISE_main.tex` | 영문 원고: 제목·저자·초록·키워드, 클래스 옵션, `\ifRISEanon` 익명 토글, 본문 `\input` |
| `title-page.tex` | 별도 표지(비익명): 저자·소속·교신저자·선언문 (`article`, pdfLaTeX) |
| `RISE_main_kr.tex` | 한글 번역본 본체(`article` + LuaLaTeX + fontspec, natbib) |
| `sub/en-1-introduction.tex` | 1. Introduction (영문 스켈레톤) |
| `sub/en-2-framework.tex` | 2. Theoretical Framework |
| `sub/en-3-methods.tex` | 3. Methods |
| `sub/en-4-results.tex` | 4. Results |
| `sub/en-5-discussion.tex` | 5. Discussion and Conclusion |
| `sub/kr-1-introduction.tex` | 1. 서론 (한글 스켈레톤) |
| `sub/kr-2-framework.tex` | 2. 이론적 배경 |
| `sub/kr-3-methods.tex` | 3. 연구 방법 |
| `sub/kr-4-results.tex` | 4. 연구 결과 |
| `sub/kr-5-discussion.tex` | 5. 논의 및 결론 |
| `sub/references-sn.bib` | 참고문헌 BibTeX 데이터베이스(영문본·한글본 공용) |
| `sn-jnl.cls` | Springer 공식 클래스 |
| `sn-apacite.bst` | APA 참고문헌 스타일(영문본) |

## 클래스 옵션

`RISE_main.tex` 첫 줄에서 설정합니다.

```latex
\documentclass[pdflatex,sn-apa,referee]{sn-jnl}
```

- `pdflatex` : pdfLaTeX 엔진
- `sn-apa` : APA 참고문헌(`sn-apacite.bst`)
- `referee` : 2줄 간격(심사 투고용, 기본값). **게재 확정본**을 조판할 때는 이 옵션을 빼면
  1줄 간격의 저널 레이아웃이 됩니다.
- `lineno` : 줄번호가 필요하면 추가

> 이중 익명(double-blind) 투고 시에는 `RISE_main.tex` 를 손대지 말고
> `RISE_main_build anon` 을 실행하세요. `\ifRISEanon` 토글이 저자·소속 블록을
> 자동으로 익명 처리하여 `RISE_main_anon.pdf` 를 만듭니다(저자 신원은 `title-page.pdf`).

## 빌드

**pdfLaTeX**와 **BibTeX**가 PATH에 있어야 합니다(TeX Live 또는 MiKTeX 전체 설치 권장).
설치는 [../manual/3-VSCODE_TeXLive_SETUP.md](../manual/3-VSCODE_TeXLive_SETUP.md)를 참고하세요.

Windows:

```powershell
.\RISE_main_build.cmd
```

macOS / Linux:

```bash
./RISE_main_build.sh
```

인자 없이 실행하면 위 **네 개 PDF 를 모두** 빌드합니다(`en → anon → title → kr`).
각 산출물의 빌드 순서는 `(lua)pdflatex → bibtex → (lua)pdflatex → (lua)pdflatex`
입니다(표지는 참고문헌이 없어 pdflatex 1회). 특정 산출물만 빌드하거나 정리하려면
하위 명령을 사용합니다.

| 명령 | 동작 |
| --- | --- |
| `RISE_main_build`  (인자 없음) | 네 개 PDF 모두 (= `all`) |
| `RISE_main_build all` | 동일 |
| `RISE_main_build en` | `RISE_main.pdf` (영문 원고) |
| `RISE_main_build anon` | `RISE_main_anon.pdf` (익명 투고본) |
| `RISE_main_build title` | `title-page.pdf` (별도 표지) |
| `RISE_main_build kr` | `RISE_main_kr.pdf` (한글 번역본) |
| `RISE_main_build clean` | 보조 파일(.aux/.bbl/.log 등) 삭제 (PDF 는 보존) |

> 한글본 빌드에는 **LuaLaTeX** 가 추가로 필요합니다(TeX Live/MiKTeX 전체 설치 시 포함).

```powershell
.\RISE_main_build.cmd            # 4개 모두
.\RISE_main_build.cmd anon       # 익명본만
.\RISE_main_build.cmd clean      # 보조 파일 정리(PDF 보존)
```

## 새 원고 작성 순서

1. `RISE_main.tex` 의 front matter(제목·저자·소속·초록·키워드)를 수정합니다.
2. `sub/en-1..5-*.tex` 의 안내 문구를 지우고 본문을 작성합니다.
3. 인용할 문헌을 `sub/references-sn.bib` 에 등록하고 본문에서 `\parencite`/`\textcite`
   또는 `\citep`/`\citet` 로 인용합니다.
4. 그림은 `images/` 에 넣고 `\includegraphics` 로 삽입합니다.
5. 제출 직전에 본문 인용과 참고문헌 목록이 1:1로 대응되는지 확인합니다.

## 참고

- `Documents/user-manual.pdf` : Springer Nature LaTeX 템플릿 공식 사용자 매뉴얼.
- 투고 시스템·규정은 저널 홈페이지의 최신 안내가 항상 우선합니다.
