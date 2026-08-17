# 이 스크립트는 `sub/references.bib`의 BibTeX 항목과 `ref` 폴더에 들어 있는
# 참고문헌 PDF 파일을 서로 대조하여, PDF 파일명을 참고문헌 형식의 읽기 쉬운
# 이름으로 정리하는 도구이다.
#
# 기본 실행 흐름
# 1. 기본 BibTeX 파일인 `sub/references.bib`를 읽고 각 항목의 저자, 연도,
#    제목, 학술지/출판처 정보를 파싱한다.
# 2. 기본 AUX 패턴인 `KH_thesis_main_*.aux`에서 실제 원고에 인용된 citation key를
#    읽는다. submission/review/final 빌드 보조 파일을 함께 보므로, 특정 빌드
#    모드의 aux만 보고 인용 PDF를 미인용으로 판단하는 일을 줄인다.
#    기본값은 `--cited-only`이므로, BibTeX 전체가
#    아니라 현재 원고에 실제로 인용된 항목만 PDF 매칭 대상으로 삼는다.
# 3. 기본 PDF 폴더인 `ref`에서 `*.pdf` 파일을 모두 찾는다.
# 4. 각 PDF의 파일명과, 가능하면 PDF 앞부분 텍스트를 추출하여 BibTeX 항목과
#    비교한다. 텍스트 추출은 먼저 PyMuPDF(`fitz`)를 사용하고, 실패하면
#    `pypdf`로 한 번 더 시도한다.
# 5. BibTeX citation key, 제목, 저자, 연도, 참고문헌 문자열, PDF 파일명,
#    PDF 본문 텍스트를 종합해 유사도 점수를 계산한다. 점수가
#    `MIN_MATCH_SCORE` 이상이면 해당 PDF를 BibTeX 항목과 매칭한다.
# 6. 매칭된 PDF는 BibTeX 항목에서 만든 참고문헌 문자열을 기반으로
#    `저자. (연도). 제목. 저널.pdf` 형태의 파일명으로 정리한다. 파일명에는
#    Windows에서 사용할 수 없는 문자와 너무 긴 UTF-8 이름을 자동으로 정리한다.
# 7. 매칭되지 않은 PDF는 기본적으로 `_NOT_CITED-` 접두어를 붙여 현재 원고에서
#    인용되지 않았거나 매칭에 실패한 파일임을 표시한다. 이 동작은
#    `--no-mark-unmatched`로 끌 수 있다.
# 8. 실행 결과는 CSV 보고서 세 개로 저장한다.
#    - `ref/reference_pdf_rename_log.csv`: 각 PDF의 매칭/변경 상태, 점수, 이유
#    - `ref/reference_pdf_unmatched_candidates.csv`: 미매칭 PDF의 후보 항목
#    - `ref/references_missing_in_ref.csv`: 인용되었지만 PDF가 없는 참고문헌
#
# 기본값과 주요 옵션
# - 기본 BibTeX: `sub/references.bib`
# - 기본 AUX 패턴: `KH_thesis_main_*.aux`
# - 기본 원본/대상 PDF 폴더: `ref`
# - 기본 보고서 폴더: `ref`
# - 기본은 dry-run이 아니므로 실제 파일 이름을 바꾸거나 복사/이동한다.
# - `--dry-run`: 파일은 건드리지 않고 CSV 보고서만 만든다.
# - `--move`: 대상 폴더가 다를 때 복사 대신 이동한다.
# - `--no-cited-only`: 현재 원고 인용 여부와 관계없이 BibTeX 전체와 매칭한다.
# - `--no-pdf-text`: PDF 본문 추출 없이 파일명만으로 매칭한다.
# - `--pdf-pages N`: PDF 앞부분 몇 페이지를 읽을지 지정한다. 기본값은 3쪽이다.
#
# 주의 사항
# - 같은 폴더 안에서 실행할 때 매칭된 PDF는 사실상 rename되고, 대상 폴더를
#   따로 지정하면 기본적으로 copy된다. `--move`를 주면 move된다.
# - PDF 텍스트 추출이 되지 않는 스캔본은 파일명 기반 매칭에 더 의존한다.
# - 매칭 기준은 보수적으로 설정되어 있으나, 자동 정리 도구이므로 중요한
#   변경 전에는 `--dry-run`으로 CSV 보고서를 먼저 확인하는 것이 좋다.
from __future__ import annotations
# /// script
# dependencies = ["pymupdf>=1.24.0", "pypdf>=6.0.0"]
# ///

import argparse
import csv
import hashlib
import re
import shutil
import sys
import unicodedata
from dataclasses import dataclass
from difflib import SequenceMatcher
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_BIB = ROOT / "sub" / "references.bib"
DEFAULT_REF_DIR = ROOT / "ref"
DEFAULT_SOURCE_REF_DIR = DEFAULT_REF_DIR
DEFAULT_REPORT_DIR = ROOT / "ref"
DEFAULT_AUX = ROOT / "KH_thesis_main_*.aux"
MAX_FILENAME_BYTES = 100
MAX_UNUSED_FILENAME_BYTES = 140
MIN_MATCH_SCORE = 0.85
DEFAULT_PDF_TEXT_PAGES = 3
MAX_PDF_TEXT_CHARS = 12000
DEFAULT_UNUSED_PREFIX = "_NOT_CITED-"
UNUSED_PREFIX_PATTERNS = (
    re.compile(r"^(?:_?NOT_CITED\s*-\s*)+", re.I),
)


