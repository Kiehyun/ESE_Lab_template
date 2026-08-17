#!/usr/bin/env bash
# ===========================================================================
# JKESS_main Build Script - Full Build Version with Watch Mode
# Compatible with Windows (Git Bash/MSYS2), macOS, and Linux
# ===========================================================================

set -e
cd "$(dirname "$0")"

# Detect OS for potential platform-specific operations
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    OS="windows"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
else
    OS="linux"
fi

MAIN="JKESS_main"
MAINTEX="${MAIN}.tex"
COMMAND="${1:-build}"
MODEARG="${2:-}"
BUILDMODE="final"
OUTBASE="${MAIN}_final"
SYNCTEX="1"
LOCKDIR="${MAIN}.build_lock"

# Normalize command arguments
case "$COMMAND" in
    --clean|-c) COMMAND="clean" ;;
    --build|-b) COMMAND="build" ;;
    --quick|-q) COMMAND="quick" ;;
    --watch|-w) COMMAND="watch" ;;
    --submission) COMMAND="submission" ;;
    --review) COMMAND="review" ;;
    --final) COMMAND="final" ;;
    crops) COMMAND="crops" ;;
esac

case "$COMMAND" in
    submission|review|final)
        BUILDMODE="$COMMAND"
        ;;
esac

case "$MODEARG" in
    submission|review|final)
        BUILDMODE="$MODEARG"
        ;;
    --submission)
        BUILDMODE="submission"
        ;;
    --review)
        BUILDMODE="review"
        ;;
    --final)
        BUILDMODE="final"
        ;;
esac

set_outbase() {
    case "$BUILDMODE" in
        submission) OUTBASE="${MAIN}_submission" ;;
        review) OUTBASE="${MAIN}_review" ;;
        final|*) OUTBASE="${MAIN}_final" ;;
    esac
}

# Check if main tex file exists
if [[ ! -f "$MAINTEX" ]]; then
    echo "Error: $MAINTEX not found in current directory"
    exit 1
fi

# Check required tools
for cmd in lualatex biber; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: $cmd is not installed or not on PATH"
        exit 1
    fi
done

# Acquire lock
acquire_lock() {
    mkdir -p "$LOCKDIR" 2>/dev/null || {
        echo "Error: Another build/watch is already running."
        echo "Lock: $LOCKDIR"
        echo "If this is stale, run '$0 clean' or delete the lock folder."
        return 1
    }
    return 0
}

# Release lock
release_lock() {
    rm -rf "$LOCKDIR" 2>/dev/null || true
}

