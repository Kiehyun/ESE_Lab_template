@echo off
REM 콘솔을 UTF-8로 전환해 한글 출력이 깨지지 않게 합니다(cmd/PowerShell 공통).
REM Switch the console to UTF-8 so Korean output is not garbled.
chcp 65001 >nul 2>&1
REM ===========================================================================
REM KNUE thesis/dissertation LaTeX template build script for Windows
REM
REM Purpose:
REM   - Builds KNUE_thesis_main.tex with latexmk using LuaLaTeX.
REM   - Lets latexmk run biber automatically when bibliography processing is needed.
REM   - Removes fragile generated files before builds and uses a lock folder to avoid
REM     concurrent builds of the same thesis.
REM   - Compiles into a cache folder (BUILDDIR below) and copies only the finished
REM     PDF back to the project folder. Building directly inside a folder synced by
REM     Synology Drive/Dropbox/OneDrive/iCloud can make the sync client lock
REM     intermediate files mid-compile, so the final SyncTeX rename fails and no
REM     PDF is produced. watch mode is the exception: it builds in place so the
REM     VS Code PDF viewer can follow along live.
REM
REM   KNUE_thesis_main_build.cmd [build^|quick^|clean^|watch^|submit^|review^|review-blue^|color^|bw^|versions^|crops]
REM
REM   build       Full build. Processes the bibliography as needed.
REM   quick       Quick incremental rebuild handled by latexmk.
REM   clean       Removes generated artifacts and stale locks. Keeps tex and pdf files.
REM   watch       Watches file changes and rebuilds automatically.
REM   submit      Final submission build with all revision marks OFF (plain text).
REM               Also copies the result to KNUE_thesis_main_submit.pdf.
REM   review      Review build with revision marks ON (per-examiner colors).
REM               Copies the result to KNUE_thesis_main_review_colors.pdf.
REM   review-blue Review build with all revision marks unified to blue.
REM               Copies the result to KNUE_thesis_main_review_blue.pdf.
REM   color       Color build (use *_color figures, keep colors). Copies to
REM               KNUE_thesis_main_color.pdf.
REM   bw          B&W build (use *_bw figures, grayscale everything). Copies to
REM               KNUE_thesis_main_bw.pdf.
REM   versions    Builds the color and bw variants one after another, each in its
REM               own isolated build folder (sequential on Windows; the Git Bash
REM               script ./KNUE_thesis_main_build.sh versions runs them in parallel).
REM   crops       Builds crop_debug.pdf for checking image crop settings.
REM
REM   submit/review/review-blue drive the revision-mark macros in sub/0-preamble.tex
REM   through the THESIS_SHOW_REVISIONS and THESIS_REV_ALLBLUE environment variables.
REM   color/bw drive the figure-variant macro through THESIS_FIGMODE.
REM   For a git-based track-changes PDF that shows what changed since a review-copy
REM   submission (added=blue, deleted=red strikeout) without manual \revised
REM   wrapping, use make-diff.cmd instead.
REM ===========================================================================
setlocal enabledelayedexpansion
REM Move to this script's folder so relative paths work from any launch location.
cd /d "%~dp0"

REM Set the main target files and read the first command argument.
set "main=KNUE_thesis_main"
set "maintex=%main%.tex"
set "command=%~1"
set "LOCKDIR=%main%.build_lock"

REM SyncTeX enables source/PDF synchronization. Only watch mode turns it on.
set "SYNCTEX=0"
set "LATEXMK_SYNCTEX=0"

REM Temporary build folder for all compile artifacts; only the final PDF is
REM copied back to the project root. Keep this OUTSIDE any cloud-synced folder.
REM Defaults to a per-user local cache folder; override by setting BUILDDIR
REM before running this script.
if not defined BUILDDIR (
  if defined LOCALAPPDATA (set "BUILDDIR=%LOCALAPPDATA%\latexbuild\%main%") else (set "BUILDDIR=%TEMP%\latexbuild\%main%")
)

