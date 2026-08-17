# 한국교원대학교 학위논문 LaTeX 템플릿

현재 이 양식은 개발 중이며, 학교 또는 학과 지침 변경과 사용자 피드백에 따라 계속해서 수정 및 보완될 수 있습니다. 최종 제출 전에는 반드시 최신 공식 학위논문 작성 지침과 생성된 PDF를 직접 대조해 주세요.

이 폴더는 한국교원대학교 석사/박사 학위논문 작성을 위한 LaTeX 템플릿입니다. 표지, 인준면, 국문 초록, 영문 초록, 목차, 표 목차, 그림 목차, 본문, 참고문헌, 부록을 하나의 프로젝트로 관리합니다.
현재 템플릿은 한국어 학위논문과 영어 학위논문 두 가지 경우를 지원합니다. 영어 논문을 작성할 때도 `sub/en` 같은 별도 폴더를 만들지 않고, `sub/`의 같은 장별 파일에 영어 본문을 작성합니다.

이 저장소는 연구의 전 과정(연구 계획서 → 발표 → 학위논문 → 학술지 투고)을 **하나의 Obsidian 볼트 안에서** 이어가도록 설계되었습니다. 저장소 전체를 볼트로 열고, 학위논문은 그 안의 `KNUE_thesis/` 폴더에서 그대로 작성하는 것을 권장합니다. 다만 특정 양식만 따로 관리하거나 Overleaf에 올리려면 `KNUE_thesis/` 폴더만 복사해 별도 작업 폴더로 써도 됩니다(각 템플릿 폴더는 단독으로도 빌드됩니다). 볼트 활용법은 저장소 루트의 `manual/4-OBSIDIAN_VAULT_SETUP.md`를 참고하세요.

학위논문에서는 연구 내용만큼이나 학교가 요구하는 형식을 맞추는 일도 중요합니다. 이 템플릿은 여백, 글꼴, 장 제목, 표지, 인준면, 목차, 표와 그림 번호처럼 반복적으로 확인해야 하는 포맷 요소를 미리 설정해 두어, 작성자가 형식을 매번 직접 조정하지 않고 논문 내용 작성에 집중할 수 있도록 돕습니다.

LaTeX 설치, VS Code 설정, 빌드 실행 방법은 상위 폴더의 [README.md](../README.md)와 거기서 안내하는 설치 문서를 확인합니다. Overleaf로 작성하려면 [1-OVERLEAF_THESIS_PROJECT.md](../manual/1-OVERLEAF_THESIS_PROJECT.md)를, 개인 PC에 직접 설치해 작성하려면 [2-VSCODE_LOCAL_THESIS_SETUP.md](../manual/2-VSCODE_LOCAL_THESIS_SETUP.md)를 참고합니다. Windows에서 TeX Live를 설치할 때 참고할 공식 문서와 연구실 ISO 이미지 설치 방법은 `2-VSCODE_LOCAL_THESIS_SETUP.md`에 정리되어 있습니다. 이 문서는 한국교원대학교 학위논문 템플릿의 파일 구성과 작성 방법만 설명합니다.

## Overleaf에서 사용하는 방법

GitHub에서 이 템플릿을 내려받아 Overleaf에서 사용할 때는 `KNUE_thesis` 폴더 안의 내용물이 Overleaf 프로젝트의 최상위에 놓이도록 업로드하는 것이 가장 안전합니다.
Overleaf 프로젝트의 최상위에는 `KNUE_thesis_main.tex`, `KNUE_thesis.cls`, `sub/`, `images/`, `logo/`가 함께 보여야 합니다.

1. GitHub 저장소 <https://github.com/Kiehyun/ESE_Lab_template>에 접속합니다.
2. `Code` 버튼을 누르고 `Download ZIP`을 선택해 저장소를 내려받습니다.
3. 내려받은 ZIP 파일의 압축을 풉니다.
4. 압축을 푼 폴더 안에서 `KNUE_thesis` 폴더로 들어갑니다.
5. `KNUE_thesis` 폴더 자체가 아니라, 그 안의 파일과 하위 폴더 전체를 선택해 새 ZIP 파일로 압축합니다.
   예를 들어 새 ZIP 파일을 열었을 때 바로 `KNUE_thesis_main.tex`, `KNUE_thesis.cls`, `sub/`, `images/`, `logo/`가 보여야 합니다.
6. Overleaf에 로그인한 뒤 `New Project`를 누르고 `Upload Project`를 선택합니다.
7. 방금 만든 ZIP 파일을 업로드합니다.
8. 프로젝트가 열리면 메인 파일이 `KNUE_thesis_main.tex`인지 확인합니다.
9. `Menu` 또는 `Settings`에서 `Compiler`를 `LuaLaTeX`로 바꿉니다.
10. `Recompile`을 눌러 PDF를 생성합니다.
11. 표지, 인준면, 초록, 목차, 표와 그림 번호가 의도한 대로 출력되는지 확인합니다.

GitHub에서 받은 저장소 ZIP을 그대로 올리면 `ESE_Lab_template-main/KNUE_thesis/`처럼 한 단계 안쪽에 논문 파일이 들어갈 수 있습니다.
이 경우 Overleaf가 메인 문서를 자동으로 찾지 못하거나 상대 경로가 어긋날 수 있으므로, 위 순서처럼 `KNUE_thesis` 안쪽 내용만 새 ZIP으로 묶어 올리는 방식을 권장합니다.

이 템플릿은 LuaLaTeX 기준으로 표지 간격, 한글 글꼴, 이름 자간을 맞추었습니다.
Overleaf의 컴파일러가 `pdfLaTeX`나 `XeLaTeX`로 되어 있으면 표지 첫 장에 `\directlua` 코드가 그대로 보이거나, 한글 글꼴과 줄바꿈이 로컬 빌드 결과와 달라질 수 있습니다.

### Overleaf 회원 정책과 제한

Overleaf의 요금제와 제한은 바뀔 수 있으므로, 논문을 제출하기 전에는 공식 문서의 최신 내용을 확인하는 것이 좋습니다.
2026년 5월 6일 공식 문서 확인 기준으로는 무료 계정도 프로젝트 수 제한 없이 사용할 수 있지만, 무료 계정의 컴파일 제한 시간은 10초이고 프로젝트당 공동 작업자는 1명입니다.
유료 요금제는 컴파일 제한 시간이 240초로 늘어나며, Student는 프로젝트당 6명, Standard는 10명, Professional은 제한 없는 수의 공동 작업자를 초대할 수 있습니다.

프로젝트 파일 제한은 무료와 유료 모두 프로젝트당 최대 2000개 파일, 한 번 업로드당 최대 50 MB, Overleaf에서 편집 가능한 전체 텍스트 자료 7 MB, 개별 편집 가능 텍스트 파일 2 MB입니다.
전체 프로젝트 크기에 강제 제한은 없지만, Overleaf는 큰 프로젝트에서는 성능 문제가 생길 수 있으므로 500 MB 이하를 권장하고, GitHub 동기화나 Git 연동을 사용할 경우에는 100 MB 이하를 권장합니다.

이 학위논문 템플릿을 혼자 작성하고 그림 파일이 크지 않다면 무료 계정으로도 시작할 수 있습니다.
다만 그림이 많거나 참고문헌과 부록이 커져 컴파일 시간이 자주 초과되거나, 여러 명이 동시에 검토해야 하거나, GitHub 연동과 변경 추적 기능이 필요하면 유료 요금제 또는 로컬 빌드를 함께 고려합니다.

공식 안내:

- GitHub ZIP 다운로드: <https://docs.github.com/en/repositories/working-with-files/using-files/downloading-source-code-archives>
- Overleaf 프로젝트 업로드: <https://docs.overleaf.com/managing-projects-and-files/uploading-a-project>
- Overleaf 무료/유료 요금제: <https://docs.overleaf.com/getting-started/free-and-premium-plans>
- Overleaf 요금제 제한: <https://docs.overleaf.com/getting-started/free-and-premium-plans/plan-limits>

## 형식 문제 제보

학교 또는 학과의 최신 학위논문 작성 지침이 바뀌었거나, 아직 이 템플릿에 반영되지 않은 포맷 문제가 있을 수 있습니다. 그런 부분을 발견하면 GitHub issue로 등록해 주세요. 여백, 표지, 인준면, 표와 그림 배치, 사각형 테두리 표시처럼 양식 개선이 필요한 부분도 issue로 남겨 주시면 템플릿 보완에 반영할 수 있습니다.

1. 웹브라우저에서 <https://github.com/Kiehyun/ESE_Lab_template/issues>에 접속합니다.
2. `New issue`를 누릅니다.
3. 제목에는 문제를 짧게 적습니다. 예: `표 목차 번호 간격 수정 필요`
4. 본문에는 문제가 나타난 PDF 쪽수, 관련 파일명, 기대한 형식, 현재 출력 결과를 적습니다.
5. 가능하면 공식 학위논문 작성 지침의 해당 항목이나 화면 캡처를 함께 첨부합니다.

최종 제출 전에는 반드시 학교 또는 학과의 최신 공식 지침과 생성된 PDF를 대조해 주세요.

## 주요 파일

| 파일 또는 폴더 | 역할 |
| --- | --- |
| `KNUE_thesis_main.tex` | 논문 전체를 조립하는 메인 파일입니다. 표지, 초록, 본문, 참고문헌, 부록의 순서를 관리합니다. |
| `KNUE_thesis.cls` | 한국교원대학교 학위논문 형식을 정의하는 클래스 파일입니다. 여백, 글꼴, 장 제목, 표/그림 번호 등을 설정합니다. |
| `sub/0-preamble.tex` | 논문 제목, 저자명, 지도교수, 심사위원, 학위 구분, 전공명, 공통 명령을 입력합니다. |
| `sub/coverpage-thesis.tex` | 표지와 인준면의 세부 배치를 조정합니다. |
| `sub/abstractKor.tex` | 국문 초록을 작성합니다. |
| `sub/1-Introduction.tex` | 서론을 작성합니다. |
| `sub/2-Theorical_background.tex` | 이론적 배경, 선행 연구, 참고문헌 인용 방법을 작성합니다. |
| `sub/3-Methods.tex` | 연구 방법을 작성합니다. |
| `sub/4-Results.tex` | 연구 결과, 표, 그래프, 그림, 수식, TikZ 예시를 작성합니다. |
| `sub/5-Conclusions.tex` | 결론 및 제언을 작성합니다. |
| `sub/abstractEng.tex` | 영문 초록을 작성합니다. |
| `sub/references.bib` | 참고문헌 BibTeX 정보를 입력합니다. |
| `sub/A4_Code_File_Example.tex` | Python 코드 파일을 부록에 넣는 예시입니다. |
| `code/` | Python 분석 코드나 부록에 넣을 코드 파일을 저장합니다. |
| `images/` | 본문에 삽입할 그림 파일을 저장합니다. |
| `logo/` | 표지나 워터마크에 사용할 로고 파일을 저장합니다. |
| `KNUE_thesis_main_build.cmd` / `.sh` | 로컬 빌드 스크립트입니다. `build`/`quick`/`clean`/`watch`/`submit`/`review`/`review-blue`/`crops` 모드를 지원합니다(Windows는 `.cmd`, macOS·Linux·Git Bash는 `.sh`). |
| `make-diff.cmd` / `.sh` | git 커밋을 기준으로 "변경 추적(track-changes)" PDF를 만드는 스크립트입니다(추가=파랑, 삭제=빨강 취소선). |

