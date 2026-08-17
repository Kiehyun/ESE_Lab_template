#!/bin/bash
# Build script for JKASE_main.tex (macOS/Linux version)
# Usage: ./JKASE_main_build.sh [build|all|quick|clean|watch|crops|submission|review|final]

set -e  # Exit on error (can be overridden with || true)

MAIN="JKASE_main"
MAINTEX="${MAIN}.tex"
LOCKDIR="${MAIN}.build_lock"
SYNCTEX=0
COMMAND="${1:-build}"
MODEARG="${2:-}"
BUILDMODE="final"
OPENPDF=1
SINGLEMODE=0

# Normalize command aliases
case "$COMMAND" in
    --clean|-c|/clean) COMMAND="clean" ;;
    --build|-b|/build) COMMAND="build" ;;
    --all|/all|all) COMMAND="all" ;;
    --quick|-q|/quick) COMMAND="quick" ;;
    --watch|-w|/watch) COMMAND="watch" ;;
    --crops|/crops|crops) COMMAND="crops" ;;
    submission|--submission)
        COMMAND="build"
        BUILDMODE="submission"
        SINGLEMODE=1
        ;;
    review|--review)
        COMMAND="build"
        BUILDMODE="review"
        SINGLEMODE=1
        ;;
    final|--final)
        COMMAND="build"
        BUILDMODE="final"
        SINGLEMODE=1
        ;;
esac

case "$MODEARG" in
    submission|--submission)
        BUILDMODE="submission"
        SINGLEMODE=1
        ;;
    review|--review)
        BUILDMODE="review"
        SINGLEMODE=1
        ;;
    final|--final)
        BUILDMODE="final"
        SINGLEMODE=1
        ;;
esac

set_outbase() {
    OUTBASE="${MAIN}_final"
    case "$BUILDMODE" in
        submission) OUTBASE="${MAIN}_submission" ;;
        review) OUTBASE="${MAIN}_review" ;;
    esac
}

set_outbase

