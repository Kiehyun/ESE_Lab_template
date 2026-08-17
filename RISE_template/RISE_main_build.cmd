@echo off
REM 콘솔을 UTF-8로 전환해 한글 출력이 깨지지 않게 합니다(cmd/PowerShell 공통).
REM Switch the console to UTF-8 so Korean output is not garbled.
chcp 65001 >nul 2>&1
REM ===================================================================
REM  RISE_main_build.cmd  —  Research in Science Education (Springer)
REM  다중 산출물 빌드 스크립트 / multi-output submission build.
REM
REM    RISE_main_build.cmd          네 개 산출물 모두 빌드 (기본 = all)
REM    RISE_main_build.cmd all      동일 (별칭)
REM    RISE_main_build.cmd en       (1) RISE_main.pdf       영문 원고(저자 포함)  pdflatex+bibtex
REM    RISE_main_build.cmd anon     (2) RISE_main_anon.pdf  익명 투고본(저자 제거) pdflatex+bibtex
REM    RISE_main_build.cmd title    (3) title-page.pdf      별도 표지(저자 신원)   pdflatex
REM    RISE_main_build.cmd kr       (4) RISE_main_kr.pdf     한글 번역본           lualatex+bibtex
REM    RISE_main_build.cmd clean    보조 파일(.aux/.bbl/.log 등) 삭제 (PDF 는 보존)
REM
REM  * 이중 익명(double-blind) 투고: RISE_main_anon.pdf + title-page.pdf 를 함께 올립니다.
REM  * sn-jnl 은 natbib + 고전 BibTeX(sn-apacite.bst = APA). biber/biblatex 아님.
REM  * 한글본은 sn-jnl/pdflatex 로 렌더링 불가하므로 article+LuaLaTeX 로 독립 빌드합니다.
REM  * 순서: (lua)pdflatex -> bibtex -> (lua)pdflatex x2 (상호참조/인용 확정)
REM  * 사전 요구사항: pdflatex, lualatex, bibtex 가 PATH 에 있어야 합니다.
REM ===================================================================
setlocal
cd /d "%~dp0"

set "CMD=%~1"
if "%CMD%"=="" set "CMD=all"

if /i "%CMD%"=="all"   goto :all
if /i "%CMD%"=="en"    goto :en
if /i "%CMD%"=="anon"  goto :anon
if /i "%CMD%"=="title" goto :title
if /i "%CMD%"=="kr"    goto :kr
if /i "%CMD%"=="clean" goto :clean
echo Usage: %~nx0 [all^|en^|anon^|title^|kr^|clean]
exit /b 1

:all
call :en    || exit /b 1
call :anon  || exit /b 1
call :title || exit /b 1
call :kr    || exit /b 1
echo.
echo ======================================================
echo  빌드 완료 / Build complete — 4 outputs:
echo    (1) RISE_main.pdf       (영문 원고, 저자 포함)
echo    (2) RISE_main_anon.pdf  (익명 투고본, 저자 제거)
echo    (3) title-page.pdf      (별도 표지, 저자 신원)
echo    (4) RISE_main_kr.pdf    (한글 번역본, LuaLaTeX)
echo  이중 익명 투고: (2) + (3) 을 함께 제출하세요.
echo ======================================================
exit /b 0

REM ---------- (1) 영문 원고(저자 포함) ----------
:en
where pdflatex >nul 2>&1 || (echo [ERROR] pdflatex not found in PATH & exit /b 1)
where bibtex   >nul 2>&1 || (echo [ERROR] bibtex not found in PATH & exit /b 1)
del /q "RISE_main.aux" "RISE_main.out" "RISE_main.bbl" "RISE_main.blg" >nul 2>&1
echo [EN 1/4] pdflatex
pdflatex -synctex=1 -interaction=nonstopmode -halt-on-error "RISE_main.tex" || exit /b 1
echo [EN 2/4] bibtex
bibtex "RISE_main"
echo [EN 3/4] pdflatex
pdflatex -synctex=1 -interaction=nonstopmode -halt-on-error "RISE_main.tex" || exit /b 1
echo [EN 4/4] pdflatex
pdflatex -synctex=1 -interaction=nonstopmode -halt-on-error "RISE_main.tex" || exit /b 1
echo [OK] RISE_main.pdf
exit /b 0

REM ---------- (2) 익명 투고본 (\def\ANON{} 로 토글 ON) ----------
:anon
where pdflatex >nul 2>&1 || (echo [ERROR] pdflatex not found in PATH & exit /b 1)
where bibtex   >nul 2>&1 || (echo [ERROR] bibtex not found in PATH & exit /b 1)
del /q "RISE_main_anon.aux" "RISE_main_anon.out" "RISE_main_anon.bbl" "RISE_main_anon.blg" >nul 2>&1
echo [ANON 1/4] pdflatex
pdflatex -synctex=1 -interaction=nonstopmode -halt-on-error -jobname=RISE_main_anon "\def\ANON{}\input{RISE_main.tex}" || exit /b 1
echo [ANON 2/4] bibtex
bibtex "RISE_main_anon"
echo [ANON 3/4] pdflatex
pdflatex -synctex=1 -interaction=nonstopmode -halt-on-error -jobname=RISE_main_anon "\def\ANON{}\input{RISE_main.tex}" || exit /b 1
echo [ANON 4/4] pdflatex
pdflatex -synctex=1 -interaction=nonstopmode -halt-on-error -jobname=RISE_main_anon "\def\ANON{}\input{RISE_main.tex}" || exit /b 1
echo [OK] RISE_main_anon.pdf
exit /b 0

REM ---------- (3) 별도 표지(저자 신원) ----------
:title
where pdflatex >nul 2>&1 || (echo [ERROR] pdflatex not found in PATH & exit /b 1)
del /q "title-page.aux" "title-page.out" >nul 2>&1
echo [TITLE 1/1] pdflatex
pdflatex -interaction=nonstopmode -halt-on-error "title-page.tex" || exit /b 1
echo [OK] title-page.pdf
exit /b 0

REM ---------- (4) 한글 번역본 (LuaLaTeX + BibTeX) ----------
:kr
where lualatex >nul 2>&1 || (echo [ERROR] lualatex not found in PATH & exit /b 1)
where bibtex   >nul 2>&1 || (echo [ERROR] bibtex not found in PATH & exit /b 1)
del /q "RISE_main_kr.aux" "RISE_main_kr.out" "RISE_main_kr.bbl" "RISE_main_kr.blg" >nul 2>&1
echo [KR 1/4] lualatex
lualatex -synctex=1 -interaction=nonstopmode -halt-on-error "RISE_main_kr.tex" || exit /b 1
echo [KR 2/4] bibtex
bibtex "RISE_main_kr"
echo [KR 3/4] lualatex
lualatex -synctex=1 -interaction=nonstopmode -halt-on-error "RISE_main_kr.tex" || exit /b 1
echo [KR 4/4] lualatex
lualatex -synctex=1 -interaction=nonstopmode -halt-on-error "RISE_main_kr.tex" || exit /b 1
echo [OK] RISE_main_kr.pdf
exit /b 0

:clean
for %%J in (RISE_main RISE_main_anon RISE_main_kr title-page) do (
  for %%E in (aux bbl blg log out toc lof lot fls fdb_latexmk synctex.gz synctex) do del /q "%%J.%%E" >nul 2>&1
)
echo [clean] done. (PDF 는 보존)
exit /b 0
