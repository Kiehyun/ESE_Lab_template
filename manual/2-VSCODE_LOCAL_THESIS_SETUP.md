# Windows 개인 PC의 VS Code에서 KNUE 학위논문 템플릿 사용하기

이 문서는 LaTeX을 처음 쓰는 사용자가 Windows 개인 컴퓨터에 TeX Live, VS Code, LaTeX Workshop을 설치하고 `KNUE_thesis/` 템플릿으로 한국교원대학교 학위논문 PDF를 만드는 과정을 안내합니다.

Windows 10/11 기준으로 설명합니다.

Overleaf에서 작성하려면 [1-OVERLEAF_THESIS_PROJECT.md](1-OVERLEAF_THESIS_PROJECT.md)를 확인합니다.

## 0. 전체 흐름

처음 한 번만 아래 순서로 준비합니다.

1. TeX Live 설치
2. VS Code 설치
3. VS Code에서 LaTeX Workshop 확장 설치
4. `KNUE_thesis/` 폴더를 작업 폴더로 준비
5. `KNUE_thesis_main.tex` 열기
6. PDF 빌드
7. 제목, 저자, 초록, 본문, 그림, 참고문헌 수정

## 1. TeX Live 설치

TeX Live는 LaTeX 문서를 PDF로 바꾸는 프로그램 묶음입니다. `KNUE_thesis/` 템플릿은 TeX Live 전체 설치를 권장합니다.

설치 파일은 약 6GB이고, 설치 후에는 약 9.62GB의 디스크 공간이 필요합니다. 설치 시간도 매우 오래 걸릴 수 있으므로 노트북은 전원을 연결하고, 여유 시간이 있을 때 진행합니다.

### ISO 이미지로 설치하기

1. 아래 링크에서 TeX Live ISO 이미지 파일을 내려받습니다.

   https://gofile.me/6VcYy/fiPUGdUIz

2. 내려받은 ISO 이미지 파일을 마우스 오른쪽 버튼으로 클릭합니다.

3. 메뉴에서 `탑재`를 선택합니다.

4. Windows에 새 드라이브가 생기면 그 드라이브를 엽니다.

5. 드라이브 안에 있는 `install-tl-windows.bat` 파일을 실행합니다.

6. 설치 화면에서 특별한 이유가 없으면 기본값을 사용합니다.

7. 설치 방식은 `full scheme` 또는 전체 설치를 선택합니다.

8. 설치를 시작합니다.

9. 설치가 끝날 때까지 기다립니다. 컴퓨터 성능에 따라 매우 오래 걸릴 수 있습니다.

10. 설치가 끝나면 컴퓨터를 한 번 재시작합니다.

### 공식 설치 파일로 설치하기

ISO 이미지를 사용할 수 없을 때는 TeX Live 공식 설치 안내 페이지에서 Windows용 설치 파일을 내려받아 설치할 수 있습니다.

1. 웹 브라우저에서 TeX Live 공식 설치 안내 페이지를 엽니다.

   https://tug.org/texlive/doc/install-tl.html

2. Windows용 설치 파일 `install-tl-windows.exe`를 내려받습니다.

3. 내려받은 `install-tl-windows.exe`를 실행합니다.

4. 설치 화면에서 특별한 이유가 없으면 기본값을 사용합니다.

5. 설치 방식은 `full scheme` 또는 전체 설치를 선택합니다.

6. 설치를 시작합니다.

7. 설치가 끝날 때까지 기다립니다. 인터넷 속도와 컴퓨터 성능에 따라 오래 걸릴 수 있습니다.

8. 설치가 끝나면 컴퓨터를 한 번 재시작합니다.

### TeX Live 설치 확인

1. Windows 시작 메뉴에서 `PowerShell`을 엽니다.

2. 아래 명령을 입력합니다.

```powershell
lualatex --version
latexmk --version
biber --version
```

3. 각 명령에서 버전 정보가 나오면 설치가 된 것입니다.

4. `명령을 찾을 수 없습니다` 또는 `not recognized`가 나오면 컴퓨터를 재시작한 뒤 다시 확인합니다.