# Lightweight pre-clean: remove only the auxiliary navigation/index files
preclean_runtime() {
    echo "[Preclean] Removing runtime artifacts..."
    rm -f "${OUTBASE}".{aux,nav,snm,toc,out,run.xml} 2>/dev/null || true
    rm -f "${OUTBASE}".synctex.gz "${OUTBASE}".synctex\(busy\) 2>/dev/null || true
    
    # Also delete subfile auxiliary files
    if [[ -d "sub" ]]; then
        rm -f sub/*.{aux,nav,snm,toc,out,run.xml} 2>/dev/null || true
        rm -f sub/*.synctex.gz sub/*.synctex\(busy\) 2>/dev/null || true
    fi
}

# Remove SyncTeX artifacts that can remain locked by PDF viewers on macOS
clean_synctex() {
    rm -f "${OUTBASE}".synctex.gz "${OUTBASE}".synctex\(busy\) 2>/dev/null || true
}

# Full clean build
clean_build() {
    echo "Cleaning build artifacts (preserving $MAINTEX and PDFs)..."
    
    rm -f "${MAIN}".{aux,bbl,bcf,blg,log,nav,out,run.xml,snm,toc,xdv,fls,fdb_latexmk,synctex.gz,synctex\(busy\)} 2>/dev/null || true
    rm -f "${MAIN}_submission".{aux,bbl,bcf,blg,log,nav,out,run.xml,snm,toc,xdv,fls,fdb_latexmk,synctex.gz,synctex\(busy\)} 2>/dev/null || true
    rm -f "${MAIN}_review".{aux,bbl,bcf,blg,log,nav,out,run.xml,snm,toc,xdv,fls,fdb_latexmk,synctex.gz,synctex\(busy\)} 2>/dev/null || true
    rm -f "${MAIN}_final".{aux,bbl,bcf,blg,log,nav,out,run.xml,snm,toc,xdv,fls,fdb_latexmk,synctex.gz,synctex\(busy\)} 2>/dev/null || true
    
    # Also delete subfile aux files
    if [[ -d "sub" ]]; then
        rm -f sub/*.{aux,bbl,bcf,blg,log,nav,out,run.xml,snm,toc,xdv,fls,fdb_latexmk,synctex.gz,synctex\(busy\)} 2>/dev/null || true
    fi
    
    # Crop debug artifacts
    rm -f crop_debug.{aux,log,out,toc,synctex.gz} 2>/dev/null || true
    
    # Remove stale lock
    release_lock
    
    echo "Clean complete. $MAINTEX preserved."
}

run_lualatex_mode() {
    lualatex -jobname="$OUTBASE" -synctex=$SYNCTEX -interaction=nonstopmode -file-line-error -shell-escape "\\def\\DocMode{$BUILDMODE}\\input{$MAINTEX}"
}

publish_main_pdf() {
    if [[ ! -f "${OUTBASE}.pdf" ]]; then
        echo "Error: ${OUTBASE}.pdf was not found; cannot update ${MAIN}.pdf."
        return 1
    fi
    cp -f "${OUTBASE}.pdf" "${MAIN}.pdf" || {
        echo "Error: failed to update ${MAIN}.pdf from ${OUTBASE}.pdf."
        return 1
    }
}

file_size() {
    local file="$1"
    if command -v stat &> /dev/null; then
        if [[ "$OS" == "macos" ]]; then
            stat -f%z "$file" 2>/dev/null || echo "unknown"
        else
            stat -c%s "$file" 2>/dev/null || echo "unknown"
        fi
    else
        wc -c < "$file" 2>/dev/null || echo "unknown"
    fi
}

build_all_modes() {
    BUILDMODE="submission"
    set_outbase
    full_build || return 1
    BUILDMODE="review"
    set_outbase
    full_build || return 1
    BUILDMODE="final"
    set_outbase
    full_build || return 1
    echo "========================================"
    echo "All paper modes built successfully:"
    echo "  ${MAIN}_submission.pdf"
    echo "  ${MAIN}_review.pdf"
    echo "  ${MAIN}_final.pdf"
    echo "========================================"
}

# Crops build
crops_build() {
    echo "========================================"
    echo "Generating crop_debug.tex and building crop_debug.pdf..."
    echo "========================================"
    
    if [[ ! -f "scripts/generate_crop_debug.py" ]]; then
        echo "Error: scripts/generate_crop_debug.py not found."
        return 1
    fi
    
    # Find Python executable (cross-platform compatible)
    PYTHON=""
    if command -v python3 &> /dev/null; then
        PYTHON="python3"
    elif command -v python &> /dev/null; then
        PYTHON="python"
    elif command -v py &> /dev/null; then
        PYTHON="py -3"
    else
        echo "Error: Python not found on PATH."
        echo "  Windows: Install Python from python.org or Microsoft Store"
        echo "  macOS: Install via Homebrew: brew install python3"
        echo "  Linux: Install via package manager: apt install python3"
        return 1
    fi
    
    "$PYTHON" "scripts/generate_crop_debug.py" || {
        echo "Error: failed to generate crop_debug.tex"
        return 1
    }
    
    lualatex -synctex=$SYNCTEX -interaction=nonstopmode -file-line-error "crop_debug.tex" || {
        echo "Error: failed to build crop_debug.pdf"
        return 1
    }
    
    echo "Done: crop_debug.pdf"
    return 0
}

# Full build: 3 passes with biber
full_build() {
    set_outbase
    echo "========================================"
    echo "Building $MAINTEX [mode=$BUILDMODE]..."
    echo "========================================"
    
    preclean_runtime
    
    echo "[1/4] Running LuaLaTeX (first pass)..."
    clean_synctex
    run_lualatex_mode || {
        echo "Error: LuaLaTeX first pass reported an error. Check ${OUTBASE}.log for details."
        echo "Tip: run '$0 clean' then build again if this is an aux/nav corruption."
        return 1
    }
    
    if [[ ! -f "${OUTBASE}.pdf" ]]; then
        echo "Error: LuaLaTeX first pass failed. Check ${OUTBASE}.log for details."
        return 1
    fi
    
    if [[ ! -f "${OUTBASE}.bcf" ]]; then
        echo "Warning: .bcf file not created. Bibliography might not be present."
        echo "Skipping biber..."
    else
        echo "[2/4] Running biber for bibliography..."
        biber "$OUTBASE" || {
            echo "Error: biber failed. Check ${OUTBASE}.blg for details."
            return 1
        }
    fi
    
    echo "[3/4] Running LuaLaTeX (second pass)..."
    clean_synctex
    run_lualatex_mode || {
        echo "Error: LuaLaTeX second pass reported an error. Check ${OUTBASE}.log for details."
        return 1
    }
    
    if [[ ! -f "${OUTBASE}.pdf" ]]; then
        echo "Error: LuaLaTeX second pass failed. Check ${OUTBASE}.log for details."
        return 1
    fi
    
    echo "[4/4] Running LuaLaTeX (third pass)..."
    clean_synctex
    run_lualatex_mode || {
        echo "Error: LuaLaTeX third pass reported an error. Check ${OUTBASE}.log for details."
        return 1
    }
    
    if [[ ! -f "${OUTBASE}.pdf" ]]; then
        echo "Error: LuaLaTeX third pass failed. Check ${OUTBASE}.log for details."
        return 1
    fi
    
    if [[ -f "${OUTBASE}.pdf" ]]; then
        publish_main_pdf || return 1
        pdf_size=$(file_size "${OUTBASE}.pdf")
        main_pdf_size=$(file_size "${MAIN}.pdf")
        echo "========================================"
        echo "Build successful"
        echo "  Output: ${OUTBASE}.pdf - $pdf_size bytes"
        echo "  Current mode copy: ${MAIN}.pdf - $main_pdf_size bytes"
        echo "========================================"
        return 0
    else
        echo "Error: PDF was not created."
        return 1
    fi
}

# Quick build: single pass, skip biber
quick_build() {
    set_outbase
    echo "Quick rebuild (skipping biber) [mode=$BUILDMODE]..."
    preclean_runtime
    
    run_lualatex_mode || {
        echo "Error: LuaLaTeX reported an error. Check ${OUTBASE}.log for details."
        return 1
    }
    
    publish_main_pdf || return 1
    echo "Quick build complete: ${OUTBASE}.pdf"
    echo "Current mode copy: ${MAIN}.pdf"
    return 0
}

# Watch mode
watch_mode() {
    echo "========================================"
    echo "Initial final-mode build before starting watch mode..."
    echo "========================================"
    
    BUILDMODE="final"
    set_outbase
    preclean_runtime
    
    if ! full_build; then
        echo "Initial build failed. Watch mode cancelled."
        return 1
    fi
    
    echo ""
    echo "========================================"
    echo "Watch mode started (Ctrl+C to stop)..."
    echo "Files will auto-rebuild on changes"
    echo "PDF will auto-refresh in viewer"
    echo ""
    echo "Watching for file changes..."
    echo "========================================"
    
    # Use latexmk continuous watch mode with LuaLaTeX + biber
    latexmk -lualatex -usebiber -pvc -pv- -f -shell-escape -interaction=nonstopmode -file-line-error -synctex=1 "$MAINTEX"
    
    echo ""
    echo "Watch mode ended."
    return 0
}

# Usage info
usage() {
    echo "Usage: $0 [all|submission|review|final|quick|clean|watch|crops]"
    echo ""
    echo "Commands:"
    echo "  all         - Build submission, review, and final PDFs (default)"
    echo "  build       - Alias for all"
    echo "  submission  - Build submission copy: ${MAIN}_submission.pdf and ${MAIN}.pdf"
    echo "  review      - Build review copy: ${MAIN}_review.pdf and ${MAIN}.pdf"
    echo "  final       - Build final copy: ${MAIN}_final.pdf and ${MAIN}.pdf"
    echo "  quick       - Quick rebuild for the selected/default final mode, no biber; updates ${MAIN}.pdf"
    echo "  clean       - Remove build artifacts, preserving PDFs and .tex files"
    echo "  watch       - Watch mode for final-mode editing"
    echo "  crops       - Build crop_debug.pdf"
    return 1
}

# Main command dispatch
case "$COMMAND" in
    all|build)
        if ! acquire_lock; then
            exit 1
        fi
        trap release_lock EXIT
        build_all_modes
        exit $?
        ;;
    submission|review|final)
        if ! acquire_lock; then
            exit 1
        fi
        trap release_lock EXIT
        full_build
        exit $?
        ;;
    clean)
        clean_build
        exit 0
        ;;
    crops)
        crops_build
        exit $?
        ;;
    quick)
        if ! acquire_lock; then
            exit 1
        fi
        trap release_lock EXIT
        quick_build
        exit $?
        ;;
    watch)
        if ! acquire_lock; then
            exit 1
        fi
        trap release_lock EXIT
        watch_mode
        exit $?
        ;;
    *)
        usage
        exit 1
        ;;
esac
