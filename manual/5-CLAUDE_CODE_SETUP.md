# Windows VS Code PowerShell에서 Claude Code 사용하기

이 문서는 Windows 개인 PC의 VS Code 통합 터미널(PowerShell)에서 **Claude Code**(Anthropic의 터미널용 AI 코딩 에이전트)를 설치하고 사용하는 방법을 안내합니다. 논문·코드·자료 정리를 자연어로 요청해 처리할 수 있습니다.

Windows 10/11 기준으로 설명합니다.

> Claude Code는 파일을 읽고 고치고, 명령을 실행하는 **에이전트**입니다. 실제 파일을 바꾸므로, 중요한 작업은 git으로 커밋해 두고(→ [4-OBSIDIAN_VAULT_SETUP.md](4-OBSIDIAN_VAULT_SETUP.md)의 Git 절) 변경 내용을 확인하며 쓰는 것이 안전합니다.

## 0. 전체 흐름

처음 한 번만 아래 순서로 준비합니다.

1. Git for Windows 설치(필수)
2. VS Code 설치(이미 있으면 건너뜀)
3. PowerShell에서 Claude Code 설치
4. 새 터미널을 열어 설치 확인
5. 로그인(인증)
6. 작업 폴더에서 `claude` 실행
7. 자연어로 요청하며 사용

## 1. 준비물

- **Windows PowerShell** — x86 버전이 아닌 일반 PowerShell을 사용합니다. Git Bash나 명령 프롬프트(cmd)가 아닙니다.
- **Git for Windows (필수)** — Claude Code는 명령을 실행할 때 내부적으로 Git Bash를 사용합니다. Git이 없으면 설치가 실패하거나 실행되어도 제대로 동작하지 않습니다.

  1. <https://git-scm.com/download/win> 에서 설치 파일을 내려받아 설치합니다.
  2. 설치가 끝나면 PowerShell에서 아래가 버전을 출력하는지 확인합니다.

     ```powershell
     git --version
     ```

- **VS Code** — 편집기 겸 터미널로 사용합니다. 설치는 [2-VSCODE_LOCAL_THESIS_SETUP.md](2-VSCODE_LOCAL_THESIS_SETUP.md)를 참고합니다.

## 2. Claude Code 설치 (PowerShell 네이티브 설치)

2026년 현재 **네이티브 설치 방식**이 권장됩니다(Node.js가 필요 없습니다).

1. VS Code에서 터미널을 엽니다: 메뉴 `Terminal > New Terminal` 또는 단축키 `Ctrl+``(백틱).
2. 터미널 오른쪽 위 드롭다운에서 **PowerShell**을 선택합니다.
3. 아래 한 줄을 입력해 실행합니다.

   ```powershell
   irm https://claude.ai/install.ps1 | iex
   ```

   `irm`(Invoke-RestMethod)이 설치 스크립트를 받아 `iex`(Invoke-Expression)로 실행하며, 바이너리 다운로드·PATH 등록·셸 연동을 자동으로 처리합니다.

4. **설치가 끝나면 터미널을 닫고 새 PowerShell 창을 엽니다.** PATH 변경은 새로 여는 터미널에만 적용되므로, 이 단계를 건너뛰면 다음 단계에서 `claude`를 찾지 못합니다.

> 사내망/방화벽 등으로 설치 스크립트 실행이 막히면, Node.js(18 이상)를 설치한 뒤 `npm install -g @anthropic-ai/claude-code`로도 설치할 수 있습니다(네이티브 설치가 우선 권장).

## 3. 설치 확인

새 PowerShell에서 아래를 입력합니다.

```powershell
claude --version
claude doctor
```

- 버전이 출력되면 설치가 된 것입니다.
- `claude doctor`는 설치·환경(예: Git 연동)을 진단해 문제가 있으면 알려 줍니다.
- 나중에 업데이트하려면 `claude update`를 실행합니다.

`claude : 용어가 cmdlet ... 으로 인식되지 않습니다` 오류가 나면 대부분 **새 터미널을 열지 않았기 때문**입니다. VS Code를 완전히 닫았다가 다시 열고 확인합니다.

## 4. 로그인 (인증)

처음 `claude`를 실행하면 인증을 요구합니다.

- 브라우저가 열리며 **Claude 계정(Pro/Max 구독)** 또는 **Anthropic Console(API 키)** 로 로그인합니다.
- 인증이 끝나면 터미널로 돌아옵니다.
- 이후 다시 로그인하려면 Claude Code 안에서 `/login`, 상태 확인은 `/status`를 입력합니다.

**브라우저가 자동으로 열리지 않을 때** — 터미널에 `Browser didn't open? Use the url below to sign in`과 함께 긴 URL, `Paste code here if prompted >` 프롬프트가 나타납니다. 이때는:

1. 프롬프트 상태에서 **`c` 키를 누릅니다.** URL 전체가 클립보드에 복사됩니다(터미널에서 줄바꿈되어 보이는 URL을 손으로 복사하면 끊길 수 있으니 `c`로 복사하세요).
2. 복사한 URL을 브라우저에 붙여넣어 열고, 로그인·승인합니다.
3. 브라우저에 표시되는 **인증 코드(authorization code)** 를 복사합니다.
4. 터미널로 돌아와 `Paste code here if prompted >` 뒤에 붙여넣고 Enter를 누릅니다.

