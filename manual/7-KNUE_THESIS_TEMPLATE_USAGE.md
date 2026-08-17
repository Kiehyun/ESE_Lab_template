# 7. KNUE_thesis 템플릿 사용법

이 문서는 `KNUE_thesis/` LaTeX 템플릿을 **실제로 어떻게 조작하는지**(양식·빌드·파일 구조)만 설명합니다. 각 장에 무엇을 써야 하는지 같은 **논문 내용 작성법**은 [KNUE_thesis/Readme__KNUEthesis.md](../KNUE_thesis/Readme__KNUEthesis.md)를 참고하세요.

현재 이 양식은 개발 중이며, 학교·학과 지침 변경과 사용자 피드백에 따라 계속 수정될 수 있습니다. 최종 제출 전에는 반드시 최신 공식 학위논문 작성 지침과 생성된 PDF를 직접 대조해 주세요.

---

## 처음 수정할 곳

1. `sub/0-preamble.tex`에서 논문 제목, 저자명, 지도교수명, 심사위원명, 학위 구분을 수정합니다.
2. `sub/abstractKor.tex`와 `sub/abstractEng.tex`에서 국문·영문 초록을 작성합니다.
3. `sub/1-Introduction.tex`부터 `sub/5-Conclusions.tex`까지 장별 본문을 작성합니다.
4. `sub/references.bib`에 참고문헌 BibTeX 정보를 추가하고 본문에서 인용합니다.
5. 필요하면 `code/`에 분석 코드를 넣고 부록에서 파일명으로 불러옵니다.

파일명은 예시이며 바꿀 수 있습니다. 파일명을 바꾸면 `KNUE_thesis_main.tex`의 `\include`/`\input`도 함께 수정해야 합니다.

---

## 석사·박사 학위 구분 사용법

이 템플릿은 `sub/0-preamble.tex`의 **`\degreeProgramKor` 값 하나**로 석사논문과 박사논문 표지·인준면·문구를 자동으로 전환합니다. 나머지는 아래 표에 따라 값만 채우면 됩니다.

| 항목 | 석사학위논문 | 박사학위논문 |
| --- | --- | --- |
| `\degreeProgramKor` | `석사` | `박사` (기본값) |
| `\degreeEng` | `Master of Education` | `Doctor of Philosophy in Education` |
| 표지 영문 제목 | 표시 안 함(국문 제목만) | 국문 제목 아래 영문 제목도 함께 표시 |
| 인준면 심사위원 | 심사위원장 1명 + 심사위원 **2명** | 심사위원장 1명 + 심사위원 **4명** |
| 채워야 할 심사위원 변수 | `\committeeChairKor/Eng`, `\committeeMemberOneKor/Eng`, `\committeeMemberTwoKor/Eng` | 왼쪽 항목 + `\committeeMemberThreeKor/Eng`, `\committeeMemberFourKor/Eng` |

```tex
% 석사학위논문
\newcommand{\degreeProgramKor}{석사}
\newcommand{\degreeEng}{Master of Education}

% 박사학위논문 (기본값)
\newcommand{\degreeProgramKor}{박사}
\newcommand{\degreeEng}{Doctor of Philosophy in Education}
```

`\degreeProgramKor`만 바꾸면 `\degreeKor`(예: "박사 학위논문"), `\degreeSubmissionKor`("…교육학 박사 학위 논문으로 제출함"), `\degreeApprovalKor`("…교육학 박사학위 논문을 인준함") 같은 국문 문구가 모두 자동으로 함께 바뀝니다. 영문 학위명(`\degreeEng`)만 직접 확인해서 수정하면 됩니다.

심사위원 이름은 학위와 무관하게 `sub/0-preamble.tex`에 6개 변수(`\committeeChairKor/Eng`, `\committeeMemberOneKor/Eng`~`\committeeMemberFourKor/Eng`)가 항상 정의되어 있습니다. **석사논문에서는 `Three`/`Four` 변수를 채우지 않아도 됩니다** — 인준면이 자동으로 심사위원장 1명 + 심사위원 2명 줄만 출력하고, `Three`/`Four` 값은 표지에 출력되지 않습니다. 박사논문에서는 5명(위원장 포함) 전원을 채워야 인준면이 올바르게 나옵니다.