5. 재시작 후에도 안 되면 TeX Live 설치 경로가 Windows PATH에 들어가지 않은 상태일 수 있습니다. 보통 설치 경로는 아래와 비슷합니다.

```text
C:\texlive\2026\bin\windows
```

## 2. VS Code 설치

VS Code는 학위논문 템플릿 파일을 편집하고 PDF를 빌드할 때 사용할 편집기입니다.

1. VS Code 공식 다운로드 페이지를 엽니다.

   https://code.visualstudio.com/download

2. Windows의 `User Installer x64`를 내려받습니다.

3. 설치 파일을 실행합니다.

4. 설치 옵션에서 아래 항목을 선택하면 편합니다.

   - `Add to PATH`
   - `Open with Code` 관련 항목

5. 설치가 끝나면 VS Code를 실행합니다.

## 3. LaTeX Workshop 확장 설치

LaTeX Workshop은 VS Code에서 LaTeX 파일을 편집하고 PDF를 빌드하게 해 주는 확장입니다.

1. VS Code를 엽니다.

2. 왼쪽 Activity Bar에서 Extensions 아이콘을 클릭합니다.

3. 검색창에 `LaTeX Workshop`을 입력합니다.

4. 제작자가 `James Yu`인 `LaTeX Workshop`을 설치합니다.

5. 설치 후 VS Code를 한 번 다시 시작합니다.

확장 페이지는 아래에서 확인할 수 있습니다.

https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop

## 4. 학위논문 템플릿 폴더 준비

한국교원대학교 학위논문을 작성할 때는 이 저장소의 `KNUE_thesis/` 폴더를 사용합니다.

이 저장소는 연구 전 과정을 하나의 Obsidian 볼트에서 이어가도록 설계되었으므로, 저장소 전체를 열고 그 안의 `KNUE_thesis/` 폴더에서 학위논문을 작성하는 것을 권장합니다. 특정 양식만 따로 관리하거나 Overleaf에 올릴 때는 `KNUE_thesis/` 폴더만 복사해 별도 작업 폴더로 써도 됩니다.

예:

```text
C:\Mydata\My_KNUE_thesis\
```

작업 폴더 안에는 아래 파일과 폴더가 있어야 합니다.

```text
KNUE_thesis_main.tex
KNUE_thesis.cls
sub/
images/
logo/
```

## 5. VS Code에서 폴더 열기

1. VS Code를 엽니다.

2. 메뉴에서 `File > Open Folder...`를 선택합니다.

3. 학위논문 작업 폴더를 선택합니다.

   예:

```text
C:\Mydata\My_KNUE_thesis\
```

4. VS Code가 이 폴더를 신뢰할지 물으면 `Yes, I trust the authors`를 선택합니다.

5. 왼쪽 Explorer에서 `KNUE_thesis_main.tex`가 보이는지 확인합니다.

이어서 **자동 저장(Auto Save)**을 켜는 것을 권장합니다. 자동 저장을 켜면 `.tex`를 고친 뒤 따로 저장하지 않아도 되고, LaTeX Workshop이 저장 시점에 PDF를 자동으로 다시 빌드해 주어 편리합니다.

6. 메뉴에서 `File`을 엽니다.

7. `Auto Save` 항목을 클릭해 체크 표시가 켜지도록 합니다.

더 세밀하게 설정하고 싶으면 아래처럼 합니다.

- `Ctrl+,`(쉼표)를 눌러 설정(Settings)을 엽니다.
- 검색창에 `Auto Save`를 입력합니다.
- `Files: Auto Save` 값을 `afterDelay`(잠시 후 자동 저장)로 선택합니다.

> 자동 저장을 켜면, LaTeX Workshop 기본 설정상 저장될 때마다 PDF가 다시 빌드됩니다. 빌드가 너무 자주 일어나 불편하면 두 가지 중 하나로 조절합니다. (1) `Files: Auto Save`를 `onFocusChange`(다른 곳을 클릭할 때 저장)로 바꾸거나, (2) 설정에서 `Auto Build`를 검색해 `Latex-workshop › Latex › Auto Build: Run`을 `never`로 두고 `Ctrl+Alt+B`로 직접 빌드합니다.

