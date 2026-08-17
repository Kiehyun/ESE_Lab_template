@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

REM ===========================================================================
REM make-diff.cmd - 기준 커밋(git) 대비 "수정사항 추적(track-changes)" PDF 생성.
REM                 Build a track-changes PDF against a base git commit.
REM
REM   Usage:  make-diff.cmd [BASE_COMMIT] [--no-build]
REM
REM   BASE_COMMIT : 비교 기준 git 커밋/태그/브랜치 (기본값 HEAD)
REM                 OLD = 기준커밋 시점의 원고, NEW = 현재 작업트리
REM   --no-build  : diff용 .tex 만 만들고 PDF 컴파일은 건너뜀
REM
REM   Examples:
REM     make-diff.cmd                  마지막 커밋 이후의 (미커밋) 변경분
REM     make-diff.cmd 3a1c9ef          특정 커밋 이후의 모든 변경분
REM     make-diff.cmd v1.0 --no-build
REM
REM   Output: KNUE_thesis_main-diff<shorthash>.pdf  (추가=파랑, 삭제=빨강 취소선)
REM
REM   ※ git 이력(커밋)이 있어야 동작한다. 두 시점의 원고를 비교하므로 최소 한 번은
REM      커밋해 두어야 한다. 심사위원별 "색상 표시" 기능(\revised, \revisedA..D)과는
REM      별개이며, 그 기능은 sub/0-preamble.tex 에서 정의한다.
REM ===========================================================================

set "main=KNUE_thesis_main"
set "maintex=%main%.tex"
set "SYNCTEX=0"

REM --- parse args ---------------------------------------------------------
set "base=HEAD"
set "dobuild=1"
:argloop
if "%~1"=="" goto argdone
if /i "%~1"=="--no-build" (
  set "dobuild=0"
) else if /i "%~1"=="-n" (
  set "dobuild=0"
) else (
  set "base=%~1"
)
shift
goto argloop
:argdone

REM --- put TeX Live on PATH (same as the build script) --------------------
set "TLBIN="
if exist "D:\texlive\2026\bin\windows\latexmk.exe" set "TLBIN=D:\texlive\2026\bin\windows"
if "%TLBIN%"=="" if exist "D:\texlive\2025\bin\windows\latexmk.exe" set "TLBIN=D:\texlive\2025\bin\windows"
if "%TLBIN%"=="" if exist "C:\texlive\2026\bin\windows\latexmk.exe" set "TLBIN=C:\texlive\2026\bin\windows"
if "%TLBIN%"=="" if exist "C:\texlive\2025\bin\windows\latexmk.exe" set "TLBIN=C:\texlive\2025\bin\windows"
if not "%TLBIN%"=="" set "PATH=%TLBIN%;%PATH%"

REM --- check required tools -----------------------------------------------
for %%c in (git latexpand latexdiff latexmk lualatex biber tar) do (
  where %%c >nul 2>&1
  if errorlevel 1 (
    echo Error: %%c is not installed or not on PATH
    exit /b 1
  )
)

if not exist "%maintex%" (
  echo Error: %maintex% not found in current directory
  exit /b 1
)

REM --- validate base commit, get short hash + subject --------------------
set "shorthash="
for /f "delims=" %%H in ('git rev-parse --short "%base%" 2^>nul') do set "shorthash=%%H"
if "%shorthash%"=="" (
  echo Error: '%base%' is not a valid git commit/branch/tag.
  echo Usage: %~nx0 [BASE_COMMIT] [--no-build]
  exit /b 1
)
set "subject="
for /f "delims=" %%S in ('git log -1 --format^=%%s "%base%" 2^>nul') do set "subject=%%S"

set "diffname=%main%-diff%shorthash%"
set "difftex=%diffname%.tex"

REM --- keep work dir OUTSIDE the cloud-sync tree (same reason as build) ---
if defined LOCALAPPDATA (set "WORK=%LOCALAPPDATA%\latexbuild\diff") else (set "WORK=%TEMP%\latexbuild\diff")
set "OLDDIR=%WORK%\old"
set "LDTMP=%WORK%\_ldtmp"
set "OUT=%WORK%\out"
if exist "%WORK%" rmdir /s /q "%WORK%" 2>nul
mkdir "%OLDDIR%" 2>nul
mkdir "%LDTMP%" 2>nul
mkdir "%OUT%"    2>nul