REM Find TeX Live automatically. Some computers install it under C:\texlive,
REM while others install it under D:\texlive. Prefer the newest year found.
set "TEXLIVE_BIN="
for /l %%y in (2035,-1,2020) do (
  for %%d in (D C) do (
    if not defined TEXLIVE_BIN if exist "%%d:\texlive\%%y\bin\windows\lualatex.exe" set "TEXLIVE_BIN=%%d:\texlive\%%y\bin\windows"
  )
)
if defined TEXLIVE_BIN (
  set "PATH=%TEXLIVE_BIN%;%PATH%"
  echo Using TeX Live: %TEXLIVE_BIN%
)

REM Normalize aliases to one command name. With no argument, build is the default.
if "%command%"=="" set "command=build"
if /i "%command%"=="--clean" set "command=clean"
if /i "%command%"=="/clean" set "command=clean"
if /i "%command%"=="-c" set "command=clean"
if /i "%command%"=="--build" set "command=build"
if /i "%command%"=="/build" set "command=build"
if /i "%command%"=="-b" set "command=build"
if /i "%command%"=="--quick" set "command=quick"
if /i "%command%"=="/quick" set "command=quick"
if /i "%command%"=="-q" set "command=quick"
if /i "%command%"=="--watch" set "command=watch"
if /i "%command%"=="/watch" set "command=watch"
if /i "%command%"=="-w" set "command=watch"
if /i "%command%"=="--crops" set "command=crops"
if /i "%command%"=="/crops" set "command=crops"
if /i "%command%"=="crops" set "command=crops"
if /i "%command%"=="submit" set "command=submit"
if /i "%command%"=="--submit" set "command=submit"
if /i "%command%"=="-s" set "command=submit"
if /i "%command%"=="final" set "command=submit"
if /i "%command%"=="--final" set "command=submit"
if /i "%command%"=="review" set "command=review"
if /i "%command%"=="--review" set "command=review"
if /i "%command%"=="review-blue" set "command=reviewblue"
if /i "%command%"=="--review-blue" set "command=reviewblue"
if /i "%command%"=="reviewblue" set "command=reviewblue"
if /i "%command%"=="--versions" set "command=versions"
if /i "%command%"=="both" set "command=versions"

REM Clean mode should work even when TeX tools are unavailable, so jump directly to cleanup.
if /i "%command%"=="clean" goto clean_build

REM If the main TeX file is missing, the script is probably running in the wrong folder.
if not exist "%maintex%" (
  echo Error: %maintex% not found in current directory
  exit /b 1
)

REM Check that required external tools are available on PATH.
for %%c in (lualatex biber latexmk) do (
  where %%c >nul 2>&1
  if errorlevel 1 (
    echo Error: %%c is not installed or not on PATH
    exit /b 1
  )
)

REM Avoid concurrent runs writing the same aux/nav files.
call :acquire_lock
if errorlevel 1 exit /b 1

REM Note: other LaTeX jobs may be running in parallel.
REM We only guard against concurrent builds of this thesis via %LOCKDIR%.
tasklist /FI "IMAGENAME eq lualatex.exe" | find /I "lualatex.exe" >nul 2>&1
if not errorlevel 1 (
  echo [WARNING] Another lualatex.exe process is running. Continuing; builds are isolated by folder.
)