# Clean mode: skip all checks and go directly to cleanup
if [ "$COMMAND" = "clean" ]; then
    echo "Cleaning build artifacts (PRESERVING SOURCE FILES: $MAINTEX, *.cls, *.sty)..."
    rm -f "${MAIN}.aux" "${MAIN}.bbl" "${MAIN}.bcf" "${MAIN}.blg" "${MAIN}.log" \
          "${MAIN}.nav" "${MAIN}.out" "${MAIN}.run.xml" "${MAIN}.snm" "${MAIN}.toc" \
          "${MAIN}.xdv" "${MAIN}.fls" "${MAIN}.fdb_latexmk" "${MAIN}.synctex.gz" \
          "${MAIN}.synctex(busy)" 2>/dev/null || true
    for mode in submission review final; do
        rm -f "${MAIN}_${mode}.aux" "${MAIN}_${mode}.bbl" "${MAIN}_${mode}.bcf" \
              "${MAIN}_${mode}.blg" "${MAIN}_${mode}.log" "${MAIN}_${mode}.nav" \
              "${MAIN}_${mode}.out" "${MAIN}_${mode}.run.xml" "${MAIN}_${mode}.snm" \
              "${MAIN}_${mode}.toc" "${MAIN}_${mode}.xdv" "${MAIN}_${mode}.fls" \
              "${MAIN}_${mode}.fdb_latexmk" "${MAIN}_${mode}.synctex.gz" \
              "${MAIN}_${mode}.synctex(busy)" 2>/dev/null || true
    done
    
    # Clean subfile auxiliary files
    if [ -d "sub" ]; then
        rm -f sub/*.aux sub/*.bbl sub/*.bcf sub/*.blg sub/*.log sub/*.nav \
              sub/*.out sub/*.run.xml sub/*.snm sub/*.toc sub/*.xdv sub/*.fls \
              sub/*.fdb_latexmk sub/*.synctex.gz sub/*.synctex\(busy\) 2>/dev/null || true
    fi
    
    # Clean crop debug artifacts
    rm -f crop_debug.aux crop_debug.log crop_debug.out crop_debug.toc \
          crop_debug.synctex.gz 2>/dev/null || true
    
    # Remove stale lock if present
    [ -d "$LOCKDIR" ] && rmdir "$LOCKDIR" 2>/dev/null || true
    
    echo "Clean complete. Source files ($MAINTEX, *.cls, *.sty) PRESERVED."
    exit 0
fi

# SyncTeX is useful for watch mode (editor integration)
if [ "$COMMAND" = "watch" ] || [ "$COMMAND" = "crops" ]; then
    SYNCTEX=1
fi

# Verify main tex file exists
if [ ! -f "$MAINTEX" ]; then
    echo "Warning: $MAINTEX not found in current directory"
    echo "Creating minimal $MAINTEX from backup if available..."
    # Continue anyway
fi

# Check required commands
for cmd in lualatex biber latexmk; do
    if ! command -v $cmd &>/dev/null; then
        echo "Error: $cmd is not installed or not on PATH"
        exit 1
    fi
done

# Acquire lock to prevent concurrent builds
acquire_lock() {
    if ! mkdir "$LOCKDIR" 2>/dev/null; then
        echo "Error: Another build/watch is already running."
        echo "Lock: $LOCKDIR"
        echo "If this is stale, run '$0 clean' or delete the lock folder."
        exit 1
    fi
}

# Release lock
release_lock() {
    [ -d "$LOCKDIR" ] && rmdir "$LOCKDIR" 2>/dev/null || true
}

# Trap to ensure lock is released on exit
trap release_lock EXIT INT TERM

# Check for other lualatex processes (warning only)
if pgrep -x lualatex >/dev/null 2>&1; then
    echo "[WARNING] Another lualatex process is running. Continuing; builds are isolated by folder."
fi

# Pre-clean runtime artifacts
preclean_runtime() {
    rm -f "${OUTBASE}.aux" "${OUTBASE}.nav" "${OUTBASE}.snm" "${OUTBASE}.toc" \
          "${OUTBASE}.out" "${OUTBASE}.run.xml" "${OUTBASE}.synctex(busy)" \
          "${OUTBASE}.synctex.gz" 2>/dev/null || true
    
    if [ -d "sub" ]; then
        rm -f sub/*.aux sub/*.nav sub/*.snm sub/*.toc sub/*.out sub/*.run.xml \
              sub/*.synctex\(busy\) sub/*.synctex.gz 2>/dev/null || true
    fi
}

latex_mode_args() {
    case "$BUILDMODE" in
        submission)
            printf '%s' "\\def\\ANONYMIZED{1}\\input{$MAINTEX}"
            ;;
        review)
            printf '%s' "\\def\\ANONYMIZED{1}\\def\\REVIEWCOPY{1}\\input{$MAINTEX}"
            ;;
        *)
            printf '%s' "\\def\\FINALMODE{1}\\input{$MAINTEX}"
            ;;
    esac
}

publish_main_pdf() {
    if [ ! -f "${OUTBASE}.pdf" ]; then
        echo "Error: ${OUTBASE}.pdf was not found; cannot update ${MAIN}.pdf."
        return 1
    fi
    cp -f "${OUTBASE}.pdf" "${MAIN}.pdf" || {
        echo "Error: failed to update ${MAIN}.pdf from ${OUTBASE}.pdf."
        return 1
    }
}

# Open PDF in VS Code (avoid default external viewers such as Acrobat)
open_pdf_in_vscode() {
    local pdf_path="$1"

    # 1) Prefer CLI if available on PATH
    if command -v code &>/dev/null; then
        code --reuse-window "$pdf_path" &
        return 0
    fi

    # 2) macOS fallback: launch file explicitly with VS Code app
    if command -v open &>/dev/null; then
        if open -a "Visual Studio Code" --args --reuse-window "$pdf_path" &>/dev/null; then
            return 0
        fi
    fi

    # 3) Try common absolute paths for code CLI on macOS
    for code_bin in \
        "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" \
        "$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
    do
        if [ -x "$code_bin" ]; then
            "$code_bin" --reuse-window "$pdf_path" &
            return 0
        fi
    done

    echo "Warning: Could not open PDF in VS Code automatically."
    echo "Tip: Install the 'code' shell command from VS Code (Command Palette: Shell Command)."
    return 1
}

# Full build function
full_build() {
    echo "========================================"
    echo "Building $MAINTEX [mode=$BUILDMODE]..."
    echo "========================================"
    
    set_outbase
    preclean_runtime
    TEXINPUT=$(latex_mode_args)
    
    echo "[1/4] Running LuaLaTeX (first pass)..."
    if ! lualatex -jobname="$OUTBASE" -synctex=$SYNCTEX -interaction=nonstopmode -file-line-error -shell-escape "$TEXINPUT"; then
        echo "Error: LuaLaTeX first pass reported an error. Check ${OUTBASE}.log for details."
        echo "Tip: run '$0 clean' then build again if this is an aux/nav corruption."
        exit 1
    fi
    
    if [ ! -f "${OUTBASE}.pdf" ]; then
        echo "Error: LuaLaTeX first pass failed. Check ${OUTBASE}.log for details."
        exit 1
    fi
    
    if [ ! -f "${OUTBASE}.bcf" ]; then
        echo "Warning: .bcf file not created. Bibliography might not be present."
        echo "Skipping biber..."
    else
        echo "[2/4] Running biber for bibliography..."
        # Retry biber up to 3 times with a short delay to handle Synology Drive
        # sync locking the .bcf file immediately after lualatex writes it
        BIBER_OK=0
        for attempt in 1 2 3; do
            if biber "$OUTBASE" 2>&1; then
                BIBER_OK=1
                break
            fi
            echo "  biber attempt $attempt failed; retrying in 2s..."
            sleep 2
        done
        if [ $BIBER_OK -eq 0 ]; then
            echo "Error: biber failed after 3 attempts. Check ${OUTBASE}.blg for details."
            echo "Attempting to continue without bibliography..."
        fi
    fi
    
    echo "[3/4] Running LuaLaTeX (second pass)..."
    if ! lualatex -jobname="$OUTBASE" -synctex=$SYNCTEX -interaction=nonstopmode -file-line-error -shell-escape "$TEXINPUT"; then
        echo "Error: LuaLaTeX second pass reported an error. Check ${OUTBASE}.log for details."
        exit 1
    fi
    
    if [ ! -f "${OUTBASE}.pdf" ]; then
        echo "Error: LuaLaTeX second pass failed. Check ${OUTBASE}.log for details."
        exit 1
    fi
    
    echo "[4/4] Running LuaLaTeX (third pass)..."
    if ! lualatex -jobname="$OUTBASE" -synctex=$SYNCTEX -interaction=nonstopmode -file-line-error -shell-escape "$TEXINPUT"; then
        echo "Error: LuaLaTeX third pass reported an error. Check ${OUTBASE}.log for details."
        exit 1
    fi
    
    if [ ! -f "${OUTBASE}.pdf" ]; then
        echo "Error: LuaLaTeX third pass failed. Check ${OUTBASE}.log for details."
        exit 1
    fi
    
    if [ -f "${OUTBASE}.pdf" ]; then
        publish_main_pdf || exit 1
        PDF_SIZE=$(wc -c < "${OUTBASE}.pdf" | tr -d ' ')
        MAIN_PDF_SIZE=$(wc -c < "${MAIN}.pdf" | tr -d ' ')
        echo "========================================"
        echo "Build successful"
        echo "  Output: ${OUTBASE}.pdf ($PDF_SIZE bytes)"
        echo "  Current mode copy: ${MAIN}.pdf ($MAIN_PDF_SIZE bytes)"
        echo "========================================"
        if [ "$OPENPDF" = "1" ]; then
            echo "Opening PDF in VS Code..."
            open_pdf_in_vscode "${OUTBASE}.pdf" || true
        else
            echo "PDF auto-open skipped. Set OPENPDF=1 to open after build."
        fi
    else
        echo "Error: PDF was not created."
        exit 1
    fi
}

# Quick build function
quick_build() {
    echo "Quick rebuild (skipping biber) [mode=$BUILDMODE]..."
    
    set_outbase
    preclean_runtime
    TEXINPUT=$(latex_mode_args)
    
    if ! lualatex -jobname="$OUTBASE" -synctex=$SYNCTEX -interaction=nonstopmode -file-line-error -shell-escape "$TEXINPUT"; then
        echo "Error: LuaLaTeX reported an error. Check ${OUTBASE}.log for details."
        exit 1
    fi
    
    publish_main_pdf || exit 1
    echo "Quick build complete: ${OUTBASE}.pdf"
    echo "Current mode copy: ${MAIN}.pdf"
}

build_all_modes() {
    SAVED_OPENPDF="$OPENPDF"
    OPENPDF=0
    BUILDMODE="submission"
    full_build
    BUILDMODE="review"
    full_build
    OPENPDF="$SAVED_OPENPDF"
    BUILDMODE="final"
    full_build
    echo "========================================"
    echo "All paper modes built successfully:"
    echo "  ${MAIN}_submission.pdf"
    echo "  ${MAIN}_review.pdf"
    echo "  ${MAIN}_final.pdf"
    echo "========================================"
}

# Watch mode function
watch_mode() {
    echo "========================================"
    echo "Initial build before starting watch mode..."
    echo "========================================"
    
    if [ "$BUILDMODE" = "submission" ] || [ "$BUILDMODE" = "review" ]; then
        echo "Warning: watch mode supports final mode only."
        echo "Use full build: $0 submission | $0 review"
        exit 1
    fi

    full_build
    
    echo "Opening PDF in VS Code..."
    open_pdf_in_vscode "${OUTBASE}.pdf" || true
    
    echo ""
    echo "========================================"
    echo "Watch mode started (Ctrl+C to stop)..."
    echo "Files will auto-rebuild on changes"
    echo "PDF will auto-refresh in VS Code viewer"
    echo ""
    echo "Watching for file changes..."
    echo "========================================"
    
    # Use latexmk continuous watch mode with LuaLaTeX + biber
    # -pvc = continuous preview mode (watch and rebuild)
    # -view=none = do not launch external previewer (use VS Code PDF viewer)
    # -synctex=1 = enable synctex for VS Code integration
    # -f = force mode (continue after errors)
    latexmk -lualatex -pvc -view=none -f -shell-escape \
            -interaction=nonstopmode -file-line-error -synctex=1 \
            -jobname="${MAIN}_final" "\\def\\FINALMODE{1}\\input{$MAINTEX}"
    
    echo ""
    echo "Watch mode ended."
}

# Crops build function
crops_build() {
    echo "========================================"
    echo "Generating crop_debug.tex and building crop_debug.pdf..."
    echo "========================================"
    
    if [ ! -f "scripts/generate_crop_debug.py" ]; then
        echo "Error: scripts/generate_crop_debug.py not found."
        exit 1
    fi
    
    # Find Python command
    PYTHON=""
    if command -v python3 &>/dev/null; then
        PYTHON="python3"
    elif command -v python &>/dev/null; then
        PYTHON="python"
    else
        echo "Error: Python not found on PATH. Install Python or add it to PATH."
        exit 1
    fi
    
    if ! $PYTHON "scripts/generate_crop_debug.py"; then
        echo "Error: failed to generate crop_debug.tex"
        exit 1
    fi
    
    if ! lualatex -synctex=$SYNCTEX -interaction=nonstopmode -file-line-error "crop_debug.tex"; then
        echo "Error: failed to build crop_debug.pdf"
        exit 1
    fi
    
    echo "Done: crop_debug.pdf"
}

# Show usage
usage() {
    echo "Usage: $0 [build|all|quick|clean|watch|crops|submission|review|final] [submission|review|final]"
    echo ""
    echo "Commands:"
    echo "  build       - Full build of submission, review, and final PDFs (default)"
    echo "  all         - Full build of submission, review, and final PDFs"
    echo "  quick       - Quick rebuild (no biber, faster)"
    echo "  submission  - Full build in anonymized submission mode"
    echo "  review      - Full build in anonymized review mode (review-color enabled)"
    echo "  final       - Full build in final mode (author metadata included)"
    echo "  clean       - Remove all build artifacts"
    echo "  watch       - Watch mode (auto-rebuild on changes, final mode only)"
    echo "  crops       - Generate and build crop_debug.pdf"
    exit 1
}

# Main execution
acquire_lock

case "$COMMAND" in
    build)
        if [ "$SINGLEMODE" = "1" ]; then
            full_build
        else
            build_all_modes
        fi
        ;;
    all)
        build_all_modes
        ;;
    quick)
        quick_build
        ;;
    watch)
        watch_mode
        ;;
    crops)
        crops_build
        ;;
    *)
        usage
        ;;
esac

exit 0