## 6. 첫 PDF 빌드하기

### VS Code에서 빌드하기

1. `KNUE_thesis_main.tex` 파일을 엽니다.

2. `Ctrl+Alt+B`를 누릅니다.

3. 빌드가 끝나면 PDF가 VS Code 오른쪽 탭에 열립니다.

4. PDF가 열리지 않으면 왼쪽의 TeX 아이콘을 클릭하고 `View LaTeX PDF`를 실행합니다.

### PowerShell에서 직접 빌드하기

VS Code 빌드가 잘 안 될 때는 PowerShell에서 직접 빌드할 수 있습니다.

```powershell
cd C:\Mydata\My_KNUE_thesis
latexmk -pdf -lualatex KNUE_thesis_main.tex
```

참고문헌을 포함한 문서는 보통 `lualatex`, `biber`, `lualatex`, `lualatex` 순서가 필요합니다. `latexmk`는 이 과정을 자동으로 처리합니다.

## 7. 처음 수정할 파일

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

## 8. 그림 넣기

1. 그림 파일은 `images/` 폴더에 넣습니다.

2. 파일 이름은 가능하면 영어, 숫자, 밑줄만 사용합니다.

   좋은 예:

```text
student_project_result.png
co2_timeseries_2026.pdf
```

   피하는 예:

```text
그림 1 최종본 (수정).png
```

3. LaTeX에서는 아래처럼 넣습니다.

```latex
\begin{figure}
  \centering
  \includegraphics[width=0.8\textwidth]{student_project_result.png}
  \caption{그림 설명}
\end{figure}
```

### 그림을 컬러본·흑백본으로 만들어 두고 빌드할 때 선택하기

학위논문은 흑백으로 인쇄하는 경우가 많지만, 화면용 PDF나 발표 자료에는 컬러 그림이 필요할 수 있습니다. 이 템플릿은 **같은 그림을 컬러본과 흑백본으로 각각 저장**해 두고, 빌드할 때 한쪽을 자동으로 고르는 기능을 제공합니다.

1. 그림을 컬러본과 흑백본으로 각각 만들어 `images/` 폴더에 저장합니다. 같은 이름 뒤에 `_color`와 `_bw`를 붙입니다.

```text
images/fig1_color.pdf
images/fig1_bw.pdf
```

2. 본문에서는 파일명 자리에 `\figf{...}`를 씁니다. 빌드 모드에 따라 `fig1_color` 또는 `fig1_bw`가 자동으로 선택됩니다.

```latex
\includegraphics[width=0.8\textwidth]{images/\figf{fig1}}
```

3. 빌드할 때 컬러/흑백을 고릅니다(우선순위: 빌드 명령 > `main.tex` 설정 > 기본값 흑백).

```powershell
.\KNUE_thesis_main_build.cmd bw      # 흑백(기본): *_bw 사용 + 문서 전체 회색조
.\KNUE_thesis_main_build.cmd color   # 컬러: *_color 사용 + 색 유지
```

또는 `KNUE_thesis_main.tex` 위쪽의 `%\def\figmode{color}` 줄 앞의 `%`를 지우면 컬러로 빌드됩니다. 컬러/흑백 구분이 필요 없는 그림은 예전처럼 `\includegraphics{images/그림.png}`로 그냥 넣으면 됩니다.

> 그래프를 `matplotlib`으로 그린다면, 저장할 때 컬러본과 흑백본(예: `plt.savefig`를 색 지정만 바꿔 두 번)으로 각각 저장해 두면 됩니다. 자세한 설명은 학위논문 본문 작성법(`KNUE_thesis/sub/4-Results.tex`의 "그림 컬러본과 흑백본" 절)과 [KNUE_thesis Readme](../KNUE_thesis/Readme__KNUEthesis.md)에 있습니다.

## 9. 참고문헌 넣기

참고문헌은 `sub/references.bib` 파일에 BibTeX 형식으로 넣습니다.