```tex
\newcommand{\committeeChairKor}{성춘향}         \newcommand{\committeeChairEng}{Seong, Chunhyang}
\newcommand{\committeeMemberOneKor}{허준}       \newcommand{\committeeMemberOneEng}{Heo, Jun}
\newcommand{\committeeMemberTwoKor}{장보고}     \newcommand{\committeeMemberTwoEng}{Jang, Bogo}
% 박사논문만 필요
\newcommand{\committeeMemberThreeKor}{신사임당} \newcommand{\committeeMemberThreeEng}{Shin, Saimdang}
\newcommand{\committeeMemberFourKor}{유관순}    \newcommand{\committeeMemberFourEng}{Yu, Gwansun}
```

> 학위 구분을 바꾼 뒤에는 반드시 다시 빌드해서 표지·인준면이 의도한 대로 나오는지 확인하세요(`.\KNUE_thesis_main_build.cmd`).

> **⚠️ 도서관 제출 시 주의.** 이 템플릿이 만드는 인준면은 이름을 텍스트로 출력한 서명란일 뿐입니다. 도서관(학위논문 원문 제출)에는 **심사위원 전원의 서명 또는 도장을 실제로 받은 원본 인준면**을 제출해야 합니다 — PDF의 텍스트 인준면만으로는 제출이 인정되지 않습니다. 실물 서명을 받은 인준면을 스캔해 최종 제출 PDF에 끼워 넣거나, 학교 제출 규정에 맞는 별도 절차(원문 제출 매뉴얼 등)를 따르세요. 정확한 제출 방식은 소속 학과·대학원 행정실의 최신 안내를 반드시 확인해야 합니다.

---

## 한국어·영어 논문 전환

`sub/0-preamble.tex`의 `\documentLanguage` 값으로 전환합니다. 기본값은 `korean`입니다.

```tex
\newcommand{\documentLanguage}{korean}   % 또는 english
```

한국어 논문이라도 영문 제목·영문 초록은 필요하고, 영어 논문이라도 국문 제목·국문 초록은 필요합니다 — `\thesistitleKor`/`\thesistitleEng`, `\authorKor`/`\authorEng` 등 국·영문 값을 항상 함께 입력합니다. 본문은 별도 폴더(`sub/en` 등)를 만들지 않고 `sub/1-Introduction.tex` ~ `sub/5-Conclusions.tex`에 선택한 언어로 그대로 씁니다.

| 항목 | 한국어(korean) | 영어(english) |
| --- | --- | --- |
| 초록 배치 | 국문 초록이 앞쪽, 영문 초록이 참고문헌 뒤 | 영문 초록이 앞쪽, 국문 초록이 참고문헌 뒤 |
| 표/그림 표기 | `표`, `그림` | `Table`, `Fig.` |

---

## 논문 정보 수정

논문 전체에서 반복되는 정보는 `sub/0-preamble.tex`에서 한 번만 수정합니다.

```tex
\newcommand{\thesistitleKor}{국문 논문 제목}
\newcommand{\thesistitleEng}{English Thesis Title}
\newcommand{\authorKor}{홍길동}
\newcommand{\authorEng}{Hong, Gildong}
\newcommand{\thesiskeywordsKor}{지구과학, 과학교육, 5개 입력}
\newcommand{\thesiskeywordsEng}{Earth science, science education, enter five keywords}
\newcommand{\advisorKor}{임꺽정}
\newcommand{\advisorEng}{Im, Kkeokjeong, Ph. D.}
```

국문 주요어는 국문 초록과 PDF 메타데이터(`pdfkeywords`)에 함께 쓰입니다.

---

## 주요 파일

| 파일 또는 폴더 | 역할 | 보통 수정 여부 |
| --- | --- | --- |
| `KNUE_thesis_main.tex` | 논문 전체를 조립하는 메인 파일. 표지·초록·본문·참고문헌·부록 순서 관리 | 거의 안 함 |
| `KNUE_thesis.cls` | 학위논문 형식(여백·글꼴·장 제목·표/그림 번호) 정의 | 형식 자체를 고칠 때만 |
| `sub/0-preamble.tex` | 제목, 저자명, 지도교수, 심사위원, 학위 구분, 전공명, 공통 명령 | 예 |
| `sub/coverpage-thesis.tex` | 표지·인준면 세부 배치 | 거의 안 함 |
| `sub/abstractKor.tex` / `abstractEng.tex` | 국문/영문 초록 | 예 |
| `sub/1-Introduction.tex` ~ `sub/5-Conclusions.tex` | 장별 본문 | 예 |
| `sub/references.bib` | 참고문헌 BibTeX | 예 |
| `sub/A4_Code_File_Example.tex` | 부록에 Python 코드 넣는 예시 | 선택 |
| `code/` | 분석 코드·부록용 코드 파일 | 선택 |
| `images/` | 본문 삽입 그림 | 예 |
| `logo/` | 표지·워터마크용 로고 | 거의 안 함 |
| `KNUE_thesis_main_build.cmd` / `.sh` | 로컬 빌드 스크립트(아래 "빌드 모드" 참고) | - |
| `make-diff.cmd` / `.sh` | git 커밋 기준 변경 추적 PDF 생성 | - |

