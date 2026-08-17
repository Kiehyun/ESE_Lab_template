#!/usr/bin/env bash

set -e
cd "$(dirname "$0")"

MAIN="TPT_main"
MAINTEX="${MAIN}.tex"
COMMAND="${1:-build}"
LOCKDIR="${MAIN}.build_lock"

case "$COMMAND" in
    --build|-b) COMMAND="build" ;;
    --quick|-q) COMMAND="quick" ;;
    --clean|-c) COMMAND="clean" ;;
esac

if [[ "$COMMAND" == "clean" ]]; then
    echo "Cleaning submission build artifacts, preserving PDFs and source files..."
    rm -f "${MAIN}".{aux,bbl,bcf,blg,log,nav,out,run.xml,snm,toc,xdv,fls,fdb_latexmk,synctex.gz,synctex\(busy\)} 2>/dev/null || true
    rm -f sub/*.{aux,bbl,bcf,blg,log,nav,out,run.xml,snm,toc,xdv,fls,fdb_latexmk,synctex.gz,synctex\(busy\)} 2>/dev/null || true
    rm -rf "$LOCKDIR" 2>/dev/null || true
    echo "Clean complete. $MAINTEX preserved."
    exit 0
fi

if [[ ! -f "$MAINTEX" ]]; then
    echo "Error: $MAINTEX not found in current directory"
    exit 1
fi

for cmd in lualatex biber; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: $cmd is not installed or not on PATH"
        exit 1
    fi
done

mkdir "$LOCKDIR" 2>/dev/null || {
    echo "Error: Another build is already running."
    echo "Lock: $LOCKDIR"
    echo "If this is stale, run '$0 clean' or delete the lock folder."
    exit 1
}
trap 'rm -rf "$LOCKDIR" 2>/dev/null || true' EXIT

preclean_runtime() {
    rm -f "${MAIN}".{aux,nav,snm,toc,out,run.xml,synctex.gz,synctex\(busy\)} 2>/dev/null || true
    rm -f sub/*.{aux,nav,snm,toc,out,run.xml,synctex.gz,synctex\(busy\)} 2>/dev/null || true
}

run_lualatex() {
    lualatex -synctex=0 -interaction=nonstopmode -file-line-error -shell-escape "$MAINTEX"
}

full_build() {
    echo "========================================"
    echo "Building anonymous manuscript PDF..."
    echo "========================================"
    preclean_runtime
    echo "[1/4] Running LuaLaTeX..."
    run_lualatex
    if [[ -f "${MAIN}.bcf" ]]; then
        echo "[2/4] Running biber..."
        biber "$MAIN"
    else
        echo "[2/4] No .bcf file found; skipping biber."
    fi
    echo "[3/4] Running LuaLaTeX..."
    run_lualatex
    echo "[4/4] Running LuaLaTeX..."
    run_lualatex
    echo "Build successful: ${MAIN}.pdf"
}

quick_build() {
    echo "Quick anonymous manuscript rebuild..."
    preclean_runtime
    run_lualatex
    echo "Quick build complete: ${MAIN}.pdf"
}

case "$COMMAND" in
    build)
        full_build
        ;;
    quick)
        quick_build
        ;;
    *)
        echo "Usage: $0 [build|quick|clean]"
        echo "  build  - Build anonymous manuscript PDF: ${MAIN}.pdf"
        echo "  quick  - One-pass anonymous submission rebuild"
        echo "  clean  - Remove submission build artifacts, preserving PDFs and source files"
        exit 1
        ;;
esac
