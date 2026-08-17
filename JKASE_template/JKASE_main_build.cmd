@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"
set "main=JKASE_main"
set "maintex=%main%.tex"
set "command=%~1"
set "modearg=%~2"
set "LOCKDIR=%main%.build_lock"
set "SYNCTEX=1"
set "BUILDMODE=final"
set "OPENPDF=1"
set "SINGLEMODE=0"

if "%command%"=="" set "command=build"
if /i "%command%"=="--clean" set "command=clean"
if /i "%command%"=="/clean" set "command=clean"
if /i "%command%"=="-c" set "command=clean"
if /i "%command%"=="--build" set "command=build"
if /i "%command%"=="/build" set "command=build"
if /i "%command%"=="-b" set "command=build"
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

REM Mode aliases
if /i "%command%"=="submission" (
  set "command=build"
  set "BUILDMODE=submission"
  set "SINGLEMODE=1"
)
if /i "%command%"=="review" (
  set "command=build"
  set "BUILDMODE=review"
  set "SINGLEMODE=1"
)
if /i "%command%"=="final" (
  set "command=build"
  set "BUILDMODE=final"
  set "SINGLEMODE=1"
)
if /i "%command%"=="--submission" (
  set "BUILDMODE=submission"
  set "SINGLEMODE=1"
)
if /i "%command%"=="--review" (
  set "BUILDMODE=review"
  set "SINGLEMODE=1"
)
if /i "%command%"=="--final" (
  set "BUILDMODE=final"
  set "SINGLEMODE=1"
)
if /i "%modearg%"=="submission" (
  set "BUILDMODE=submission"
  set "SINGLEMODE=1"
)
if /i "%modearg%"=="review" (
  set "BUILDMODE=review"
  set "SINGLEMODE=1"
)
if /i "%modearg%"=="final" (
  set "BUILDMODE=final"
  set "SINGLEMODE=1"
)
if /i "%modearg%"=="--submission" (
  set "BUILDMODE=submission"
  set "SINGLEMODE=1"
)
if /i "%modearg%"=="--review" (
  set "BUILDMODE=review"
  set "SINGLEMODE=1"
)
if /i "%modearg%"=="--final" (
  set "BUILDMODE=final"
  set "SINGLEMODE=1"
)

set "OUTBASE=%main%_final"
if /i "%BUILDMODE%"=="submission" set "OUTBASE=%main%_submission"
if /i "%BUILDMODE%"=="review" set "OUTBASE=%main%_review"

REM Clean mode: skip all checks and go directly to cleanup
if /i "%command%"=="clean" goto clean_build

REM SyncTeX is useful for watch mode (editor integration), but can fail with
REM "synctex(busy)" when a PDF viewer locks the file. Disable it for normal builds.
if /i "%command%"=="watch" set "SYNCTEX=1"
if /i "%command%"=="crops" set "SYNCTEX=1"

if not exist "%maintex%" (
  echo Warning: %maintex% not found in current directory
  echo Creating minimal %maintex% from backup if available...
  REM Continue anyway to avoid deleting the file
)

REM Locate TeX Live even when its bin folder is not on PATH.
REM Typical Windows layout: C:\texlive\2026\bin\windows\lualatex.exe
call :setup_texlive_path

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

REM Note: other LaTeX jobs (e.g., thesis watch) may be running in parallel.
REM We only guard against concurrent builds of THIS proposal via %LOCKDIR%.
tasklist /FI "IMAGENAME eq lualatex.exe" | find /I "lualatex.exe" >nul 2>&1
if not errorlevel 1 (
  echo [WARNING] Another lualatex.exe process is running. Continuing; builds are isolated by folder.
)