---

## Overleaf에서 사용하는 방법

GitHub에서 이 템플릿을 내려받아 Overleaf에서 사용할 때는 `KNUE_thesis` 폴더 안의 내용물이 Overleaf 프로젝트 최상위에 놓이도록 업로드해야 합니다. 최상위에 `KNUE_thesis_main.tex`, `KNUE_thesis.cls`, `sub/`, `images/`, `logo/`가 함께 보여야 합니다.

1. GitHub 저장소 <https://github.com/Kiehyun/ESE_Lab_template>에 접속해 `Code` → `Download ZIP`.
2. 압축을 풀고 `KNUE_thesis` 폴더로 들어갑니다.
3. `KNUE_thesis` 폴더 자체가 아니라 **그 안의 파일과 하위 폴더 전체**를 선택해 새 ZIP으로 압축합니다.
4. Overleaf에서 `New Project` → `Upload Project` → 방금 만든 ZIP 업로드.
5. 메인 파일이 `KNUE_thesis_main.tex`인지 확인하고, `Menu`/`Settings`에서 `Compiler`를 **LuaLaTeX**로 바꿉니다.
6. `Recompile` 후 표지·인준면·초록·목차·표/그림 번호가 의도한 대로 나오는지 확인합니다.

GitHub 저장소 ZIP을 그대로 올리면 `ESE_Lab_template-main/KNUE_thesis/`처럼 한 단계 안쪽에 들어가 메인 문서를 못 찾거나 상대 경로가 어긋날 수 있으므로, 위처럼 `KNUE_thesis` 안쪽 내용만 새 ZIP으로 묶어 올리세요.

이 템플릿은 LuaLaTeX 기준으로 맞춰져 있습니다. 컴파일러가 pdfLaTeX/XeLaTeX이면 표지에 `\directlua` 코드가 그대로 보이거나 한글 글꼴·줄바꿈이 달라질 수 있습니다.

### Overleaf 요금제 참고

Overleaf의 요금제·제한은 바뀔 수 있으므로 제출 전 공식 문서를 확인하세요. 무료 계정은 프로젝트 수 제한은 없지만 컴파일 10초·공동작업자 1명 제한이 있고, 유료 요금제는 컴파일 240초에 요금제별로 공동작업자 수가 늘어납니다. 프로젝트 파일은 최대 2000개, 업로드당 50MB, 편집 가능 텍스트 전체 7MB(개별 파일 2MB) 제한입니다. 전체 프로젝트 용량은 500MB 이하(GitHub 연동 시 100MB 이하)를 권장합니다.

- GitHub ZIP 다운로드: <https://docs.github.com/en/repositories/working-with-files/using-files/downloading-source-code-archives>
- Overleaf 프로젝트 업로드: <https://docs.overleaf.com/managing-projects-and-files/uploading-a-project>
- Overleaf 요금제: <https://docs.overleaf.com/getting-started/free-and-premium-plans>

---

## 참고문헌 인용 명령

참고문헌은 `sub/references.bib`에 BibTeX 형식으로 입력합니다. 본문에서 실제로 인용한 항목만 목록에 출력됩니다. 인용·참고문헌 표기 원칙(저자 수 규칙, 직접/간접인용 등)은 [Readme__KNUEthesis.md](../KNUE_thesis/Readme__KNUEthesis.md)를 참고하고, 여기서는 LaTeX 명령 문법만 다룹니다.

```tex
% 영어 문헌
\textcite{eng_example2026}
(\parencite{eng_example2026})

% 한국어 문헌
\ktextcite{kor_example2026}
(\kparencite{kor_example2026})
```