## 이 문서의 구성

이 안내 문서는 학위논문을 작성할 때 필요한 내용과 이 템플릿을 실제로 수정하는 방법을 함께 설명합니다.
각 장에 무엇을 써야 하는지, 연구 목적과 연구 문제를 어떻게 연결하는지, 표와 그림을 어떻게 해석해 서술하는지 먼저 이해한 뒤, 해당 내용을 어느 파일에서 어떤 LaTeX 명령으로 입력하는지 확인하면 됩니다.

## 처음 수정할 곳

처음 사용할 때는 아래 순서로 수정합니다.

1. `sub/0-preamble.tex`에서 논문 제목, 저자명, 지도교수명, 심사위원명, 학위 구분을 수정합니다.
2. `sub/abstractKor.tex`와 `sub/abstractEng.tex`에서 국문 초록과 영문 초록을 작성합니다.
3. `sub/1-Introduction.tex`부터 `sub/5-Conclusions.tex`까지 장별 본문을 작성합니다.
4. `sub/references.bib`에 참고문헌 BibTeX 정보를 추가합니다.
5. 본문에서 실제로 참고문헌을 인용합니다.
6. 필요한 경우 `code/`에 분석 코드를 넣고 부록에서 파일명으로 불러옵니다.

위 파일명은 템플릿에서 제공하는 예시입니다. 저자는 논문 구성과 작업 방식에 맞게 파일명을 바꿀 수 있으며, 파일명을 바꾼 경우에는 `KNUE_thesis_main.tex`의 `\include` 또는 `\input` 명령도 함께 수정해야 합니다.

## 한국어 논문을 작성하는 경우

한국어로 학위논문을 작성할 때는 `sub/0-preamble.tex`에서 `\documentLanguage` 값을 `korean`으로 둡니다. 템플릿의 기본값은 `korean`입니다.

```tex
\newcommand{\documentLanguage}{korean}
```

같은 파일에서 표지, 인준면, 초록에 반복해서 쓰이는 논문 정보를 수정합니다. 한국어 논문이라도 영문 제목과 영문 초록이 필요하므로, 국문 정보와 영문 정보를 함께 입력합니다.

```tex
\newcommand{\thesistitleKor}{국문 논문 제목}
\newcommand{\thesistitleEng}{English Thesis Title}
\newcommand{\authorKor}{홍길동}
\newcommand{\authorEng}{Hong, Gildong}
\newcommand{\advisorKor}{임꺽정}
\newcommand{\advisorEng}{Im, Kkeokjeong, Ph. D.}
\newcommand{\degreeProgramKor}{석사}
\newcommand{\degreeEng}{Master of Education}
```

한국어 논문에서는 본문을 `sub/1-Introduction.tex`, `sub/2-Theorical_background.tex`, `sub/3-Methods.tex`, `sub/4-Results.tex`, `sub/5-Conclusions.tex`에 한국어로 작성합니다. 국문 초록은 `sub/abstractKor.tex`에, 영문 초록은 `sub/abstractEng.tex`에 작성합니다.

출력 순서는 한국어 학위논문 형식에 맞게 구성됩니다. 앞쪽에는 국문 초록이 나오고, 참고문헌 뒤에는 영문 초록이 나옵니다. 표와 그림 표기는 본문과 표 목차/그림 목차에서 한국어 형식인 `표`, `그림`으로 출력됩니다.

## 영어 논문을 작성하는 경우

영어로 학위논문을 작성할 때는 `sub/0-preamble.tex`에서 `\documentLanguage` 값을 `english`로 바꿉니다.

```tex
\newcommand{\documentLanguage}{english}
```

그 다음 같은 파일에서 표지, 인준면, 초록에 쓰이는 한국어 정보와 영어 정보를 모두 확인합니다. 영어 논문에서는 영문 정보가 표지와 본문 앞쪽에 더 두드러지게 쓰이지만, 한글 제목과 국문 초록도 함께 필요합니다.

```tex
\newcommand{\thesistitleEng}{English Thesis Title}
\newcommand{\thesistitleKor}{국문 논문 제목}
\newcommand{\authorEng}{Hong, Gildong}
\newcommand{\authorKor}{홍길동}
\newcommand{\majorEng}{Major in Earth Science Education}
\newcommand{\majorKor}{지구과학교육전공}
\newcommand{\degreeEng}{Doctor of Philosophy in Education}
\newcommand{\degreeProgramKor}{박사}
```

본문은 한국어 논문과 같은 파일에 작성합니다. 별도의 `sub/en` 폴더를 만들거나 영어용 장 파일을 복제하지 않고, `sub/1-Introduction.tex`, `sub/2-Theorical_background.tex`, `sub/3-Methods.tex`, `sub/4-Results.tex`, `sub/5-Conclusions.tex`의 내용을 영어로 작성하면 됩니다.

영어 모드에서는 영문 제목이 위에, 한글 제목이 아래에 나오고, 영문 초록이 앞쪽에 배치됩니다. 국문 초록은 참고문헌 뒤에 배치됩니다. 표와 그림 표기는 본문과 표 목차/그림 목차에서 각각 `Table`, `Fig.` 형식으로 출력됩니다.

정리하면, 한국어 논문과 영어 논문은 다른 폴더를 쓰는 방식이 아닙니다. `sub/0-preamble.tex`의 `\documentLanguage` 값으로 출력 언어와 초록 배치, 표/그림 표기 방식을 선택하고, 본문은 같은 장별 파일에 선택한 언어로 작성합니다.

## 논문 정보 수정

논문 전체에서 반복되는 정보는 `sub/0-preamble.tex`에서 한 번만 수정합니다.

```tex
\newcommand{\thesistitleKor}{\LaTeX{}을 이용하여 학위논문 작성하기}
\newcommand{\thesistitleEng}{Writing a Thesis with \LaTeX}
\newcommand{\authorKor}{홍길동}
\newcommand{\authorEng}{Hong, Gildong}
\newcommand{\thesiskeywordsKor}{지구과학, 과학교육, 5개 입력}
\newcommand{\thesiskeywordsEng}{Earth science, science education, enter five keywords}
\newcommand{\advisorKor}{임꺽정}
\newcommand{\advisorEng}{Im, Kkeokjeong, Ph. D.}
```

국문 주요어는 국문 초록과 PDF 메타데이터의 `pdfkeywords`에 함께 사용됩니다. 영문 주요어는 영문 초록에 사용됩니다.

심사위원 이름도 같은 파일에서 수정합니다.

```tex
\newcommand{\committeeChairKor}{성춘향}
\newcommand{\committeeMemberOneKor}{이몽룡}
\newcommand{\committeeMemberTwoKor}{장보고}
```

박사학위논문은 심사위원장 1명과 심사위원 4명을 출력하고, 석사학위논문은 심사위원장 1명과 심사위원 2명을 출력합니다.

## 석사/박사 학위 구분

학위 구분은 `sub/0-preamble.tex`에서 수정합니다.

석사학위논문:

```tex
\newcommand{\degreeProgramKor}{석사}
\newcommand{\degreeEng}{Master of Education}
```

박사학위논문:

```tex
\newcommand{\degreeProgramKor}{박사}
\newcommand{\degreeEng}{Doctor of Philosophy in Education}
```

국문 학위 문구는 `\degreeProgramKor` 값을 기준으로 자동 반영됩니다. 영문 학위명은 `\degreeEng`에서 직접 확인하고 수정합니다.

## 장별 작성 내용

### 서론

서론은 독자에게 이 과학교육 연구가 왜 필요한지 설득하는 장입니다. 연구의 필요성에서는 교육과정 변화, 과학 개념 학습의 어려움, 탐구 역량, 수업 현장의 문제, 기존 연구의 한계를 근거와 함께 제시합니다. 연구 목적에서는 어떤 학습자, 과학 개념, 탐구 활동, 교수·학습 처치, 평가 결과를 밝히려는지 구체적으로 쓰고, 연구 문제에서는 그 목적을 자료로 답할 수 있는 질문으로 나눕니다. 연구 목적과 연구 문제는 뒤의 연구 방법, 연구 결과, 결론에서 반드시 다시 회수되어야 합니다.

이 내용은 `sub/1-Introduction.tex`에서 수정합니다.

### 이론적 배경

이론적 배경에는 과학 개념, 학습 이론, 탐구 활동, 교수·학습 모형, 평가 관점, 선행 연구, 본 연구의 분석 관점을 작성합니다. 선행 연구 검토에서는 문헌을 단순 나열하지 말고 과학교육 연구의 흐름, 쟁점, 한계를 중심으로 정리합니다.

이 내용은 `sub/2-Theorical_background.tex`에서 수정합니다. 이 파일에는 참고문헌 인용 예시와 생성형 AI가 제시한 선행 연구를 확인하는 방법도 포함되어 있습니다.

### 연구 방법

연구 방법에는 연구 설계, 참여자와 수업 맥락, 연구 절차, 자료 수집, 자료 분석, 타당도와 신뢰도, 연구 윤리를 작성합니다. 과학교육 분야에서는 연구 문제가 과학 개념 이해, 탐구 수행, 과학 학습 동기, 수업 상호작용, 교사의 전문성, 교육과정 실행처럼 다양하므로 연구 문제에 맞는 방법론을 분명히 선택해야 합니다.

양적 연구는 수업 처치의 효과, 집단 간 차이, 변인 간 관계를 검사 점수나 설문 결과처럼 수치 자료로 설명할 때 적절합니다. 질적 연구는 학습자의 사고 과정, 수업 장면의 의미, 교사와 학생의 상호작용을 면담, 관찰, 활동지, 담화 자료를 통해 깊이 해석할 때 적절합니다. 혼합 연구는 양적 결과와 질적 자료를 함께 사용하여 결과의 크기와 그 의미를 함께 설명할 때 사용합니다.

또한 과학교육 논문에서는 교수·학습 자료나 평가 도구를 만드는 개발 연구, 선행 연구의 흐름을 분석하는 문헌 연구, 전문가 합의를 도출하는 델파이 연구도 자주 사용됩니다. 어떤 방법을 선택하든 검사, 설문, 면담, 관찰, 수업 산출물처럼 과학교육 연구에서 사용하는 자료가 어떻게 수집되고 분석되었는지 독자가 평가할 수 있을 정도로 구체적으로 씁니다.

이 내용은 `sub/3-Methods.tex`에서 수정합니다.

### 연구 결과

연구 결과에는 연구 문제에 대한 답이 되는 결과를 작성합니다. 결과 장의 핵심은 학습자의 개념 변화, 탐구 수행, 응답 범주, 집단 간 차이, 수업 장면의 특징 등을 자료에 근거해 제시하는 것입니다. 표와 그림을 제시한 뒤에는 반드시 본문에서 그 의미를 설명합니다.