REM Dispatch to the selected command and preserve its exit code.
set "exitcode=0"
if /i "%command%"=="build" (
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
if /i "%command%"=="submit" (
  REM Final submission: turn all revision marks OFF.
  set "THESIS_SHOW_REVISIONS="
  set "THESIS_REV_ALLBLUE="
  call :profiled_build submit
  set "exitcode=!errorlevel!"
  goto end
)
if /i "%command%"=="review" (
  REM Review copy: revision marks ON with per-examiner colors.
  set "THESIS_SHOW_REVISIONS=1"
  set "THESIS_REV_ALLBLUE="
  call :profiled_build review_colors
  set "exitcode=!errorlevel!"
  goto end
)
if /i "%command%"=="reviewblue" (
  REM Review copy: revision marks ON, all unified to blue.
  set "THESIS_SHOW_REVISIONS=1"
  set "THESIS_REV_ALLBLUE=1"
  call :profiled_build review_blue
  set "exitcode=!errorlevel!"
  goto end
)
if /i "%command%"=="color" (
  REM Color build: use *_color figure variants, keep colors (no grayscale).
  set "THESIS_SHOW_REVISIONS="
  set "THESIS_REV_ALLBLUE="
  set "THESIS_FIGMODE=color"
  call :profiled_build color
  set "exitcode=!errorlevel!"
  goto end
)
if /i "%command%"=="bw" (
  REM B&W build: use *_bw figure variants, convert everything to grayscale.
  set "THESIS_SHOW_REVISIONS="
  set "THESIS_REV_ALLBLUE="
  set "THESIS_FIGMODE=bw"
  call :profiled_build bw
  set "exitcode=!errorlevel!"
  goto end
)
if /i "%command%"=="versions" (
  call :versions_build
  set "exitcode=!errorlevel!"
  goto end
)

call :release_lock
goto usage

:end
REM Release the lock after the command and return the original exit code.
call :release_lock
exit /b %exitcode%

:acquire_lock
REM Use an atomic mkdir as a simple cross-process mutex.
mkdir "%LOCKDIR%" 2>nul
if errorlevel 1 (
  echo Error: Another build/watch is already running.
  echo Lock: %LOCKDIR%
  echo If this is stale, run "%~nx0 clean" or delete the lock folder.
  exit /b 1
)
exit /b 0

:release_lock
REM Remove the lock folder after a normal or failed build.
if exist "%LOCKDIR%" rmdir "%LOCKDIR%" >nul 2>&1
exit /b 0

REM Reset the temporary build folder so each build starts from a clean state.
:preclean_runtime
if exist "%BUILDDIR%" rmdir /s /q "%BUILDDIR%" 2>nul
mkdir "%BUILDDIR%\sub" 2>nul
if exist "%main%.synctex(busy)" del /f /q "%main%.synctex(busy)" 2>nul
if exist "%main%.synctex.gz" del /f /q "%main%.synctex.gz" 2>nul
if exist "%main%.synctex" del /f /q "%main%.synctex" 2>nul
goto :eof

REM ---------------------------------------------------------------------------
REM Build verification. "A PDF file exists" is not "the build succeeded": when
REM LuaLaTeX dies mid-run, it leaves behind the pages it had already shipped out
REM as a truncated, unreadable PDF. Checks: (1) the log does not report a fatal
REM error / capacity error, (2) the log reports a page count, (3) the PDF exists.
REM %1 = folder to check. Sets VERIFY_OK (0/1), VERIFY_PAGES, VERIFY_REASON.
REM ---------------------------------------------------------------------------
:verify_build
set "VERIFY_OK=0"
set "VERIFY_PAGES=0"
set "VERIFY_REASON="
set "_vdir=%~1"
if not exist "%_vdir%\%main%.pdf" (
  set "VERIFY_REASON=PDF was not created"
  goto :eof
)
if not exist "%_vdir%\%main%.log" (
  set "VERIFY_REASON=%main%.log missing (compilation never started)"
  goto :eof
)
findstr /c:"Fatal error occurred" "%_vdir%\%main%.log" >nul 2>&1
if not errorlevel 1 (
  set "VERIFY_REASON=fatal error (see log)"
  goto :eof
)
findstr /c:"TeX capacity exceeded" "%_vdir%\%main%.log" >nul 2>&1
if not errorlevel 1 (
  set "VERIFY_REASON=TeX capacity exceeded"
  goto :eof
)
set "_pages="
for /f "tokens=2 delims=(" %%P in ('findstr /c:"Output written on" "%_vdir%\%main%.log" 2^>nul') do set "_pgtoken=%%P"
if defined _pgtoken (
  for /f "tokens=1" %%N in ("!_pgtoken!") do set "_pages=%%N"
)
if not defined _pages (
  set "VERIFY_REASON=page count not found in log (output may be truncated)"
  goto :eof
)
set "VERIFY_PAGES=%_pages%"
set "VERIFY_OK=1"
goto :eof

:clean_build
REM Full cleanup requested by the user. Source .tex files and the output PDF are preserved.
echo Cleaning build artifacts (preserving %maintex% and %main%.pdf)...
if defined BUILDDIR (
  if exist "%BUILDDIR%" rmdir /s /q "%BUILDDIR%" 2>nul
  if exist "%BUILDDIR%_color" rmdir /s /q "%BUILDDIR%_color" 2>nul
  if exist "%BUILDDIR%_bw" rmdir /s /q "%BUILDDIR%_bw" 2>nul
)
for %%f in (aux bbl bbl-SAVE-ERROR bcf bcf-SAVE-ERROR blg log nav out run.xml snm toc xdv fls fdb_latexmk synctex synctex.gz) do (
  if exist "%main%.%%f" del /f /q "%main%.%%f" 2>nul
)
if exist "%main%.synctex(busy)" del /f /q "%main%.synctex(busy)" 2>nul
REM Also delete subfile aux files (sub/*.aux). These can get corrupted and break builds.
if exist "sub" (
  del /f /q "sub\*.aux" 2>nul
  del /f /q "sub\*.bbl" 2>nul
  del /f /q "sub\*.bbl-SAVE-ERROR" 2>nul
  del /f /q "sub\*.bcf" 2>nul
  del /f /q "sub\*.bcf-SAVE-ERROR" 2>nul
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
  del /f /q "sub\*.synctex" 2>nul
  del /f /q "sub\*.synctex.gz" 2>nul
  del /f /q "sub\*.synctex(busy)" 2>nul
)
REM Crop debug artifacts
for %%f in (aux log out toc synctex.gz) do (
  if exist "crop_debug.%%f" del /f /q "crop_debug.%%f" 2>nul
)
REM NEVER delete .tex files
REM Remove a stale build/watch lock if present.
if exist "%LOCKDIR%" rmdir "%LOCKDIR%" >nul 2>&1
echo Clean complete. %maintex% preserved.
goto :eof

:crops_build
REM Generate a separate PDF for checking image trim/clip crop settings.
echo ========================================
echo Generating crop_debug.tex and building crop_debug.pdf...
echo ========================================
if not exist "scripts\generate_crop_debug.py" (
  echo Error: scripts\generate_crop_debug.py not found.
  exit /b 1
)
REM Find a Python executable for generating crop_debug.tex.
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

:full_build
REM Full build: compile in the cache folder (BUILDDIR), copy back only the
REM finished PDF. latexmk decides the required LuaLaTeX and biber passes.
echo ========================================
echo Building %maintex%...
echo   figures: %THESIS_FIGMODE%  (empty = template default)
echo   revision marks: %THESIS_SHOW_REVISIONS%  (empty = off)
echo ========================================
call :preclean_runtime

echo [1/2] Running LuaLaTeX to create fresh aux/bcf files...
lualatex -synctex=0 -interaction=nonstopmode -file-line-error -shell-escape -output-directory="%BUILDDIR%" "%maintex%" >nul 2>&1
call :verify_build "%BUILDDIR%"
if "%VERIFY_OK%"=="0" if not "%VERIFY_REASON%"=="PDF was not created" (
  echo Error: LuaLaTeX first pass aborted - %VERIFY_REASON%
  echo Check %BUILDDIR%\%main%.log for details.
  echo Tip: run "%~nx0 clean" then build again if generated files are corrupted.
  exit /b 1
)

echo [2/2] Running latexmk with LuaLaTeX and biber as needed...
set "LATEXMK_SYNCTEX=0"
latexmk "-auxdir=%BUILDDIR%" "-outdir=%BUILDDIR%" -pdflua -interaction=nonstopmode "%maintex%"
set "lrc=%errorlevel%"

call :verify_build "%BUILDDIR%"
if "%VERIFY_OK%"=="0" (
  echo Error: build failed - %VERIFY_REASON% ^(latexmk rc=%lrc%^)
  echo Check %BUILDDIR%\%main%.log for details.
  echo Tip: run "%~nx0 clean" then build again if generated files are corrupted.
  exit /b 1
)
if not "%lrc%"=="0" (
  echo [WARNING] latexmk exited with %lrc%, but the PDF is complete ^(%VERIFY_PAGES% pages^). Continuing.
)

copy /y "%BUILDDIR%\%main%.pdf" "%main%.pdf" >nul
if errorlevel 1 (
  echo Error: failed to update %main%.pdf. Close PDF viewers and try again.
  exit /b 1
)

for %%A in ("%main%.pdf") do set "pdf_size=%%~zA"
echo ========================================
echo Build successful
echo   Output: %main%.pdf ^(%VERIFY_PAGES% pages, !pdf_size! bytes^)
echo ========================================
exit /b 0

:profiled_build
REM Profiled build (submit/review/color/bw). Runs a full build with the env
REM variables already set by the caller, then copies the finished PDF to a
REM labeled name. %1 = suffix for the copied PDF.
call :full_build
if errorlevel 1 exit /b 1
if not "%~1"=="" if exist "%main%.pdf" (
  copy /y "%main%.pdf" "%main%_%~1.pdf" >nul 2>&1
  echo   copy: %main%_%~1.pdf
)
exit /b 0

:quick_build
REM Quick rebuild. Reuses auxiliary files already in the build folder for an
REM incremental latexmk build.
echo Quick rebuild with latexmk...
if not exist "%BUILDDIR%" mkdir "%BUILDDIR%\sub" 2>nul
set "LATEXMK_SYNCTEX=0"
latexmk "-auxdir=%BUILDDIR%" "-outdir=%BUILDDIR%" -pdflua -interaction=nonstopmode "%maintex%"
set "lrc=%errorlevel%"
call :verify_build "%BUILDDIR%"
if "%VERIFY_OK%"=="0" (
  echo Error: quick build failed - %VERIFY_REASON% ^(latexmk rc=%lrc%^)
  echo Check %BUILDDIR%\%main%.log for details.
  exit /b 1
)
copy /y "%BUILDDIR%\%main%.pdf" "%main%.pdf" >nul
if errorlevel 1 (
  echo Error: failed to update %main%.pdf. Close PDF viewers and try again.
  exit /b 1
)
echo Quick build complete: %main%.pdf ^(%VERIFY_PAGES% pages^)
goto :eof

:versions_build
REM Builds the color and bw variants one after another, each in its own
REM isolated build folder. (Sequential on Windows; use the Git Bash script
REM ./KNUE_thesis_main_build.sh versions for a parallel build.)
echo ========================================
echo Building 2 variants (sequential):
echo   1) %main%_color.pdf
echo   2) %main%_bw.pdf
echo ========================================

set "THESIS_SHOW_REVISIONS="
set "THESIS_REV_ALLBLUE="

set "THESIS_FIGMODE=color"
call :build_one color
set "rc_color=%errorlevel%"

set "THESIS_FIGMODE=bw"
call :build_one bw
set "rc_bw=%errorlevel%"

echo ========================================
echo Versions build summary:
if "%rc_color%"=="0" (echo   color  OK     -^> %main%_color.pdf) else (echo   color  FAILED. See %BUILDDIR%_color\%main%.log)
if "%rc_bw%"=="0"    (echo   bw     OK     -^> %main%_bw.pdf)    else (echo   bw     FAILED. See %BUILDDIR%_bw\%main%.log)
echo ========================================

if not "%rc_color%"=="0" exit /b 1
if not "%rc_bw%"=="0" exit /b 1
exit /b 0

:build_one
REM Build a single labelled variant in an isolated build folder + output PDF.
REM %1 = suffix (also used as the BUILDDIR_<suffix> folder name).
set "_suffix=%~1"
set "_vbuild=%BUILDDIR%_%_suffix%"
if exist "%_vbuild%" rmdir /s /q "%_vbuild%" 2>nul
mkdir "%_vbuild%\sub" 2>nul

lualatex -interaction=nonstopmode -file-line-error -shell-escape -output-directory="%_vbuild%" "%maintex%" >nul 2>&1
call :verify_build "%_vbuild%"
if "%VERIFY_OK%"=="0" if not "%VERIFY_REASON%"=="PDF was not created" (
  echo [%_suffix%] FAILED - first pass aborted - %VERIFY_REASON%
  exit /b 1
)

latexmk "-auxdir=%_vbuild%" "-outdir=%_vbuild%" -pdflua -interaction=nonstopmode "%maintex%" >nul 2>&1
call :verify_build "%_vbuild%"
if "%VERIFY_OK%"=="0" (
  echo [%_suffix%] FAILED - %VERIFY_REASON%
  exit /b 1
)

copy /y "%_vbuild%\%main%.pdf" "%main%_%_suffix%.pdf" >nul
if errorlevel 1 (
  echo [%_suffix%] FAILED - could not write %main%_%_suffix%.pdf (close any open PDF viewer)
  exit /b 1
)
echo [%_suffix%] OK -^> %main%_%_suffix%.pdf ^(%VERIFY_PAGES% pages^)
exit /b 0

:watch_mode
REM First performs one full build, then continuously watches for file changes.
REM Watch mode builds in place in the project folder (not the cache folder) so
REM the VS Code PDF viewer can follow along live.
echo ========================================
echo Initial build before starting watch mode...
echo ========================================
if exist "%main%.synctex(busy)" del /f /q "%main%.synctex(busy)" 2>nul
echo.
echo ========================================
echo Watch mode started (Ctrl+C to stop)...
echo Files will auto-rebuild on changes
echo PDF will auto-refresh in VS Code viewer
echo.
echo Watching for file changes...
echo ========================================
REM Use latexmk continuous watch mode with LuaLaTeX + biber
REM -pvc = continuous preview mode
REM -pv- = do not launch external previewer (use VS Code PDF viewer)
REM -synctex=1 = enable SyncTeX for VS Code integration
REM biber is configured via local latexmkrc
set "LATEXMK_SYNCTEX=1"
latexmk -lualatex -usebiber -pvc -pv- -f -shell-escape -interaction=nonstopmode -file-line-error -synctex=1 "%maintex%"
echo.
echo Watch mode ended.
exit /b 0
goto :eof

:usage
REM Show supported commands.
echo Usage: %~nx0 [build^|quick^|clean^|watch^|submit^|review^|review-blue^|color^|bw^|versions^|crops]
echo.
echo Commands:
echo   build       - Full build with bibliography (default)
echo   quick       - Quick rebuild (no biber, faster)
echo   clean       - Remove all build artifacts
echo   watch       - Watch mode (auto-rebuild on changes)
echo   submit      - Final submission build (revision marks OFF)
echo   review      - Review build (revision marks ON, per-examiner colors)
echo   review-blue - Review build (all revision marks unified to blue)
echo   color       - Color build (use *_color figures, keep colors)
echo   bw          - B^&W build (use *_bw figures, grayscale everything)
echo   versions    - Build color and bw variants (sequential)
echo   crops       - Build crop_debug.pdf for image cropping
exit /b 1
