# Overleaf에서 KNUE 학위논문 프로젝트 만들기

이 문서는 개인 PC에 TeX Live를 설치하지 않고, Overleaf에서 한국교원대학교 학위논문 템플릿 `KNUE_thesis/`로 논문 프로젝트를 만들어 작성하는 방법을 안내합니다.

Overleaf에서는 웹 브라우저만으로 `.tex`, `.bib`, 그림 파일을 관리하고 PDF를 만들 수 있습니다. 다만 이 템플릿은 `LuaLaTeX` 기준으로 맞추어져 있으므로, 프로젝트를 만든 뒤 반드시 컴파일러를 `LuaLaTeX`로 바꿔야 합니다.

Windows 개인 PC에 직접 설치해서 작성하려면 [2-VSCODE_TeXLive_SETUP.md](2-VSCODE_TeXLive_SETUP.md)를 확인합니다.

## 참고: Overleaf 무료/유료 버전 차이

Overleaf는 무료 버전으로도 논문 프로젝트를 만들고 작성할 수 있습니다. 다만 학위논문처럼 파일이 많고 컴파일 시간이 길어질 수 있는 프로젝트에서는 무료 버전의 제한을 미리 알고 시작하는 것이 좋습니다.

2026년 5월 30일 기준 Overleaf 공식 안내의 주요 차이는 아래와 같습니다.

| 항목 | 무료 버전 | 유료 버전 |
| --- | --- | --- |
| 프로젝트 수 | 무제한 | 무제한 |
| 프로젝트당 파일 수 | 최대 2000개 | 최대 2000개 |
| 컴파일 시간 제한 | 10초 | 240초 |
| 프로젝트당 공동작업자 | 1명 | Student는 6명, Standard는 10명, Professional은 무제한 |
| 변경 내용 추적 | 제한됨 | 사용 가능 |
| 문서 히스토리 | 최근 24시간 중심 | 전체 히스토리와 버전 복원 가능 |
| Git, GitHub, Dropbox, Zotero, Mendeley 연동 | 제한됨 | 사용 가능 |
| Overleaf AI 사용량 | 기본 일일 사용량 제공 | 요금제에 따라 더 많은 사용량 또는 AI Assistant 제공 |

현재 `KNUE_thesis/` 템플릿은 Overleaf 무료 버전에서 컴파일 시간이 부족해 PDF 생성이 실패할 수 있습니다. 특히 이 템플릿은 `LuaLaTeX`, 한글 글꼴 설정, 참고문헌 처리, 표지와 초록 양식, 그림 예시 등을 함께 사용하므로 첫 컴파일이나 전체 재컴파일 시간이 무료 버전의 10초 제한을 넘기기 쉽습니다. 따라서 Overleaf에서 이 템플릿을 안정적으로 사용하려면 유료 계정이 필요할 수 있습니다.

Overleaf 무료 버전에서 컴파일 시간 초과가 반복되면 아래 방법을 고려합니다.

- Overleaf 유료 버전으로 전환해 컴파일 시간 제한을 늘린다.
- [2-VSCODE_TeXLive_SETUP.md](2-VSCODE_TeXLive_SETUP.md)를 참고해 개인 PC에서 로컬로 컴파일한다.
- 작성 초기에는 사용하지 않는 큰 그림 파일이나 예시 파일을 잠시 줄여 컴파일 시간을 낮춘다.

컴파일 시간 외에도 아래 상황에서는 유료 버전 사용을 고려하는 것이 좋습니다.

- 지도교수나 공동연구자 여러 명과 동시에 수정해야 한다.
- 수정 이력을 길게 보관하거나 이전 버전으로 되돌릴 일이 많다.
- GitHub, Dropbox, Zotero, Mendeley 같은 외부 도구와 연동해 관리하고 싶다.

유료 기능은 프로젝트 소유자의 구독 상태에 따라 적용되는 경우가 많습니다. 예를 들어 유료 계정 사용자가 만든 프로젝트에 초대된 공동작업자는 해당 프로젝트 안에서 확장된 컴파일 시간, 변경 추적, 전체 히스토리 같은 기능을 함께 사용할 수 있지만, 공동작업자 본인이 만든 다른 프로젝트까지 자동으로 유료 기능이 적용되는 것은 아닙니다.

### Overleaf AI 사용 비용

