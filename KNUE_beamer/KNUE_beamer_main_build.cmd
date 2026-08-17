@echo off

REM 한국교원대학교 Beamer 발표 템플릿의 Windows 빌드 스크립트입니다.
REM Windows build script for the KNUE Beamer presentation template.

setlocal

REM 스크립트가 있는 KNUE_beamer 폴더로 이동합니다.
REM Move to the KNUE_beamer folder where this script is located.
cd /d "%~dp0"

REM 빌드할 메인 파일입니다.
REM Main file to build.
set "main=KNUE_beamer_main.tex"

REM 첫 번째 인자를 명령으로 사용합니다. 없으면 build를 기본값으로 둡니다.
REM Use the first argument as the command. Default is build.
set "command=%~1"
if "%command%"=="" set "command=build"

if /i "%command%"=="build" (
  REM 전체 빌드입니다. latexmk가 LuaLaTeX와 biber를 필요에 따라 실행합니다.
  REM Full build. latexmk runs LuaLaTeX and biber as needed.
  latexmk -pdf -lualatex -interaction=nonstopmode -file-line-error "%main%"
  exit /b %errorlevel%
)

if /i "%command%"=="quick" (
  REM 빠른 재빌드입니다. 작은 수정 확인용으로 사용합니다.
  REM Quick rebuild for checking small edits.
  latexmk -pdf -lualatex -interaction=nonstopmode -file-line-error -use-make "%main%"
  exit /b %errorlevel%
)

if /i "%command%"=="watch" (
  REM 파일 변경을 감시하며 자동으로 다시 빌드합니다.
  REM Watch files and rebuild automatically.
  latexmk -pdf -lualatex -pvc -pv- -interaction=nonstopmode -file-line-error "%main%"
  exit /b %errorlevel%
)

if /i "%command%"=="clean" (
  REM 빌드 산출물을 정리합니다.
  REM Clean generated build artifacts.
  latexmk -C "%main%"
  exit /b %errorlevel%
)

REM 잘못된 명령을 입력했을 때 사용법을 출력합니다.
REM Print usage when an unknown command is provided.
echo Usage: %~nx0 [build^|quick^|watch^|clean]
exit /b 1
