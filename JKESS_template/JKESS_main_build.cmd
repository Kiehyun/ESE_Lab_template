@echo off
chcp 65001 >nul

REM =====================================================================
REM  JKESS_main 원고 빌드 스크립트 (LuaLaTeX + biber) 사용법
REM ---------------------------------------------------------------------
REM  실행 방법:  JKESS_main_build.cmd [명령] [모드]
REM             (탐색기에서 더블클릭하면 명령 없이 실행되어 기본값 all 동작)
REM
REM  ▣ 명령(command) 목록
REM    all         모든 모드(투고본·심사본·최종본) PDF를 한 번에 빌드 [기본값]
REM    build       all 과 동일 (별칭)
REM    submission  투고본만 빌드  → JKESS_main_submission.pdf, JKESS_main.pdf
REM    review      심사본만 빌드  → JKESS_main_review.pdf,     JKESS_main.pdf
REM    final       최종본만 빌드  → JKESS_main_final.pdf,      JKESS_main.pdf
REM    quick       biber(참고문헌) 생략하고 1회만 빠르게 빌드 (인용 갱신 안 됨)
REM    clean       빌드 중간 산출물(.aux/.log 등) 삭제, PDF와 .tex 는 보존
REM    watch       최종본 기준 자동 감시 빌드 (파일 저장 시 자동 재빌드, Ctrl+C 종료)
REM    crops       crop_debug.pdf 생성 (그림 자르기 디버그용)
REM
REM  ▣ 각 명령은 다음 형태의 별칭(alias)도 허용합니다(대소문자 무시):
REM       --build / /build / -b , --all / /all , --quick / /quick / -q ,
REM       --clean / /clean / -c , --watch / /watch / -w , --crops / /crops
REM       --submission / --review / --final (이 셋은 단일 모드 빌드로 동작)
REM
REM  ▣ 모드(mode) 인자: 두 번째 인자로 submission|review|final 을 주면
REM       quick 등 일부 명령의 빌드 대상 모드를 지정할 수 있습니다.
REM       예) JKESS_main_build.cmd quick final   → 최종본을 biber 없이 빠르게 빌드
REM
REM  ▣ 사용 예시
REM       JKESS_main_build.cmd              모든 모드 빌드(기본)
REM       JKESS_main_build.cmd final        최종본만 빌드
REM       JKESS_main_build.cmd quick        선택/기본(최종) 모드를 빠르게 재빌드
REM       JKESS_main_build.cmd clean        중간 산출물 정리
REM       JKESS_main_build.cmd watch        편집 중 자동 재빌드
REM
REM  ▣ 사전 요구사항: lualatex, biber, latexmk 가 PATH 에 설치되어 있어야 합니다.
REM                   (없으면 시작 시 오류 메시지를 내고 종료)
REM  ▣ 중복 실행 방지: 빌드 중에는 JKESS_main.build_lock 폴더로 잠금합니다.
REM                   비정상 종료로 잠금이 남으면 "clean" 명령으로 해제하세요.
REM =====================================================================

setlocal enabledelayedexpansion
cd /d "%~dp0"
REM --- 기본 변수: 원고 파일명, 인자 받기, 잠금 폴더, 기본 모드 ---
set "main=JKESS_main"
set "maintex=%main%.tex"
set "command=%~1"
set "modearg=%~2"
set "LOCKDIR=%main%.build_lock"
set "SYNCTEX=0"
set "BUILDMODE=final"
REM --- 명령 정규화: 별칭(-b, --build 등)을 내부 표준 명령으로 변환 ---
if "%command%"=="" set "command=all"
if /i "%command%"=="--clean" set "command=clean"
if /i "%command%"=="/clean" set "command=clean"
if /i "%command%"=="-c" set "command=clean"
if /i "%command%"=="--build" set "command=all"
if /i "%command%"=="/build" set "command=all"
if /i "%command%"=="-b" set "command=all"
if /i "%command%"=="build" set "command=all"
if /i "%command%"=="--all" set "command=all"
if /i "%command%"=="/all" set "command=all"
if /i "%command%"=="all" set "command=all"
if /i "%command%"=="--quick" set "command=quick"
if /i "%command%"=="/quick" set "command=quick"
if /i "%command%"=="-q" set "command=quick"
if /i "%command%"=="--watch" set "command=watch"
if /i "%command%"=="/watch" set "command=watch"
if /i "%command%"=="-w" set "command=watch"
if /i "%command%"=="--crops" set "command=crops"
if /i "%command%"=="/crops" set "command=crops"
if /i "%command%"=="crops" set "command=crops"