이 내용은 `sub/4-Results.tex`에서 수정합니다. 이 파일에는 표, 그림, 그래프, 수식, TikZ 그림 예시가 포함되어 있습니다.

### 결론 및 제언

결론 및 제언에는 연구 목적에 대한 최종 답, 연구 결과의 일반화, 연구의 의의, 제한점, 후속 연구 제언을 작성합니다. 결론은 결과 장의 수치를 반복하는 곳이 아니라, 연구 결과가 과학 개념 학습, 탐구 활동, 수업 설계, 평가, 교사 교육 또는 교육과정 실행 측면에서 무엇을 의미하는지 정리하는 곳입니다.

이 내용은 `sub/5-Conclusions.tex`에서 수정합니다.

## 참고문헌 인용

인용 표기 방법과 참고문헌 표기 방법은 학교, 학과, 학술지, 전공 분야에 따라 다를 수 있습니다. 최종 제출 전에는 반드시 소속 학교와 학과의 최신 학위논문 작성 지침을 확인해야 합니다.

이 템플릿의 인용 및 참고문헌 형식은 APA 7판을 기반으로 하되, 한국어 문헌의 저자명 표기와 조사 처리 등 한글 문헌에 필요한 규칙을 추가한 것입니다.

참고문헌 정보는 `sub/references.bib`에 BibTeX 형식으로 입력합니다. 본문에서 실제로 인용한 항목만 참고문헌 목록에 출력됩니다.

영어 문헌:

```tex
\textcite{eng_example2026}
(\parencite{eng_example2026})
```

한국어 문헌:

```tex
\ktextcite{kor_example2026}
(\kparencite{kor_example2026})
```

이 템플릿에서는 `\parencite`와 `\kparencite`가 바깥 괄호를 직접 출력하지 않도록 설정되어 있습니다. 한국어 문헌과 영어 문헌을 함께 인용할 때 표기 형식이 서로 다르기 때문입니다.

혼합 인용 예시:

```tex
관련 논의는 여러 연구에서 확인된다(\kparencite{kor_cite_example_two_authors}; \parencite{eng_cite_example_two_authors}).
```

의도한 출력 형식:

```text
(홍길동과 임꺽정, 2026; Hong and Im, 2026)
```

한국어 문헌을 앞에 두고, 영어 문헌을 뒤에 둡니다.

### APA 7판 저자 수 규칙

이 템플릿의 본문 인용 예시는 APA 7판 기준입니다. 직접인용과 간접인용 모두 저자 수에 따른 표기 원칙은 같고, 직접인용에서는 쪽수나 쪽수 범위를 함께 적는다는 점만 다릅니다.

저자가 1명인 문헌은 처음 인용할 때와 다시 인용할 때 모두 그 저자명을 표시합니다. 저자가 2명인 문헌도 처음 인용과 재인용 모두 두 저자명을 함께 표시합니다. 한국어 문헌은 두 저자 사이를 `와/과`로 연결하고, 영어 문헌은 APA 7판의 영문 저자 연결 방식에 따라 표시합니다.

저자가 3명 이상인 문헌은 처음 인용할 때부터 재인용할 때까지 첫 번째 저자만 쓰고 나머지 저자는 축약합니다. 이 템플릿에서는 한국어 문헌은 `홍길동 외`, 영어 문헌은 `Hong et al.`처럼 표시됩니다. 다만 서로 다른 문헌이 같은 첫 저자, 같은 연도, 비슷한 저자 조합을 가져 축약형만으로 구분되지 않을 때는 모호성을 피하기 위해 필요한 만큼 저자명을 더 표시해야 합니다.

### 직접인용과 간접인용

간접인용은 원문의 핵심 의미를 자신의 문장으로 바꾸어 서술하는 방식입니다. 선행 연구의 결과나 주장을 요약할 때 주로 사용합니다.

저자 수별 간접인용 예시:

```tex
% 저자 1명
\ktextcite{kor_cite_example_one_author}는 과학 탐구 활동이 학습자의 개념 이해를 돕는다고 보았다.
\textcite{eng_cite_example_one_author}는 과학 탐구 활동이 학습자의 개념 이해를 돕는다고 보았다.

% 저자 2명
\ktextcite{kor_cite_example_two_authors}는 학생 질문이 탐구 과정의 중요한 단서라고 보았다.
\textcite{eng_cite_example_two_authors}는 학생 질문이 탐구 과정의 중요한 단서라고 보았다.

% 저자 3명
\ktextcite{kor_cite_example_three_authors}는 학습자의 질문 생성이 개념 이해와 관련된다고 보았다.
\textcite{eng_cite_example_three_authors}는 학습자의 질문 생성이 개념 이해와 관련된다고 보았다.

% 저자 6명
\ktextcite{kor_cite_example_six_authors}는 협력적 탐구 활동이 과학적 설명 구성을 촉진한다고 보았다.
\textcite{eng_cite_example_six_authors}는 협력적 탐구 활동이 과학적 설명 구성을 촉진한다고 보았다.

% 저자 8명
\ktextcite{kor_cite_example_eight_authors}는 수업 담화가 탐구 참여 양상과 연결된다고 보았다.
\textcite{eng_cite_example_eight_authors}는 수업 담화가 탐구 참여 양상과 연결된다고 보았다.

% 한국어 논문과 영어 논문을 함께 간접인용하는 예
관련 논의는 여러 연구에서 확인된다(\kparencite{kor_cite_example_two_authors}; \parencite{eng_cite_example_two_authors}).
```

간접인용에서는 따옴표를 붙이지 않지만, 원문의 주장이나 아이디어를 가져온 것이므로 반드시 출처를 표시합니다. 특정 쪽의 논의를 자세히 풀어 쓴 경우에는 직접인용이 아니더라도 쪽수를 함께 적을 수 있습니다.

직접인용은 원문의 표현을 따옴표 안에 그대로 옮기는 방식입니다. 원문 표현 자체가 중요할 때 제한적으로 사용하며, 가능하면 쪽수를 함께 적습니다.

저자 수별 직접인용 예시:

```tex
% 저자 1명
``학습자의 질문은 탐구의 출발점이다''(\kparencite{kor_cite_example_one_author}, p.~3).
``questions can guide inquiry''(\parencite{eng_cite_example_one_author}, p.~3).

% 저자 2명
``학생 질문은 탐구 과정의 중요한 단서이다''(\kparencite{kor_cite_example_two_authors}, p.~15).
``student questions are important evidence for inquiry''(\parencite{eng_cite_example_two_authors}, p.~15).

% 저자 3명
``질문 생성은 개념 이해와 관련된다''(\kparencite{kor_cite_example_three_authors}, p.~24).
``question generation is related to conceptual understanding''(\parencite{eng_cite_example_three_authors}, p.~24).

% 저자 6명
``협력적 탐구는 설명 구성을 촉진한다''(\kparencite{kor_cite_example_six_authors}, p.~35).
``collaborative inquiry supports the construction of explanations''(\parencite{eng_cite_example_six_authors}, p.~35).

% 저자 8명
``수업 담화는 탐구 참여 양상과 연결된다''(\kparencite{kor_cite_example_eight_authors}, p.~46).
``classroom discourse is connected to patterns of inquiry participation''(\parencite{eng_cite_example_eight_authors}, p.~46).
```

긴 직접인용 예시:

```tex
\begin{quote}
    과학 수업에서 탐구는 학생이 이미 정해진 절차를 따라가는 활동에 머물지 않는다.
    학생은 관찰, 질문, 증거 해석의 과정을 거치며 과학 개념을 자신의 언어로 재구성한다(\kparencite{kor_cite_example_two_authors}, pp.~23--24).
\end{quote}
```

긴 문단을 직접 인용하는 경우에는 인용문 전체를 별도 블록으로 제시하고, 인용문 뒤에 출처와 쪽수 범위를 적습니다. 긴 직접인용 블록에서는 본문 속 짧은 직접인용처럼 따옴표를 붙이기보다, 들여쓰기된 인용 블록 자체로 직접인용임을 드러내는 방식이 일반적입니다.

```tex
\begin{quote}
    과학 수업에서 학생의 질문은 단순히 교사의 설명을 확인하는 절차가 아니라, 학습자가 현상을 어떻게 이해하고 있는지를 드러내는 중요한 단서이다.
    특히 탐구 활동에서 학생이 제기하는 질문은 관찰한 현상, 기존 지식, 동료와의 상호작용이 만나는 지점에서 형성된다.
    따라서 교사는 질문의 정답 여부만 판단하기보다, 그 질문이 어떤 개념적 어려움과 탐구 가능성을 포함하고 있는지 해석할 필요가 있다(\kparencite{kor_cite_example_three_authors}, pp.~31--32).
\end{quote}

위 인용문은 과학 수업에서 학생 질문을 탐구의 출발점으로 해석해야 함을 보여 준다.
```

긴 직접인용을 넣은 뒤에는 인용문을 그대로 두고 끝내지 말고, 그 인용문이 자신의 연구 문제나 분석 관점과 어떻게 연결되는지 반드시 설명합니다.

위 문장은 직접인용 형식을 보여 주기 위한 예시입니다. 실제 논문에서는 반드시 원문과 정확히 일치하는 문장을 사용하고, 해당 문장이 실린 정확한 쪽수를 확인해야 합니다.

직접인용과 간접인용 모두 출처를 정확히 표시해야 합니다. 원문의 문장, 아이디어, 자료, 표, 그림을 가져오면서 출처를 밝히지 않거나 부정확하게 표시하면 표절로 판단될 수 있으므로, 본문 인용과 참고문헌 목록을 함께 확인합니다.

## Google Scholar BibTeX

Google Scholar에서 BibTeX를 가져오는 절차는 다음과 같습니다.

1. 논문 제목을 검색합니다.
2. 검색 결과 아래의 따옴표 모양 인용 아이콘을 누릅니다.
3. `BibTeX`를 선택합니다.
4. 나타난 BibTeX 항목 전체를 복사합니다.
5. `sub/references.bib`에 붙여 넣습니다.
6. 저자명, 제목, 학술지명, 연도, 권호, 페이지, DOI를 실제 논문과 대조합니다.
7. 한글 논문에서 한국어 문헌과 영어 문헌을 함께 인용할 때는 한국어 문헌에는 `langid = {korean}`, 영어 문헌에는 `langid = {english}`를 추가합니다.

영어로 작성하는 논문에서는 일반적인 APA 7판 BibTeX 형식을 그대로 활용해도 되는 경우가 많습니다. 다만 현재 이 템플릿은 한글 논문 작성 기준으로 구성되어 있으므로, 한글 논문에서 한국어 문헌과 영어 문헌의 표기를 구분하려면 위와 같이 `langid`와 인용 키를 정리해 두는 것이 좋습니다.

생성형 AI가 알려 준 논문은 바로 인용하지 말고 실제 존재 여부를 확인해야 합니다. 제목, 저자, 연도, DOI, 학술지명, 원문 또는 초록을 Google Scholar, RISS, DBpia, KCI, Scopus, Web of Science, 학술지 공식 페이지에서 확인합니다.

## 표와 그림