def safe_console_text(value: object) -> str:
    text = str(value).replace("\ufffd", "?")
    encoding = sys.stdout.encoding or "utf-8"
    return text.encode(encoding, errors="replace").decode(encoding, errors="replace")


def log(message: object) -> None:
    print(safe_console_text(message))


@dataclass
class BibEntry:
    entry_type: str
    key: str
    fields: dict[str, str]
    reference_text: str
    filename_stem: str
    search_text: str


@dataclass
class PdfMatch:
    pdf_path: Path
    entry: BibEntry | None
    score: float
    reason: str


@dataclass
class PdfInfo:
    path: Path
    text: str
    text_error: str = ""


def strip_outer_braces(value: str) -> str:
    value = value.strip().rstrip(",").strip()
    if len(value) >= 2 and value[0] == "{" and value[-1] == "}":
        return value[1:-1].strip()
    if len(value) >= 2 and value[0] == '"' and value[-1] == '"':
        return value[1:-1].strip()
    return value


def clean_latex(value: str) -> str:
    replacements = {
        r"{\&}": "&",
        r"\&": "&",
        r"\%": "%",
        r"\_": "_",
        r"\textendash": "-",
        r"\textemdash": "-",
        r"---": "-",
        r"--": "-",
        r"\ldots{}": "...",
        r"\ldots": "...",
    }
    for old, new in replacements.items():
        value = value.replace(old, new)
    value = re.sub(r"\\[a-zA-Z]+\*?(?:\[[^\]]*\])?(?:\{([^{}]*)\})", r"\1", value)
    value = re.sub(r"\\[\"'`^~=.]?\{?([A-Za-z])\}?", r"\1", value)
    value = value.replace("{", "").replace("}", "")
    value = re.sub(r"\s+", " ", value)
    return value.strip()


def parse_fields(body: str) -> dict[str, str]:
    body = "\n".join(line for line in body.splitlines() if not line.lstrip().startswith("%"))
    fields: dict[str, str] = {}
    i = 0
    n = len(body)
    while i < n:
        while i < n and body[i] in " \t\r\n,":
            i += 1
        name_start = i
        while i < n and re.match(r"[A-Za-z0-9_-]", body[i]):
            i += 1
        if i == name_start:
            i += 1
            continue
        name = body[name_start:i].strip().lower()
        while i < n and body[i].isspace():
            i += 1
        if i >= n or body[i] != "=":
            continue
        i += 1
        while i < n and body[i].isspace():
            i += 1
        if i >= n:
            break
        if body[i] == "{":
            depth = 0
            value_start = i
            while i < n:
                if body[i] == "{":
                    depth += 1
                elif body[i] == "}":
                    depth -= 1
                    if depth == 0:
                        i += 1
                        break
                i += 1
            raw = body[value_start:i]
        elif body[i] == '"':
            value_start = i
            i += 1
            while i < n:
                if body[i] == '"' and body[i - 1] != "\\":
                    i += 1
                    break
                i += 1
            raw = body[value_start:i]
        else:
            value_start = i
            while i < n and body[i] not in ",\r\n":
                i += 1
            raw = body[value_start:i]
        fields[name] = clean_latex(strip_outer_braces(raw))
    return fields


def parse_bib(path: Path) -> list[BibEntry]:
    text = path.read_text(encoding="utf-8-sig")
    pattern = re.compile(r"(?ms)^@(\w+)\s*\{\s*([^,]+)\s*,(.*?)(?=^@\w+\s*\{|\Z)")
    entries: list[BibEntry] = []
    for entry_type, key, body in pattern.findall(text):
        fields = parse_fields(body)
        reference_text = make_reference_text(fields)
        entries.append(
            BibEntry(
                entry_type=entry_type,
                key=key.strip(),
                fields=fields,
                reference_text=reference_text,
                filename_stem=truncate_utf8(safe_filename(reference_text), MAX_FILENAME_BYTES),
                search_text=make_search_text(key, fields, reference_text),
            )
        )
    return entries


def parse_cited_keys(path: Path) -> list[str]:
    paths = resolve_aux_paths(path)
    keys: list[str] = []
    seen: set[str] = set()
    patterns = [
        re.compile(r"\\abx@aux@cite\{[^{}]*\}\{([^{}]+)\}"),
        re.compile(r"\\citation\{([^{}]+)\}"),
    ]
    for aux_path in paths:
        text = aux_path.read_text(encoding="utf-8", errors="ignore")
        for pattern in patterns:
            for match in pattern.findall(text):
                for key in match.split(","):
                    key = key.strip()
                    if key and key not in seen:
                        seen.add(key)
                        keys.append(key)
    return keys