REM 단일 모드 빌드 별칭: submission/review/final 을 single 명령 + 해당 모드로 변환
REM Mode aliases for single-mode builds.
if /i "%command%"=="submission" (
  set "command=single"
  set "BUILDMODE=submission"
)
if /i "%command%"=="review" (
  set "command=single"
  set "BUILDMODE=review"
)
if /i "%command%"=="final" (
  set "command=single"
  set "BUILDMODE=final"
)
if /i "%command%"=="--submission" (
  set "command=single"
  set "BUILDMODE=submission"
)
if /i "%command%"=="--review" (
  set "command=single"
  set "BUILDMODE=review"
)
if /i "%command%"=="--final" (
  set "command=single"
  set "BUILDMODE=final"
)
REM 두 번째 인자(modearg)로 빌드 대상 모드를 덮어씀 (예: quick final)
if /i "%modearg%"=="submission" set "BUILDMODE=submission"
if /i "%modearg%"=="review" set "BUILDMODE=review"
if /i "%modearg%"=="final" set "BUILDMODE=final"
if /i "%modearg%"=="--submission" set "BUILDMODE=submission"
if /i "%modearg%"=="--review" set "BUILDMODE=review"
if /i "%modearg%"=="--final" set "BUILDMODE=final"

REM 모드에 맞는 출력 파일 이름(OUTBASE) 결정
call :set_outbase

REM clean 명령은 검사 없이 곧바로 정리 루틴으로 이동
REM Clean mode: skip all checks and go directly to cleanup.
if /i "%command%"=="clean" goto clean_build

REM SyncTeX 비활성화: 모드별 빌드에서 보조파일 변동(churn)을 줄임
REM Disable SyncTeX for mode-separated builds to reduce aux-file churn.
set "SYNCTEX=0"

REM 원고 .tex 파일 존재 확인
if not exist "%maintex%" (
  echo Error: %maintex% not found in current directory
  exit /b 1
)
REM 필수 도구(lualatex/biber/latexmk)가 PATH 에 있는지 확인
for %%c in (lualatex biber latexmk) do (
  where %%c >nul 2>&1
  if errorlevel 1 (
    echo Error: %%c is not installed or not on PATH
    exit /b 1
  )
)

REM 빌드 잠금 획득(중복 실행 방지). 실패하면 종료
call :acquire_lock
if errorlevel 1 exit /b 1

REM 다른 lualatex.exe 가 돌고 있으면 경고만 표시(폴더 단위로 격리되므로 진행)
tasklist /FI "IMAGENAME eq lualatex.exe" | find /I "lualatex.exe" >nul 2>&1
if not errorlevel 1 (
  echo [WARNING] Another lualatex.exe process is running. Continuing; builds are isolated by folder.
)

REM --- 명령 분기(dispatch): 정규화된 명령에 따라 해당 루틴 호출 ---
set "exitcode=0"
if /i "%command%"=="all" (
  call :build_all_modes
  set "exitcode=!errorlevel!"
  goto end
)
if /i "%command%"=="single" (
  call :full_build
  set "exitcode=!errorlevel!"
  goto end
)
if /i "%command%"=="quick" (
  call :quick_build
  set "exitcode=!errorlevel!"
  goto end
)
if /i "%command%"=="watch" (
  call :watch_mode
  set "exitcode=!errorlevel!"
  goto end
)
if /i "%command%"=="crops" (
  call :crops_build
  set "exitcode=!errorlevel!"
  goto end
)