set "exitcode=0"
if /i "%command%"=="build" (
  if "%SINGLEMODE%"=="1" (
    call :full_build
  ) else (
    call :build_all_modes
  )
  set "exitcode=!errorlevel!"
  goto end
)
if /i "%command%"=="all" (
  call :build_all_modes
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

call :release_lock
goto usage

:end
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
if exist "%LOCKDIR%" rmdir "%LOCKDIR%" >nul 2>&1
exit /b 0

:setup_texlive_path
set "TL_BINDIR="

REM Prefer an already configured PATH.
for /f "delims=" %%P in ('where lualatex 2^>nul') do (
  if not defined TL_BINDIR set "TL_BINDIR=%%~dpP"
)
if defined TL_BINDIR goto texlive_path_found

REM Search common TeX Live install locations across local drive letters.
for %%D in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
  if not defined TL_BINDIR (
    if exist "%%D:\texlive\" (
      for /d %%Y in ("%%D:\texlive\*") do (
        if not defined TL_BINDIR (
          if exist "%%~fY\bin\windows\lualatex.exe" (
            set "TL_BINDIR=%%~fY\bin\windows\"
          )
        )
      )
    )
  )
)

:texlive_path_found
if defined TL_BINDIR (
  set "PATH=%TL_BINDIR%;%PATH%"
  echo Using TeX Live binaries: %TL_BINDIR%
) else (
  echo Warning: TeX Live bin folder was not found automatically.
)
exit /b 0

:set_outbase
set "OUTBASE=%main%_final"
if /i "%BUILDMODE%"=="submission" set "OUTBASE=%main%_submission"
if /i "%BUILDMODE%"=="review" set "OUTBASE=%main%_review"
exit /b 0

:build_all_modes
set "OPENPDF_SAVED=%OPENPDF%"
set "OPENPDF=0"
set "BUILDMODE=submission"
call :set_outbase
call :full_build
if errorlevel 1 exit /b 1
set "BUILDMODE=review"
call :set_outbase
call :full_build
if errorlevel 1 exit /b 1
set "OPENPDF=%OPENPDF_SAVED%"
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