def resolve_aux_paths(path: Path) -> list[Path]:
    raw = str(path)
    if any(char in raw for char in "*?[]"):
        parent = path.parent if str(path.parent) else Path(".")
        return sorted(p for p in parent.glob(path.name) if p.is_file())
    return [path] if path.is_file() else []


def split_authors(author: str) -> list[str]:
    if not author:
        return []
    author = author.replace(" and others", "")
    return [clean_latex(part).strip() for part in re.split(r"\s+and\s+", author) if part.strip()]


def author_label(author: str, langid: str = "") -> str:
    authors = split_authors(author)
    if not authors:
        return ""
    if langid.lower() == "korean":
        return ", ".join(authors)
    if len(authors) == 1:
        return authors[0]
    if len(authors) == 2:
        return f"{authors[0]} & {authors[1]}"
    return f"{authors[0]} et al."


def make_reference_text(fields: dict[str, str]) -> str:
    author = fields.get("author") or fields.get("editor") or fields.get("institution") or fields.get("organization") or ""
    year = fields.get("year", "n.d.")
    title = fields.get("title", "").rstrip(".")
    container = (
        fields.get("journal")
        or fields.get("booktitle")
        or fields.get("publisher")
        or fields.get("institution")
        or fields.get("howpublished")
        or ""
    )
    parts = []
    if author:
        parts.append(author_label(author, fields.get("langid", "")))
    if year:
        parts.append(f"({year})")
    if title:
        parts.append(title)
    if container:
        parts.append(container)
    return ". ".join(part.strip().rstrip(".") for part in parts if part.strip()) + "."


def safe_filename(text: str) -> str:
    text = unicodedata.normalize("NFC", text)
    text = re.sub(r'[<>:"/\\|?*\x00-\x1f]', " ", text)
    text = re.sub(r"\s+", " ", text).strip()
    text = text.rstrip(" .")
    reserved = {
        "CON",
        "PRN",
        "AUX",
        "NUL",
        "COM1",
        "COM2",
        "COM3",
        "COM4",
        "COM5",
        "COM6",
        "COM7",
        "COM8",
        "COM9",
        "LPT1",
        "LPT2",
        "LPT3",
        "LPT4",
        "LPT5",
        "LPT6",
        "LPT7",
        "LPT8",
        "LPT9",
    }
    if not text or text.upper() in reserved:
        return "reference"
    return text


def strip_unused_prefixes(text: str) -> str:
    for pattern in UNUSED_PREFIX_PATTERNS:
        text = pattern.sub("", text)
    return text.strip()


def truncate_utf8(text: str, max_bytes: int) -> str:
    while len(text.encode("utf-8")) > max_bytes:
        text = text[:-1].rstrip()
    return text.rstrip(" .") or "reference"


def normalize(text: str) -> str:
    text = clean_latex(unicodedata.normalize("NFKC", text)).lower()
    text = re.sub(r"[^0-9a-z가-힣]+", " ", text)
    text = re.sub(r"\s+", " ", text).strip()
    return text


def has_hangul(text: str) -> bool:
    return bool(re.search(r"[가-힣]", text))


def compact_key(key: str) -> str:
    return normalize(re.sub(r"^(kor|eng)_", "", key, flags=re.I))


def split_key_for_search(key: str) -> str:
    key = re.sub(r"^(kor|eng)_", "", key, flags=re.I)
    key = re.sub(r"[_-]+", " ", key)
    key = re.sub(r"(?<=[가-힣A-Za-z])(?=\d)", " ", key)
    key = re.sub(r"(?<=\d)(?=[가-힣A-Za-z])", " ", key)
    key = re.sub(r"(?<=[a-z])(?=[A-Z])", " ", key)
    return normalize(key)


# Project-local override: the original Hangul ranges above may be damaged when
# this file is opened in a legacy console encoding. Keep the corrected versions
# close to the matching logic so Korean filenames and BibTeX entries are handled
# consistently on Windows.
def normalize(text: str) -> str:  # type: ignore[no-redef]
    text = clean_latex(unicodedata.normalize("NFKC", text)).lower()
    text = re.sub(r"[^0-9a-z가-힣ㄱ-ㅎㅏ-ㅣ]+", " ", text)
    text = re.sub(r"\s+", " ", text).strip()
    return text


def has_hangul(text: str) -> bool:  # type: ignore[no-redef]
    return bool(re.search(r"[가-힣ㄱ-ㅎㅏ-ㅣ]", text))


def split_key_for_search(key: str) -> str:  # type: ignore[no-redef]
    key = re.sub(r"^(kor|eng)_", "", key, flags=re.I)
    key = re.sub(r"[_-]+", " ", key)
    key = re.sub(r"(?<=[가-힣ㄱ-ㅎㅏ-ㅣA-Za-z])(?=\d)", " ", key)
    key = re.sub(r"(?<=\d)(?=[가-힣ㄱ-ㅎㅏ-ㅣA-Za-z])", " ", key)
    key = re.sub(r"(?<=[a-z])(?=[A-Z])", " ", key)
    return normalize(key)