예:

```bibtex
@article{park2026example,
  author = {Park, Kiehyun and Kim, Example},
  title = {Example Article Title},
  journal = {Journal of Example Studies},
  year = {2026},
  volume = {10},
  number = {1},
  pages = {1--15},
  doi = {10.0000/example.2026.001},
  langid = {english}
}
```

본문에서는 아래처럼 인용합니다.

```latex
\textcite{park2026example}
\parencite{park2026example}
```

한국어 참고문헌에서 `langid={korean}`을 넣고 `\ktextcite`, `\kparencite`를 사용하는 방식은 `KNUE_thesis/` 템플릿의 한국어 참고문헌 처리를 위한 특수 설정입니다.

### Google Scholar에서 BibTeX 가져오기

Google Scholar에서 논문 정보를 찾은 뒤 BibTeX 형식으로 복사해 `.bib` 파일에 붙여 넣을 수 있습니다.

1. 웹 브라우저에서 Google Scholar를 엽니다.

   https://scholar.google.com/

2. 논문 제목, 저자, DOI 등을 검색합니다.

3. 검색 결과 아래의 따옴표 아이콘 또는 `인용`을 클릭합니다.

4. 인용 형식 목록에서 `BibTeX`를 클릭합니다.

5. 새 페이지에 나온 BibTeX 항목 전체를 복사합니다.

6. `sub/references.bib` 맨 아래에 붙여 넣습니다.

7. BibTeX 항목의 첫 줄에 있는 인용 키를 확인합니다.

   예:

```bibtex
@article{park2026example,
```

   여기서는 `park2026example`이 인용 키입니다.

8. 본문에서는 아래처럼 같은 인용 키를 사용합니다.

```latex
\parencite{park2026example}
```

Google Scholar에서 가져온 BibTeX는 저자명, 제목 대소문자, 학술지명, DOI가 완전하지 않을 수 있습니다. 붙여 넣은 뒤 원문 PDF나 학술지 페이지와 비교해서 필요한 정보를 확인하는 것이 좋습니다.

## 10. 자주 쓰는 VS Code 기능