표와 그림은 본문 내용을 대신하는 장식 요소가 아니라, 연구 문제에 대한 답을 독자가 더 쉽게 이해하도록 돕는 근거입니다. 표나 그림을 제시한 뒤에는 반드시 본문에서 핵심 패턴, 차이, 의미를 설명합니다.

숫자 자료는 소수점 자릿수와 단위를 통일하고, 그림은 축 이름, 범례, 단위를 명확히 표시합니다. 너무 긴 표나 부가 자료는 본문보다 부록에 두는 편이 좋습니다.

표 번호와 그림 번호는 직접 입력하지 않습니다. `\caption{}`과 `\label{}`을 사용하면 LaTeX이 자동으로 번호를 붙입니다.
표에는 `\ThesisTableStyle`을 적용합니다. 이 명령은 표의 글자 크기, 열 간격, 행 간격을 템플릿에 맞게 조정하므로, `\caption{}`과 `\label{}` 다음에 넣고 `tabular*`를 시작하면 됩니다.

### 표와 그림의 위치 옵션

LaTeX에서 `table`과 `figure`는 본문 사이를 떠다니며 배치되는 float 환경입니다. 따라서 `\begin{table}[htbp]`나 `\begin{figure}[htbp]`의 대괄호 안 옵션은 정확한 고정 위치가 아니라 배치 후보를 지정합니다.

| 옵션 | 의미 |
| --- | --- |
| `h` | here. 가능한 한 현재 위치에 배치 |
| `t` | top. 페이지 위쪽에 배치 |
| `b` | bottom. 페이지 아래쪽에 배치 |
| `p` | page. 표와 그림만 모은 별도 float 페이지에 배치 |
| `!` | 일부 배치 제한을 완화하여 요청한 위치를 더 적극적으로 시도 |

기본적으로는 `[htbp]`를 사용하면 안정적입니다. 현재 문단 가까이에 더 두고 싶을 때는 `[h!]`를 사용할 수 있습니다. 완전히 고정하고 싶을 때 쓰는 `[H]`는 `float` 패키지가 필요하며, 너무 자주 쓰면 페이지 여백과 본문 흐름이 어색해질 수 있으므로 제한적으로 사용하는 것이 좋습니다.

표 참조:

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
        비교 집단 & 28 & 67.85 & 73.20 & 5.35 \\
        \bottomrule
    \end{tabular*}
\end{table}

표~\ref{tab:result-example}에서 ...
```

그림 참조:

```tex
\begin{figure}[htbp]
    \centering
    \includegraphics[width=0.8\textwidth]{images/example.pdf}
    \caption{그림 제목}
    \label{fig:example-image}
\end{figure}

그림~\ref{fig:example-image}는 ...
```

## 그림 파일 형식

그래프, 도식, 흐름도, 개념도처럼 선과 글자가 중요한 그림은 벡터 형식이 가장 좋습니다.

| 형식 | 권장 용도 |
| --- | --- |
| `.pdf` | 그래프, 도식, 벡터 그림에 가장 권장 |
| `.png` | 화면 캡처, 글자와 선이 포함된 래스터 이미지 |
| `.jpg` | 사진 자료. 손실 압축이므로 그래프, 표 이미지, 글자 포함 그림에는 부적합 |

그림 파일의 여백을 잘라 넣으려면 `trim`과 `clip`을 사용합니다.

```tex
\includegraphics[
    width=0.8\textwidth,
    trim=1cm 0.5cm 1cm 0.5cm,
    clip
]{images/example.pdf}
```

`trim` 값의 순서는 왼쪽, 아래쪽, 오른쪽, 위쪽입니다.

## 수식과 TikZ

수식 번호는 `equation` 환경과 `\label{}`로 관리합니다.

```tex
\begin{equation}
    \bar{x} = \frac{1}{n}\sum_{i=1}^{n} x_i
    \label{eq:mean-example}
\end{equation}

식~\ref{eq:mean-example}은 ...
```

TikZ 그림 예시는 `sub/4-Results.tex`에 포함되어 있습니다. TikZ 그림도 일반 그림처럼 `figure` 환경 안에 넣고 `\caption{}`과 `\label{}`을 붙여 참조합니다.

## 워터마크

워터마크는 각 페이지 배경 중앙에 한국교원대학교 로고를 연하게 넣는 기능입니다. 최종 제출용 PDF에 워터마크가 필요한지 여부는 학교 또는 학과 지침을 먼저 확인합니다.

워터마크는 `KNUE_thesis_main.tex` 맨 위의 `\documentclass` 옵션으로 켜거나 끕니다. 기본 설정은 워터마크를 넣지 않는 `nowatermark`입니다.

워터마크를 사용하려면 `watermark` 옵션이 있는 줄을 활성화합니다.

```tex
\documentclass[watermark]{KNUE_thesis}
```

워터마크를 사용하지 않으려면 `nowatermark` 옵션을 사용합니다.

```tex
\documentclass[nowatermark]{KNUE_thesis}
```

두 줄을 동시에 활성화하면 안 됩니다. 한 줄만 남기고 다른 한 줄은 `%`로 주석 처리합니다.

예를 들어 워터마크를 켜려면 다음처럼 만듭니다.

```tex
\documentclass[watermark]{KNUE_thesis}
% \documentclass[nowatermark]{KNUE_thesis}
```

워터마크를 끄려면 다음처럼 만듭니다.

```tex
% \documentclass[watermark]{KNUE_thesis}
\documentclass[nowatermark]{KNUE_thesis}
```

워터마크에 사용하는 로고 파일은 `logo/Knue_logo.png`입니다. 다른 그림을 워터마크로 쓰려면 해당 파일을 `logo/` 폴더에 넣고, `KNUE_thesis.cls`의 `Optional KNUE Logo Watermark` 부분에서 파일명을 바꿉니다.

```tex
\includegraphics[width=88mm]{logo/Knue_logo.png}
```

워터마크 크기는 `width=88mm` 값을 조정해 바꿀 수 있습니다. 숫자를 키우면 로고가 커지고, 줄이면 작아집니다. 워터마크의 진하기는 같은 블록의 `opacity=0.35` 값을 조정합니다. 값이 `1`에 가까울수록 진하고, `0`에 가까울수록 옅습니다.

```tex
\node[opacity=0.35] at (current page.center)
```

워터마크 옵션이나 로고 파일을 바꾼 뒤에는 `KNUE_thesis_main_build.cmd`로 다시 빌드해 PDF를 확인합니다.

## 표지 사각형 테두리

표지와 인준면에 보이는 190 mm x 260 mm 사각형 테두리는 양식 확인용 재단 영역 표시입니다. 최종 제출용 PDF에서 이 테두리가 필요 없으면 `KNUE_thesis_main.tex` 맨 위의 `\documentclass` 옵션에 `notrimbox`를 넣습니다.

```tex
\documentclass[nowatermark,notrimbox]{KNUE_thesis}
```

테두리를 다시 보이게 하려면 `trimbox` 옵션을 사용합니다.

```tex
\documentclass[nowatermark,trimbox]{KNUE_thesis}
```

`trimbox`와 `notrimbox`는 동시에 사용하지 않습니다. 워터마크 옵션과 함께 쓸 때는 위 예시처럼 쉼표로 구분합니다.

## 로컬 빌드와 빌드 모드

로컬(내 컴퓨터)에서 빌드할 때는 빌드 스크립트를 사용합니다. Windows에서는 `KNUE_thesis_main_build.cmd`, macOS·Linux·Git Bash에서는 `KNUE_thesis_main_build.sh`를 씁니다. 두 스크립트는 같은 모드를 지원합니다.

| 모드 | 설명 |
| --- | --- |
| `build` | 기본값입니다. 참고문헌(biber)까지 필요한 만큼 처리해 전체 빌드합니다. |
| `quick` | 변경된 부분만 빠르게 다시 빌드합니다(참고문헌 재처리 생략). |
| `clean` | 보조 파일과 잠금 폴더를 지웁니다. `.tex`와 `.pdf`는 보존합니다. |
| `watch` | 파일이 바뀔 때마다 자동으로 다시 빌드합니다. |
| `submit` | 최종 제출본을 빌드합니다. 아래 "심사위원별 수정 표시"를 모두 끈(검정) 상태로 만들고, 결과를 `KNUE_thesis_main_제출본.pdf`(Windows에서는 `..._submit.pdf`)로 함께 복사합니다. |
| `review` | 검토본을 빌드합니다. 수정 표시를 켜서 심사위원별 색상으로 출력하고, 결과를 `..._수정표시_심사위원별색상.pdf`(Windows에서는 `..._review_colors.pdf`)로 복사합니다. |
| `review-blue` | 검토본을 빌드하되 수정 표시를 모두 파란색 한 가지로 통일하고, `..._수정표시_전체파란색.pdf`(Windows에서는 `..._review_blue.pdf`)로 복사합니다. |
| `color` | 그림 컬러본(`\figf` → `*_color`)을 사용하고 색을 유지한 채 빌드해 `..._컬러.pdf`로 복사합니다. |
| `bw` | 그림 흑백본(`\figf` → `*_bw`)을 사용하고 문서 전체를 회색조로 변환해 `..._흑백.pdf`로 복사합니다. (그림 컬러/흑백 관리법은 본문 작성법의 "그림 컬러본과 흑백본" 절 참고) |
| `crops` | 그림 여백(trim/clip) 확인용 `crop_debug.pdf`를 만듭니다. |

사용 예:

```powershell
REM Windows (명령 프롬프트 / PowerShell)
.\KNUE_thesis_main_build.cmd            REM 기본 빌드
.\KNUE_thesis_main_build.cmd submit     REM 최종 제출본
.\KNUE_thesis_main_build.cmd review     REM 심사위원별 색상 검토본
```

```bash
# macOS / Linux / Windows Git Bash
./KNUE_thesis_main_build.sh             # 기본 빌드
./KNUE_thesis_main_build.sh submit      # 최종 제출본
./KNUE_thesis_main_build.sh review      # 심사위원별 색상 검토본
```

`submit`/`review`/`review-blue`는 아래에서 설명하는 수정 표시 매크로를 환경변수(`THESIS_SHOW_REVISIONS`, `THESIS_REV_ALLBLUE`)로 자동으로 켜고 끕니다. 스크립트를 쓰지 않고 직접 켜려면 이 환경변수를 설정한 뒤 빌드하면 됩니다.

## 심사위원별 수정 표시 (검토본)

논문 심사 과정에서 "어느 심사위원의 지적을 반영해 어디를 고쳤는지"를 색으로 구분해 보여 줄 수 있습니다. 이 기능은 서로 보완하는 두 가지 방식으로 제공됩니다.

### 방식 1. 수정 표시 매크로 (직접 감싸기)

`sub/0-preamble.tex`에 정의된 명령으로 수정한 부분을 직접 감싸는 방식입니다. 어떤 심사위원의 의견을 반영했는지 원고를 쓰는 사람이 알고 있을 때 사용합니다.

- `\revised{...}` : 공통/기타 수정(파란색). 특정 심사위원과 무관한 일반 수정.
- `\revisedA{...}` / `\revisedB{...}` / `\revisedC{...}` / `\revisedD{...}` : 심사위원 1/2/3/4의 의견을 반영한 수정. 각각 파랑·초록·보라·청록으로 표시됩니다.
- `\revTODO{담당색명령}{메모}` : 아직 본문은 고치지 않고 "여기를 이렇게 고쳐야 함"이라는 메모만 남길 때. 예) `\revTODO{\revisedB}{제목 재검토 필요}`
- `\RevisionLegend` : 색과 심사위원의 대응표(범례)를 한 번 출력합니다. `KNUE_thesis_main.tex`의 본문 시작 부분에 주석 처리되어 있으니, 필요하면 주석(`%`)만 풀면 됩니다.

색을 켜고 끄는 방법:

- **검토본(색상 표시)** : `review` 모드로 빌드하거나, 환경변수 `THESIS_SHOW_REVISIONS=1`을 설정한 뒤 빌드합니다. → 심사위원별 색상으로 출력됩니다.
- **전체 파란색으로 통일** : `review-blue` 모드로 빌드하거나, `THESIS_SHOW_REVISIONS=1`과 함께 `THESIS_REV_ALLBLUE=1`을 설정합니다. → 수정 부분을 한 가지 색(파랑)으로만 봅니다. 이때 범례는 자동으로 숨겨집니다.
- **최종 제출본(표시 없음)** : `submit` 모드로 빌드하거나, 아무 환경변수도 설정하지 않고 기본 빌드합니다. → 모든 표시가 사라져 검정 본문으로 출력되므로, 원고에서 `\revised` 래퍼를 일일이 지울 필요가 없습니다.

심사위원별 색을 바꾸려면 `sub/0-preamble.tex`의 `\definecolor{RevA}{RGB}{...}`~`RevD`의 RGB 값을, 심사위원 이름을 범례에 넣으려면 같은 파일 `\RevisionLegend` 정의의 "심사위원 1" 등을 실제 이름으로 수정합니다.

> 참고: 이 템플릿의 본문은 예시 골격이므로 수정 표시 매크로가 실제로 쓰인 곳은 없습니다. 위 명령으로 직접 감싸야 색이 나타납니다.

### 방식 2. git 기준 변경 추적 (make-diff)

`make-diff.cmd`(Windows) / `make-diff.sh`(macOS·Linux·Git Bash)는 특정 git 커밋 시점의 원고와 현재 원고를 비교해, 바뀐 부분을 자동으로 표시한 PDF를 만듭니다(추가=파랑, 삭제=빨강 취소선). `latexdiff`를 사용하며, 수정 표시 매크로와 달리 어디를 고쳤는지 자동으로 찾아 줍니다.

```powershell
.\make-diff.cmd            REM 마지막 커밋 이후의 변경분
.\make-diff.cmd 3a1c9ef    REM 특정 커밋 이후의 모든 변경분
```

```bash
./make-diff.sh             # 마지막 커밋 이후의 변경분
./make-diff.sh v1.0        # 태그 v1.0 이후의 모든 변경분
```

필요한 입력과 도구:

- **git 이력**: 두 시점의 원고를 비교하므로 최소 한 번은 커밋되어 있어야 합니다. 인자로 기준 커밋/태그/브랜치를 주면 그 시점과 현재를 비교하고, 생략하면 마지막 커밋(HEAD)과 비교합니다.
- **필요한 프로그램**: `git`, `latexpand`, `latexdiff`, `latexmk`, `lualatex`, `biber`(Windows는 추가로 `tar`). TeX Live에 대부분 포함되어 있습니다.
- **결과물**: `KNUE_thesis_main-diff<짧은해시>.pdf`. `--no-build` 옵션을 주면 diff용 `.tex`만 만들고 PDF 컴파일은 건너뜁니다.

### 방식 2를 100% 활용하기 — 제출 시점마다 커밋·태그로 "구분점" 남기기

`make-diff`의 진짜 힘은 **논문의 한 단계가 끝날 때마다(초고 완성, 투고본·심사본 제출, 1차 수정본 제출 등) 반드시 커밋하고 이름표(git 태그)를 붙여 두는 것**에서 나옵니다. 그러면 그 시점 이후에 무엇을 어떻게 고쳤는지 언제든 **색으로 표시한 PDF**(추가=파랑, 삭제=빨강 취소선)로 뽑아, 심사자에게 "이번에 이렇게 바꿨습니다"를 그대로 보여 줄 수 있습니다.

**권장 절차**

1. 한 단계가 끝나면 커밋하고 태그를 붙입니다. 태그 이름은 나중에 알아보기 쉽게 짓습니다.

   ```bash
   git add -A
   git commit -m "박사학위논문 심사본 제출"
   git tag 심사본-1차            # 예: submitted-1, review-1 등 원하는 이름
   ```

2. 심사 의견을 반영해 계속 수정하고, 평소처럼 커밋합니다.

3. 그 제출 시점 **이후에 바뀐 부분만** 색으로 표시한 PDF를 만듭니다.

   ```powershell
   .\make-diff.cmd 심사본-1차     REM '심사본-1차' 태그 이후의 모든 변경
   ```
   ```bash
   ./make-diff.sh 심사본-1차
   ```
   → `KNUE_thesis_main-diff<해시>.pdf`가 만들어집니다.

4. 다음 단계에서도 같은 방식으로 태그를 남깁니다(`심사본-2차`, `최종본` 등). 각 단계 사이의 변경만 골라 비교할 수도 있습니다.

   ```bash
   ./make-diff.sh 심사본-1차           # 1차 제출 이후 지금까지의 모든 변경(색 표시 PDF)
   git diff 심사본-1차 -- '*.tex'      # 변경 목록만 텍스트로 빠르게 보기
   git log --oneline 심사본-1차..HEAD  # 그 사이의 커밋(수정 이력) 목록
   ```

> **핵심**: 원고를 고치기 전에 "지금이 어떤 시점인가"를 **커밋 + 태그로 먼저 남겨** 두세요. 태그가 곧 비교 기준점이 되어, 이후 변경분을 색으로 뽑아내는 일이 명령 한 줄로 끝납니다. 학술지 논문도 같은 방식으로 투고본·수정본마다 태그를 남기면, 재심사 때 변경 표시본을 손쉽게 제출할 수 있습니다(학술지 템플릿에는 `make-diff`가 없더라도 `git diff <태그>`로 변경 목록을 확인할 수 있습니다). 방식 1(심사위원별 색상 매크로)과 함께 쓰면, 자동 변경 추적과 "누구 의견을 반영했는지" 색 구분을 모두 보여 줄 수 있습니다. 이 워크플로의 저장소 전체 관점 설명은 [../manual/4-OBSIDIAN_VAULT_SETUP.md](../manual/4-OBSIDIAN_VAULT_SETUP.md)에도 있습니다.

## Python 코드 부록

Python 예제 코드는 `../code/example_analysis.py`에 있습니다. 부록 파일 `sub/A4_Code_File_Example.tex`에서 코드 파일을 불러오는 방법을 예시로 보여 줍니다.

부록에 코드 파일을 넣을 때는 코드 파일을 저장소 루트의 공용 `code/` 폴더(또는 원하는 위치)에 저장하고, 부록용 `.tex` 파일에서 `../code/파일명.py`처럼 상대경로로 참조합니다.

## 참고문헌 PDF 도구 (저장소 루트 `code/` 폴더)

저장소 루트의 공용 `code/` 폴더에 참고문헌 PDF를 관리하는 Python 스크립트 두 개가 함께 들어 있습니다.

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

`KNUE_thesis` 폴더를 작업 폴더로 열고 그 위치에서 실행합니다. 처음에는 파일을 실제로 바꾸지 않는 `--dry-run`으로 먼저 확인하는 것이 안전합니다.

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

## 최종 제출 전 확인

최종 제출 전에는 다음을 확인합니다.

1. 표지의 논문 제목, 저자명, 지도교수명, 심사위원명이 정확한가?
2. 석사/박사 학위 구분이 맞는가?
3. 국문 초록과 영문 초록의 제목, 저자명, 전공명, 주요어가 맞는가?
4. 본문에서 모든 표, 그림, 수식을 `\ref{}`로 참조했는가?
5. 본문에서 인용한 모든 문헌이 참고문헌 목록에 출력되는가?
6. 생성형 AI가 제시한 선행 연구는 실제 존재하는 문헌인지 확인했는가?
7. 학교 또는 학과의 최신 학위논문 작성 지침과 양식이 일치하는가?

학교 또는 학과의 제출 규정은 바뀔 수 있으므로, 최종 제출 전에는 반드시 공식 학위논문 작성 지침과 대조해야 합니다.

---

# English Version

# KNUE Thesis and Dissertation LaTeX Template

This template is currently under development and may continue to be revised and improved as university or department guidelines change and user feedback is incorporated. Before final submission, always compare the generated PDF with the latest official thesis guidelines yourself.

This folder contains a LaTeX template for writing master's theses and doctoral dissertations at Korea National University of Education. It manages the cover page, approval page, Korean abstract, English abstract, table of contents, list of tables, list of figures, main chapters, references, and appendices as one project.

The current template supports both Korean and English theses. Even when writing an English thesis, you do not need to create a separate folder such as `sub/en`; write the English main text in the same chapter files under `sub/`.

When you download this template repository from GitHub, the entire repository may include several template formats. For an actual KNUE thesis or dissertation, it is best to copy only the `KNUE_thesis/` subfolder into your own thesis working folder, or delete the other template folders and keep only this folder. Even if journal or other institution templates are added later, you can use the repository in the same way by selecting only the subfolder you need.

In a thesis or dissertation, matching the required university format is as important as the research content. This template preconfigures format elements that must be checked repeatedly, such as margins, fonts, chapter titles, cover page, approval page, table of contents, and table and figure numbering, so that authors can focus on writing the thesis rather than adjusting formatting by hand.

For LaTeX installation, VS Code setup, and build commands, see the parent folder's [README.md](../README.md) and the setup guides it links to: use [1-OVERLEAF_THESIS_PROJECT.md](../manual/1-OVERLEAF_THESIS_PROJECT.md) to write on Overleaf, or [2-VSCODE_LOCAL_THESIS_SETUP.md](../manual/2-VSCODE_LOCAL_THESIS_SETUP.md) to install LaTeX on your own PC. The official TeX Live Windows documentation link and the lab ISO installation notes are in `2-VSCODE_LOCAL_THESIS_SETUP.md`. This document explains only the file structure and writing workflow for the KNUE thesis template.

## Using Overleaf

When using this template from GitHub on Overleaf, upload the contents of the `KNUE_thesis` folder so that they sit at the top level of the Overleaf project.
At the project top level, you should see `KNUE_thesis_main.tex`, `KNUE_thesis.cls`, `sub/`, `images/`, and `logo/` together.

1. Open the GitHub repository at <https://github.com/Kiehyun/ESE_Lab_template>.
2. Click `Code`, then choose `Download ZIP`.
3. Unzip the downloaded file.
4. Open the `KNUE_thesis` folder inside the extracted repository.
5. Select all files and subfolders inside `KNUE_thesis`, then compress those selected items into a new ZIP file.
   When you open the new ZIP file, `KNUE_thesis_main.tex`, `KNUE_thesis.cls`, `sub/`, `images/`, and `logo/` should appear immediately.
6. Sign in to Overleaf, click `New Project`, and choose `Upload Project`.
7. Upload the new ZIP file.
8. After the project opens, check that the main file is `KNUE_thesis_main.tex`.
9. In `Menu` or `Settings`, set `Compiler` to `LuaLaTeX`.
10. Click `Recompile` to generate the PDF.
11. Check the cover page, approval page, abstracts, table of contents, and table/figure numbering.

If you upload GitHub's repository ZIP directly, the thesis files may be placed under a nested path such as `ESE_Lab_template-main/KNUE_thesis/`.
That structure can prevent Overleaf from detecting the main document or resolving relative paths correctly, so the recommended workflow is to make a new ZIP from the contents of `KNUE_thesis`.

This template adjusts cover-page spacing, Korean fonts, and Korean-name spacing for LuaLaTeX.
If Overleaf is set to `pdfLaTeX` or `XeLaTeX`, `\directlua` code may appear on the first cover page, or Korean fonts and line breaks may differ from the local build.

### Overleaf Account Plans and Limits

Overleaf's plans and limits can change, so check the official pages before final submission.
As checked in the official documentation on May 6, 2026, the free plan supports unlimited projects, but has a 10-second compile timeout and allows one collaborator per project.
Premium plans increase the compile timeout to 240 seconds. Student subscriptions allow 6 collaborators per project, Standard allows 10, and Professional allows an unlimited number of collaborators.

For both free and premium plans, Overleaf lists these project limits: 2000 files per project, 50 MB per upload, 7 MB of editable text material per project, and 2 MB per individual editable text file.
There is no enforced total project-size limit, but Overleaf recommends keeping projects under 500 MB, or under 100 MB when using GitHub sync or Git integration.

For this thesis template, a free account is usually enough to start if you are writing alone and image files are not too large.
Consider a premium plan or local builds if compilation often times out, several people need to review the thesis together, or you need GitHub sync, track changes, or reference-manager integrations.

Official references:

- Downloading a GitHub ZIP archive: <https://docs.github.com/en/repositories/working-with-files/using-files/downloading-source-code-archives>
- Uploading an Overleaf project: <https://docs.overleaf.com/managing-projects-and-files/uploading-a-project>
- Overleaf free and premium plans: <https://docs.overleaf.com/getting-started/free-and-premium-plans>
- Overleaf plan limits: <https://docs.overleaf.com/getting-started/free-and-premium-plans/plan-limits>

## English Quick Start for Thesis Authors

Use this checklist if you do not read Korean and need to create or troubleshoot the PDF.

1. Open `sub/0-preamble.tex`.
2. Set the thesis language.

```tex
\newcommand{\documentLanguage}{english}
```

3. Enter both English and Korean thesis metadata in `sub/0-preamble.tex`. KNUE documents may still require Korean title, author, major, and abstract information even for an English thesis.
4. Write the main chapters in these files:

```text
sub/1-Introduction.tex
sub/2-Theorical_background.tex
sub/3-Methods.tex
sub/4-Results.tex
sub/5-Conclusions.tex
```

5. Put figures in `images/` and bibliography entries in `sub/references.bib`.
6. Build the PDF from the `KNUE_thesis` folder.

```powershell
.\KNUE_thesis_main_build.cmd
```

7. Check `KNUE_thesis_main.pdf`.
8. If the PDF is not created, read `Troubleshooting for English Users` near the end of this document.

## Reporting Format Issues

The university or department thesis guidelines may change, or some required format details may not yet be reflected in this template. If you find such an issue, please open a GitHub issue. Suggestions for improving the template, including margins, cover pages, approval pages, table and figure placement, or the cover trim-box display, are also welcome as GitHub issues.

1. Go to <https://github.com/Kiehyun/ESE_Lab_template/issues> in your web browser.
2. Click `New issue`.
3. Write a short title. Example: `Need to adjust spacing in list of tables`.
4. In the body, include the PDF page number, related file name, expected format, and current output.
5. If possible, attach the relevant item from the official thesis guidelines or a screenshot.

Before final submission, always compare the generated PDF with the latest official guidelines from the university or department.

## Main Files

| File or Folder | Role | Usually Edit? |
| --- | --- | --- |
| `KNUE_thesis_main.tex` | Main file that assembles the whole thesis. It manages the order of the cover page, abstracts, main chapters, references, and appendices. | Rarely |
| `KNUE_thesis.cls` | Class file that defines the KNUE thesis format, including margins, fonts, chapter titles, and table/figure numbering. | No, unless fixing the template format |
| `sub/0-preamble.tex` | Enter the thesis title, author, advisor, committee members, degree type, major name, and common commands. | Yes |
| `sub/coverpage-thesis.tex` | Adjusts the detailed layout of the cover page and approval page. | Rarely |
| `sub/abstractKor.tex` | Write the Korean abstract. | Yes |
| `sub/1-Introduction.tex` | Write the introduction. | Yes |
| `sub/2-Theorical_background.tex` | Write the theoretical background, previous research, and citation examples. | Yes |
| `sub/3-Methods.tex` | Write the research methods. | Yes |
| `sub/4-Results.tex` | Write the results, tables, graphs, figures, equations, and TikZ examples. | Yes |
| `sub/5-Conclusions.tex` | Write the conclusions and suggestions. | Yes |
| `sub/abstractEng.tex` | Write the English abstract. | Yes |
| `sub/references.bib` | Enter bibliography information in BibTeX format. | Yes |
| `sub/A4_Code_File_Example.tex` | Example of including a Python code file in an appendix. | Optional |
| `code/` | Store Python analysis code or code files to include in appendices. | Optional |
| `images/` | Store figure files to insert in the main text. | Yes |
| `logo/` | Store logo files used on the cover page or as a watermark. | Rarely |

## How This Document Is Organized

This guide explains both what should be written in a thesis and how to edit this template in practice.
First understand what each chapter should contain, how to connect research purposes with research questions, and how to interpret tables and figures in writing. Then check which file and which LaTeX commands are used to enter that content.

## Where to Start Editing

When using the template for the first time, edit the files in this order.

1. In `sub/0-preamble.tex`, edit the thesis title, author name, advisor name, committee member names, and degree type.
2. Write the Korean and English abstracts in `sub/abstractKor.tex` and `sub/abstractEng.tex`.
3. Write the chapter text from `sub/1-Introduction.tex` through `sub/5-Conclusions.tex`.
4. Add bibliography entries to `sub/references.bib`.
5. Cite the references in the main text.
6. If needed, place analysis code in `code/` and include it in an appendix by file name.

The file names above are examples provided by the template. Authors may rename files according to their thesis structure and workflow. If you rename a file, also update the corresponding `\include` or `\input` command in `KNUE_thesis_main.tex`.

## Writing a Korean Thesis

When writing a thesis in Korean, keep the `\documentLanguage` value in `sub/0-preamble.tex` as `korean`. The default value is `korean`.

```tex
\newcommand{\documentLanguage}{korean}
```

In the same file, edit the thesis information used repeatedly on the cover page, approval page, and abstracts. Even for a Korean thesis, an English title and English abstract are required, so enter both Korean and English information.

```tex
\newcommand{\thesistitleKor}{국문 논문 제목}
\newcommand{\thesistitleEng}{English Thesis Title}
\newcommand{\authorKor}{홍길동}
\newcommand{\authorEng}{Hong, Gildong}
\newcommand{\advisorKor}{임꺽정}
\newcommand{\advisorEng}{Im, Kkeokjeong, Ph. D.}
\newcommand{\degreeProgramKor}{석사}
\newcommand{\degreeEng}{Master of Education}
```

For a Korean thesis, write the main text in Korean in `sub/1-Introduction.tex`, `sub/2-Theorical_background.tex`, `sub/3-Methods.tex`, `sub/4-Results.tex`, and `sub/5-Conclusions.tex`. Write the Korean abstract in `sub/abstractKor.tex` and the English abstract in `sub/abstractEng.tex`.

The output order follows the Korean thesis format. The Korean abstract appears near the front, and the English abstract appears after the references. Tables and figures are labeled in Korean as `표` and `그림` in the main text, list of tables, and list of figures.

## Writing an English Thesis

When writing a thesis in English, change the `\documentLanguage` value in `sub/0-preamble.tex` to `english`.

```tex
\newcommand{\documentLanguage}{english}
```

Then check both the Korean and English information used on the cover page, approval page, and abstracts. In an English thesis, English information is more prominent on the cover and in the front matter, but a Korean title and Korean abstract are still required.

```tex
\newcommand{\thesistitleEng}{English Thesis Title}
\newcommand{\thesistitleKor}{국문 논문 제목}
\newcommand{\authorEng}{Hong, Gildong}
\newcommand{\authorKor}{홍길동}
\newcommand{\majorEng}{Major in Earth Science Education}
\newcommand{\majorKor}{지구과학교육전공}
\newcommand{\degreeEng}{Doctor of Philosophy in Education}
\newcommand{\degreeProgramKor}{박사}
```

Write the main text in the same files used for a Korean thesis. Do not create a separate `sub/en` folder or duplicate chapter files for English. Instead, write the contents of `sub/1-Introduction.tex`, `sub/2-Theorical_background.tex`, `sub/3-Methods.tex`, `sub/4-Results.tex`, and `sub/5-Conclusions.tex` in English.

In English mode, the English title appears above the Korean title, and the English abstract is placed near the front. The Korean abstract is placed after the references. Tables and figures are labeled as `Table` and `Fig.` in the main text, list of tables, and list of figures.

In short, Korean and English theses do not use separate folders. The `\documentLanguage` value in `sub/0-preamble.tex` selects the output language, abstract placement, and table/figure labels. The main text is written in the selected language in the same chapter files.

## Editing Thesis Information

Information repeated throughout the thesis is edited once in `sub/0-preamble.tex`.

```tex
\newcommand{\thesistitleKor}{\LaTeX{}을 이용하여 학위논문 작성하기}
\newcommand{\thesistitleEng}{Writing a Thesis with \LaTeX}
\newcommand{\authorKor}{홍길동}
\newcommand{\authorEng}{Hong, Gildong}
\newcommand{\thesiskeywordsKor}{지구과학, 과학교육, 5개 입력}
\newcommand{\thesiskeywordsEng}{Earth science, science education, enter five keywords}
\newcommand{\advisorKor}{임꺽정}
\newcommand{\advisorEng}{Im, Kkeokjeong, Ph. D.}
```

Korean keywords are used both in the Korean abstract and in the PDF metadata field `pdfkeywords`. English keywords are used in the English abstract.

Edit the committee member names in the same file.

```tex
\newcommand{\committeeChairKor}{성춘향}
\newcommand{\committeeMemberOneKor}{이몽룡}
\newcommand{\committeeMemberTwoKor}{장보고}
```

A doctoral dissertation prints one committee chair and four committee members. A master's thesis prints one committee chair and two committee members.

## Master's or Doctoral Degree

Edit the degree type in `sub/0-preamble.tex`.

Master's thesis:

```tex
\newcommand{\degreeProgramKor}{석사}
\newcommand{\degreeEng}{Master of Education}
```

Doctoral dissertation:

```tex
\newcommand{\degreeProgramKor}{박사}
\newcommand{\degreeEng}{Doctor of Philosophy in Education}
```

The Korean degree phrase is applied automatically based on `\degreeProgramKor`. Check and edit the English degree name directly in `\degreeEng`.

## Chapter Content

### Introduction

The introduction persuades readers why this science education study is necessary. In the research necessity section, present evidence such as curriculum changes, difficulties in learning science concepts, inquiry competencies, classroom problems, and limitations of previous studies. In the research purpose section, specify the learners, science concepts, inquiry activities, teaching and learning treatment, or assessment outcomes the study will investigate. In the research questions, divide that purpose into questions that can be answered with data. The research purpose and research questions must be revisited in the methods, results, and conclusion chapters.

Edit this content in `sub/1-Introduction.tex`.

### Theoretical Background

The theoretical background includes science concepts, learning theories, inquiry activities, teaching and learning models, assessment perspectives, previous research, and the analytic perspective of the current study. When reviewing previous studies, do not simply list literature. Instead, organize the flow, issues, and limitations of science education research.

Edit this content in `sub/2-Theorical_background.tex`. This file also includes citation examples and guidance for checking previous studies suggested by generative AI.

### Research Methods

The methods chapter includes the research design, participants and classroom context, research procedure, data collection, data analysis, validity and reliability, and research ethics. In science education, research questions may address science concept understanding, inquiry performance, science learning motivation, classroom interaction, teacher expertise, or curriculum implementation, so the methodology should be clearly selected according to the research questions.

Quantitative research is appropriate when explaining treatment effects, group differences, or relationships among variables using numerical data such as test scores or survey results. Qualitative research is appropriate when deeply interpreting learners' thinking processes, the meaning of classroom scenes, or teacher-student interaction through interviews, observations, worksheets, and discourse data. Mixed methods research is used when quantitative results and qualitative data are combined to explain both the size of an effect and its meaning.

Science education theses also often use development research for teaching-learning materials or assessment tools, literature reviews that analyze trends in previous research, and Delphi studies that draw expert consensus. Whatever method is selected, describe how data used in science education research, such as tests, surveys, interviews, observations, and classroom products, were collected and analyzed in enough detail for readers to evaluate the study.

Edit this content in `sub/3-Methods.tex`.

### Research Results

The results chapter presents answers to the research questions. Its main purpose is to show, based on data, learners' conceptual change, inquiry performance, response categories, group differences, or characteristics of classroom scenes. After presenting a table or figure, always explain its meaning in the text.

Edit this content in `sub/4-Results.tex`. This file includes examples of tables, figures, graphs, equations, and TikZ drawings.

### Conclusions and Suggestions

The conclusions and suggestions chapter presents the final answer to the research purpose, generalization of findings, significance, limitations, and suggestions for future research. The conclusion is not a place to repeat the numbers from the results chapter. It should explain what the findings mean for science concept learning, inquiry activities, instructional design, assessment, teacher education, or curriculum implementation.

Edit this content in `sub/5-Conclusions.tex`.

## Citing References

Citation and reference formats may differ by university, department, journal, and field. Before final submission, always check the latest thesis guidelines from your university and department.

The citation and reference style in this template is based on APA 7th edition, with additional rules for Korean-language literature such as Korean author-name formatting and Korean particles.

Enter reference information in BibTeX format in `sub/references.bib`. Only works actually cited in the main text are printed in the reference list.

English references:

```tex
\textcite{eng_example2026}
(\parencite{eng_example2026})
```

Korean references:

```tex
\ktextcite{kor_example2026}
(\kparencite{kor_example2026})
```

In this template, `\parencite` and `\kparencite` are configured not to print the outer parentheses automatically. This is because Korean and English references may need different formatting when cited together.

Mixed citation example:

```tex
관련 논의는 여러 연구에서 확인된다(\kparencite{kor_cite_example_two_authors}; \parencite{eng_cite_example_two_authors}).
```

Intended output:

```text
(홍길동과 임꺽정, 2026; Hong and Im, 2026)
```

Place Korean references first and English references after them.

### APA 7 Author-Count Rules

The in-text citation examples in this template follow APA 7th edition. The author-count rules are the same for direct and indirect quotations; direct quotations additionally include a page number or page range.

For works with one author, cite that author in both the first citation and later citations. For works with two authors, cite both authors every time. Korean references connect two author names with the Korean `와/과` form, while English references follow APA 7 English author-name formatting.

For works with three or more authors, APA 7 uses the first author plus a shortened form from the first citation through later citations. In this template, Korean references appear as `홍길동 외`, and English references appear as `Hong et al.`. If two different works would become ambiguous because they have the same first author, same year, and similar author groups, include enough author names to distinguish them.

### Direct and Indirect Quotations

An indirect quotation paraphrases the key meaning of the original text in your own words. It is mainly used to summarize the results or arguments of previous studies.

Indirect quotation examples by author count:

```tex
% One author
\ktextcite{kor_cite_example_one_author}는 과학 탐구 활동이 학습자의 개념 이해를 돕는다고 보았다.
\textcite{eng_cite_example_one_author}는 과학 탐구 활동이 학습자의 개념 이해를 돕는다고 보았다.

% Two authors
\ktextcite{kor_cite_example_two_authors}는 학생 질문이 탐구 과정의 중요한 단서라고 보았다.
\textcite{eng_cite_example_two_authors}는 학생 질문이 탐구 과정의 중요한 단서라고 보았다.

% Three authors
\ktextcite{kor_cite_example_three_authors}는 학습자의 질문 생성이 개념 이해와 관련된다고 보았다.
\textcite{eng_cite_example_three_authors}는 학습자의 질문 생성이 개념 이해와 관련된다고 보았다.

% Six authors
\ktextcite{kor_cite_example_six_authors}는 협력적 탐구 활동이 과학적 설명 구성을 촉진한다고 보았다.
\textcite{eng_cite_example_six_authors}는 협력적 탐구 활동이 과학적 설명 구성을 촉진한다고 보았다.

% Eight authors
\ktextcite{kor_cite_example_eight_authors}는 수업 담화가 탐구 참여 양상과 연결된다고 보았다.
\textcite{eng_cite_example_eight_authors}는 수업 담화가 탐구 참여 양상과 연결된다고 보았다.

% Citing Korean and English papers together
관련 논의는 여러 연구에서 확인된다(\kparencite{kor_cite_example_two_authors}; \parencite{eng_cite_example_two_authors}).
```

Indirect quotations do not use quotation marks, but they still require a source because they use the original author's claim or idea. If you paraphrase a specific passage in detail, you may include a page number even though the sentence is not a direct quotation.

A direct quotation reproduces the original wording exactly inside quotation marks. Use it only when the wording itself matters, and include page numbers whenever possible.

Direct quotation examples by author count:

```tex
% One author
``학습자의 질문은 탐구의 출발점이다''(\kparencite{kor_cite_example_one_author}, p.~3).
``questions can guide inquiry''(\parencite{eng_cite_example_one_author}, p.~3).