def make_search_text(key: str, fields: dict[str, str], reference_text: str) -> str:
    chunks = [
        key,
        compact_key(key),
        split_key_for_search(key),
        reference_text,
        fields.get("title", ""),
        fields.get("author", ""),
        fields.get("editor", ""),
        fields.get("journal", ""),
        fields.get("booktitle", ""),
        fields.get("publisher", ""),
        fields.get("institution", ""),
        fields.get("year", ""),
    ]
    return normalize(" ".join(chunks))


def token_score(a: str, b: str) -> float:
    at = set(a.split())
    bt = set(b.split())
    if not at or not bt:
        return 0.0
    inter = len(at & bt)
    return inter / max(1, min(len(at), len(bt)))


def extract_pdf_text(path: Path, max_pages: int, max_chars: int = MAX_PDF_TEXT_CHARS) -> tuple[str, str]:
    errors: list[str] = []
    try:
        import fitz

        # Some otherwise readable PDFs emit MuPDF diagnostics such as
        # "format error: No default Layer config" while opening optional layers.
        # Keep those messages out of the console and fall back to pypdf only if
        # text extraction actually fails.
        old_errors = fitz.TOOLS.mupdf_display_errors(False)
        old_warnings = fitz.TOOLS.mupdf_display_warnings(False)
        try:
            doc = fitz.open(path)
            chunks: list[str] = []
            for page in doc[:max_pages]:
                chunks.append(page.get_text() or "")
                text = "\n".join(chunks)
                if len(text) >= max_chars:
                    doc.close()
                    return text[:max_chars], ""
            doc.close()
            text = "\n".join(chunks)[:max_chars]
        finally:
            fitz.TOOLS.mupdf_display_errors(old_errors)
            fitz.TOOLS.mupdf_display_warnings(old_warnings)
        if text.strip():
            return text, ""
    except Exception as exc:  # pragma: no cover - depends on runtime environment
        errors.append(f"pymupdf-failed: {exc}")

    try:
        from pypdf import PdfReader
    except Exception as exc:  # pragma: no cover - depends on runtime environment
        errors.append(f"pypdf-import-failed: {exc}")
        return "", "; ".join(errors)

    try:
        reader = PdfReader(str(path))
        chunks: list[str] = []
        for page in reader.pages[:max_pages]:
            try:
                chunks.append(page.extract_text() or "")
            except Exception as exc:
                chunks.append(f" [page-text-error: {exc}] ")
            text = "\n".join(chunks)
            if len(text) >= max_chars:
                return text[:max_chars], ""
        text = "\n".join(chunks)[:max_chars]
        if text.strip():
            return text, ""
        errors.append("no extractable text")
        return "", "; ".join(errors)
    except Exception as exc:
        errors.append(f"pypdf-read-failed: {exc}")
        return "", "; ".join(errors)


def build_pdf_infos(pdf_paths: list[Path], max_pages: int) -> list[PdfInfo]:
    infos: list[PdfInfo] = []
    for pdf in pdf_paths:
        text, error = extract_pdf_text(pdf, max_pages=max_pages)
        infos.append(PdfInfo(path=pdf, text=text, text_error=error))
    return infos


