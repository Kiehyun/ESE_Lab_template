@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

set "main=TPT_main"
set "maintex=%main%.tex"
set "command=%~1"
set "LOCKDIR=%main%.build_lock"

if "%command%"=="" set "command=build"
if /i "%command%"=="--build" set "command=build"
if /i "%command%"=="/build" set "command=build"
if /i "%command%"=="-b" set "command=build"
if /i "%command%"=="--quick" set "command=quick"
if /i "%command%"=="/quick" set "command=quick"
if /i "%command%"=="-q" set "command=quick"
if /i "%command%"=="--clean" set "command=clean"
if /i "%command%"=="/clean" set "command=clean"
if /i "%command%"=="-c" set "command=clean"

if /i "%command%"=="clean" goto clean_build

if not exist "%maintex%" (
  echo Error: %maintex% not found in current directory
  exit /b 1
)
for %%c in (lualatex biber) do (
  where %%c >nul 2>&1
  if errorlevel 1 (
    echo Error: %%c is not installed or not on PATH
    exit /b 1
  )
)

call :acquire_lock
if errorlevel 1 exit /b 1

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

call :release_lock
goto usage

:end
call :release_lock
exit /b %exitcode%

:acquire_lock
mkdir "%LOCKDIR%" 2>nul
if errorlevel 1 (
  echo Error: Another build is already running.
  echo Lock: %LOCKDIR%
  echo If this is stale, run "%~nx0 clean" or delete the lock folder.
  exit /b 1
)
exit /b 0

:release_lock
if exist "%LOCKDIR%" rmdir "%LOCKDIR%" >nul 2>&1
exit /b 0

:preclean_runtime
for %%f in (aux nav snm toc out run.xml synctex.gz) do (
  if exist "%main%.%%f" del /f /q "%main%.%%f" 2>nul
)
if exist "%main%.synctex(busy)" del /f /q "%main%.synctex(busy)" 2>nul
if exist "sub" (
  del /f /q "sub\*.aux" 2>nul
  del /f /q "sub\*.nav" 2>nul
  del /f /q "sub\*.snm" 2>nul
  del /f /q "sub\*.toc" 2>nul
  del /f /q "sub\*.out" 2>nul
  del /f /q "sub\*.run.xml" 2>nul
)
exit /b 0

:clean_build
echo Cleaning submission build artifacts, preserving PDFs and source files...
for %%f in (aux bbl bcf blg log nav out run.xml snm toc xdv fls fdb_latexmk synctex.gz) do (
  if exist "%main%.%%f" del /f /q "%main%.%%f" 2>nul
)
if exist "%main%.synctex(busy)" del /f /q "%main%.synctex(busy)" 2>nul
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
)
if exist "%LOCKDIR%" rmdir "%LOCKDIR%" >nul 2>&1
echo Clean complete. %maintex% preserved.
exit /b 0

:run_lualatex
lualatex -synctex=0 -interaction=nonstopmode -file-line-error -shell-escape "%maintex%"
exit /b %errorlevel%

:full_build
echo ========================================
echo Building anonymous manuscript PDF...
echo ========================================
call :preclean_runtime
echo [1/4] Running LuaLaTeX...
call :run_lualatex
if errorlevel 1 exit /b 1
if exist "%main%.bcf" (
  echo [2/4] Running biber...
  biber "%main%"
  if errorlevel 1 exit /b 1
) else (
  echo [2/4] No .bcf file found; skipping biber.
)
echo [3/4] Running LuaLaTeX...
call :run_lualatex
if errorlevel 1 exit /b 1
echo [4/4] Running LuaLaTeX...
call :run_lualatex
if errorlevel 1 exit /b 1
echo Build successful: %main%.pdf
exit /b 0

:quick_build
echo Quick anonymous manuscript rebuild...
call :preclean_runtime
call :run_lualatex
if errorlevel 1 exit /b 1
echo Quick build complete: %main%.pdf
exit /b 0

:usage
echo Usage: %~nx0 [build^|quick^|clean]
echo.
echo Commands:
echo   build  - Build anonymous manuscript PDF: %main%.pdf
echo   quick  - One-pass anonymous submission rebuild
echo   clean  - Remove submission build artifacts, preserving PDFs and source files
exit /b 1
