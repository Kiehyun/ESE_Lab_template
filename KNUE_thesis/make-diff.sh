#!/usr/bin/env bash
# ===========================================================================
# make-diff.sh - 기준 커밋(git) 대비 "수정사항 추적(track-changes)" PDF를 만든다.
#                Build a track-changes PDF against a base git commit.
# (Windows Git Bash / macOS / Linux 공용)
#
#   사용법 / Usage:  ./make-diff.sh [기준커밋 BASE_COMMIT] [--no-build]
#
#   기준커밋 BASE_COMMIT : 비교 기준 git 커밋/태그/브랜치 (기본값 HEAD)
#                          OLD = 기준커밋 시점의 원고, NEW = 현재 작업트리
#   --no-build           : diff용 .tex 만 만들고 PDF 컴파일은 건너뜀
#
#   예) ./make-diff.sh              # 마지막 커밋 이후의 (미커밋) 변경분
#       ./make-diff.sh v1.0         # 태그 v1.0 이후의 모든 변경분
#       ./make-diff.sh 3a1c9ef      # 특정 커밋 이후의 변경분
#
#   결과물 / Output: KNUE_thesis_main-diff<짧은해시>.pdf
#                    (추가=파랑 added=blue, 삭제=빨강 취소선 deleted=red strikeout)
#
#   ※ 이 스크립트는 git 이력(커밋)이 있어야 동작한다. 두 시점의 원고를 비교하므로
#      최소 한 번은 커밋해 두어야 한다. (심사위원별 "색상 표시" 기능과는 별개이며,
#      그 기능은 sub/0-preamble.tex 의 \revised / \revisedA..D 매크로를 사용한다.)
#      This needs git history: commit at least once so two versions can be compared.
#      It is independent of the per-examiner color macros (\revised, \revisedA..D)
#      defined in sub/0-preamble.tex.
#
#   주의: 본문 + sub/ 챕터의 변경만 표시된다. latexpand 가 따라가지 못하는
#         부록(\input 이 아닌 커스텀 매크로로 불러오는 자료)의 변경은 표시되지 않는다.
# ===========================================================================
set -e
cd "$(dirname "$0")"

MAIN="KNUE_thesis_main"
MAINTEX="${MAIN}.tex"
SYNCTEX="0"

BASE="HEAD"
DOBUILD=1
for a in "$@"; do
  case "$a" in
    --no-build|-n) DOBUILD=0 ;;
    *) BASE="$a" ;;
  esac
done

for cmd in git latexpand latexdiff latexmk lualatex biber; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Error: $cmd 가 설치되어 있지 않거나 PATH 에 없습니다."; exit 1; }
done
[[ -f "$MAINTEX" ]] || { echo "Error: $MAINTEX 가 현재 폴더에 없습니다."; exit 1; }

SHORTHASH="$(git rev-parse --short "$BASE" 2>/dev/null || true)"
[[ -n "$SHORTHASH" ]] || { echo "Error: '$BASE' 는 유효한 git 커밋이 아닙니다."; echo "사용법: $0 [기준커밋] [--no-build]"; exit 1; }
SUBJECT="$(git log -1 --format=%s "$BASE" 2>/dev/null || true)"

DIFFNAME="${MAIN}-diff${SHORTHASH}"
DIFFTEX="${DIFFNAME}.tex"

CACHE_BASE="${XDG_CACHE_HOME:-$HOME/.cache}"
WORK="${BUILDDIR:-${CACHE_BASE}/latexbuild/diff}"
OLDDIR="$WORK/old"; LDTMP="$WORK/_ldtmp"; OUT="$WORK/out"
rm -rf "$WORK"; mkdir -p "$OLDDIR" "$LDTMP" "$OUT"

echo "========================================"
echo " diff 생성: $DIFFTEX"
echo "   OLD = $SHORTHASH  ($SUBJECT)"
echo "   NEW = 현재 작업트리(저장된 파일)"
echo "========================================"

echo "[1/4] $BASE ($SHORTHASH) 시점의 소스 추출..."
# 평탄화에 필요한 것은 본문 + sub/ 뿐(latexpand 가 따라가는 \input/\include 는 모두 sub/).
git archive "$BASE" "$MAINTEX" sub | tar -x -C "$OLDDIR"
[[ -f "$OLDDIR/$MAINTEX" ]] || { echo "Error: 기준 커밋에서 소스 추출 실패."; exit 1; }