def score_text_against_entry(text_norm: str, entry: BibEntry, source: str) -> tuple[float, str]:
    if not text_norm:
        return 0.0, f"{source}=empty"

    is_pdf_text = source.startswith("pdf-")
    title_norm = normalize(entry.fields.get("title", ""))
    ref_norm = normalize(entry.reference_text)
    author_norm = normalize(entry.fields.get("author", ""))
    doi_norm = normalize(entry.fields.get("doi", ""))
    url_norm = normalize(entry.fields.get("url", ""))
    key_norm = compact_key(entry.key)
    key_split_norm = split_key_for_search(entry.key)
    year = normalize(entry.fields.get("year", ""))
    year_present = bool(year and year in text_norm)

    if not is_pdf_text and key_norm and key_norm in text_norm:
        return 0.99, "citation-key"
    if not is_pdf_text and doi_norm and doi_norm in text_norm:
        return 0.99, "doi"
    if not is_pdf_text and url_norm and len(url_norm) >= 12 and url_norm in text_norm:
        return 0.98, "url"
    if not is_pdf_text and key_split_norm and len(key_split_norm) >= 8:
        key_tokens = token_score(text_norm, key_split_norm)
        if key_tokens >= 0.80:
            return 0.96, f"citation-key-tokens={key_tokens:.2f}"
    if not is_pdf_text and title_norm and len(title_norm) >= 18 and (title_norm in text_norm or text_norm in title_norm):
        title_score = 0.97 if is_pdf_text and year_present else 0.95
        return title_score, "title-substring"
    if not is_pdf_text and ref_norm and len(text_norm) >= 18 and text_norm in ref_norm:
        return 0.93, "reference-substring"

    title_tokens = token_score(text_norm, title_norm)
    ref_tokens = token_score(text_norm, ref_norm)
    author_tokens = token_score(text_norm, author_norm)
    key_tokens = 0.0 if is_pdf_text else token_score(text_norm, key_split_norm)
    seq = SequenceMatcher(None, text_norm[:260], ref_norm[:260]).ratio() if text_norm and ref_norm else 0.0
    year_bonus = 0.05 if year_present else 0.0

    if is_pdf_text:
        # Full PDF text often contains bibliography sections, so avoid matching by citation
        # keys or broad reference text. Trust it only when the article identity appears
        # near enough through title, author, and year evidence.
        if doi_norm and doi_norm in text_norm and (title_tokens >= 0.50 or author_tokens >= 0.20):
            return 0.99, f"pdf-doi title={title_tokens:.2f} author={author_tokens:.2f}"
        if url_norm and len(url_norm) >= 12 and url_norm in text_norm and (title_tokens >= 0.50 or author_tokens >= 0.20):
            return 0.98, f"pdf-url title={title_tokens:.2f} author={author_tokens:.2f}"
        if year_present and title_tokens >= 0.90 and author_tokens >= 0.25:
            score = title_tokens * 0.80 + author_tokens * 0.10 + 0.10
            return min(score, 0.96), f"pdf-strong-title-author-year title={title_tokens:.2f} author={author_tokens:.2f}"
        if year_present and title_tokens >= 0.65 and author_tokens >= 0.20:
            score = title_tokens * 0.70 + author_tokens * 0.20 + 0.10
            return min(score, 0.96), f"pdf-title-author-year title={title_tokens:.2f} author={author_tokens:.2f}"
        if year_present and title_tokens >= 0.52 and author_tokens >= 0.50:
            score = title_tokens * 0.62 + author_tokens * 0.28 + 0.10
            return min(score, 0.93), f"pdf-author-title-year title={title_tokens:.2f} author={author_tokens:.2f}"
        score = title_tokens * 0.70 + author_tokens * 0.18 + year_bonus
        reason = f"pdf-text-fuzzy title={title_tokens:.2f} author={author_tokens:.2f} year={int(year_present)}"
        return min(score, 0.84), reason

    if year_present and author_tokens >= 0.50 and title_tokens >= 0.45:
        score = title_tokens * 0.55 + author_tokens * 0.35 + 0.10
        return min(score, 0.94), f"author-year-title title={title_tokens:.2f} author={author_tokens:.2f}"
    if year_present and ref_tokens >= 0.72:
        return min(ref_tokens + 0.08, 0.92), f"reference-with-year={ref_tokens:.2f}"

    score = max(title_tokens * 0.75 + author_tokens * 0.15, ref_tokens * 0.70, key_tokens * 0.82, seq * 0.62) + year_bonus
    reason = f"{source}-fuzzy title={title_tokens:.2f} ref={ref_tokens:.2f} author={author_tokens:.2f} key={key_tokens:.2f} seq={seq:.2f}"
    return min(score, 0.90), reason


def score_pdf(pdf_info: PdfInfo, entry: BibEntry) -> tuple[float, str]:
    stem_score, stem_reason = score_text_against_entry(normalize(strip_unused_prefixes(pdf_info.path.stem)), entry, "filename")
    text_score, text_reason = score_text_against_entry(normalize(pdf_info.text[:2500]), entry, "pdf-head")
    langid = normalize(entry.fields.get("langid", ""))
    if (
        langid == "english"
        and has_hangul(pdf_info.text)
        and text_score > stem_score
        and stem_score < MIN_MATCH_SCORE
    ):
        text_score = min(text_score, MIN_MATCH_SCORE - 0.01)
        text_reason = f"pdf-text-language-mismatch; {text_reason}"
    if text_score >= 0.80 and stem_score >= 0.60:
        return min(max(text_score, stem_score) + 0.04, 0.98), f"combined filename={stem_score:.2f} pdf-text={text_score:.2f}"
    if text_score > stem_score:
        return text_score, text_reason
    return stem_score, stem_reason


def top_candidate_entries(pdf_info: PdfInfo, entries: list[BibEntry], limit: int = 5) -> list[tuple[float, str, BibEntry]]:
    candidates = []
    for entry in entries:
        score, reason = score_pdf(pdf_info, entry)
        candidates.append((score, reason, entry))
    candidates.sort(key=lambda item: item[0], reverse=True)
    return candidates[:limit]


def make_unique_path(path: Path, reserved: set[Path]) -> Path:
    if path not in reserved and not path.exists():
        return path
    stem = path.stem
    suffix = path.suffix
    for i in range(2, 1000):
        marker = f" ({i})"
        base = truncate_utf8(stem, MAX_FILENAME_BYTES - len(marker.encode("utf-8")))
        candidate = path.with_name(f"{base}{marker}{suffix}")
        if candidate not in reserved and not candidate.exists():
            return candidate
    raise RuntimeError(f"Cannot create unique filename for {path}")