> 이 과정을 하는 동안 **터미널 창을 닫지 마세요.** 닫으면 코드가 무효가 되어 `claude`를 다시 실행해 새 URL을 받아야 합니다.

## 5. VS Code에서 실행

1. VS Code에서 작업할 폴더를 엽니다: `File > Open Folder`(예: 이 저장소 폴더).
2. 통합 터미널(PowerShell)에서 현재 위치가 그 프로젝트 폴더인지 확인합니다.
3. 아래를 입력해 Claude Code를 시작합니다.

   ```powershell
   claude
   ```

4. VS Code의 통합 터미널에서 실행하면 **편집기와 자동으로 연결**됩니다. 편집기에서 선택(드래그)한 코드가 맥락으로 전달되고, Claude가 만든 변경은 diff(변경 비교)로 확인할 수 있습니다.

종료는 `Ctrl+C`를 두 번 누르거나 `/exit`를 입력합니다.

## 6. (선택) VS Code 확장 설치

더 편한 통합을 원하면 확장을 설치합니다.

1. VS Code 왼쪽 Activity Bar에서 Extensions 아이콘을 클릭합니다.
2. 검색창에 `Claude Code`를 입력합니다.
3. Anthropic이 제공하는 **Claude Code** 확장을 설치합니다(사이드바·diff 뷰 등 제공).

## 7. 기본 사용법

- **자연어로 요청**합니다. 예: `이 함수의 버그를 고쳐줘`, `README에 설치법 절을 추가해줘`, `sub/4-Results.tex의 표를 2단 폭으로 바꿔줘`.
- **`/` (슬래시 명령)**
  - `/help` — 사용 가능한 명령 전체 보기
  - `/clear` — 대화 맥락 초기화(새 작업 시작할 때)
  - `/model` — 사용할 모델 선택
  - `/config` — 설정 열기, `/status` — 상태, `/login` — 로그인
  - `/init` — 현재 저장소를 분석해 `CLAUDE.md`(프로젝트 안내) 생성
- **`@` (파일 참조)** — `@KNUE_thesis/sub/0-preamble.tex`처럼 특정 파일을 지목해 요청합니다.
- **`#` (기억 추가)** — 문장 앞에 `#`을 붙여 입력하면 `CLAUDE.md`에 저장되어 이후에도 반영됩니다. 예: `#빌드는 항상 lualatex로`.
- **`Shift+Tab`** — 작업 모드 전환(계획 모드 ↔ 자동 수락 등).
- **`Esc`** — 진행 중인 작업 중단. **`↑`** — 이전 입력 다시 불러오기.
- 이미지 붙여넣기, 파일 드래그도 됩니다.

## 8. 이 연구실에서 특히 유용한 사용법

- **변경 리뷰**: 원고나 코드를 고친 뒤 `/code-review`로 변경분을 점검할 수 있습니다.
- **AI 작업 일지**: 작업이 끝날 때 `오늘 작업 내역을 worklog에 남겨줘`라고 요청하면 `worklog/`에 기록됩니다(→ [4-OBSIDIAN_VAULT_SETUP.md](4-OBSIDIAN_VAULT_SETUP.md)의 AI 작업 일지 절).
- **참고문헌 정리**: `References/`의 논문을 `저자_연도-제목` 규칙으로 정리하거나 요약 노트 작성을 요청할 수 있습니다(→ [../References/README.md](../References/README.md)).
- **데이터 분석**: 그래프·분석 코드는 Python 환경이 준비돼 있어야 원활합니다(→ [3-PYTHON_CONDA_VSCODE_SETUP.md](3-PYTHON_CONDA_VSCODE_SETUP.md)).

## 9. 자주 나는 오류와 해결

- **`claude`가 인식되지 않을 때** — 새 PowerShell 창(또는 VS Code)을 다시 열었는지 확인합니다. 그래도 안 되면 `claude doctor` 실행.
- **명령 실행이 실패할 때** — `git --version`이 동작하는지 확인합니다(Git for Windows 필수).
- **로그인이 안 될 때** — `/login`으로 다시 시도하고, 구독/요금제 상태는 `/status`로 확인합니다.
- **회사/학교 네트워크에서 설치가 막힐 때** — 방화벽·프록시 문제일 수 있으니, npm 설치 방식(2절 참고)을 시도하거나 개인 네트워크에서 설치합니다.

## 10. 안전하게 쓰기

- Claude Code는 **명령을 실행하기 전에 보통 확인을 요청**합니다. 내용을 보고 승인/거부하세요.
- 중요한 원고·코드는 미리 **git 커밋**해 두면, 마음에 들지 않는 변경을 쉽게 되돌릴 수 있습니다.
- 큰 변경 뒤에는 **빌드(PDF 생성)와 결과를 직접 확인**하는 습관을 들이세요.

## 공식 링크

- Claude Code 문서: <https://docs.claude.com/en/docs/claude-code>
- Claude Code 설치 안내: <https://docs.claude.com/en/docs/claude-code/setup>
- Git for Windows: <https://git-scm.com/download/win>