Overleaf의 AI 기능은 기본적으로 제한된 일일 사용량 안에서 사용할 수 있습니다. 하지만 Error Assist, 언어 교정, 표 생성, 수식 생성, 편집 도구, TeXGPT 같은 AI 기능을 제한 없이 사용하려면 `AI Assist` 애드온을 추가로 구독해야 할 수 있습니다.

2026년 5월 30일 기준 Overleaf 요금제 페이지에서 `AI Assist` 애드온은 월 결제 기준 월 21달러, 연 결제 기준 월 12.50달러로 안내되어 있습니다. 즉 Overleaf 무료 계정이나 일반 유료 계정을 사용하더라도, AI 기능을 많이 쓰려면 논문 작성 비용에 AI 애드온 비용이 별도로 추가될 수 있습니다.

AI 기능은 논문 초안 작성, 문장 다듬기, LaTeX 오류 설명 등에 도움을 줄 수 있지만, 학위논문에서는 생성된 문장의 사실 여부, 인용의 정확성, 연구윤리 기준을 반드시 직접 확인해야 합니다. 학교나 학과에 AI 사용 지침이 있다면 그 기준을 먼저 따르는 것이 좋습니다.

## 0. 전체 흐름

처음 한 번만 아래 순서로 프로젝트를 만듭니다.

1. GitHub에서 템플릿 ZIP 내려받기
2. ZIP 압축 풀기
3. `KNUE_thesis/` 폴더 안의 내용만 새 ZIP으로 압축하기
4. Overleaf에서 `Upload Project`로 새 프로젝트 만들기
5. 메인 파일을 `KNUE_thesis_main.tex`로 확인하기
6. 컴파일러를 `LuaLaTeX`로 바꾸기
7. `Recompile`로 첫 PDF 만들기
8. 제목, 저자, 초록, 본문, 그림, 참고문헌 수정하기

## 1. 템플릿 내려받기

1. 웹 브라우저에서 이 템플릿 GitHub 저장소를 엽니다.

   https://github.com/Kiehyun/ESE_Lab_template

2. 오른쪽 위의 초록색 `Code` 버튼을 누릅니다.

3. `Download ZIP`을 선택합니다.

4. 내려받은 ZIP 파일을 적당한 위치에 저장합니다.

5. ZIP 파일의 압축을 풉니다.

압축을 풀면 `ESE_Lab_template-main` 또는 비슷한 이름의 폴더가 생길 수 있습니다. 그 안에서 학위논문 작성에 사용할 `KNUE_thesis/` 폴더를 찾습니다.

## 2. Overleaf 업로드용 ZIP 만들기

Overleaf에는 저장소 전체가 아니라 `KNUE_thesis/` 폴더 안의 내용만 올려야 합니다.

1. 압축을 푼 폴더 안에서 `KNUE_thesis/` 폴더로 들어갑니다.

2. `KNUE_thesis/` 폴더 안에 아래 파일과 폴더가 보이는지 확인합니다.

```text
KNUE_thesis_main.tex
KNUE_thesis.cls
sub/
images/
logo/
```

3. `KNUE_thesis/` 폴더 자체를 선택하지 말고, 그 안의 파일과 하위 폴더 전체를 선택합니다.

4. 선택한 파일과 폴더를 새 ZIP 파일로 압축합니다.

5. 새 ZIP 파일을 열었을 때 바로 아래처럼 보여야 합니다.

```text
KNUE_thesis_main.tex
KNUE_thesis.cls
sub/
images/
logo/
```

새 ZIP 안에 `KNUE_thesis/KNUE_thesis_main.tex`처럼 폴더가 한 단계 더 들어가 있으면 Overleaf에서 메인 파일이나 그림 경로를 찾지 못할 수 있습니다.

## 3. Overleaf 프로젝트 만들기

1. Overleaf에 로그인합니다.

   https://www.overleaf.com/

2. 프로젝트 목록 화면에서 `New Project`를 누릅니다.

3. `Upload Project`를 선택합니다.

4. 앞에서 만든 `KNUE_thesis/` 내용물 ZIP 파일을 업로드합니다.

5. 업로드가 끝나면 Overleaf 편집기 화면이 열립니다.

6. 왼쪽 파일 목록의 최상위에 `KNUE_thesis_main.tex`, `KNUE_thesis.cls`, `sub/`, `images/`, `logo/`가 보이는지 확인합니다.

## 4. 메인 파일과 컴파일러 확인

프로젝트를 연 뒤 가장 먼저 메인 파일과 컴파일러를 확인합니다.

1. 메인 파일이 `KNUE_thesis_main.tex`인지 확인합니다.