REM Lightweight pre-clean: remove only the auxiliary navigation/index files
REM that are known to get corrupted and trigger Beamer "Unbalanced output routine".
:preclean_runtime
for %%f in (aux nav snm toc out run.xml) do (
  if exist "%main%.%%f" del /f /q "%main%.%%f" 2>nul
)
REM SyncTeX can be left as "(busy)" if a viewer holds a lock.
if exist "%main%.synctex(busy)" del /f /q "%main%.synctex(busy)" 2>nul
if exist "%main%.synctex.gz" del /f /q "%main%.synctex.gz" 2>nul
REM Also delete subfile auxiliary files (sub/*.{aux,nav,snm,toc,out,run.xml}).
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
goto :eof
:clean_build
echo Cleaning build artifacts (PRESERVING SOURCE FILES: %maintex%, *.cls, *.sty)...
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
REM Also delete subfile aux files (sub/*.aux). These can get corrupted and break builds.
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
REM Crop debug artifacts
for %%f in (aux log out toc synctex.gz) do (
  if exist "crop_debug.%%f" del /f /q "crop_debug.%%f" 2>nul
)
REM ============================================================
REM CRITICAL: NEVER DELETE .tex, .cls, .sty SOURCE FILES
REM ============================================================
REM Remove a stale build/watch lock if present.
if exist "%LOCKDIR%" rmdir "%LOCKDIR%" >nul 2>&1
echo Clean complete. Source files (%maintex%, *.cls, *.sty) PRESERVED.
goto :eof

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
:full_build
echo ========================================
echo Building %maintex% [mode=%BUILDMODE%]...
echo ========================================
REM Pre-clean runtime artifacts (inlined to avoid batch label resolution warnings)
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
echo [1/4] Running LuaLaTeX (first pass)...
if /i "%BUILDMODE%"=="submission" (
  lualatex -jobname="%OUTBASE%" -synctex=%SYNCTEX% -interaction=nonstopmode -file-line-error -shell-escape "\def\ANONYMIZED{1}\input{%maintex%}"
) else if /i "%BUILDMODE%"=="review" (
  lualatex -jobname="%OUTBASE%" -synctex=%SYNCTEX% -interaction=nonstopmode -file-line-error -shell-escape "\def\ANONYMIZED{1}\def\REVIEWCOPY{1}\input{%maintex%}"
) else (
  lualatex -jobname="%OUTBASE%" -synctex=%SYNCTEX% -interaction=nonstopmode -file-line-error -shell-escape "\def\FINALMODE{1}\input{%maintex%}"
)
if errorlevel 1 (
  echo Error: LuaLaTeX first pass failed. Check %OUTBASE%.log for details.
  exit /b 1
)
if not exist "%OUTBASE%.pdf" (
  echo Error: LuaLaTeX first pass failed. Check %OUTBASE%.log for details.
  exit /b 1
)
if not exist "%OUTBASE%.bcf" (
  echo Warning: .bcf file not created. Bibliography might not be present.
  echo Skipping biber...
  goto skip_biber
)
echo [2/4] Running biber for bibliography...
biber "%OUTBASE%"
if errorlevel 1 (
  echo Error: biber failed. Check %OUTBASE%.blg for details.
  echo Attempting to continue...
)
:skip_biber
echo [3/4] Running LuaLaTeX (second pass)...
if /i "%BUILDMODE%"=="submission" (
  lualatex -jobname="%OUTBASE%" -synctex=%SYNCTEX% -interaction=nonstopmode -file-line-error -shell-escape "\def\ANONYMIZED{1}\input{%maintex%}"
) else if /i "%BUILDMODE%"=="review" (
  lualatex -jobname="%OUTBASE%" -synctex=%SYNCTEX% -interaction=nonstopmode -file-line-error -shell-escape "\def\ANONYMIZED{1}\def\REVIEWCOPY{1}\input{%maintex%}"
) else (
  lualatex -jobname="%OUTBASE%" -synctex=%SYNCTEX% -interaction=nonstopmode -file-line-error -shell-escape "\def\FINALMODE{1}\input{%maintex%}"
)
if errorlevel 1 (
  echo Error: LuaLaTeX second pass failed. Check %OUTBASE%.log for details.
  exit /b 1
)
if not exist "%OUTBASE%.pdf" (
  echo Error: LuaLaTeX second pass failed. Check %OUTBASE%.log for details.
  exit /b 1
)
echo [4/4] Running LuaLaTeX (third pass)...
if /i "%BUILDMODE%"=="submission" (
  lualatex -jobname="%OUTBASE%" -synctex=%SYNCTEX% -interaction=nonstopmode -file-line-error -shell-escape "\def\ANONYMIZED{1}\input{%maintex%}"
) else if /i "%BUILDMODE%"=="review" (
  lualatex -jobname="%OUTBASE%" -synctex=%SYNCTEX% -interaction=nonstopmode -file-line-error -shell-escape "\def\ANONYMIZED{1}\def\REVIEWCOPY{1}\input{%maintex%}"
) else (
  lualatex -jobname="%OUTBASE%" -synctex=%SYNCTEX% -interaction=nonstopmode -file-line-error -shell-escape "\def\FINALMODE{1}\input{%maintex%}"
)
if errorlevel 1 (
  echo Error: LuaLaTeX third pass failed. Check %OUTBASE%.log for details.
  exit /b 1
)
if not exist "%OUTBASE%.pdf" (
  echo Error: LuaLaTeX third pass failed. Check %OUTBASE%.log for details.
  exit /b 1
)
if exist "%OUTBASE%.pdf" (
  call :publish_main_pdf
  if errorlevel 1 exit /b 1
  for %%A in ("%OUTBASE%.pdf") do set "pdf_size=%%~zA"
  for %%A in ("%main%.pdf") do set "main_pdf_size=%%~zA"
  echo ========================================
  echo Build successful
  echo   Output: %OUTBASE%.pdf (!pdf_size! bytes)
  echo   Current mode copy: %main%.pdf (!main_pdf_size! bytes)
  echo ========================================
  if /i "%OPENPDF%"=="1" (
    echo Opening PDF in VS Code...
    timeout /t 1 /nobreak >nul 2>&1
    for %%P in ("%OUTBASE%.pdf") do set "PDFPATH=%%~fP"
    where code.cmd >nul 2>&1
    if errorlevel 1 (
      echo Warning: VS Code CLI not found. PDF was not opened to avoid launching the default external viewer.
    ) else (
      code.cmd --reuse-window "!PDFPATH!"
    )
  ) else (
    echo PDF auto-open skipped. Set OPENPDF=1 to open after build.
  )
  exit /b 0
) else (
  echo Error: PDF was not created.
  exit /b 1
)
goto :eof

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

:quick_build
echo Quick rebuild (skipping biber) [mode=%BUILDMODE%]...
REM Pre-clean runtime artifacts (inlined to avoid batch label resolution warnings)
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
if /i "%BUILDMODE%"=="submission" (
  lualatex -jobname="%OUTBASE%" -synctex=%SYNCTEX% -interaction=nonstopmode -file-line-error -shell-escape "\def\ANONYMIZED{1}\input{%maintex%}"
) else if /i "%BUILDMODE%"=="review" (
  lualatex -jobname="%OUTBASE%" -synctex=%SYNCTEX% -interaction=nonstopmode -file-line-error -shell-escape "\def\ANONYMIZED{1}\def\REVIEWCOPY{1}\input{%maintex%}"
) else (
  lualatex -jobname="%OUTBASE%" -synctex=%SYNCTEX% -interaction=nonstopmode -file-line-error -shell-escape "\def\FINALMODE{1}\input{%maintex%}"
)
call :publish_main_pdf
if errorlevel 1 exit /b 1
echo Quick build complete: %OUTBASE%.pdf
echo Current mode copy: %main%.pdf
goto :eof
:watch_mode
echo ========================================
echo Initial build before starting watch mode...
echo ========================================
if /i "%BUILDMODE%"=="submission" (
  echo Warning: watch mode does not support submission/review mode macro injection.
  echo Use full build: %~nx0 submission ^| %~nx0 review
  exit /b 1
)
if /i "%BUILDMODE%"=="review" (
  echo Warning: watch mode does not support submission/review mode macro injection.
  echo Use full build: %~nx0 submission ^| %~nx0 review
  exit /b 1
)
REM Pre-clean runtime artifacts (inlined to avoid batch label resolution warnings)
for %%f in (aux nav snm toc out run.xml) do (
  if exist "%main%.%%f" del /f /q "%main%.%%f" 2>nul
)
if exist "%main%.synctex(busy)" del /f /q "%main%.synctex(busy)" 2>nul
if exist "%main%.synctex.gz" del /f /q "%main%.synctex.gz" 2>nul
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
call :full_build
if errorlevel 1 (
  echo Initial build failed. Watch mode cancelled.
  exit /b 1
)
echo PDF auto-open skipped in watch mode.
echo.
echo ========================================
echo Watch mode started (Ctrl+C to stop)...
echo Files will auto-rebuild on changes
echo PDF will not be opened automatically
echo.
echo Watching for file changes...
echo ========================================
REM Use latexmk continuous watch mode with LuaLaTeX + biber
REM -pvc = continuous preview mode (watch and rebuild)
REM -view=none = do not launch external previewer (use VS Code PDF viewer)
REM -synctex=1 = enable synctex for VS Code integration
REM biber is configured via .latexmkrc (bibtex_use=2)
REM -f = force mode (continue after errors)
latexmk -lualatex -pvc -view=none -f -shell-escape -interaction=nonstopmode -file-line-error -synctex=1 "%maintex%"
echo.
echo Watch mode ended.
exit /b 0
goto :eof
:usage
echo Usage: %~nx0 [build^|all^|quick^|clean^|watch^|submission^|review^|final] [submission^|review^|final]
echo.
echo Commands:
echo   build       - Full build of submission, review, and final PDFs (default)
echo   all         - Full build of submission, review, and final PDFs
echo   quick       - Quick rebuild (no biber, faster)
echo   submission  - Full build in anonymized submission mode
echo   review      - Full build in anonymized review mode (review-color enabled)
echo   final       - Full build in final mode (author metadata included)
echo   clean       - Remove all build artifacts
echo   watch       - Watch mode (auto-rebuild on changes, final mode only)
exit /b 1