`\parencite`/`\kparencite`는 바깥 괄호를 직접 출력하지 않으므로, 한국어·영어 문헌을 함께 인용할 때는 괄호를 직접 감싸고 한국어 문헌을 앞에, 영어 문헌을 뒤에 세미콜론으로 구분해 둡니다.

```tex
관련 논의는 여러 연구에서 확인된다(\kparencite{kor_cite_example_two_authors}; \parencite{eng_cite_example_two_authors}).
% → (홍길동과 임꺽정, 2026; Hong and Im, 2026)
```

### Google Scholar에서 BibTeX 가져오기

1. 논문 제목 검색 → 검색 결과 아래 인용 아이콘 클릭 → `BibTeX` 선택.
2. BibTeX 항목 전체를 복사해 `sub/references.bib`에 붙여 넣습니다.
3. 저자명·제목·학술지명·연도·권호·페이지·DOI를 실제 논문과 대조합니다.
4. 한국어 문헌에는 `langid = {korean}`, 영어 문헌에는 `langid = {english}`를 추가합니다(한 논문 안에서 한국어·영어 문헌 표기를 구분하는 데 사용).

---

## 표와 그림 명령

표 번호·그림 번호는 `\caption{}`과 `\label{}`로 자동 부여됩니다. 표에는 `\ThesisTableStyle`을 `\caption{}`/`\label{}` 다음, `tabular*` 시작 전에 넣어 글자 크기·간격을 템플릿에 맞춥니다.

```tex
\begin{table}[htbp]
    \centering
    \caption{집단별 사전-사후 검사 점수 예시}
    \label{tab:result-example}
    \ThesisTableStyle
    \begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}p{0.22\textwidth}rrrr@{}}
        \toprule
        집단 & 사례 수 & 사전 평균 & 사후 평균 & 평균 변화 \\
        \midrule
        실험 집단 & 30 & 68.40 & 82.15 & 13.75 \\
        \bottomrule
    \end{tabular*}
\end{table}

표~\ref{tab:result-example}에서 ...
```

```tex
\begin{figure}[htbp]
    \centering
    \includegraphics[width=0.8\textwidth]{images/example.pdf}
    \caption{그림 제목}
    \label{fig:example-image}
\end{figure}

그림~\ref{fig:example-image}는 ...
```

### 위치 옵션(float)

`table`/`figure`는 본문 사이를 떠다니는 float 환경이라 `[htbp]` 등은 정확한 고정 위치가 아니라 배치 후보입니다.

| 옵션 | 의미 |
| --- | --- |
| `h` | 가능한 한 현재 위치 |
| `t` | 페이지 위쪽 |
| `b` | 페이지 아래쪽 |
| `p` | 표/그림만 모은 별도 페이지 |
| `!` | 배치 제한 완화 |

기본은 `[htbp]`가 안정적입니다. 완전 고정용 `[H]`는 `float` 패키지가 필요하고 남용하면 여백·흐름이 어색해지므로 제한적으로 씁니다.

### 그림 파일 형식

| 형식 | 권장 용도 |
| --- | --- |
| `.pdf` | 그래프·도식·벡터 그림 (가장 권장) |
| `.png` | 화면 캡처, 글자·선 포함 래스터 이미지 |
| `.jpg` | 사진 자료(손실 압축이라 그래프·표 이미지·텍스트 포함 그림엔 부적합) |

```tex
\includegraphics[width=0.8\textwidth, trim=1cm 0.5cm 1cm 0.5cm, clip]{images/example.pdf}
```

`trim` 순서는 왼쪽·아래쪽·오른쪽·위쪽입니다.

### 그림 컬러본과 흑백본

`\figf`(또는 프로젝트에서 정의한 동등 매크로)로 컬러/흑백 두 버전을 준비해 두면, `bw` 빌드 모드에서 자동으로 흑백 파일을 선택합니다. 컬러/흑백 관리 원칙은 아래 "빌드 모드" 표를 참고하세요.

---

## 수식과 TikZ

```tex
\begin{equation}
    \bar{x} = \frac{1}{n}\sum_{i=1}^{n} x_i
    \label{eq:mean-example}
\end{equation}

식~\ref{eq:mean-example}은 ...
```

TikZ 그림도 일반 그림처럼 `figure` 환경 안에 넣고 `\caption{}`/`\label{}`로 참조합니다. 예시는 `sub/4-Results.tex`에 있습니다.

---