def make_unused_target(pdf_path: Path, prefix: str, reserved: set[Path]) -> Path:
    if pdf_path.stem.startswith(prefix.rstrip()):
        return pdf_path
    clean_stem = strip_unused_prefixes(pdf_path.stem)
    stem = truncate_utf8(safe_filename(f"{prefix}{clean_stem}"), MAX_UNUSED_FILENAME_BYTES)
    return make_unique_path(pdf_path.with_name(f"{stem}{pdf_path.suffix}"), reserved)


def match_pdfs(pdf_infos: list[PdfInfo], entries: list[BibEntry]) -> list[PdfMatch]:
    best_candidates: list[tuple[float, str, PdfInfo, BibEntry]] = []
    below_threshold: dict[Path, tuple[float, str, BibEntry | None]] = {}
    for pdf_info in pdf_infos:
        candidates: list[tuple[float, str, BibEntry]] = []
        for entry in entries:
            score, reason = score_pdf(pdf_info, entry)
            candidates.append((score, reason, entry))
        candidates.sort(key=lambda item: item[0], reverse=True)
        if candidates and candidates[0][0] >= MIN_MATCH_SCORE:
            score, reason, entry = candidates[0]
            best_candidates.append((score, reason, pdf_info, entry))
        elif candidates:
            score, reason, entry = candidates[0]
            below_threshold[pdf_info.path] = (score, reason, entry)
        else:
            below_threshold[pdf_info.path] = (0.0, "no candidates", None)

    best_candidates.sort(key=lambda x: x[0], reverse=True)
    used_pdfs: set[Path] = set()
    matches: list[PdfMatch] = []
    duplicate_best: dict[Path, str] = {}
    for score, reason, pdf_info, entry in best_candidates:
        if pdf_info.path in used_pdfs:
            duplicate_best[pdf_info.path] = f"unmatched; pdf already matched: {entry.key}"
            continue
        used_pdfs.add(pdf_info.path)
        matches.append(PdfMatch(pdf_info.path, entry, score, reason))

    for pdf_info in pdf_infos:
        if pdf_info.path not in used_pdfs:
            reason = duplicate_best.get(pdf_info.path, "unmatched")
            if reason == "unmatched" and pdf_info.path in below_threshold:
                score, best_reason, entry = below_threshold[pdf_info.path]
                key = entry.key if entry else "none"
                reason = f"unmatched; best={score:.3f} {key} {best_reason}"
            if pdf_info.text_error:
                reason = f"unmatched; {pdf_info.text_error}"
            elif not pdf_info.text.strip():
                reason = "unmatched; no extractable pdf text"
            matches.append(PdfMatch(pdf_info.path, None, 0.0, reason))
    matches.sort(key=lambda m: m.pdf_path.name.lower())
    return matches


def write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fieldnames = list(rows[0].keys()) if rows else ["message"]
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def resolve_existing_dir(path: Path, label: str) -> Path:
    path = path.expanduser().resolve()
    if not path.is_dir():
        raise FileNotFoundError(f"{label} directory not found: {path}")
    return path


def same_file(a: Path, b: Path) -> bool:
    try:
        return a.resolve().samefile(b.resolve())
    except FileNotFoundError:
        return False
    except OSError:
        return a.resolve() == b.resolve()


def same_directory(a: Path, b: Path) -> bool:
    try:
        return a.resolve() == b.resolve()
    except OSError:
        return a.resolve() == b.resolve()


def file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def duplicate_keep_key(path: Path) -> tuple[int, int, str]:
    has_unused_prefix = 1 if strip_unused_prefixes(path.stem) != path.stem else 0
    return (has_unused_prefix, len(path.name), path.name.lower())


def deduplicate_identical_pdfs(pdf_paths: list[Path], dry_run: bool) -> tuple[list[Path], list[dict[str, str]]]:
    size_groups: dict[int, list[Path]] = {}
    for pdf in pdf_paths:
        size_groups.setdefault(pdf.stat().st_size, []).append(pdf)

    groups: dict[tuple[int, str], list[Path]] = {}
    for size, same_size_paths in size_groups.items():
        if len(same_size_paths) == 1:
            groups[(size, "")] = same_size_paths
            continue
        for pdf in same_size_paths:
            groups.setdefault((size, file_sha256(pdf)), []).append(pdf)

    active_paths: list[Path] = []
    duplicate_rows: list[dict[str, str]] = []
    for (size, digest), group in groups.items():
        if len(group) == 1:
            active_paths.append(group[0])
            continue
        keeper = sorted(group, key=duplicate_keep_key)[0]
        active_paths.append(keeper)
        for duplicate in sorted((p for p in group if p != keeper), key=lambda p: p.name.lower()):
            status = "dry_run_duplicate_removed" if dry_run else "duplicate_removed"
            duplicate_rows.append(
                {
                    "status": status,
                    "score": "",
                    "reason": f"identical duplicate; size={size} bytes; sha256={digest}",
                    "key": "",
                    "old_name": duplicate.name,
                    "new_name": keeper.name,
                    "pdf_text_chars": "",
                    "pdf_text_error": "",
                    "reference_start": "",
                }
            )
            log(
                f"[{'DRY RUN][' if dry_run else ''}DUPLICATE REMOVED{']' if dry_run else ''}] "
                f"{duplicate.name} -> kept {keeper.name} ({size} bytes)"
            )
            if not dry_run:
                duplicate.unlink()
    return sorted(active_paths), duplicate_rows