echo ========================================
echo  diff: %difftex%
echo   OLD = %shorthash%  (%subject%)
echo   NEW = current working tree
echo ========================================

REM --- [1/4] extract sources at the base commit --------------------------
echo [1/4] Extracting sources at %base% (%shorthash%)...
git archive "%base%" "%maintex%" sub | tar -x -C "%OLDDIR%"
if not exist "%OLDDIR%\%maintex%" (
  echo Error: failed to extract sources from base commit.
  exit /b 1
)

REM --- [2/4] flatten OLD and NEW (latexpand) -----------------------------
echo [2/4] Flattening OLD and NEW (latexpand)...
pushd "%OLDDIR%"
latexpand "%maintex%" > "%LDTMP%\old_flat.tex" 2> "%LDTMP%\old_flat.log"
popd
if errorlevel 1 (echo Error: failed to flatten OLD & exit /b 1)
latexpand "%maintex%" > "%LDTMP%\new_flat.tex" 2> "%LDTMP%\new_flat.log"
if errorlevel 1 (echo Error: failed to flatten NEW & exit /b 1)

REM --- [3/4] latexdiff ---------------------------------------------------
REM This template is heavily customized, which trips several latexdiff defaults.
REM The options below keep the diff compilable (prose changes render cleanly):
REM   --type=CFONT           color markup, NOT ulem; avoids "paragraph ended" errors.
REM   --exclude-textcmd      don't descend into cite args (avoids unbalanced \DIFdel).
REM   --append-safecmd       keep graphics wrappers atomic (image paths with '_').
REM   --graphics-markup=none don't wrap \includegraphics in \DIFadd variants.
REM   PICTUREENV             treat figure/table/tabular envs as atomic blocks.
set "CITECMDS=cite,parencite,textcite,kparencite,ktextcite,autocite,citeauthor,citeyear,citetitle,footcite,parencites,textcites"
set "SAFECMDS=includegraphics"
set "PICENV=(?:picture|tikzpicture|pspicture|figure\*?|table\*?|tabularx?\*?|longtable\*?|threeparttable|DIFnomarkup)"
echo [3/4] Running latexdiff...
latexdiff --encoding=utf8 --type=CFONT --exclude-textcmd=%CITECMDS% --append-safecmd=%SAFECMDS% --graphics-markup=none --config="PICTUREENV=%PICENV%" "%LDTMP%\old_flat.tex" "%LDTMP%\new_flat.tex" > "%difftex%" 2> "%LDTMP%\latexdiff.log"
if errorlevel 1 (
  echo Error: latexdiff failed. Log: %LDTMP%\latexdiff.log
  exit /b 1
)
for %%A in ("%difftex%") do set "tex_size=%%~zA"
if "%tex_size%"=="0" (
  echo Error: generated %difftex% is empty. Log: %LDTMP%\latexdiff.log
  exit /b 1
)
echo   Wrote %difftex% (%tex_size% bytes)
echo   (latexdiff warnings about the Korean middle dot are harmless.)

if "%dobuild%"=="0" (
  echo --no-build: skipping PDF compile.
  echo To build it:  latexmk -pdflua -shell-escape -interaction=nonstopmode "%difftex%"
  goto :done
)

REM --- [4/4] build PDF (force mode) --------------------------------------
echo [4/4] Building PDF (LuaLaTeX + biber, force mode)...
lualatex -synctex=%SYNCTEX% -interaction=nonstopmode -file-line-error -shell-escape -output-directory="%OUT%" "%difftex%"
latexmk "-auxdir=%OUT%" "-outdir=%OUT%" -pdflua -f -synctex=%SYNCTEX% -interaction=nonstopmode "%difftex%"
if not exist "%OUT%\%diffname%.pdf" (
  echo Error: PDF was not created. Log: %OUT%\%diffname%.log
  exit /b 1
)
copy /y "%OUT%\%diffname%.pdf" "%diffname%.pdf" >nul
if errorlevel 1 (
  echo Error: failed to update %diffname%.pdf. Close PDF viewers and retry.
  exit /b 1
)

:done
echo ========================================
echo  Done: %diffname%.pdf
echo   changes since %shorthash% (added=blue, deleted=red strikeout)
echo ========================================
endlocal
exit /b 0