## 워터마크

각 페이지 배경 중앙에 학교 로고를 연하게 넣는 기능입니다. 최종 제출 PDF에 필요한지는 학교·학과 지침을 먼저 확인하세요.

`KNUE_thesis_main.tex` 맨 위 `\documentclass` 옵션으로 켜고 끕니다(기본값 `nowatermark`). 두 줄을 동시에 활성화하지 마세요.

```tex
\documentclass[watermark]{KNUE_thesis}     % 워터마크 켜기
% \documentclass[nowatermark]{KNUE_thesis} % 워터마크 끄기(둘 중 하나만 주석 해제)
```

로고 파일은 `logo/Knue_logo.png`이며, `KNUE_thesis.cls`의 `Optional KNUE Logo Watermark` 부분에서 파일명·크기(`width=88mm`)·진하기(`opacity=0.35`, 0에 가까울수록 옅음)를 조정할 수 있습니다.

## 표지 사각형 테두리(트림박스)

표지·인준면의 190mm×260mm 테두리는 재단 영역 확인용 표시입니다. 최종 제출본에는 보통 필요 없으므로 `notrimbox` 옵션을 씁니다.

```tex
\documentclass[nowatermark,notrimbox]{KNUE_thesis}  % 테두리 숨김
\documentclass[nowatermark,trimbox]{KNUE_thesis}    % 테두리 표시
```

`trimbox`와 `notrimbox`는 동시에 사용하지 않습니다.

---

## 로컬 빌드와 빌드 모드

Windows는 `KNUE_thesis_main_build.cmd`, macOS·Linux·Git Bash는 `KNUE_thesis_main_build.sh`를 씁니다.

| 모드 | 설명 |
| --- | --- |
| `build` | 기본값. 참고문헌(biber) 포함 전체 빌드 |
| `quick` | 변경분만 빠르게 재빌드(참고문헌 재처리 생략) |
| `clean` | 보조 파일·잠금 폴더 삭제(`.tex`/`.pdf`는 보존) |
| `watch` | 파일 변경 시 자동 재빌드 |
| `submit` | 최종 제출본. 수정 표시를 모두 끄고(검정) `..._submit.pdf`로 복사 |
| `review` | 검토본. 심사위원별 색상 수정 표시, `..._review_colors.pdf`로 복사 |
| `review-blue` | 검토본. 수정 표시를 전체 파란색으로 통일, `..._review_blue.pdf`로 복사 |
| `color` | 그림 컬러본 사용, `..._컬러.pdf`로 복사 |
| `bw` | 그림 흑백본 사용 + 문서 전체 회색조 변환, `..._흑백.pdf`로 복사 |
| `crops` | 그림 여백(trim/clip) 확인용 `crop_debug.pdf` 생성 |

```powershell
.\KNUE_thesis_main_build.cmd            # 기본 빌드
.\KNUE_thesis_main_build.cmd submit     # 최종 제출본
.\KNUE_thesis_main_build.cmd review     # 심사위원별 색상 검토본
```

```bash
./KNUE_thesis_main_build.sh             # 기본 빌드
./KNUE_thesis_main_build.sh submit      # 최종 제출본
```

`submit`/`review`/`review-blue`는 수정 표시 매크로를 환경변수(`THESIS_SHOW_REVISIONS`, `THESIS_REV_ALLBLUE`)로 자동 전환합니다.

---

## 심사위원별 수정 표시(검토본)

"어느 심사위원 지적을 반영해 어디를 고쳤는지" 색으로 구분해 보여주는 기능입니다. 두 방식을 함께 씁니다.

### 방식 1. 수정 표시 매크로(직접 감싸기)

`sub/0-preamble.tex`에 정의된 명령으로 수정한 부분을 직접 감쌉니다.

- `\revised{...}` — 공통/기타 수정(파란색)
- `\revisedA{...}`/`\revisedB{...}`/`\revisedC{...}`/`\revisedD{...}` — 심사위원 1~4 의견 반영(파랑·초록·보라·청록)
- `\revTODO{담당색명령}{메모}` — 아직 고치지 않고 메모만 남길 때. 예: `\revTODO{\revisedB}{제목 재검토 필요}`
- `\RevisionLegend` — 색-심사위원 대응 범례 출력(`KNUE_thesis_main.tex`에 주석 처리되어 있으니 필요하면 `%`만 해제)