def run(args: argparse.Namespace) -> None:
    bib_path = Path(args.bib).expanduser().resolve()
    source_dir = resolve_existing_dir(Path(args.source_dir), "source ref")
    ref_dir = Path(args.ref_dir).expanduser().resolve()
    report_dir = Path(args.report_dir).expanduser().resolve()
    ref_dir.mkdir(parents=True, exist_ok=True)
    report_dir.mkdir(parents=True, exist_ok=True)
    entries = parse_bib(bib_path)
    all_entries = entries
    cited_keys: list[str] = []
    unknown_cited_keys: list[str] = []
    if args.cited_only:
        cited_keys = parse_cited_keys(Path(args.aux).expanduser().resolve())
        if cited_keys:
            entry_by_key = {entry.key: entry for entry in all_entries}
            entries = [entry_by_key[key] for key in cited_keys if key in entry_by_key]
            unknown_cited_keys = [key for key in cited_keys if key not in entry_by_key]
        else:
            log(f"warning: no cite keys found in aux file; matching against all BibTeX entries: {args.aux}")
    pdf_paths = sorted(p for p in source_dir.glob("*.pdf") if p.is_file())
    pdf_paths, duplicate_rows = deduplicate_identical_pdfs(pdf_paths, args.dry_run)
    pdf_infos = [
        PdfInfo(path=pdf, text="", text_error="pdf-text-disabled")
        for pdf in pdf_paths
    ] if args.no_pdf_text else build_pdf_infos(pdf_paths, max_pages=args.pdf_pages)
    pdf_info_by_path = {info.path: info for info in pdf_infos}
    matches = match_pdfs(pdf_infos, entries)

    matched_keys = {m.entry.key for m in matches if m.entry is not None}
    reserved_targets: set[Path] = set()
    rename_rows: list[dict[str, str]] = list(duplicate_rows)
    candidate_rows: list[dict[str, str]] = []

    for match in matches:
        if match.entry is None:
            pdf_info = pdf_info_by_path[match.pdf_path]
            candidates = top_candidate_entries(pdf_info, entries)
            target = make_unused_target(match.pdf_path, args.unused_prefix, reserved_targets) if args.mark_unmatched else match.pdf_path
            reserved_targets.add(target)
            if same_file(match.pdf_path, target):
                status = "unchanged_unused"
            elif args.mark_unmatched:
                status = "marked_unused"
            else:
                status = "unmatched_pdf"
            rename_rows.append(
                {
                    "status": "dry_run_" + status if args.dry_run else status,
                    "score": "",
                    "reason": match.reason,
                    "key": "",
                    "old_name": match.pdf_path.name,
                    "new_name": target.name if args.mark_unmatched else "",
                    "pdf_text_chars": str(len(pdf_info.text)),
                    "pdf_text_error": pdf_info.text_error,
                    "reference_start": "",
                }
            )
            if not args.dry_run and status == "marked_unused":
                log(f"[MARK UNUSED] {match.pdf_path.name} -> {target.name}")
                shutil.move(str(match.pdf_path), str(target))
            elif args.dry_run and status == "marked_unused":
                log(f"[DRY RUN][MARK UNUSED] {match.pdf_path.name} -> {target.name}")
            elif status == "unchanged_unused":
                log(f"[UNCHANGED UNUSED] {match.pdf_path.name}")
            elif status == "unmatched_pdf":
                log(f"[UNMATCHED] {match.pdf_path.name}: {match.reason}")
            for rank, (score, reason, entry) in enumerate(candidates, start=1):
                candidate_rows.append(
                    {
                        "pdf_name": match.pdf_path.name,
                        "rank": str(rank),
                        "score": f"{score:.3f}",
                        "reason": reason,
                        "candidate_key": entry.key,
                        "candidate_title": entry.fields.get("title", ""),
                        "candidate_author": entry.fields.get("author", entry.fields.get("editor", "")),
                        "expected_filename": f"{entry.filename_stem}.pdf",
                    }
                )
            continue

        raw_target = ref_dir / f"{match.entry.filename_stem}.pdf"
        if same_file(match.pdf_path, raw_target):
            target = raw_target
        else:
            target = make_unique_path(raw_target, reserved_targets)
        reserved_targets.add(target)
        if same_file(match.pdf_path, target):
            status = "unchanged"
        elif target.exists():
            status = "already_exists"
        elif same_directory(match.pdf_path.parent, target.parent):
            status = "renamed"
        elif args.move:
            status = "moved"
        else:
            status = "copied"
        rename_rows.append(
            {
                "status": "dry_run_" + status if args.dry_run else status,
                "score": f"{match.score:.3f}",
                "reason": match.reason,
                "key": match.entry.key,
                "old_name": match.pdf_path.name,
                "new_name": target.name,
                "pdf_text_chars": str(len(pdf_info_by_path[match.pdf_path].text)),
                "pdf_text_error": pdf_info_by_path[match.pdf_path].text_error,
                "reference_start": match.entry.reference_text,
            }
        )
        if not args.dry_run and status in {"copied", "moved", "renamed"}:
            log(f"[{status.upper()}] {match.pdf_path.name} -> {target.name} ({match.entry.key}, score={match.score:.3f})")
            if args.move or status == "renamed":
                shutil.move(str(match.pdf_path), str(target))
            else:
                shutil.copy2(match.pdf_path, target)
        elif args.dry_run and status in {"copied", "moved", "renamed"}:
            log(f"[DRY RUN][{status.upper()}] {match.pdf_path.name} -> {target.name} ({match.entry.key}, score={match.score:.3f})")
        elif status == "unchanged":
            log(f"[UNCHANGED] {match.pdf_path.name} ({match.entry.key}, score={match.score:.3f})")
        elif status == "already_exists":
            log(f"[ALREADY EXISTS] {match.pdf_path.name} -> {target.name} ({match.entry.key}, score={match.score:.3f})")

    missing_rows = [
        {
            "key": entry.key,
            "entry_type": entry.entry_type,
            "year": entry.fields.get("year", ""),
            "title": entry.fields.get("title", ""),
            "author": entry.fields.get("author", entry.fields.get("editor", "")),
            "expected_filename": f"{entry.filename_stem}.pdf",
            "reference_start": entry.reference_text,
        }
        for entry in entries
        if entry.key not in matched_keys
    ]
    for key in unknown_cited_keys:
        missing_rows.append(
            {
                "key": key,
                "entry_type": "missing_bib_entry",
                "year": "",
                "title": "",
                "author": "",
                "expected_filename": "",
                "reference_start": "Cited in aux file but not found in BibTeX file.",
            }
        )

    write_csv(report_dir / "reference_pdf_rename_log.csv", rename_rows)
    write_csv(report_dir / "reference_pdf_unmatched_candidates.csv", candidate_rows)
    write_csv(report_dir / "references_missing_in_ref.csv", missing_rows)
    log(f"bib entries: {len(all_entries)}")
    log(f"active reference entries: {len(entries)}" + (" (cited-only)" if args.cited_only and cited_keys else ""))
    if unknown_cited_keys:
        log(f"cited keys missing in bib: {len(unknown_cited_keys)}")
    log(f"source ref dir: {source_dir}")
    log(f"target ref dir: {ref_dir}")
    log(f"source pdf files: {len(pdf_paths)}")
    log(f"matched pdfs: {sum(1 for m in matches if m.entry is not None)}")
    log(f"unmatched pdfs: {sum(1 for m in matches if m.entry is None)}")
    log(f"pdf text pages: {args.pdf_pages if not args.no_pdf_text else 0}")
    log(f"pdfs with extracted text: {sum(1 for info in pdf_infos if info.text.strip())}")
    log(f"missing references: {len(missing_rows)}")
    log(f"rename log: {report_dir / 'reference_pdf_rename_log.csv'}")
    log(f"unmatched candidates: {report_dir / 'reference_pdf_unmatched_candidates.csv'}")
    log(f"missing list: {report_dir / 'references_missing_in_ref.csv'}")


