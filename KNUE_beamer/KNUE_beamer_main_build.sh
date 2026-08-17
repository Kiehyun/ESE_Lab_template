#!/usr/bin/env bash

# 한국교원대학교 Beamer 발표 템플릿의 macOS/Linux 빌드 스크립트입니다.
# macOS/Linux build script for the KNUE Beamer presentation template.

set -euo pipefail

# 스크립트가 어느 위치에서 실행되더라도 KNUE_beamer 폴더로 이동합니다.
# Move to the KNUE_beamer folder no matter where the script is launched from.
cd "$(dirname "$0")"

# 빌드할 메인 파일입니다.
# Main file to build.
main="KNUE_beamer_main.tex"

# 첫 번째 인자로 build, quick, watch, clean 중 하나를 받습니다. 기본값은 build입니다.
# Read the first argument as build, quick, watch, or clean. Default is build.
case "${1:-build}" in
  build)
    # 전체 빌드입니다. LuaLaTeX와 biber가 latexmk 규칙에 따라 실행됩니다.
    # Full build. latexmk runs LuaLaTeX and biber as needed.
    latexmk -pdf -lualatex -interaction=nonstopmode -file-line-error "$main"
    ;;
  quick)
    # 빠른 재빌드입니다. 작은 수정 확인용으로 사용합니다.
    # Quick rebuild for checking small edits.
    latexmk -pdf -lualatex -interaction=nonstopmode -file-line-error -use-make "$main"
    ;;
  watch)
    # 파일 변경을 감시하며 자동으로 다시 빌드합니다.
    # Watch files and rebuild automatically.
    latexmk -pdf -lualatex -pvc -pv- -interaction=nonstopmode -file-line-error "$main"
    ;;
  clean)
    # 빌드 산출물을 정리합니다.
    # Clean generated build artifacts.
    latexmk -C "$main"
    ;;
  *)
    # 잘못된 명령을 입력했을 때 사용법을 출력합니다.
    # Print usage when an unknown command is provided.
    echo "Usage: $0 [build|quick|watch|clean]" >&2
    exit 1
    ;;
esac