REM 인식되지 않은 명령이면 잠금 해제 후 사용법 출력
call :release_lock
goto usage

REM 공통 종료점: 잠금 해제 후 마지막 종료코드로 종료
:end
call :release_lock
exit /b %exitcode%

REM 잠금 획득: 빌드 잠금 폴더 생성(이미 있으면 실패=중복 실행)
:acquire_lock
mkdir "%LOCKDIR%" 2>nul
if errorlevel 1 (
  echo Error: Another build/watch is already running.
  echo Lock: %LOCKDIR%
  echo If this is stale, run "%~nx0 clean" or delete the lock folder.
  exit /b 1
)
exit /b 0

REM 잠금 해제: 빌드 잠금 폴더 제거
:release_lock
if exist "%LOCKDIR%" rmdir "%LOCKDIR%" >nul 2>&1
exit /b 0

REM 출력 파일 기준 이름 설정: 모드에 따라 _final/_submission/_review 접미사 결정
:set_outbase
set "OUTBASE=%main%_final"
if /i "%BUILDMODE%"=="submission" set "OUTBASE=%main%_submission"
if /i "%BUILDMODE%"=="review" set "OUTBASE=%main%_review"
exit /b 0

REM 전체 빌드: 투고본→심사본→최종본 순서로 각각 풀빌드(하나라도 실패하면 중단)
:build_all_modes
set "BUILDMODE=submission"
call :set_outbase
call :full_build
if errorlevel 1 exit /b 1
set "BUILDMODE=review"
call :set_outbase
call :full_build
if errorlevel 1 exit /b 1
set "BUILDMODE=final"
call :set_outbase
call :full_build
if errorlevel 1 exit /b 1
echo ========================================
echo All paper modes built successfully:
echo   %main%_submission.pdf
echo   %main%_review.pdf
echo   %main%_final.pdf
echo ========================================
exit /b 0

REM 빌드 전 정리: 현재 모드의 보조파일(.aux 등)만 지워 깨끗하게 시작
:preclean_runtime
for %%f in (aux nav snm toc out run.xml) do (
  if exist "%OUTBASE%.%%f" del /f /q "%OUTBASE%.%%f" 2>nul
)
if exist "%OUTBASE%.synctex(busy)" del /f /q "%OUTBASE%.synctex(busy)" 2>nul
if exist "%OUTBASE%.synctex.gz" del /f /q "%OUTBASE%.synctex.gz" 2>nul
if exist "sub" (
  del /f /q "sub\*.aux" 2>nul
  del /f /q "sub\*.nav" 2>nul
  del /f /q "sub\*.snm" 2>nul
  del /f /q "sub\*.toc" 2>nul
  del /f /q "sub\*.out" 2>nul
  del /f /q "sub\*.run.xml" 2>nul
  del /f /q "sub\*.synctex(busy)" 2>nul
  del /f /q "sub\*.synctex.gz" 2>nul
)
exit /b 0