% Two authors
``학생 질문은 탐구 과정의 중요한 단서이다''(\kparencite{kor_cite_example_two_authors}, p.~15).
``student questions are important evidence for inquiry''(\parencite{eng_cite_example_two_authors}, p.~15).

% Three authors
``질문 생성은 개념 이해와 관련된다''(\kparencite{kor_cite_example_three_authors}, p.~24).
``question generation is related to conceptual understanding''(\parencite{eng_cite_example_three_authors}, p.~24).

% Six authors
``협력적 탐구는 설명 구성을 촉진한다''(\kparencite{kor_cite_example_six_authors}, p.~35).
``collaborative inquiry supports the construction of explanations''(\parencite{eng_cite_example_six_authors}, p.~35).

% Eight authors
``수업 담화는 탐구 참여 양상과 연결된다''(\kparencite{kor_cite_example_eight_authors}, p.~46).
``classroom discourse is connected to patterns of inquiry participation''(\parencite{eng_cite_example_eight_authors}, p.~46).
```

Long direct quotation example:

```tex
\begin{quote}
    과학 수업에서 탐구는 학생이 이미 정해진 절차를 따라가는 활동에 머물지 않는다.
    학생은 관찰, 질문, 증거 해석의 과정을 거치며 과학 개념을 자신의 언어로 재구성한다(\kparencite{kor_cite_example_two_authors}, pp.~23--24).
\end{quote}
```

When directly quoting a long paragraph, present the whole quotation as a separate block and add the source and page range after the quotation. For long direct quotations, it is common to use the indented quotation block itself to show that it is a direct quotation, rather than adding quotation marks as in a short quotation.

```tex
\begin{quote}
    과학 수업에서 학생의 질문은 단순히 교사의 설명을 확인하는 절차가 아니라, 학습자가 현상을 어떻게 이해하고 있는지를 드러내는 중요한 단서이다.
    특히 탐구 활동에서 학생이 제기하는 질문은 관찰한 현상, 기존 지식, 동료와의 상호작용이 만나는 지점에서 형성된다.
    따라서 교사는 질문의 정답 여부만 판단하기보다, 그 질문이 어떤 개념적 어려움과 탐구 가능성을 포함하고 있는지 해석할 필요가 있다(\kparencite{kor_cite_example_three_authors}, pp.~31--32).
\end{quote}

위 인용문은 과학 수업에서 학생 질문을 탐구의 출발점으로 해석해야 함을 보여 준다.
```

After a long direct quotation, do not end the discussion with the quoted block alone. Always explain how the quotation connects to your research questions or analytic perspective.

The sentences above are examples for showing direct quotation format. In an actual thesis, use sentences that exactly match the original text and check the exact page numbers.

Both direct and indirect quotations must show accurate sources. If you use original sentences, ideas, data, tables, or figures without citing the source, or cite them incorrectly, it may be considered plagiarism. Check both in-text citations and the reference list.

## Google Scholar BibTeX

To get BibTeX from Google Scholar:

1. Search for the paper title.
2. Click the quotation-mark citation icon under the search result.
3. Select `BibTeX`.
4. Copy the entire BibTeX entry.
5. Paste it into `sub/references.bib`.
6. Compare the author names, title, journal name, year, volume, issue, pages, and DOI with the actual paper.
7. When citing both Korean and English references in a Korean thesis, add `langid = {korean}` to Korean references and `langid = {english}` to English references.

For a thesis written in English, a standard APA 7th edition BibTeX format is often sufficient. However, because this template is currently organized mainly around Korean thesis writing, it is useful to organize `langid` values and citation keys as above when distinguishing Korean and English references in a Korean thesis.

Do not cite papers suggested by generative AI without verifying that they actually exist. Check the title, authors, year, DOI, journal name, original text, or abstract through Google Scholar, RISS, DBpia, KCI, Scopus, Web of Science, and the journal's official website.

## Tables and Figures

Tables and figures are not decorative substitutes for the main text. They are evidence that helps readers understand answers to the research questions more easily. After presenting a table or figure, always explain the main patterns, differences, and meanings in the text.

For numerical data, keep decimal places and units consistent. For figures, clearly label axes, legends, and units. Very long tables or supplementary materials are often better placed in appendices than in the main text.

Do not type table and figure numbers manually. If you use `\caption{}` and `\label{}`, LaTeX numbers them automatically.
Apply `\ThesisTableStyle` to tables. This command adjusts font size, column spacing, and row spacing for the template, so place it after `\caption{}` and `\label{}` and before starting `tabular*`.

### Placement Options for Tables and Figures

In LaTeX, `table` and `figure` are float environments that move among paragraphs. Therefore, the options in square brackets, such as `\begin{table}[htbp]` or `\begin{figure}[htbp]`, specify placement candidates rather than exact fixed positions.

| Option | Meaning |
| --- | --- |
| `h` | here. Place as close as possible to the current position |
| `t` | top. Place at the top of a page |
| `b` | bottom. Place at the bottom of a page |
| `p` | page. Place on a separate float page containing tables and figures |
| `!` | Relax some placement restrictions and try the requested location more actively |

Using `[htbp]` is generally stable. Use `[h!]` when you want the float to stay closer to the current paragraph. The `[H]` option fixes placement more strongly but requires the `float` package. Use it sparingly, because frequent forced placement can make page margins and text flow look awkward.

Table reference:

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
        비교 집단 & 28 & 67.85 & 73.20 & 5.35 \\
        \bottomrule
    \end{tabular*}
\end{table}

표~\ref{tab:result-example}에서 ...
```

Figure reference:

```tex
\begin{figure}[htbp]
    \centering
    \includegraphics[width=0.8\textwidth]{images/example.pdf}
    \caption{그림 제목}
    \label{fig:example-image}
\end{figure}

그림~\ref{fig:example-image}는 ...
```

## Figure File Formats

Vector formats are best for figures where lines and text are important, such as graphs, diagrams, flowcharts, and concept maps.

| Format | Recommended Use |
| --- | --- |
| `.pdf` | Most recommended for graphs, diagrams, and vector figures |
| `.png` | Screenshots and raster images that include text and lines |
| `.jpg` | Photographs. Because it uses lossy compression, it is not suitable for graphs, table images, or figures containing text |

Use `trim` and `clip` to crop the margins of an inserted figure.

```tex
\includegraphics[
    width=0.8\textwidth,
    trim=1cm 0.5cm 1cm 0.5cm,
    clip
]{images/example.pdf}
```

The order of `trim` values is left, bottom, right, top.

## Equations and TikZ

Manage equation numbers with the `equation` environment and `\label{}`.

```tex
\begin{equation}
    \bar{x} = \frac{1}{n}\sum_{i=1}^{n} x_i
    \label{eq:mean-example}
\end{equation}

식~\ref{eq:mean-example}은 ...
```

TikZ figure examples are included in `sub/4-Results.tex`. Put TikZ drawings inside a `figure` environment like ordinary figures, and add `\caption{}` and `\label{}` for references.

## Watermark

The watermark feature places a faint Korea National University of Education logo at the center of each page background. First check the university or department guidelines to see whether a watermark is needed for the final submission PDF.

Turn the watermark on or off with the `\documentclass` option at the top of `KNUE_thesis_main.tex`. The default setting is `nowatermark`, which does not include a watermark.

To use the watermark, activate the line with the `watermark` option.

```tex
\documentclass[watermark]{KNUE_thesis}
```

To disable the watermark, use the `nowatermark` option.

```tex
\documentclass[nowatermark]{KNUE_thesis}
```

Do not activate both lines at the same time. Keep only one active and comment out the other with `%`.

For example, to turn the watermark on:

```tex
\documentclass[watermark]{KNUE_thesis}
% \documentclass[nowatermark]{KNUE_thesis}
```

To turn the watermark off:

```tex
% \documentclass[watermark]{KNUE_thesis}
\documentclass[nowatermark]{KNUE_thesis}
```

The logo file used for the watermark is `logo/Knue_logo.png`. To use a different image as the watermark, place the image in the `logo/` folder and change the file name in the `Optional KNUE Logo Watermark` section of `KNUE_thesis.cls`.

```tex
\includegraphics[width=88mm]{logo/Knue_logo.png}
```

Change the `width=88mm` value to adjust the watermark size. A larger number makes the logo larger, and a smaller number makes it smaller. Adjust the `opacity=0.35` value in the same block to change the watermark density. Values closer to `1` are darker, and values closer to `0` are lighter.

```tex
\node[opacity=0.35] at (current page.center)
```

After changing the watermark option or logo file, rebuild with `KNUE_thesis_main_build.cmd` and check the PDF.

## Cover Trim Box

The 190 mm x 260 mm rectangular box shown on the cover and approval pages is a trim-area guide for checking the format. If the final submission PDF should not show this box, add the `notrimbox` option to the `\documentclass` line at the top of `KNUE_thesis_main.tex`.

```tex
\documentclass[nowatermark,notrimbox]{KNUE_thesis}
```

To show the box again, use the `trimbox` option.

```tex
\documentclass[nowatermark,trimbox]{KNUE_thesis}
```

Do not use `trimbox` and `notrimbox` at the same time. When using this option with the watermark option, separate the options with commas as shown above.

## Python Code Appendix

The Python example code is in `../code/example_analysis.py`. The appendix file `sub/A4_Code_File_Example.tex` shows an example of how to include a code file.

When adding code files to an appendix, save the code file in the `code/` folder and refer to that file name from the appendix `.tex` file.

## Reference PDF Tools (repo-root `code/` folder)

The `code/` folder also contains two Python scripts for managing reference PDFs.

| File | Purpose |
| --- | --- |
| `../code/rename_ref_pdfs_by_bib.py` | Matches the BibTeX entries in `sub/references.bib` against the PDFs in the `ref/` folder and renames the PDFs to readable `Author. (Year). Title. Journal.pdf` names. It writes CSV reports for matched, unmatched, and missing references. |
| `../code/download_missing_ref_pdfs.py` | Downloads reference PDFs that are listed in `references.bib` but missing from the `ref/` folder, using open-access sources, DOIs, and the lab paper-search server. |

### Installing the required modules

The two scripts use the following Python packages.

- `pymupdf` — extracts PDF body text (for filename matching)
- `pypdf` — fallback text extraction when PyMuPDF fails
- `requests` — paper downloads (download script only)

Install them on Python 3.10 or newer. Running them inside the `knue-python` conda environment from this repository's [3-PYTHON_CONDA_VSCODE_SETUP.md](../manual/3-PYTHON_CONDA_VSCODE_SETUP.md) is recommended.

```powershell
conda activate knue-python
pip install pymupdf pypdf requests
```

If you do not use conda, install the same packages into your Python.

```powershell
pip install pymupdf pypdf requests
```

On Windows, if typing `python` only opens the Microsoft Store page instead of running, make sure the conda environment is activated, or that Python is installed and on your PATH.

### Running the scripts

Open the `KNUE_thesis` folder as your working folder and run the scripts from there. It is safest to preview first with `--dry-run`, which does not change any files.

```powershell
# 1) Tidy PDF names in the ref folder (preview first)
python ../code/rename_ref_pdfs_by_bib.py --dry-run
# Actually rename
python ../code/rename_ref_pdfs_by_bib.py

# 2) Download missing reference PDFs (list candidates first)
python ../code/download_missing_ref_pdfs.py --dry-run
# Actually download
python ../code/download_missing_ref_pdfs.py
```

See all options, such as `--bib` and `--ref-dir`, with `--help`.

```powershell
python ../code/rename_ref_pdfs_by_bib.py --help
python ../code/download_missing_ref_pdfs.py --help
```

### Lab paper-search server password

`download_missing_ref_pdfs.py` also checks the lab paper-search server (`parksparks`) alongside the public sources. That server requires a login, and the password is not stored in the code. Provide it in one of two ways.

- Set the password in the `PARKSPARKS_PASSWORD` environment variable.
- Or save the password as a single line in `../code/.parksparks_secret`. This file is listed in `.gitignore`, so it is not committed to the repository.

If no password is provided or it is wrong, the script skips the search server and keeps downloading from the public sources. Ask the lab administrator for the password.

## Troubleshooting for English Users

Use this section when you cannot read Korean messages but need to diagnose the PDF build.

### The PDF Is Not Created

Cause: LaTeX stopped before producing `KNUE_thesis_main.pdf`.

Fix:

1. Run a clean build from the `KNUE_thesis` folder.

```powershell
.\KNUE_thesis_main_build.cmd clean
.\KNUE_thesis_main_build.cmd
```

2. Open `KNUE_thesis_main.log`.
3. Search for the first line that starts with `!`.
4. Fix that first error before reading later errors, because later messages are often caused by the first failure.

### latexmk Cannot Be Found

English Windows may show:

```text
'latexmk' is not recognized as an internal or external command, operable program or batch file.
```

Korean Windows may show:

```text
'latexmk'은(는) 내부 또는 외부 명령, 실행할 수 있는 프로그램, 또는 배치 파일이 아닙니다.
```

Meaning: Windows cannot find `latexmk.exe`.

Fix:

1. Check that `latexmk.exe`, `lualatex.exe`, and `biber.exe` exist in `C:\texlive\2026\bin\windows`.
2. Add `C:\texlive\2026\bin\windows` to the Windows `Path` environment variable.
3. Completely close VS Code and open it again.
4. Build again from the `KNUE_thesis` folder.

### A Build Lock Remains

If this message appears, a previous build or watch process may have left a lock folder.

```text
Error: Another build/watch is already running.
Lock: KNUE_thesis_main.build_lock
```

Fix:

```powershell
.\KNUE_thesis_main_build.cmd clean
.\KNUE_thesis_main_build.cmd
```

### References Do Not Appear

Cause: BibLaTeX prints only works that are actually cited in the thesis.

Fix:

1. Check that the BibTeX entry exists in `sub/references.bib`.
2. Check that the citation key is used in the main text.
3. Run a clean build.

```powershell
.\KNUE_thesis_main_build.cmd clean
.\KNUE_thesis_main_build.cmd
```

### Git Reports Unmerged Files

The following message means Git found a merge conflict.

```text
Committing is not possible because you have unmerged files.
```

Fix:

1. Run `git status` and open each file marked as unmerged.
2. Search for conflict markers: `<<<<<<<`, `=======`, and `>>>>>>>`.
3. Keep the correct content and remove the conflict markers.
4. Run `git add` on the resolved files.
5. Commit again.

## Final Checklist Before Submission

Before final submission, check the following.

1. Are the thesis title, author name, advisor name, and committee member names on the cover page correct?
2. Is the master's or doctoral degree type correct?
3. Are the title, author name, major name, and keywords in the Korean and English abstracts correct?
4. Are all tables, figures, and equations referenced with `\ref{}` in the main text?
5. Are all works cited in the main text printed in the reference list?
6. Have you checked that previous studies suggested by generative AI actually exist?
7. Does the format match the latest thesis guidelines from the university or department?

Submission rules from the university or department may change, so always compare the final PDF with the official thesis guidelines before submission.