| 기능 | 방법 |
| --- | --- |
| PDF 빌드 | `Ctrl+Alt+B` |
| 명령 찾기 | `Ctrl+Shift+P` |
| 전체 파일 검색 | `Ctrl+Shift+F` |
| 현재 파일 검색 | `Ctrl+F` |
| 터미널 열기 | `` Ctrl+` `` |
| PDF에서 소스 위치 찾기 | PDF에서 `Ctrl+클릭` |

## 11. 자주 나는 오류와 해결

### lualatex를 찾을 수 없다고 나올 때

TeX Live가 설치되지 않았거나 PATH가 연결되지 않은 상태입니다.

1. 컴퓨터를 재시작합니다.

2. PowerShell에서 확인합니다.

```powershell
lualatex --version
```

3. 계속 안 되면 TeX Live 설치 경로가 PATH에 들어갔는지 확인합니다.

### 한글이 깨질 때

이 학위논문 템플릿은 LuaLaTeX 사용을 권장합니다. pdfLaTeX으로 빌드하면 한글 처리가 깨질 수 있습니다.

1. `latexmk -pdf -lualatex KNUE_thesis_main.tex`로 빌드합니다.

2. VS Code의 LaTeX Workshop에서도 `latexmk` 레시피를 사용합니다.

3. Windows 기본 한글 글꼴인 맑은 고딕, 바탕이 설치되어 있는지 확인합니다.

### 참고문헌이 물음표로 나올 때

참고문헌 처리가 아직 끝나지 않은 상태일 수 있습니다.

1. 같은 파일을 한 번 더 빌드합니다.

2. 가능하면 `latexmk`로 빌드합니다.

3. `.bib` 파일의 인용 키와 본문 인용 키가 같은지 확인합니다.

### PDF가 열려 있어서 빌드가 실패할 때

외부 PDF 뷰어가 파일을 잠그고 있을 수 있습니다.

1. 열려 있는 PDF 뷰어를 닫습니다.

2. VS Code 내부 PDF 뷰어를 사용합니다.

3. 다시 빌드합니다.

### 파일 경로에 문제가 생길 때

LaTeX은 공백, 괄호, 한글이 섞인 파일명에서 문제가 생길 때가 있습니다.

1. 작업 폴더 경로를 짧게 둡니다.

   예:

```text
D:\LaTeX\MyThesis
```

2. 그림 파일명은 영어와 숫자 중심으로 씁니다.

3. OneDrive, iCloud, Dropbox처럼 동기화가 강한 폴더에서는 빌드 중 충돌이 날 수 있으므로 주의합니다.

## 12. 작업할 때 추천하는 습관

1. 문서를 크게 고치기 전에는 폴더를 복사해서 백업합니다.

2. 그림 파일은 `images/`, 참고문헌은 `sub/references.bib`에 모읍니다.

3. 한 번에 너무 많이 고치지 말고, 조금 수정한 뒤 바로 빌드합니다.

4. 에러가 나면 로그의 첫 번째 에러부터 봅니다.

5. 파일 이름은 가능한 한 단순하게 둡니다.

6. **제출·심사 등 한 단계가 끝날 때마다 git으로 커밋하고 태그를 붙여 둡니다.** 그러면 그 시점 이후에 무엇을 어떻게 고쳤는지 나중에 색으로 표시한 PDF(추가=파랑, 삭제=빨강)로 뽑아 심사자에게 보여 줄 수 있습니다.

   ```bash
   git add -A && git commit -m "박사학위논문 심사본 제출"
   git tag 심사본-1차              # 원하는 이름으로 구분점을 남김
   # ... 심사 의견 반영해 수정한 뒤 ...
   ./make-diff.sh 심사본-1차       # 제출 이후 변경분을 색으로 표시한 PDF 생성 (Windows: make-diff.cmd)
   ```

   자세한 방법(태그 관리, `make-diff`, 심사위원별 색상)은 [4-OBSIDIAN_VAULT_SETUP.md](4-OBSIDIAN_VAULT_SETUP.md)의 "제출 시점을 커밋(태그)해 두면" 절과 [KNUE_thesis Readme](../KNUE_thesis/Readme__KNUEthesis.md)의 "심사위원별 수정 표시" 절을 참고하세요.

## 13. 설치 확인 체크리스트

아래 항목이 모두 되면 개인 PC에서 학위논문 템플릿을 사용할 준비가 된 것입니다.

- [ ] PowerShell에서 `lualatex --version`이 실행된다.
- [ ] PowerShell에서 `latexmk --version`이 실행된다.
- [ ] PowerShell에서 `biber --version`이 실행된다.
- [ ] VS Code가 설치되어 있다.
- [ ] VS Code에 LaTeX Workshop 확장이 설치되어 있다.
- [ ] VS Code에서 학위논문 작업 폴더를 열 수 있다.
- [ ] `KNUE_thesis_main.tex`를 열고 `Ctrl+Alt+B`로 PDF가 만들어진다.

## 14. macOS나 Ubuntu에서 사용할 때

macOS나 Ubuntu에서도 큰 흐름은 같습니다. TeX Live, VS Code, LaTeX Workshop을 설치한 뒤 `KNUE_thesis_main.tex`를 `LuaLaTeX`로 빌드하면 됩니다.

다만 설치 파일, 터미널 명령, 한글 글꼴 설정이 Windows와 다를 수 있습니다. macOS나 Ubuntu에서는 TeX Live 공식 설치 안내와 각 운영체제의 VS Code 설치 안내를 먼저 확인합니다.

## 15. 공식 참고 링크

- 이 템플릿 GitHub 저장소: https://github.com/Kiehyun/ESE_Lab_template
- TeX Live 설치 안내: https://tug.org/texlive/doc/install-tl.html
- TeX Live Windows 안내: https://tug.org/texlive/windows.html
- VS Code 다운로드: https://code.visualstudio.com/download
- VS Code Windows 설치 안내: https://code.visualstudio.com/docs/setup/windows
- LaTeX Workshop 확장: https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop
