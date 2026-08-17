#!/usr/bin/env bash
# ===========================================================================
# 한국교원대학교 학위논문 LaTeX 템플릿 Unix 계열 빌드 스크립트
# KNUE thesis/dissertation LaTeX template build script for Unix-like shells
#
# 역할:
#   - KNUE_thesis_main.tex를 LuaLaTeX 기반 latexmk로 빌드합니다.
#   - biber가 필요한 참고문헌 처리도 latexmk가 자동으로 실행합니다.
#   - 빌드 전에 깨지기 쉬운 보조 파일을 정리하고, 동시 빌드를 막기 위해
#     잠금 폴더를 사용합니다.
#   - 실제 빌드 산출물은 캐시 폴더(아래 BUILDDIR)에서 만들고, 완성된 PDF만
#     프로젝트 폴더로 복사합니다. Synology/Dropbox/iCloud처럼 동기화되는
#     폴더 안에서 직접 빌드하면, 동기화 클라이언트가 컴파일 중간에 임시
#     파일을 잠가 SyncTeX 이름 변경이 실패하고 PDF가 안 만들어질 수 있기
#     때문입니다.
#   - macOS, Linux, Windows Git Bash/MSYS2 환경에서 사용할 수 있습니다.
#
# Purpose:
#   - Builds KNUE_thesis_main.tex with latexmk using LuaLaTeX.
#   - Lets latexmk run biber automatically when bibliography processing is needed.
#   - Removes fragile generated files before builds and uses a lock folder to avoid
#     concurrent builds of the same thesis.
#   - Compiles into a cache folder (BUILDDIR below) and copies only the
#     finished PDF back to the project folder. Building directly inside a
#     cloud-synced folder (Synology Drive/Dropbox/iCloud) can make the sync
#     client lock intermediate files mid-compile, so the final SyncTeX
#     rename fails and no PDF is produced.
#   - Works on macOS, Linux, and Windows Git Bash/MSYS2.
#
# 사용법 / Usage:
#   ./KNUE_thesis_main_build.sh
#   ./KNUE_thesis_main_build.sh build        또는 / or --build, -b
#   ./KNUE_thesis_main_build.sh quick        또는 / or --quick, -q
#   ./KNUE_thesis_main_build.sh clean        또는 / or --clean, -c
#   ./KNUE_thesis_main_build.sh watch        또는 / or --watch, -w
#   ./KNUE_thesis_main_build.sh submit       또는 / or final, --submit, -s
#   ./KNUE_thesis_main_build.sh review       또는 / or --review
#   ./KNUE_thesis_main_build.sh review-blue  또는 / or --review-blue
#   ./KNUE_thesis_main_build.sh color
#   ./KNUE_thesis_main_build.sh bw
#   ./KNUE_thesis_main_build.sh versions     (컬러본 + 흑백본을 한 번에)
#   ./KNUE_thesis_main_build.sh crops
#
# 명령 / Commands:
#   build  : 전체 빌드입니다. 참고문헌까지 필요한 만큼 처리합니다.
#            Full build. Processes the bibliography as needed.
#   quick  : 빠른 재빌드입니다. 변경된 부분만 latexmk가 처리합니다.
#            Quick incremental rebuild handled by latexmk.
#   clean  : 보조 파일과 잠금 폴더를 삭제합니다. tex와 pdf는 보존합니다.
#            Removes generated artifacts and stale locks. Keeps tex and pdf files.
#   watch  : 파일 변경을 감지해 자동으로 다시 빌드합니다.
#            Watches file changes and rebuilds automatically.
#   submit : 최종 제출본을 빌드합니다. 수정 표시를 모두 끕니다(검정 본문).
#            결과를 KNUE_thesis_main_제출본.pdf 로 함께 복사합니다.
#            Final submission build with all revision marks OFF (plain black text).
#   review : 심사(검토)본을 빌드합니다. \revised/\revisedA..D 수정 표시를 켜서
#            심사위원별 색상으로 출력하고, KNUE_thesis_main_수정표시_심사위원별색상.pdf 로 복사합니다.
#            Review build: revision marks ON, per-examiner colors.
#   review-blue : 검토본을 빌드하되 수정 표시를 모두 파란색 한 가지로 통일하고,
#            KNUE_thesis_main_수정표시_전체파란색.pdf 로 복사합니다.
#            Review build with every revision mark unified to blue.
#   color  : 그림 컬러본(\figf -> *_color)을 사용해 빌드하고 KNUE_thesis_main_컬러.pdf 로 복사합니다.
#   bw     : 그림 흑백본(\figf -> *_bw)을 사용해 빌드하고 KNUE_thesis_main_흑백.pdf 로 복사합니다.
#   versions : color와 bw 두 버전을 각각 독립된 빌드 폴더에서 동시에 빌드합니다.
#            Builds the color and bw variants in parallel, in isolated build folders.
#   crops  : 이미지 잘림 상태 확인용 crop_debug.pdf를 만듭니다.
#            Builds crop_debug.pdf for checking image crop settings.
#
# ※ review / review-blue / submit 는 sub/0-preamble.tex 의 수정 표시 매크로와
#    환경변수(THESIS_SHOW_REVISIONS, THESIS_REV_ALLBLUE)를 통해 동작합니다.
#    git 이력이 있는 "변경 추적(track-changes)" PDF, 즉 심사본 제출 이후 바뀐
#    부분만 색으로 자동 표시하는 PDF는 make-diff.sh 를 쓰세요(수동으로 \revised
#    래퍼를 붙이지 않아도, git 커밋만 비교해 추가=파랑/삭제=빨강으로 보여줍니다).
#
# Compatible with Windows (Git Bash/MSYS2), macOS, and Linux
# ===========================================================================

set -e

# 스크립트가 어느 위치에서 실행되든 이 파일이 있는 폴더로 이동합니다.
# Move to this script's folder so relative paths work from any launch location.
cd "$(dirname "$0")"

# 운영체제를 감지합니다. 현재는 PDF 크기 확인처럼 플랫폼별 명령 차이에 사용합니다.
# Detect the OS for platform-specific operations such as checking PDF file size.
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    OS="windows"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
else
    OS="linux"
fi

# 기본 대상 파일과 첫 번째 명령 인자를 설정합니다.
# Set the main target files and read the first command argument.
MAIN="KNUE_thesis_main"
MAINTEX="${MAIN}.tex"
COMMAND="${1:-build}"

# SyncTeX는 PDF와 TeX 원본 사이의 위치 이동을 가능하게 합니다. watch 모드에서만 켭니다.
# SyncTeX enables source/PDF synchronization. Only watch mode turns it on.
SYNCTEX="0"
export LATEXMK_SYNCTEX=0
LOCKDIR="${MAIN}.build_lock"

# 실제 컴파일 산출물이 쌓이는 임시 빌드 폴더입니다. 완성된 PDF(와 SyncTeX)만
# 프로젝트 루트로 복사됩니다. 반드시 Synology Drive/Dropbox/iCloud 같은 동기화
# 폴더 "밖"에 두세요 — 동기화 중인 폴더 안에서 빌드하면 중간 파일이 잠겨
# SyncTeX 이름 변경이 실패하고 PDF가 안 만들어질 수 있습니다. 기본값은 사용자별
# 로컬 캐시 폴더이며, BUILDDIR 환경변수로 위치를 바꿀 수 있습니다.
#
# Temporary build folder for all compile artifacts; only the final PDF (and
# SyncTeX) is copied back to the project root. Keep this OUTSIDE any
# cloud-synced folder (Synology Drive/Dropbox/iCloud) — building inside a
# synced folder can make the sync client lock intermediate files mid-compile,
# breaking the final SyncTeX rename and producing no PDF. Defaults to a
# per-user local cache folder; override by exporting BUILDDIR.
if [[ -z "${BUILDDIR:-}" ]]; then
    CACHE_BASE="${XDG_CACHE_HOME:-$HOME/.cache}"
    BUILDDIR="${CACHE_BASE}/latexbuild/${MAIN}"
fi

# 명령 인자를 표준 명령 이름으로 바꿉니다. 인자가 없으면 build가 기본값입니다.
# Normalize aliases to one command name. With no argument, build is the default.
case "$COMMAND" in
    --clean|-c) COMMAND="clean" ;;
    --build|-b) COMMAND="build" ;;
    --quick|-q) COMMAND="quick" ;;
    --watch|-w) COMMAND="watch" ;;
    --submit|-s|submit|--final|final) COMMAND="submit" ;;
    --review|review) COMMAND="review" ;;
    --review-blue|review-blue|--reviewblue|reviewblue) COMMAND="reviewblue" ;;
    --versions|versions|--both|both) COMMAND="versions" ;;
    --crops|crops) COMMAND="crops" ;;
esac

# build/quick/watch/submit/review/review-blue/color/bw는 메인 TeX 파일이 필요합니다.
# clean과 crops는 별도 동작입니다. versions는 아래에서 별도로 확인합니다.
# These build modes require the main TeX file. clean and crops are separate modes.
if [[ "$COMMAND" == "build" || "$COMMAND" == "quick" || "$COMMAND" == "watch" \
      || "$COMMAND" == "submit" || "$COMMAND" == "review" || "$COMMAND" == "reviewblue" \
      || "$COMMAND" == "color" || "$COMMAND" == "bw" || "$COMMAND" == "versions" ]]; then
    # 메인 TeX 파일이 없으면 잘못된 폴더에서 실행한 가능성이 큽니다.
    # If the main TeX file is missing, the script is probably running in the wrong folder.
    if [[ ! -f "$MAINTEX" ]]; then
        echo "Error: $MAINTEX not found in current directory"
        exit 1
    fi
fi

# 명령별로 필요한 외부 프로그램이 PATH에 있는지 확인합니다.
# Check that the external tools required by the selected command are available on PATH.
case "$COMMAND" in
    build|quick|watch|submit|review|reviewblue|color|bw|versions)
        for cmd in latexmk lualatex biber; do
            if ! command -v "$cmd" &> /dev/null; then
                echo "Error: $cmd is not installed or not on PATH"
                exit 1
            fi
        done
        ;;
    crops)
        if ! command -v lualatex &> /dev/null; then
            echo "Error: lualatex is not installed or not on PATH"
            exit 1
        fi
        ;;
esac

# 같은 논문 폴더에서 빌드가 동시에 실행되면 aux 파일이 꼬일 수 있으므로 막습니다.
# Prevent concurrent builds in the same thesis folder because aux files can conflict.
acquire_lock() {
    # mkdir은 원자적으로 동작하므로 간단한 동시 실행 방지 장치로 사용할 수 있습니다.
    # mkdir is atomic, so it works as a simple cross-process mutex.
    mkdir "$LOCKDIR" 2>/dev/null || {
        echo "Error: Another build/watch is already running."
        echo "Lock: $LOCKDIR"
        echo "If this is stale, run '$0 clean' or delete the lock folder."
        return 1
    }
    return 0
}

# 정상 종료 또는 오류 종료 후 남은 잠금 폴더를 정리합니다.
# Remove the lock folder after a normal or failed build.
release_lock() {
    rm -rf "$LOCKDIR" 2>/dev/null || true
}

# 가벼운 사전 정리입니다. 깨지거나 오래된 생성 파일을 제거해 재빌드 오류를 줄입니다.
# Lightweight pre-clean: remove generated files that commonly become stale or corrupted.
preclean_runtime() {
    echo "[Preclean] Removing runtime artifacts..."
    # 임시 빌드 폴더를 비워 매번 깨끗한 상태에서 시작합니다.
    # Reset the temporary build folder so each build starts from a clean state.
    rm -rf "$BUILDDIR" 2>/dev/null || true
    mkdir -p "$BUILDDIR/sub" 2>/dev/null || true
    rm -f "${MAIN}".{aux,bbl,bcf,bcf-SAVE-ERROR,bbl-SAVE-ERROR,blg,fdb_latexmk,fls,lof,lot,nav,out,run.xml,snm,toc,xdv} 2>/dev/null || true
    rm -f "${MAIN}".synctex "${MAIN}".synctex.gz "${MAIN}".synctex\(busy\) 2>/dev/null || true

    # 하위 장 파일에서 생긴 보조 파일도 함께 지웁니다.
    # Also delete subfile auxiliary files.
    if [[ -d "sub" ]]; then
        rm -f sub/*.{aux,bbl,bcf,bcf-SAVE-ERROR,bbl-SAVE-ERROR,blg,fdb_latexmk,fls,lof,lot,nav,out,run.xml,snm,toc,xdv} 2>/dev/null || true
        rm -f sub/*.synctex sub/*.synctex.gz sub/*.synctex\(busy\) 2>/dev/null || true
    fi
}

# PDF 뷰어가 잡고 있던 SyncTeX 파일이 "(busy)" 상태로 남을 수 있습니다.
# Remove SyncTeX artifacts that can remain locked by PDF viewers.
clean_synctex() {
    rm -f "${MAIN}".synctex "${MAIN}".synctex.gz "${MAIN}".synctex\(busy\) 2>/dev/null || true
}

# ---------------------------------------------------------------------------
# 빌드 검증. "PDF 파일이 있다"는 "빌드가 성공했다"와 다릅니다. LuaLaTeX이 중간에
# 죽으면(예: "TeX capacity exceeded") 그때까지 찍어낸 페이지만 담긴 잘린 PDF가
# 남는데, 파일 존재 여부만 확인하면 이 잘린 PDF도 "성공"으로 오판합니다.
# 그래서 (1) 엔진이 도중에 죽지 않았는지, (2) 로그에 실제 페이지 수가 찍혔는지,
# (3) PDF 파일이 실제로 있는지 세 가지를 모두 확인합니다.
#
# Build verification. "A PDF file exists" is not the same as "the build
# succeeded": when LuaLaTeX dies mid-run, it leaves behind the pages it had
# already shipped out as a truncated, unreadable PDF. So this checks that the
# engine did not abort, the log reports a real page count, and the PDF is
# there. Sets VERIFY_PAGES / VERIFY_REASON.
# ---------------------------------------------------------------------------
VERIFY_PAGES=0
VERIFY_REASON=""
verify_build() {
    local bdir="$1"
    local pdf="${bdir}/${MAIN}.pdf"
    local tlog="${bdir}/${MAIN}.log"
    VERIFY_PAGES=0
    VERIFY_REASON=""

    if [[ ! -f "$pdf" ]]; then
        VERIFY_REASON="PDF was not created"
        return 1
    fi
    if [[ ! -f "$tlog" ]]; then
        VERIFY_REASON="${MAIN}.log missing (compilation never started)"
        return 1
    fi
    if grep -q "Fatal error occurred" "$tlog" 2>/dev/null; then
        VERIFY_REASON="fatal error: $(grep -m1 -h 'Fatal error occurred' "$tlog" | tr -d '\r' | sed 's/^[[:space:]]*//')"
        return 1
    fi
    if grep -q "TeX capacity exceeded" "$tlog" 2>/dev/null; then
        VERIFY_REASON="TeX capacity exceeded"
        return 1
    fi

    VERIFY_PAGES=$(grep -o "Output written on [^(]*([0-9]* pages" "$tlog" 2>/dev/null \
                   | tail -1 | grep -o "[0-9]* pages" | grep -o "[0-9]*")
    [[ -z "$VERIFY_PAGES" ]] && VERIFY_PAGES=0
    if [[ "$VERIFY_PAGES" -le 0 ]]; then
        VERIFY_REASON="page count not found in log (output may be truncated)"
        return 1
    fi
    return 0
}