색 표시는 빌드 모드로 전환합니다: `review`(심사위원별 색상) / `review-blue`(전체 파랑, 범례 자동 숨김) / `submit`(표시 없음, 기본 빌드도 동일 — `\revised` 래퍼를 지울 필요 없음). 심사위원별 색상은 `sub/0-preamble.tex`의 `\definecolor{RevA}{RGB}{...}`~`RevD`에서, 범례 이름은 `\RevisionLegend` 정의에서 수정합니다.

> 참고: 템플릿 본문은 예시 골격이라 수정 표시 매크로가 실제로 쓰인 곳은 없습니다. 직접 감싸야 색이 나타납니다.

### 방식 2. git 기준 변경 추적(make-diff)

`make-diff.cmd`/`.sh`는 특정 git 커밋 시점과 현재 원고를 비교해 변경분을 자동 표시한 PDF를 만듭니다(추가=파랑, 삭제=빨강 취소선, `latexdiff` 사용).

```powershell
.\make-diff.cmd            # 마지막 커밋 이후 변경분
.\make-diff.cmd 3a1c9ef    # 특정 커밋 이후 변경분
```

필요 도구: `git`, `latexpand`, `latexdiff`, `latexmk`, `lualatex`, `biber`(Windows는 `tar`도 필요, 대부분 TeX Live에 포함). 결과물은 `KNUE_thesis_main-diff<짧은해시>.pdf`(`--no-build`로 PDF 생략 가능).

**활용법**: 논문 단계가 끝날 때마다(초고 완성, 투고본·심사본 제출 등) 커밋 + git 태그로 "구분점"을 남기면, 그 이후 변경분만 색 표시 PDF로 뽑아낼 수 있습니다.

```bash
git add -A && git commit -m "박사학위논문 심사본 제출" && git tag 심사본-1차
# 수정 반영 후...
./make-diff.sh 심사본-1차          # 태그 이후 변경분(색 표시 PDF)
git diff 심사본-1차 -- '*.tex'      # 변경 목록만 텍스트로
git log --oneline 심사본-1차..HEAD  # 그 사이 커밋 목록
```

원고를 고치기 전에 "지금이 어떤 시점인가"를 커밋+태그로 먼저 남겨 두는 것이 핵심입니다. 저장소 전체 관점의 커밋·태그 워크플로는 [4-OBSIDIAN_VAULT_SETUP.md](4-OBSIDIAN_VAULT_SETUP.md)에도 있습니다.

---

## Python 코드 부록 & 참고문헌 PDF 도구

Python 예제 코드는 `code/example_analysis.py`에 있고, `sub/A4_Code_File_Example.tex`가 부록에 코드 파일을 불러오는 예시입니다. 코드 파일을 `code/`에 저장하고 부록용 `.tex`에서 파일명으로 참조합니다.

저장소 루트(또는 템플릿 폴더) `code/`에는 참고문헌 PDF 관리용 Python 스크립트 두 개가 있습니다.

| 파일 | 역할 |
| --- | --- |
| `code/rename_ref_pdfs_by_bib.py` | `references.bib`와 `ref/` 폴더 PDF를 대조해 `저자. (연도). 제목. 학술지.pdf` 형태로 이름 정리. CSV 보고서 생성 |
| `code/download_missing_ref_pdfs.py` | `references.bib`에는 있지만 없는 PDF를 공개 접근·DOI·연구실 검색 서버에서 자동 다운로드 |

필요 패키지: `pymupdf`, `pypdf`, `requests`. [3-PYTHON_CONDA_VSCODE_SETUP.md](3-PYTHON_CONDA_VSCODE_SETUP.md)의 `knue-python` conda 환경 사용을 권장합니다.

```powershell
conda activate knue-python
pip install pymupdf pypdf requests

python code/rename_ref_pdfs_by_bib.py --dry-run   # 미리보기
python code/rename_ref_pdfs_by_bib.py             # 실제 변경
python code/download_missing_ref_pdfs.py --dry-run
python code/download_missing_ref_pdfs.py
```

전체 옵션은 `--help`로 확인합니다. 연구실 논문 검색 서버(`parksparks`) 비밀번호는 환경 변수 `PARKSPARKS_PASSWORD` 또는 `code/.parksparks_secret` 파일(gitignore 처리됨)로 제공합니다. 비밀번호가 없거나 틀리면 검색 서버만 건너뛰고 공개 출처 다운로드는 계속됩니다.