def main() -> None:
    parser = argparse.ArgumentParser(
        description=(
            "Match PDFs in the ref folder against sub/references.bib. Matched PDFs "
            "are renamed to reference-style filenames, and unmatched PDFs are marked "
            "as not cited."
        )
    )
    parser.add_argument("--bib", default=str(DEFAULT_BIB), help="Path to references.bib")
    parser.add_argument("--aux", default=str(DEFAULT_AUX), help="Aux file used to determine currently cited keys")
    parser.add_argument("--source-dir", default=str(DEFAULT_SOURCE_REF_DIR), help="Directory containing source PDFs")
    parser.add_argument("--ref-dir", default=str(DEFAULT_REF_DIR), help="Directory to receive renamed/copied PDFs")
    parser.add_argument("--report-dir", default=str(DEFAULT_REPORT_DIR), help="Directory for CSV reports")
    parser.add_argument("--dry-run", action="store_true", help="Write reports without copying or moving PDFs")
    parser.add_argument("--move", action="store_true", help="Move matched PDFs instead of copying them")
    parser.add_argument("--cited-only", action=argparse.BooleanOptionalAction, default=True, help="Match only BibTeX entries cited in the aux file")
    parser.add_argument("--mark-unmatched", action=argparse.BooleanOptionalAction, default=True, help="Rename unmatched PDFs with the unused prefix")
    parser.add_argument("--unused-prefix", default=DEFAULT_UNUSED_PREFIX, help="Prefix for PDFs not matched to the current bibliography")
    parser.add_argument("--pdf-pages", type=int, default=DEFAULT_PDF_TEXT_PAGES, help="Number of leading PDF pages to read for matching")
    parser.add_argument("--no-pdf-text", action="store_true", help="Match using PDF filenames only")
    args = parser.parse_args()
    run(args)


if __name__ == "__main__":
    main()