# 사용자가 직접 요청하는 전체 정리입니다. 원본 .tex와 결과 PDF는 삭제하지 않습니다.
# Full cleanup requested by the user. Source .tex files and the output PDF are preserved.
clean_build() {
    echo "Cleaning build artifacts (preserving $MAINTEX and ${MAIN}.pdf)..."

    # 임시 빌드 폴더 전체를 삭제합니다.
    # Remove the temporary build folder entirely.
    rm -rf "$BUILDDIR" "${BUILDDIR}_bw" "${BUILDDIR}_color" 2>/dev/null || true

    rm -f "${MAIN}".{aux,bbl,bbl-SAVE-ERROR,bcf,bcf-SAVE-ERROR,blg,log,nav,out,run.xml,snm,toc,xdv,fls,fdb_latexmk,synctex,synctex.gz,synctex\(busy\)} 2>/dev/null || true

    # sub/*.aux 같은 하위 파일 보조 파일도 삭제합니다. 손상되면 빌드를 막을 수 있습니다.
    # Also delete subfile aux files. These can get corrupted and break builds.
    if [[ -d "sub" ]]; then
        rm -f sub/*.{aux,bbl,bbl-SAVE-ERROR,bcf,bcf-SAVE-ERROR,blg,log,nav,out,run.xml,snm,toc,xdv,fls,fdb_latexmk,synctex,synctex.gz,synctex\(busy\)} 2>/dev/null || true
    fi

    # 이미지 crop 확인용 임시 파일도 정리합니다.
    # Remove temporary files from the crop-debug build.
    rm -f crop_debug.{aux,log,out,toc,synctex.gz} 2>/dev/null || true

    # 이전 실행에서 남은 잠금 폴더가 있으면 제거합니다.
    # Remove a stale build/watch lock if present.
    release_lock

    echo "Clean complete. $MAINTEX preserved."
}

# 그림 여백 조정값(trim/clip)을 확인하기 위한 별도 PDF를 생성합니다.
# Generate a separate PDF for checking image trim/clip crop settings.
crops_build() {
    echo "========================================"
    echo "Generating crop_debug.tex and building crop_debug.pdf..."
    echo "========================================"

    if [[ ! -f "scripts/generate_crop_debug.py" ]]; then
        echo "Error: scripts/generate_crop_debug.py not found."
        return 1
    fi

    # crop_debug.tex 생성을 위해 사용할 Python 실행 파일을 찾습니다.
    # Find a Python executable for generating crop_debug.tex.
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

# 전체 빌드입니다. 캐시 폴더(BUILDDIR)에서 컴파일하고, 완성된 PDF만 프로젝트
# 루트로 복사합니다. latexmk가 LuaLaTeX와 biber 반복 실행을 판단합니다.
# Full build: compile in the cache folder (BUILDDIR) and copy back only the
# finished PDF. latexmk decides how many LuaLaTeX/biber passes are needed.
full_build() {
    echo "========================================"
    echo "Building $MAINTEX..."
    echo "  figures: $([[ "${THESIS_FIGMODE:-}" == "color" ]] && echo color || echo "bw (or template default)")"
    echo "  revision marks: $([[ "${THESIS_SHOW_REVISIONS:-}" == "1" ]] && echo ON || echo off)"
    echo "========================================"

    preclean_runtime

    echo "[1/2] Running LuaLaTeX to create fresh aux/bcf files..."
    lualatex -synctex=0 -interaction=nonstopmode -file-line-error -shell-escape -output-directory="$BUILDDIR" "$MAINTEX" || true
    # 1차 패스에서 종료 코드가 0이 아닌 것은 정상입니다(참고문헌/상호참조가 아직
    # 안 풀린 상태). 엔진이 도중에 죽은 것과는 다르므로, 죽었을 때만 여기서 멈춥니다.
    # A non-zero exit on the first pass is normal (unresolved refs/citations).
    # An engine abort is not: don't waste the second pass on a dead build.
    if ! verify_build "$BUILDDIR" && [[ "$VERIFY_REASON" != "PDF was not created" ]]; then
        echo "Error: LuaLaTeX first pass aborted - ${VERIFY_REASON}"
        echo "Check ${BUILDDIR}/${MAIN}.log for details."
        echo "Tip: run '$0 clean' then build again if generated files are corrupted."
        return 1
    fi

    echo "[2/2] Running latexmk with LuaLaTeX and biber as needed..."
    local lrc=0
    export LATEXMK_SYNCTEX=0
    latexmk -auxdir="$BUILDDIR" -outdir="$BUILDDIR" -pdflua -interaction=nonstopmode "$MAINTEX" || lrc=$?

    if ! verify_build "$BUILDDIR"; then
        echo "Error: build failed - ${VERIFY_REASON} (latexmk rc=$lrc)"
        echo "Check ${BUILDDIR}/${MAIN}.log for details."
        echo "Tip: run '$0 clean' then build again if generated files are corrupted."
        return 1
    fi
    if [[ $lrc -ne 0 ]]; then
        echo "[WARNING] latexmk exited with $lrc, but the PDF is complete (${VERIFY_PAGES} pages). Continuing."
    fi

    # 완성된 PDF를 캐시 폴더에서 프로젝트 루트로 복사합니다.
    # Copy the finished PDF from the build folder back to the project root.
    cp -f "${BUILDDIR}/${MAIN}.pdf" "${MAIN}.pdf" || {
        echo "Error: failed to update ${MAIN}.pdf. Close PDF viewers and try again."
        return 1
    }

    if command -v stat &> /dev/null; then
        if [[ "$OS" == "macos" ]]; then
            pdf_size=$(stat -f%z "${MAIN}.pdf" 2>/dev/null) || pdf_size="unknown"
        else
            pdf_size=$(stat -c%s "${MAIN}.pdf" 2>/dev/null) || pdf_size="unknown"
        fi
    else
        pdf_size=$(wc -c < "${MAIN}.pdf" 2>/dev/null) || pdf_size="unknown"
    fi
    echo "========================================"
    echo "Build successful"
    echo "  Output: ${MAIN}.pdf (${VERIFY_PAGES} pages, $pdf_size bytes)"
    echo "========================================"
    return 0
}

# 프로필(제출본/검토본/컬러/흑백) 빌드입니다. 환경변수를 설정한 뒤 전체 빌드를
# 수행하고, 결과 PDF를 알아보기 쉬운 이름으로 함께 복사합니다.
# Profiled build: set env vars, run a full build, then copy the result PDF to
# a descriptive name. $1 = suffix for the copied PDF.
profiled_build() {
    local suffix="$1"
    if ! full_build; then
        return 1
    fi
    if [[ -n "$suffix" && -f "${MAIN}.pdf" ]]; then
        cp -f "${MAIN}.pdf" "${MAIN}_${suffix}.pdf" 2>/dev/null || true
        echo "  사본 / copy: ${MAIN}_${suffix}.pdf"
    fi
    return 0
}

# 빠른 재빌드입니다. 캐시 폴더에 남아있는 보조 파일을 재사용해 변경된 부분만 처리합니다.
# Quick rebuild. Reuses auxiliary files already in the build folder for an
# incremental latexmk build.
quick_build() {
    echo "Quick rebuild with latexmk..."
    mkdir -p "$BUILDDIR/sub" 2>/dev/null || true
    local lrc=0
    export LATEXMK_SYNCTEX=0
    latexmk -auxdir="$BUILDDIR" -outdir="$BUILDDIR" -pdflua -interaction=nonstopmode "$MAINTEX" || lrc=$?

    if ! verify_build "$BUILDDIR"; then
        echo "Error: quick build failed - ${VERIFY_REASON} (latexmk rc=$lrc)"
        echo "Check ${BUILDDIR}/${MAIN}.log for details."
        return 1
    fi

    cp -f "${BUILDDIR}/${MAIN}.pdf" "${MAIN}.pdf" || {
        echo "Error: failed to update ${MAIN}.pdf. Close PDF viewers and try again."
        return 1
    }

    echo "Quick build complete: ${MAIN}.pdf (${VERIFY_PAGES} pages)"
    return 0
}

# 라벨이 붙은 단일 버전을 독립된 빌드 폴더 + 결과 PDF로 만듭니다. 각 버전이 자기
# 만의 aux/out 폴더를 쓰므로 여러 개를 동시에 돌려도 aux/bcf/bbl이 서로 섞이지
# 않습니다. SyncTeX는 끕니다(전달용 결과물이라 편집기 연동이 필요 없음).
# 인자: <접미사> <ENV=VAL>...   (예: build_one bw THESIS_FIGMODE=bw)
#
# Build a single labelled variant in an ISOLATED build folder + output PDF.
# Each variant gets its own aux/out dir so several can run concurrently
# without clobbering each other's aux/bcf/bbl. SyncTeX is disabled (delivery
# artifacts). Args: <suffix> <ENV=VAL>...
build_one() {
    local suffix="$1"; shift
    local vbuild="${BUILDDIR}_${suffix}"
    local out="${MAIN}_${suffix}.pdf"
    local log="${vbuild}.buildlog"
    local flag="${vbuild}.done"

    rm -rf "$vbuild" 2>/dev/null || true
    mkdir -p "$vbuild/sub" 2>/dev/null || true
    rm -f "$flag" 2>/dev/null || true

    # 서브셸이 자기만의 환경을 쓰므로, 각 버전이 서로 다른 THESIS_* 값을 봅니다.
    # 결과는 "$flag"로 보고합니다: 성공 "0 <페이지수>", 실패 "1 0 <이유>".
    #
    # The subshell runs with its own environment, so the variants can't see
    # each other's THESIS_* settings. It reports back through "$flag":
    #   "0 <pages>" on success,  "1 0 <reason>" on failure.
    (
        set +e
        export "$@"
        lualatex -interaction=nonstopmode -file-line-error -shell-escape \
                 -output-directory="$vbuild" "$MAINTEX" > "$log" 2>&1
        if ! verify_build "$vbuild" && [[ "$VERIFY_REASON" != "PDF was not created" ]]; then
            echo "1 0 first pass aborted - ${VERIFY_REASON}" > "$flag"
            exit 1
        fi
        latexmk -auxdir="$vbuild" -outdir="$vbuild" -pdflua \
                -interaction=nonstopmode "$MAINTEX" >> "$log" 2>&1
        local lrc=$?
        if ! verify_build "$vbuild"; then
            echo "1 0 ${VERIFY_REASON} (latexmk rc=$lrc)" > "$flag"
            exit 1
        fi
        if ! cp -f "$vbuild/${MAIN}.pdf" "$out" 2>/dev/null; then
            echo "1 0 could not write $out (close any open PDF viewer)" > "$flag"
            exit 1
        fi
        echo "0 ${VERIFY_PAGES}" > "$flag"
        exit 0
    )
    local rc=$?

    if [[ $rc -eq 0 ]]; then
        echo "[$suffix] OK -> $out"
    else
        echo "[$suffix] FAILED. See log: $log"
    fi
    return $rc
}

# color와 bw 두 버전을 병렬로 빌드합니다(워터마크 버전은 만들지 않습니다).
# Build the color and bw variants in parallel (no watermark variant).
versions_build() {
    echo "========================================"
    echo "Building 2 variants in parallel:"
    echo "  1) ${MAIN}_color.pdf (그림 컬러본)"
    echo "  2) ${MAIN}_bw.pdf    (그림 흑백본, 전체 회색조)"
    echo "----------------------------------------"
    echo "(Logs: ${BUILDDIR}_<variant>.buildlog)"
    echo "========================================"

    rm -f "${BUILDDIR}_color.done" "${BUILDDIR}_bw.done" 2>/dev/null || true

    build_one "color" THESIS_FIGMODE=color THESIS_SHOW_REVISIONS="" THESIS_REV_ALLBLUE="" &
    local p_color=$!
    sleep 2
    build_one "bw" THESIS_FIGMODE=bw THESIS_SHOW_REVISIONS="" THESIS_REV_ALLBLUE="" &
    local p_bw=$!
    wait "$p_color" || true
    wait "$p_bw" || true

    echo "========================================"
    echo "Versions build summary:"
    local failed=0 v flag rc pg rs
    for v in color bw; do
        flag="${BUILDDIR}_${v}.done"
        rc=1; pg=0; rs="no completion flag (the variant process died)"
        if [[ -f "$flag" ]]; then
            read -r rc pg rs < "$flag" || true
        fi
        if [[ "$rc" == "0" ]]; then
            printf "  %-6s OK     %s pages  -> %s_%s.pdf\n" "$v" "$pg" "$MAIN" "$v"
        else
            failed=$((failed + 1))
            printf "  %-6s FAILED %s\n" "$v" "$rs"
            printf "  %-6s        log: %s_%s.buildlog\n" "" "$BUILDDIR" "$v"
        fi
    done
    echo "========================================"

    [[ $failed -eq 0 ]]
}

# 먼저 한 번 정상 빌드한 뒤, 파일 변경을 계속 감시합니다. watch 모드는 PDF
# 뷰어/편집기 연동을 위해 프로젝트 폴더에 그대로(캐시 폴더를 거치지 않고) 빌드합니다.
# First performs one full build, then continuously watches for file changes.
# Watch mode builds in place in the project folder (not the cache folder) so
# the PDF viewer/editor can follow along live.
watch_mode() {
    echo "========================================"
    echo "Initial build before starting watch mode..."
    echo "========================================"

    clean_synctex

    echo ""
    echo "========================================"
    echo "Watch mode started (Ctrl+C to stop)..."
    echo "Files will auto-rebuild on changes"
    echo "PDF will auto-refresh in viewer"
    echo ""
    echo "Watching for file changes..."
    echo "========================================"

    # latexmk의 연속 미리보기 모드로 LuaLaTeX와 biber를 사용합니다.
    # Use latexmk continuous watch mode with LuaLaTeX + biber.
    # SyncTeX는 PDF 뷰어에서 Ctrl+Click으로 원본 .tex 파일을 열 수 있게 합니다.
    # SyncTeX is enabled so Ctrl+Click in the PDF viewer can open the source .tex file.
    export LATEXMK_SYNCTEX=1
    latexmk -lualatex -usebiber -pvc -pv- -f -shell-escape -interaction=nonstopmode -file-line-error -synctex=1 "$MAINTEX"

    echo ""
    echo "Watch mode ended."
    return 0
}

# 지원하는 명령을 보여 줍니다.
# Show supported commands.
usage() {
    echo "Usage: $0 [build|quick|clean|watch|submit|review|review-blue|color|bw|versions|crops]"
    echo ""
    echo "Commands:"
    echo "  build       - Full build with bibliography (default)"
    echo "  quick       - Quick rebuild (no biber, faster)"
    echo "  clean       - Remove all build artifacts"
    echo "  watch       - Watch mode (auto-rebuild on changes)"
    echo "  submit      - Final submission build (revision marks OFF)"
    echo "  review      - Review build (revision marks ON, per-examiner colors)"
    echo "  review-blue - Review build (all revision marks unified to blue)"
    echo "  color       - Color build (use *_color figures, keep colors)"
    echo "  bw          - B&W build (use *_bw figures, grayscale everything)"
    echo "  versions    - Build color and bw variants in parallel"
    echo "  crops       - Build crop_debug.pdf for image cropping"
    return 1
}

# 선택된 명령으로 분기하고, 빌드 계열 명령에는 잠금 폴더를 적용합니다.
# Dispatch to the selected command and apply the lock folder to build-like commands.
case "$COMMAND" in
    clean)
        # clean은 TeX 도구 확인 없이 실행되며, 잠금 없이 남은 파일을 정리합니다.
        # clean runs without checking TeX tools and removes stale files without acquiring a build lock.
        clean_build
        exit 0
        ;;
    crops)
        # crops는 crop_debug.pdf만 만들며 일반 논문 PDF 빌드와 분리되어 있습니다.
        # crops builds only crop_debug.pdf and is separate from the main thesis build.
        crops_build
        exit $?
        ;;
    build)
        # build, quick, watch는 같은 보조 파일을 쓰므로 잠금이 필요합니다.
        # build, quick, and watch share auxiliary files, so they require a lock.
        if ! acquire_lock; then
            exit 1
        fi
        trap release_lock EXIT
        full_build
        exit $?
        ;;
    submit)
        # 최종 제출본: 수정 표시를 모두 끕니다(검정 본문).
        # Final submission: turn all revision marks OFF.
        if ! acquire_lock; then
            exit 1
        fi
        trap release_lock EXIT
        export THESIS_SHOW_REVISIONS=""
        export THESIS_REV_ALLBLUE=""
        profiled_build "제출본"
        exit $?
        ;;
    review)
        # 검토본: 수정 표시 켬(심사위원별 색상).
        # Review copy: revision marks ON with per-examiner colors.
        if ! acquire_lock; then
            exit 1
        fi
        trap release_lock EXIT
        export THESIS_SHOW_REVISIONS="1"
        export THESIS_REV_ALLBLUE=""
        profiled_build "수정표시_심사위원별색상"
        exit $?
        ;;
    reviewblue)
        # 검토본: 수정 표시 켬(전체 파란색 통일).
        # Review copy: revision marks ON, all unified to blue.
        if ! acquire_lock; then
            exit 1
        fi
        trap release_lock EXIT
        export THESIS_SHOW_REVISIONS="1"
        export THESIS_REV_ALLBLUE="1"
        profiled_build "수정표시_전체파란색"
        exit $?
        ;;
    color)
        # 컬러 빌드: 그림 컬러본(\figf -> *_color) 사용, 회색조 변환 안 함.
        # Color build: use *_color figure variants, keep colors (no grayscale).
        if ! acquire_lock; then
            exit 1
        fi
        trap release_lock EXIT
        export THESIS_SHOW_REVISIONS=""
        export THESIS_REV_ALLBLUE=""
        export THESIS_FIGMODE="color"
        profiled_build "컬러"
        exit $?
        ;;
    bw)
        # 흑백 빌드: 그림 흑백본(\figf -> *_bw) 사용, 전체 회색조 변환.
        # B&W build: use *_bw figure variants, convert everything to grayscale.
        if ! acquire_lock; then
            exit 1
        fi
        trap release_lock EXIT
        export THESIS_SHOW_REVISIONS=""
        export THESIS_REV_ALLBLUE=""
        export THESIS_FIGMODE="bw"
        profiled_build "흑백"
        exit $?
        ;;
    versions)
        # 컬러본 + 흑백본을 각자 독립된 폴더에서 동시에 빌드합니다.
        # Build the color and bw variants concurrently in isolated folders.
        if ! acquire_lock; then
            exit 1
        fi
        trap release_lock EXIT
        versions_build
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