---

## 최종 제출 전 확인 (양식 항목)

1. 표지의 논문 제목·저자명·지도교수명·심사위원명이 정확한가?
2. 석사/박사 학위 구분(`\degreeProgramKor`, `\degreeEng`)이 맞는가?
3. 국문·영문 초록의 제목·저자명·전공명·주요어가 맞는가?
4. 워터마크·트림박스 옵션이 제출 목적에 맞게 설정됐는가?
5. `submit` 모드로 빌드해 수정 표시가 모두 사라졌는지 확인했는가?
6. **도서관 제출용 원문에는 심사위원 전원의 실제 서명·도장을 받은 인준면(원본 또는 스캔본)이 들어가 있는가?** — PDF의 텍스트 인준면만으로는 제출이 인정되지 않습니다(위 "석사·박사 학위 구분 사용법"의 도서관 제출 안내 참고).

논문 내용 관련 체크리스트(인용·표/그림·생성형 AI 검증 등)는 [Readme__KNUEthesis.md](../KNUE_thesis/Readme__KNUEthesis.md)의 "학위논문 완성도 점검"을 참고하세요. 학교·학과 규정은 바뀔 수 있으므로 최종 제출 전 공식 지침과 반드시 대조하세요.

---

## 형식 문제 제보

학교·학과 지침이 바뀌었거나 템플릿에 아직 반영되지 않은 포맷 문제를 발견하면 GitHub issue로 등록해 주세요.

1. <https://github.com/Kiehyun/ESE_Lab_template/issues> → `New issue`.
2. 제목에는 문제를 짧게(예: `표 목차 번호 간격 수정 필요`).
3. 본문에 PDF 쪽수, 관련 파일명, 기대한 형식, 현재 출력 결과를 적습니다.
4. 가능하면 공식 지침 항목이나 화면 캡처를 첨부합니다.

---

## English Quick Start for Thesis Authors

Use this checklist if you do not read Korean and need to create or troubleshoot the PDF.

1. Open `sub/0-preamble.tex` and set `\newcommand{\documentLanguage}{english}` (or keep `korean`).
2. Enter both English and Korean thesis metadata in `sub/0-preamble.tex`. KNUE documents may still require Korean title, author, major, and abstract information even for an English thesis.
3. Set `\degreeProgramKor` to `석사` (master's) or `박사` (doctoral, default), and `\degreeEng` accordingly (`Master of Education` / `Doctor of Philosophy in Education`). For a doctoral thesis, fill in all five committee members (`\committeeChairKor/Eng` through `\committeeMemberFourKor/Eng`); for a master's thesis only the chair and two members are shown.
4. Write the main chapters in `sub/1-Introduction.tex` through `sub/5-Conclusions.tex`.
5. Put figures in `images/` and bibliography entries in `sub/references.bib`.
6. Build the PDF from the `KNUE_thesis` folder: `.\KNUE_thesis_main_build.cmd`.
7. Check `KNUE_thesis_main.pdf`. If it is not created, see "Troubleshooting for English Users" below.

### Troubleshooting for English Users

**The PDF is not created.** LaTeX stopped before producing `KNUE_thesis_main.pdf`.

1. Run a clean build: `.\KNUE_thesis_main_build.cmd clean` then `.\KNUE_thesis_main_build.cmd`.
2. Open `KNUE_thesis_main.log` and search for the first line starting with `!`. Fix that error first — later messages are often caused by it.

**`latexmk` cannot be found** (`'latexmk' is not recognized...`). Windows cannot find `latexmk.exe`.

1. Check that `latexmk.exe`, `lualatex.exe`, `biber.exe` exist under `C:\texlive\2026\bin\windows`.
2. Add that folder to the Windows `Path` environment variable.
3. Restart VS Code and build again.

**A build lock remains** (`Error: Another build/watch is already running.`). Run `.\KNUE_thesis_main_build.cmd clean` then build again.

**References do not appear.** BibLaTeX only prints works actually cited in the text.

1. Check the BibTeX entry exists in `sub/references.bib`.
2. Check the citation key is used in the main text.
3. Run a clean build.

**Git reports unmerged files** (`Committing is not possible because you have unmerged files.`). Run `git status`, open each unmerged file, resolve the `<<<<<<<`/`=======`/`>>>>>>>` conflict markers, `git add` the resolved files, then commit again.