2. `Menu` 또는 설정 화면을 엽니다.

3. `Compiler`를 `LuaLaTeX`로 바꿉니다.

4. 설정을 닫고 `Recompile`을 누릅니다.

이 템플릿은 `KNUE_thesis.cls`에서 한글 글꼴, 표지 간격, 이름 자간, 일부 LuaLaTeX 기능을 사용합니다. 컴파일러가 `pdfLaTeX`나 `XeLaTeX`로 되어 있으면 표지에 코드가 그대로 보이거나 한글 출력이 달라질 수 있습니다.

## 5. 첫 PDF 확인

`Recompile`이 끝나면 오른쪽 PDF 미리보기에서 결과를 확인합니다.

처음에는 아래 항목을 먼저 봅니다.

- 표지가 만들어지는가?
- 인준면이 만들어지는가?
- 국문 초록과 영문 초록이 보이는가?
- 목차, 표 목차, 그림 목차가 만들어지는가?
- 본문 장 제목과 쪽 번호가 보이는가?
- 참고문헌이 출력되는가?

오류가 나면 오른쪽 또는 아래쪽의 로그에서 첫 번째 오류 메시지를 확인합니다. 여러 오류가 이어져 보여도 첫 번째 오류가 원인인 경우가 많습니다.

## 6. 처음 수정할 파일

논문 정보를 바꿀 때는 먼저 아래 파일들을 수정합니다.

| 작업 | 파일 |
| --- | --- |
| 제목, 저자, 지도교수, 전공 정보 | `sub/0-preamble.tex` |
| 국문 초록 | `sub/abstractKor.tex` |
| 영문 초록 | `sub/abstractEng.tex` |
| 1장 서론 | `sub/1-Introduction.tex` |
| 2장 이론적 배경 | `sub/2-Theorical_background.tex` |
| 3장 연구 방법 | `sub/3-Methods.tex` |
| 4장 연구 결과 | `sub/4-Results.tex` |
| 5장 결론 | `sub/5-Conclusions.tex` |
| 참고문헌 | `sub/references.bib` |

파일명을 바꾸거나 장 파일을 새로 만들면 `KNUE_thesis_main.tex`의 `\include` 또는 `\input` 명령도 함께 수정해야 합니다.

## 7. 그림 파일 넣기

그림 파일은 `images/` 폴더에 넣습니다.

1. Overleaf 왼쪽 파일 목록에서 `images/` 폴더를 선택합니다.

2. 업로드 버튼을 눌러 그림 파일을 올립니다.

3. 파일 이름은 가능하면 영어, 숫자, 밑줄만 사용합니다.

좋은 예:

```text
student_project_result.png
co2_timeseries_2026.pdf
```

피하는 예:

```text
그림 1 최종본 (수정).png
```

본문에서는 아래처럼 그림을 넣습니다.

```latex
\begin{figure}
  \centering
  \includegraphics[width=0.8\textwidth]{student_project_result.png}
  \caption{그림 설명}
\end{figure}
```

## 8. 참고문헌 넣기

참고문헌은 `sub/references.bib`에 BibTeX 형식으로 넣습니다.

Google Scholar에서 BibTeX를 가져오는 기본 흐름은 아래와 같습니다.

1. Google Scholar에서 논문 제목이나 DOI를 검색합니다.

   https://scholar.google.com/

2. 검색 결과 아래의 따옴표 아이콘 또는 `인용`을 누릅니다.

3. `BibTeX`를 선택합니다.

4. 새 페이지에 나온 BibTeX 항목 전체를 복사합니다.

5. Overleaf에서 `sub/references.bib` 파일을 엽니다.

6. 파일 맨 아래에 붙여 넣습니다.

7. BibTeX 첫 줄의 인용 키를 확인합니다.

```bibtex
@article{park2026example,
```

여기서는 `park2026example`이 인용 키입니다.

본문에서는 같은 키를 사용합니다.

```latex
\parencite{park2026example}
```

한국어 참고문헌에서 `langid={korean}`을 넣고 `\ktextcite`, `\kparencite`를 사용하는 방식은 `KNUE_thesis/` 템플릿의 한국어 참고문헌 처리를 위한 특수 설정입니다.

## 9. 작업 중 저장과 백업

Overleaf는 작업 내용을 자동 저장합니다. 그래도 논문 파일은 정기적으로 내려받아 백업하는 것이 좋습니다.

1. Overleaf 편집기 왼쪽 위의 `File` 메뉴를 엽니다.