echo "[2/4] OLD / NEW 평탄화(latexpand)..."
( cd "$OLDDIR" && latexpand "$MAINTEX" > "$LDTMP/old_flat.tex" 2> "$LDTMP/old_flat.log" )
latexpand "$MAINTEX" > "$LDTMP/new_flat.tex" 2> "$LDTMP/new_flat.log"

echo "[3/4] latexdiff 실행..."
# 이 템플릿은 커스터마이즈가 많아 latexdiff 기본값이 여러 곳에서 깨진다. 아래 옵션으로
# 컴파일 가능한 diff 를 만든다(본문 산문 변경은 깔끔하게 표시됨):
#   --type=CFONT           ulem 대신 색상 마크업 → 제목/표의 "paragraph ended" 오류 회피.
#   --exclude-textcmd      인용의 선택 인자([..])까지 파고들지 않도록 → 불균형 \DIFdel 방지.
#   --append-safecmd       커스텀 그래픽 래퍼를 통째로 취급 → 이미지 경로의 '_' 깨짐 방지.
#   --graphics-markup=none \includegraphics 를 \DIFadd 변형으로 감싸지 않음.
#   PICTUREENV             figure/table/tabular 환경을 통째로 취급 → 변경된 표·그림은
#                          셀 단위가 아니라 블록 전체 추가/삭제로 표시(깨짐 방지).
CITECMDS="cite,parencite,textcite,kparencite,ktextcite,autocite,citeauthor,citeyear,citetitle,footcite,parencites,textcites"
SAFECMDS="includegraphics"
PICENV='(?:picture|tikzpicture|pspicture|figure\*?|table\*?|tabularx?\*?|longtable\*?|threeparttable|DIFnomarkup)'
latexdiff --encoding=utf8 --type=CFONT --exclude-textcmd="$CITECMDS" --append-safecmd="$SAFECMDS" --graphics-markup=none --config="PICTUREENV=$PICENV" "$LDTMP/old_flat.tex" "$LDTMP/new_flat.tex" > "$DIFFTEX" 2> "$LDTMP/latexdiff.log" || {
  echo "Error: latexdiff 실패. 로그: $LDTMP/latexdiff.log"; exit 1; }
[[ -s "$DIFFTEX" ]] || { echo "Error: 생성된 $DIFFTEX 가 비어 있음. 로그: $LDTMP/latexdiff.log"; exit 1; }
echo "  생성됨: $DIFFTEX  ($(wc -c < "$DIFFTEX") bytes)"
echo "  (latexdiff 의 한글 가운뎃점 '·' 관련 경고는 무시해도 됩니다.)"

if [[ "$DOBUILD" == "0" ]]; then
  echo "--no-build: PDF 컴파일은 건너뜁니다."
  echo "직접 빌드하려면:  latexmk -pdflua -shell-escape -interaction=nonstopmode \"$DIFFTEX\""
  echo "완료: $DIFFTEX"
  exit 0
fi

echo "[4/4] PDF 빌드 (LuaLaTeX + biber, 강제 모드)..."
# latexdiff 마크업이 복잡한 그림/제목 한두 곳을 건드릴 수 있어 강제 모드(-f)로 빌드하고,
# 성공 판정은 종료 코드가 아니라 PDF 생성 여부로 한다(1차 패스 종료 코드는 무시).
lualatex -synctex=$SYNCTEX -interaction=nonstopmode -file-line-error -shell-escape -output-directory="$OUT" "$DIFFTEX" || true
latexmk -auxdir="$OUT" -outdir="$OUT" -pdflua -f -synctex=$SYNCTEX -interaction=nonstopmode "$DIFFTEX" || true
[[ -f "$OUT/$DIFFNAME.pdf" ]] || { echo "Error: PDF 미생성. 로그: $OUT/$DIFFNAME.log"; exit 1; }
cp -f "$OUT/$DIFFNAME.pdf" "$DIFFNAME.pdf"

echo "========================================"
echo " 완료: $DIFFNAME.pdf"
echo "   $SHORTHASH 이후의 변경 (추가=파랑, 삭제=빨강 취소선)"
echo "========================================"
