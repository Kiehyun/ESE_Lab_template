#!/usr/bin/env bash
# ===================================================================
#  RISE_main_build.sh  —  Research in Science Education (Springer)
#  다중 산출물 빌드 스크립트 / multi-output submission build.
#
#    ./RISE_main_build.sh          네 개 산출물 모두 빌드 (기본 = all)
#    ./RISE_main_build.sh all      동일 (별칭)
#    ./RISE_main_build.sh en       ① RISE_main.pdf       영문 원고(저자 포함)  pdflatex+bibtex
#    ./RISE_main_build.sh anon     ② RISE_main_anon.pdf  익명 투고본(저자 제거) pdflatex+bibtex
#    ./RISE_main_build.sh title    ③ title-page.pdf      별도 표지(저자 신원)   pdflatex
#    ./RISE_main_build.sh kr       ④ RISE_main_kr.pdf     한글 번역본           lualatex+bibtex
#    ./RISE_main_build.sh clean    보조 파일(.aux/.bbl/.log 등) 삭제 (PDF 는 보존)
#
#  ▶ 이중 익명(double-blind) 투고: RISE_main_anon.pdf + title-page.pdf 를 함께 올립니다.
#  ▶ sn-jnl 은 natbib + 고전 BibTeX(sn-apacite.bst = APA). biber/biblatex 아님.
#  ▶ 한글본은 sn-jnl/pdflatex 로 렌더링 불가하므로 article+LuaLaTeX 로 독립 빌드합니다.
#  ▶ 순서: (lua)pdflatex -> bibtex -> (lua)pdflatex x2 (상호참조/인용 확정)
#  ▶ 사전 요구사항: pdflatex, lualatex, bibtex 가 PATH 에 있어야 합니다.
# ===================================================================
set -e
cd "$(dirname "$0")"

need() { command -v "$1" >/dev/null 2>&1 || { echo "[ERROR] $1 not found in PATH"; exit 1; }; }

# ① 영문 원고(저자 포함) -> RISE_main.pdf
build_en() {
  need pdflatex; need bibtex
  rm -f RISE_main.{aux,out,bbl,blg}
  echo "[EN 1/4] pdflatex"; pdflatex -synctex=1 -interaction=nonstopmode -halt-on-error RISE_main.tex
  echo "[EN 2/4] bibtex";   bibtex RISE_main || true
  echo "[EN 3/4] pdflatex"; pdflatex -synctex=1 -interaction=nonstopmode -halt-on-error RISE_main.tex
  echo "[EN 4/4] pdflatex"; pdflatex -synctex=1 -interaction=nonstopmode -halt-on-error RISE_main.tex
  echo "[OK] RISE_main.pdf"
}

# ② 익명 투고본 -> RISE_main_anon.pdf  (\def\ANON{} 로 \ifRISEanon 토글을 켠다)
build_anon() {
  need pdflatex; need bibtex
  rm -f RISE_main_anon.{aux,out,bbl,blg}
  echo "[ANON 1/4] pdflatex"; pdflatex -synctex=1 -interaction=nonstopmode -halt-on-error -jobname=RISE_main_anon '\def\ANON{}\input{RISE_main.tex}'
  echo "[ANON 2/4] bibtex";   bibtex RISE_main_anon || true
  echo "[ANON 3/4] pdflatex"; pdflatex -synctex=1 -interaction=nonstopmode -halt-on-error -jobname=RISE_main_anon '\def\ANON{}\input{RISE_main.tex}'
  echo "[ANON 4/4] pdflatex"; pdflatex -synctex=1 -interaction=nonstopmode -halt-on-error -jobname=RISE_main_anon '\def\ANON{}\input{RISE_main.tex}'
  echo "[OK] RISE_main_anon.pdf"
}

# ③ 별도 표지(저자 신원) -> title-page.pdf  (참고문헌 없음)
build_title() {
  need pdflatex
  rm -f title-page.{aux,out}
  echo "[TITLE 1/1] pdflatex"; pdflatex -interaction=nonstopmode -halt-on-error title-page.tex
  echo "[OK] title-page.pdf"
}

# ④ 한글 번역본 -> RISE_main_kr.pdf  (LuaLaTeX + BibTeX)
build_kr() {
  need lualatex; need bibtex
  rm -f RISE_main_kr.{aux,out,bbl,blg}
  echo "[KR 1/4] lualatex"; lualatex -synctex=1 -interaction=nonstopmode -halt-on-error RISE_main_kr.tex
  echo "[KR 2/4] bibtex";   bibtex RISE_main_kr || true
  echo "[KR 3/4] lualatex"; lualatex -synctex=1 -interaction=nonstopmode -halt-on-error RISE_main_kr.tex
  echo "[KR 4/4] lualatex"; lualatex -synctex=1 -interaction=nonstopmode -halt-on-error RISE_main_kr.tex
  echo "[OK] RISE_main_kr.pdf"
}

clean() {
  for J in RISE_main RISE_main_anon RISE_main_kr title-page; do
    rm -f "$J".{aux,bbl,blg,log,out,toc,lof,lot,fls,fdb_latexmk,synctex.gz,synctex}
  done
  echo "[clean] done. (PDF 는 보존)"
}

case "${1:-all}" in
  en)    build_en ;;
  anon)  build_anon ;;
  title) build_title ;;
  kr)    build_kr ;;
  all|"")
    build_en; build_anon; build_title; build_kr
    echo ""
    echo "======================================================"
    echo " 빌드 완료 / Build complete — 4 outputs:"
    echo "   ① RISE_main.pdf       (영문 원고, 저자 포함)"
    echo "   ② RISE_main_anon.pdf  (익명 투고본, 저자 제거)"
    echo "   ③ title-page.pdf      (별도 표지, 저자 신원)"
    echo "   ④ RISE_main_kr.pdf    (한글 번역본, LuaLaTeX)"
    echo " 이중 익명 투고: ② + ③ 을 함께 제출하세요."
    echo "======================================================"
    ;;
  clean) clean ;;
  *) echo "Usage: $0 [all|en|anon|title|kr|clean]"; exit 1 ;;
esac