REM 정리 명령 본체: 모든 모드의 중간 산출물 삭제(.tex 와 .pdf 는 보존)
:clean_build
echo Cleaning build artifacts, preserving %maintex% and PDFs...
for %%f in (aux bbl bcf blg log nav out run.xml snm toc xdv fls fdb_latexmk synctex.gz) do (
  if exist "%main%.%%f" del /f /q "%main%.%%f" 2>nul
  if exist "%main%_submission.%%f" del /f /q "%main%_submission.%%f" 2>nul
  if exist "%main%_review.%%f" del /f /q "%main%_review.%%f" 2>nul
  if exist "%main%_final.%%f" del /f /q "%main%_final.%%f" 2>nul
)
if exist "%main%.synctex(busy)" del /f /q "%main%.synctex(busy)" 2>nul
if exist "%main%_submission.synctex(busy)" del /f /q "%main%_submission.synctex(busy)" 2>nul
if exist "%main%_review.synctex(busy)" del /f /q "%main%_review.synctex(busy)" 2>nul
if exist "%main%_final.synctex(busy)" del /f /q "%main%_final.synctex(busy)" 2>nul
if exist "sub" (
  del /f /q "sub\*.aux" 2>nul
  del /f /q "sub\*.bbl" 2>nul
  del /f /q "sub\*.bcf" 2>nul
  del /f /q "sub\*.blg" 2>nul
  del /f /q "sub\*.log" 2>nul
  del /f /q "sub\*.nav" 2>nul
  del /f /q "sub\*.out" 2>nul
  del /f /q "sub\*.run.xml" 2>nul
  del /f /q "sub\*.snm" 2>nul
  del /f /q "sub\*.toc" 2>nul
  del /f /q "sub\*.xdv" 2>nul
  del /f /q "sub\*.fls" 2>nul
  del /f /q "sub\*.fdb_latexmk" 2>nul
  del /f /q "sub\*.synctex.gz" 2>nul
  del /f /q "sub\*.synctex(busy)" 2>nul
)
for %%f in (aux log out toc synctex.gz) do (
  if exist "crop_debug.%%f" del /f /q "crop_debug.%%f" 2>nul
)
if exist "%LOCKDIR%" rmdir "%LOCKDIR%" >nul 2>&1
echo Clean complete. %maintex% preserved.
exit /b 0

REM crops 명령: 파이썬 스크립트로 crop_debug.tex 생성 후 crop_debug.pdf 빌드(그림 자르기 확인용)
:crops_build
echo ========================================
echo Generating crop_debug.tex and building crop_debug.pdf...
echo ========================================
if not exist "scripts\generate_crop_debug.py" (
  echo Error: scripts\generate_crop_debug.py not found.
  exit /b 1
)
set "PYTHON="
where py >nul 2>&1
if not errorlevel 1 set "PYTHON=py"
if "%PYTHON%"=="" (
  where python >nul 2>&1
  if not errorlevel 1 set "PYTHON=python"
)
if "%PYTHON%"=="" (
  echo Error: Python not found on PATH. Install Python or add it to PATH.
  exit /b 1
)
%PYTHON% "scripts\generate_crop_debug.py"
if errorlevel 1 (
  echo Error: failed to generate crop_debug.tex
  exit /b 1
)
lualatex -synctex=%SYNCTEX% -interaction=nonstopmode -file-line-error "crop_debug.tex"
if errorlevel 1 (
  echo Error: failed to build crop_debug.pdf
  exit /b 1
)
echo Done: crop_debug.pdf
exit /b 0

REM LuaLaTeX 1회 실행: \DocMode 를 현재 모드로 정의하여 원고를 컴파일
:run_lualatex_mode
lualatex -jobname="%OUTBASE%" -synctex=%SYNCTEX% -interaction=nonstopmode -file-line-error -shell-escape "\def\DocMode{%BUILDMODE%}\input{%maintex%}"
exit /b %errorlevel%

REM 풀빌드: LuaLaTeX(1차)→biber(참고문헌)→LuaLaTeX(2차·3차) 로 상호참조/인용 확정
:full_build
echo ========================================
echo Building %maintex% [mode=%BUILDMODE%]...
echo ========================================
call :preclean_runtime
echo [1/4] Running LuaLaTeX (first pass)...
call :run_lualatex_mode
if errorlevel 1 (
  echo Error: LuaLaTeX first pass reported an error. Check %OUTBASE%.log for details.
  echo Tip: run "%~nx0 clean" then build again if this is an aux/nav corruption.
  exit /b 1
)
if not exist "%OUTBASE%.pdf" (
  echo Error: LuaLaTeX first pass failed. Check %OUTBASE%.log for details.
  exit /b 1
)
if not exist "%OUTBASE%.bcf" (
  echo Warning: .bcf file not created. Bibliography might not be present.
  goto full_skip_biber
)
echo [2/4] Running biber for bibliography...
biber "%OUTBASE%"
if errorlevel 1 (
  echo Error: biber failed. Check %OUTBASE%.blg for details.
  exit /b 1
)
:full_skip_biber
echo [3/4] Running LuaLaTeX (second pass)...
call :run_lualatex_mode
if errorlevel 1 (
  echo Error: LuaLaTeX second pass reported an error. Check %OUTBASE%.log for details.
  exit /b 1
)
echo [4/4] Running LuaLaTeX (third pass)...
call :run_lualatex_mode
if errorlevel 1 (
  echo Error: LuaLaTeX third pass reported an error. Check %OUTBASE%.log for details.
  exit /b 1
)
if exist "%OUTBASE%.pdf" (
  call :publish_main_pdf
  if errorlevel 1 exit /b 1
  for %%A in ("%OUTBASE%.pdf") do set "pdf_size=%%~zA"
  for %%A in ("%main%.pdf") do set "main_pdf_size=%%~zA"
  echo ========================================
  echo Build successful
  echo   Output: %OUTBASE%.pdf - !pdf_size! bytes
  echo   Current mode copy: %main%.pdf - !main_pdf_size! bytes
  echo ========================================
  exit /b 0
)
echo Error: PDF was not created.
exit /b 1

REM 결과 게시: 모드별 PDF(OUTBASE)를 대표 파일 JKESS_main.pdf 로 복사
:publish_main_pdf
if not exist "%OUTBASE%.pdf" (
  echo Error: %OUTBASE%.pdf was not found; cannot update %main%.pdf.
  exit /b 1
)
copy /y "%OUTBASE%.pdf" "%main%.pdf" >nul
if errorlevel 1 (
  echo Error: failed to update %main%.pdf from %OUTBASE%.pdf.
  exit /b 1
)
exit /b 0

REM 빠른 빌드: biber 없이 LuaLaTeX 1회만 실행(인용/목차는 갱신 안 될 수 있음)
:quick_build
echo Quick rebuild (skipping biber) [mode=%BUILDMODE%]...
call :preclean_runtime
call :run_lualatex_mode
if errorlevel 1 (
  echo Error: LuaLaTeX reported an error. Check %OUTBASE%.log for details.
  exit /b 1
)
call :publish_main_pdf
if errorlevel 1 exit /b 1
echo Quick build complete: %OUTBASE%.pdf
echo Current mode copy: %main%.pdf
exit /b 0

REM 감시 빌드: 최초 최종본 풀빌드 후 latexmk -pvc 로 파일 변경 시 자동 재빌드(Ctrl+C 종료)
:watch_mode
echo ========================================
echo Initial final-mode build before starting watch mode...
echo ========================================
set "BUILDMODE=final"
call :set_outbase
call :preclean_runtime
call :full_build
if errorlevel 1 (
  echo Initial build failed. Watch mode cancelled.
  exit /b 1
)
echo.
echo ========================================
echo Watch mode started (Ctrl+C to stop)...
echo Files will auto-rebuild on changes.
echo ========================================
latexmk -lualatex -usebiber -pvc -pv- -f -shell-escape -interaction=nonstopmode -file-line-error -synctex=1 "%maintex%"
echo.
echo Watch mode ended.
exit /b 0

REM 사용법 출력: 잘못된/없는 명령일 때 표시 (exit /b 1 로 종료)
:usage
echo Usage: %~nx0 [all^|submission^|review^|final^|quick^|clean^|watch^|crops]
echo.
echo Commands:
echo   all         - Build submission, review, and final PDFs (default)
echo   build       - Alias for all
echo   submission  - Build submission copy: %main%_submission.pdf and %main%.pdf
echo   review      - Build review copy: %main%_review.pdf and %main%.pdf
echo   final       - Build final copy: %main%_final.pdf and %main%.pdf
echo   quick       - Quick rebuild for the selected/default final mode, no biber; updates %main%.pdf
echo   clean       - Remove build artifacts, preserving PDFs and .tex files
echo   watch       - Watch mode for final-mode editing
echo   crops       - Build crop_debug.pdf
exit /b 1