2. `Download as source (.zip)`를 선택해 소스 파일을 내려받습니다.

3. PDF가 필요하면 PDF 미리보기 쪽의 다운로드 버튼을 눌러 PDF를 저장합니다.

큰 수정을 하기 전에는 소스 ZIP을 한 번 내려받아 두면 되돌아가기 쉽습니다.

## 10. 자주 나는 문제

### 업로드 후 파일이 한 폴더 안에 들어가 있을 때

왼쪽 파일 목록에 `KNUE_thesis/` 폴더만 보이고 그 안에 `KNUE_thesis_main.tex`가 들어 있다면 ZIP을 잘못 만든 상태일 수 있습니다.

해결 방법:

1. 로컬 컴퓨터에서 `KNUE_thesis/` 폴더 안으로 들어갑니다.
2. 폴더 안의 파일과 하위 폴더 전체를 다시 선택합니다.
3. 새 ZIP 파일을 만듭니다.
4. Overleaf에서 새 프로젝트로 다시 업로드합니다.

### 표지에 코드가 그대로 보일 때

컴파일러가 `LuaLaTeX`가 아닐 가능성이 큽니다.

해결 방법:

1. Overleaf의 `Menu` 또는 설정 화면을 엽니다.
2. `Compiler`를 `LuaLaTeX`로 바꿉니다.
3. 다시 `Recompile`합니다.

### 참고문헌이 물음표로 나올 때

참고문헌 처리가 아직 끝나지 않았거나 인용 키가 맞지 않을 수 있습니다.

해결 방법:

1. 한 번 더 `Recompile`합니다.
2. `sub/references.bib`의 인용 키와 본문 인용 키가 같은지 확인합니다.
3. BibTeX 항목의 중괄호 `{}`와 쉼표 `,`가 빠지지 않았는지 확인합니다.

### 컴파일 시간이 너무 오래 걸릴 때

그림 파일이 너무 크거나, 프로젝트 파일이 너무 많거나, 오류가 반복될 때 컴파일 시간이 길어질 수 있습니다.

해결 방법:

1. 큰 그림 파일은 필요한 해상도로 줄입니다.
2. 사용하지 않는 그림, PDF, 임시 파일은 프로젝트에서 제거합니다.
3. 로그의 첫 번째 오류부터 해결합니다.
4. Overleaf에서 계속 시간이 초과되면 개인 PC에서 로컬 빌드를 함께 고려합니다.

## 11. 확인 체크리스트

아래 항목이 모두 되면 Overleaf에서 논문 작성을 시작할 준비가 된 것입니다.

- [ ] Overleaf 프로젝트 최상위에 `KNUE_thesis_main.tex`가 있다.
- [ ] Overleaf 프로젝트 최상위에 `KNUE_thesis.cls`가 있다.
- [ ] `sub/`, `images/`, `logo/` 폴더가 보인다.
- [ ] 메인 파일이 `KNUE_thesis_main.tex`로 설정되어 있다.
- [ ] 컴파일러가 `LuaLaTeX`로 설정되어 있다.
- [ ] `Recompile`을 눌렀을 때 PDF가 만들어진다.
- [ ] `sub/0-preamble.tex`에서 제목, 저자, 지도교수 정보를 수정할 수 있다.
- [ ] `sub/references.bib`에 참고문헌을 추가할 수 있다.

## 12. 공식 참고 링크

- 이 템플릿 GitHub 저장소: https://github.com/Kiehyun/ESE_Lab_template
- Overleaf: https://www.overleaf.com/
- Overleaf 첫 프로젝트 만들기: https://docs.overleaf.com/getting-started/your-first-project
- Overleaf 프로젝트 업로드: https://docs.overleaf.com/managing-projects-and-files/uploading-a-project
- Overleaf 파일 업로드: https://docs.overleaf.com/managing-projects-and-files/adding-files-to-a-project/uploading-files-to-a-project
- Overleaf 컴파일러 설정: https://docs.overleaf.com/getting-started/recompiling-your-project/selecting-a-tex-live-version-and-latex-compiler
- Overleaf 프로젝트 내려받기: https://docs.overleaf.com/managing-projects-and-files/downloading-a-project
- Overleaf 무료/유료 플랜 제한: https://docs.overleaf.com/getting-started/free-and-premium-plans/plan-limits
- Overleaf 요금제 비교: https://www.overleaf.com/plans
- Overleaf AI 기능: https://docs.overleaf.com/integrations-and-add-ons/ai-features
