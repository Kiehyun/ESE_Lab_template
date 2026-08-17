from __future__ import annotations
# /// script
# dependencies = ["pymupdf>=1.24.0", "pypdf>=6.0.0", "requests>=2.32.0"]
# ///

import argparse
import csv
import os
import re
import time
from pathlib import Path
from urllib.parse import quote, quote_plus, urlencode, urljoin, urlparse

import requests

from rename_ref_pdfs_by_bib import (
    DEFAULT_AUX,
    DEFAULT_BIB,
    DEFAULT_REF_DIR,
    DEFAULT_REPORT_DIR,
    BibEntry,
    PdfInfo,
    build_pdf_infos,
    make_unique_path,
    match_pdfs,
    parse_bib,
    parse_cited_keys,
    resolve_aux_paths,
    safe_filename,
    truncate_utf8,
)


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_DOWNLOAD_AUX = ROOT / "build" / "KH_thesis_main.aux"
DEFAULT_REPORT = DEFAULT_REF_DIR / "references_missing_downloads.csv"
DEFAULT_MISSING_CSV = DEFAULT_REPORT_DIR / "references_missing_in_ref.csv"
MAX_FILENAME_BYTES = 100
DEFAULT_TIMEOUT = 25
PDF_MIME_PARTS = ("application/pdf", "application/octet-stream")
HTML_MIME_PARTS = ("text/html", "application/xhtml+xml")
UNPAYWALL_EMAIL = "local-user@example.com"
PARKSPARKS_BASE_URL = "http://parksparks.iptime.org/paper_search/"
PARKSPARKS_SEARCH_LIMIT = 10
# The local paper_search server requires a login. The password is NOT stored in
# this file; it is read at runtime from the PARKSPARKS_PASSWORD environment
# variable or from a git-ignored secret file (see load_parksparks_password).
PARKSPARKS_PASSWORD_ENV = "PARKSPARKS_PASSWORD"
PARKSPARKS_SECRET_FILES = (
    Path(__file__).resolve().parent / ".parksparks_secret",
    ROOT / ".parksparks_secret",
)


def load_parksparks_password(explicit: str = "", secret_file: str = "") -> str:
    """Resolve the paper_search password without hard-coding it in this file.

    Resolution order: explicit CLI value > PARKSPARKS_PASSWORD env var >
    git-ignored secret file. In a secret file, put the password on its own line;
    blank lines and lines starting with ``#`` are ignored.
    """
    if explicit and explicit.strip():
        return explicit.strip()
    env_value = os.environ.get(PARKSPARKS_PASSWORD_ENV, "").strip()
    if env_value:
        return env_value
    candidates: list[Path] = []
    if secret_file:
        candidates.append(Path(secret_file).expanduser())
    candidates.extend(PARKSPARKS_SECRET_FILES)
    for candidate in candidates:
        try:
            text = candidate.read_text(encoding="utf-8")
        except OSError:
            continue
        for line in text.splitlines():
            line = line.strip()
            if line and not line.startswith("#"):
                return line
    return ""


def parksparks_login(session: requests.Session, base_url: str, password: str, timeout: int) -> bool:
    """Authenticate the session against the paper_search login form.

    The server keeps the login in a PHP session cookie: a correct password
    answers with an HTTP redirect, a wrong one re-renders the form (HTTP 200).
    """
    if not password:
        return False
    try:
        response = session.post(
            base_url,
            data={"password": password},
            timeout=timeout,
            allow_redirects=False,
        )
    except Exception:
        return False
    return response.is_redirect or response.status_code in (301, 302, 303)


def write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fieldnames = list(rows[0].keys()) if rows else [
        "key",
        "status",
        "source",
        "url",
        "target",
        "message",
    ]
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def entry_target_path(entry: BibEntry, ref_dir: Path, reserved: set[Path]) -> Path:
    stem = truncate_utf8(safe_filename(entry.filename_stem), MAX_FILENAME_BYTES)
    return make_unique_path(ref_dir / f"{stem}.pdf", reserved)


def existing_matched_keys(entries: list[BibEntry], ref_dir: Path, pdf_pages: int, no_pdf_text: bool) -> set[str]:
    pdf_paths = sorted(p for p in ref_dir.glob("*.pdf") if p.is_file())
    pdf_infos = [
        PdfInfo(path=pdf, text="", text_error="pdf-text-disabled")
        for pdf in pdf_paths
    ] if no_pdf_text else build_pdf_infos(pdf_paths, max_pages=pdf_pages)
    return {m.entry.key for m in match_pdfs(pdf_infos, entries) if m.entry is not None}


def missing_keys_from_csv(path: Path) -> set[str]:
    if not path.is_file():
        return set()
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return {row.get("key", "").strip() for row in csv.DictReader(f) if row.get("key", "").strip()}


def resolve_download_aux_path(aux_arg: str) -> Path:
    requested = Path(aux_arg).expanduser()
    candidates = [
        requested,
        ROOT / "build" / "KH_thesis_main.aux",
        ROOT / ".latexbuild" / "KH_thesis_main.aux",
        DEFAULT_AUX,
    ]
    for candidate in candidates:
        if resolve_aux_paths(candidate):
            raw = str(candidate)
            return candidate if any(char in raw for char in "*?[]") else candidate.resolve()
    return requested.resolve()


def normalize_doi(doi: str) -> str:
    doi = doi.strip()
    doi = re.sub(r"^https?://(?:dx\.)?doi\.org/", "", doi, flags=re.I)
    return doi.strip()


def candidate_urls(
    entry: BibEntry,
    session: requests.Session,
    timeout: int,
    use_apis: bool = True,
    use_parksparks: bool = True,
    parksparks_base_url: str = PARKSPARKS_BASE_URL,
) -> list[tuple[str, str]]:
    urls: list[tuple[str, str]] = []
    if use_parksparks:
        urls.extend(parksparks_links(entry, session, timeout, parksparks_base_url))
    urls.extend(public_candidate_urls(entry, session, timeout, use_apis=use_apis))
    return dedupe_urls(urls)


def public_candidate_urls(entry: BibEntry, session: requests.Session, timeout: int, use_apis: bool = True) -> list[tuple[str, str]]:
    fields = entry.fields
    urls: list[tuple[str, str]] = []
    if fields.get("url"):
        urls.append(("bib-url", fields["url"]))
    doi = normalize_doi(fields.get("doi", ""))
    if doi:
        if use_apis:
            urls.extend(crossref_links(doi, session, timeout))
            urls.extend(openalex_links(doi, session, timeout))
            urls.extend(unpaywall_links(doi, session, timeout))
            urls.extend(semantic_scholar_links(doi, session, timeout))
        urls.extend(direct_doi_pdf_guesses(doi))
        urls.append(("doi-resolver", f"https://doi.org/{quote(doi, safe='/')}"))
    if use_apis and fields.get("title"):
        urls.extend(crossref_title_links(entry, session, timeout, known_doi=doi))
        if not doi:
            urls.extend(openalex_title_links(entry, session, timeout))
            urls.extend(semantic_scholar_title_links(entry, session, timeout))
    return dedupe_urls(urls)


def parksparks_links(
    entry: BibEntry,
    session: requests.Session,
    timeout: int,
    base_url: str = PARKSPARKS_BASE_URL,
) -> list[tuple[str, str]]:
    queries: list[str] = []
    doi = normalize_doi(entry.fields.get("doi", ""))
    title = entry.fields.get("title", "")
    if doi:
        queries.append(doi)
    if title:
        queries.append(title)
        simplified = re.sub(r"[\{\}\\]", "", title).strip()
        if simplified and simplified != title:
            queries.append(simplified)

    links: list[tuple[str, str]] = []
    seen_sources: set[str] = set()
    for query in dedupe_strings(queries):
        endpoint = urljoin(base_url, "api.php")
        try:
            response = session.get(
                endpoint,
                params={"action": "search", "q": query, "limit": PARKSPARKS_SEARCH_LIMIT},
                timeout=timeout,
            )
            response.raise_for_status()
            data = response.json()
        except Exception:
            continue
        if not data.get("ok"):
            continue
        for item in data.get("items", []) or []:
            source_pdf = item.get("source_pdf") or ""
            if not source_pdf or source_pdf in seen_sources:
                continue
            if not parksparks_item_matches(entry, item, doi):
                continue
            seen_sources.add(source_pdf)
            links.append(
                (
                    "parksparks-pdf",
                    urljoin(base_url, "pdf.php") + "?" + urlencode({"source_pdf": source_pdf}),
                )
            )
    return links


def dedupe_strings(values: list[str]) -> list[str]:
    seen: set[str] = set()
    deduped: list[str] = []
    for value in values:
        normalized = re.sub(r"\s+", " ", value).strip()
        key = normalized.lower()
        if not normalized or key in seen:
            continue
        seen.add(key)
        deduped.append(normalized)
    return deduped


def parksparks_item_matches(entry: BibEntry, item: dict, doi: str) -> bool:
    item_doi = normalize_doi(str(item.get("doi") or ""))
    if doi and item_doi and doi.lower() == item_doi.lower():
        return True

    expected_title = entry.fields.get("title", "")
    candidate_titles = [
        str(item.get("title") or ""),
        str(item.get("subtitle") or ""),
    ]
    if expected_title and any(title_similar(expected_title, candidate) for candidate in candidate_titles):
        return True

    return False


def crossref_links(doi: str, session: requests.Session, timeout: int) -> list[tuple[str, str]]:
    endpoint = f"https://api.crossref.org/works/{quote(doi, safe='')}"
    try:
        data = session.get(endpoint, timeout=timeout).json()
    except Exception:
        return []
    links = []
    for link in data.get("message", {}).get("link", []) or []:
        url = link.get("URL") or ""
        ctype = (link.get("content-type") or "").lower()
        if url and ("pdf" in ctype or url.lower().endswith(".pdf")):
            links.append(("crossref-link", url))
    return links


def crossref_title_links(entry: BibEntry, session: requests.Session, timeout: int, known_doi: str = "") -> list[tuple[str, str]]:
    title = entry.fields.get("title", "")
    if not title:
        return []
    endpoint = f"https://api.crossref.org/works?query.bibliographic={quote_plus(title)}&rows=5"
    try:
        data = session.get(endpoint, timeout=timeout).json()
    except Exception:
        return []
    wanted_year = entry.fields.get("year", "")
    links: list[tuple[str, str]] = []
    seen_dois = {known_doi.lower()} if known_doi else set()
    for item in data.get("message", {}).get("items", []) or []:
        doi = normalize_doi(item.get("DOI") or "")
        if not doi or doi.lower() in seen_dois:
            continue
        year = crossref_item_year(item)
        if wanted_year and year and year != wanted_year:
            continue
        if not title_similar(title, " ".join(item.get("title") or [])):
            continue
        seen_dois.add(doi.lower())
        for link in item.get("link", []) or []:
            url = link.get("URL") or ""
            ctype = (link.get("content-type") or "").lower()
            if url and ("pdf" in ctype or url.lower().endswith(".pdf")):
                links.append(("crossref-title-link", url))
        links.extend((source.replace("doi-pattern", "crossref-title-pattern"), url) for source, url in direct_doi_pdf_guesses(doi))
        links.append(("crossref-title-doi", f"https://doi.org/{quote(doi, safe='/')}"))
    return links


def crossref_item_year(item: dict) -> str:
    for field in ("published-print", "published-online", "issued"):
        parts = item.get(field, {}).get("date-parts") or []
        if parts and parts[0]:
            return str(parts[0][0])
    return ""


def title_similar(expected: str, candidate: str) -> bool:
    expected_tokens = title_tokens(expected)
    candidate_tokens = title_tokens(candidate)
    if not expected_tokens or not candidate_tokens:
        return False
    overlap = len(expected_tokens & candidate_tokens) / max(1, len(expected_tokens))
    return overlap >= 0.65


def title_tokens(value: str) -> set[str]:
    words = re.findall(r"[0-9a-z가-힣]+", value.lower())
    return {word for word in words if len(word) >= 2}


def openalex_links(doi: str, session: requests.Session, timeout: int) -> list[tuple[str, str]]:
    endpoint = f"https://api.openalex.org/works/https://doi.org/{quote(doi, safe='/')}"
    try:
        data = session.get(endpoint, timeout=timeout).json()
    except Exception:
        return []
    locations = []
    best = data.get("best_oa_location") or {}
    primary = data.get("primary_location") or {}
    if best:
        locations.append(best)
    if primary:
        locations.append(primary)
    locations.extend(data.get("locations") or [])
    links = []
    for loc in locations:
        pdf_url = loc.get("pdf_url") or ""
        landing = loc.get("landing_page_url") or ""
        if pdf_url:
            links.append(("openalex-pdf", pdf_url))
        if landing:
            links.append(("openalex-landing", landing))
    return links


def openalex_title_links(entry: BibEntry, session: requests.Session, timeout: int) -> list[tuple[str, str]]:
    title = entry.fields.get("title", "")
    if not title:
        return []
    endpoint = f"https://api.openalex.org/works?search={quote_plus(title)}&per-page=5"
    try:
        data = session.get(endpoint, timeout=timeout).json()
    except Exception:
        return []
    links: list[tuple[str, str]] = []
    wanted_year = entry.fields.get("year", "")
    for work in data.get("results", []) or []:
        year = str(work.get("publication_year") or "")
        if wanted_year and year and year != wanted_year:
            continue
        links.extend(location_links(work.get("best_oa_location") or {}, "openalex-title"))
        links.extend(location_links(work.get("primary_location") or {}, "openalex-title"))
        for loc in work.get("locations") or []:
            links.extend(location_links(loc, "openalex-title"))
    return links


def location_links(loc: dict, source: str) -> list[tuple[str, str]]:
    links: list[tuple[str, str]] = []
    pdf_url = loc.get("pdf_url") or ""
    landing = loc.get("landing_page_url") or ""
    if pdf_url:
        links.append((f"{source}-pdf", pdf_url))
    if landing:
        links.append((f"{source}-landing", landing))
    return links


def unpaywall_links(doi: str, session: requests.Session, timeout: int) -> list[tuple[str, str]]:
    endpoint = f"https://api.unpaywall.org/v2/{quote(doi, safe='/')}?email={quote_plus(UNPAYWALL_EMAIL)}"
    try:
        data = session.get(endpoint, timeout=timeout).json()
    except Exception:
        return []
    locations = []
    best = data.get("best_oa_location") or {}
    if best:
        locations.append(best)
    locations.extend(data.get("oa_locations") or [])
    links: list[tuple[str, str]] = []
    for loc in locations:
        pdf_url = loc.get("url_for_pdf") or ""
        landing = loc.get("url_for_landing_page") or loc.get("url") or ""
        if pdf_url:
            links.append(("unpaywall-pdf", pdf_url))
        if landing:
            links.append(("unpaywall-landing", landing))
    return links


def semantic_scholar_links(doi: str, session: requests.Session, timeout: int) -> list[tuple[str, str]]:
    endpoint = f"https://api.semanticscholar.org/graph/v1/paper/DOI:{quote(doi, safe='')}?fields=openAccessPdf,url"
    try:
        data = session.get(endpoint, timeout=timeout).json()
    except Exception:
        return []
    return semantic_scholar_data_links(data, "semantic-scholar")


def semantic_scholar_title_links(entry: BibEntry, session: requests.Session, timeout: int) -> list[tuple[str, str]]:
    title = entry.fields.get("title", "")
    if not title:
        return []
    endpoint = (
        "https://api.semanticscholar.org/graph/v1/paper/search"
        f"?query={quote_plus(title)}&limit=5&fields=title,year,openAccessPdf,url"
    )
    try:
        data = session.get(endpoint, timeout=timeout).json()
    except Exception:
        return []
    wanted_year = entry.fields.get("year", "")
    links: list[tuple[str, str]] = []
    for paper in data.get("data", []) or []:
        year = str(paper.get("year") or "")
        if wanted_year and year and year != wanted_year:
            continue
        links.extend(semantic_scholar_data_links(paper, "semantic-scholar-title"))
    return links


def semantic_scholar_data_links(data: dict, source: str) -> list[tuple[str, str]]:
    links: list[tuple[str, str]] = []
    pdf = data.get("openAccessPdf") or {}
    pdf_url = pdf.get("url") or ""
    landing = data.get("url") or ""
    if pdf_url:
        links.append((f"{source}-pdf", pdf_url))
    if landing:
        links.append((f"{source}-landing", landing))
    return links


def direct_doi_pdf_guesses(doi: str) -> list[tuple[str, str]]:
    lower = doi.lower()
    guesses: list[tuple[str, str]] = []
    quoted = quote(doi, safe="/")
    if lower.startswith("10.1073/"):
        guesses.append(("doi-pattern-pnas", f"https://www.pnas.org/doi/pdf/{quoted}"))
        guesses.append(("doi-pattern-pnas", f"https://www.pnas.org/doi/epdf/{quoted}"))
    if lower.startswith("10.1007/"):
        guesses.append(("doi-pattern-springer", f"https://link.springer.com/content/pdf/{quoted}.pdf"))
    if lower.startswith("10.1088/"):
        guesses.append(("doi-pattern-iop", f"https://iopscience.iop.org/article/{quoted}/pdf"))
        guesses.append(("doi-pattern-iop", f"https://iopscience.iop.org/article/{quoted}/pdf?download=true"))
    if lower.startswith("10.1186/"):
        guesses.append(("doi-pattern-springeropen", f"https://link.springer.com/content/pdf/{quoted}.pdf"))
        guesses.append(("doi-pattern-springeropen", f"https://stemeducationjournal.springeropen.com/counter/pdf/{quoted}.pdf"))
        guesses.append(("doi-pattern-springeropen", f"https://stemeducationjournal.springeropen.com/articles/{quoted}"))
    if lower.startswith("10.1186/s40594"):
        guesses.append(("doi-pattern-springeropen", f"https://stemeducationjournal.springeropen.com/counter/pdf/{quoted}"))
    if lower.startswith("10.1029/"):
        guesses.append(("doi-pattern-agu", f"https://agupubs.onlinelibrary.wiley.com/doi/pdfdirect/{quoted}"))
        guesses.append(("doi-pattern-agu", f"https://agupubs.onlinelibrary.wiley.com/doi/pdf/{quoted}"))
    if lower.startswith("10.1111/"):
        guesses.append(("doi-pattern-wiley", f"https://onlinelibrary.wiley.com/doi/pdfdirect/{quoted}"))
        guesses.append(("doi-pattern-wiley", f"https://onlinelibrary.wiley.com/doi/pdf/{quoted}"))
    if lower.startswith("10.1016/"):
        pii = lower.split("/", 1)[1].replace("-", "").replace("(", "").replace(")", "")
        guesses.append(("doi-pattern-sciencedirect", f"https://www.sciencedirect.com/science/article/pii/{pii}/pdfft"))
    return guesses


def dedupe_urls(urls: list[tuple[str, str]]) -> list[tuple[str, str]]:
    seen = set()
    deduped = []
    for source, url in urls:
        url = (url or "").strip()
        if not url or url in seen:
            continue
        seen.add(url)
        deduped.append((source, url))
    return deduped


def looks_like_pdf(response: requests.Response, content_start: bytes) -> bool:
    ctype = response.headers.get("content-type", "").lower()
    path = urlparse(response.url).path.lower()
    return content_start.startswith(b"%PDF") or path.endswith(".pdf") or any(part in ctype for part in PDF_MIME_PARTS)


def looks_like_html(response: requests.Response, content_start: bytes) -> bool:
    ctype = response.headers.get("content-type", "").lower()
    start = content_start.lstrip().lower()
    return any(part in ctype for part in HTML_MIME_PARTS) or start.startswith((b"<!doctype html", b"<html"))


def landing_pdf_links(url: str, session: requests.Session, timeout: int) -> list[tuple[str, str]]:
    try:
        response = session.get(url, timeout=timeout, allow_redirects=True)
    except Exception:
        return []
    if response.status_code >= 400:
        return []
    content = response.content[:4096]
    if not looks_like_html(response, content):
        return []
    html = response.text
    base = response.url
    links: list[tuple[str, str]] = []
    meta_patterns = [
        r'<meta[^>]+name=["\']citation_pdf_url["\'][^>]+content=["\']([^"\']+)["\']',
        r'<meta[^>]+content=["\']([^"\']+)["\'][^>]+name=["\']citation_pdf_url["\']',
        r'<meta[^>]+property=["\']og:pdf["\'][^>]+content=["\']([^"\']+)["\']',
    ]
    for pattern in meta_patterns:
        for match in re.finditer(pattern, html, flags=re.I):
            links.append(("landing-meta-pdf", urljoin(base, html_unescape(match.group(1)))))
    for match in re.finditer(r'href=["\']([^"\']+)["\']', html, flags=re.I):
        href = html_unescape(match.group(1))
        href_lower = href.lower()
        if (
            ".pdf" in href_lower
            or "/pdf/" in href_lower
            or href_lower.endswith("/pdf")
            or "download" in href_lower and "article" in href_lower
        ):
            links.append(("landing-link-pdf", urljoin(base, href)))
    return dedupe_urls(links)


def html_unescape(value: str) -> str:
    return (
        value.replace("&amp;", "&")
        .replace("&lt;", "<")
        .replace("&gt;", ">")
        .replace("&quot;", '"')
        .replace("&#39;", "'")
    )


def expand_landing_candidates(urls: list[tuple[str, str]], session: requests.Session, timeout: int) -> list[tuple[str, str]]:
    expanded: list[tuple[str, str]] = []
    for source, url in urls:
        expanded.append((source, url))
        path = urlparse(url).path.lower()
        if path.endswith(".pdf"):
            continue
        if "landing" in source or "doi-resolver" in source or source.endswith("url") or "semantic-scholar" in source:
            for pdf_source, pdf_url in landing_pdf_links(url, session, timeout):
                expanded.append((f"{source}:{pdf_source}", pdf_url))
    return dedupe_urls(expanded)


def download_pdf(url: str, target: Path, session: requests.Session, timeout: int) -> tuple[bool, str]:
    tmp_target = target.with_name(f"{target.name}.part")
    try:
        with session.get(url, timeout=timeout, stream=True, allow_redirects=True) as response:
            if response.status_code >= 400:
                return False, f"HTTP {response.status_code}"
            iterator = response.iter_content(chunk_size=65536)
            first = next(iterator, b"")
            if not looks_like_pdf(response, first):
                return False, f"not a pdf: {response.headers.get('content-type', '')}"
            target.parent.mkdir(parents=True, exist_ok=True)
            with tmp_target.open("wb") as f:
                f.write(first)
                for chunk in iterator:
                    if chunk:
                        f.write(chunk)
            if tmp_target.stat().st_size < 1024:
                tmp_target.unlink(missing_ok=True)
                return False, "download too small"
            tmp_target.replace(target)
            return True, f"downloaded {target.stat().st_size} bytes"
    except Exception as exc:
        tmp_target.unlink(missing_ok=True)
        return False, str(exc)


def run(args: argparse.Namespace) -> None:
    bib_path = Path(args.bib).expanduser().resolve()
    aux_path = resolve_download_aux_path(args.aux) if args.aux else Path()
    ref_dir = Path(args.ref_dir).expanduser().resolve()
    report_path = Path(args.report).expanduser().resolve()
    missing_csv = Path(args.missing_csv).expanduser().resolve() if args.missing_csv else Path()
    ref_dir.mkdir(parents=True, exist_ok=True)
    report_path.parent.mkdir(parents=True, exist_ok=True)
    entries = parse_bib(bib_path)
    entry_by_key = {entry.key: entry for entry in entries}

    cited_keys = parse_cited_keys(aux_path) if args.cited_only and aux_path else []
    used_cited_only = False
    if args.cited_only and cited_keys:
        target_entries = [entry_by_key[key] for key in cited_keys if key in entry_by_key]
        used_cited_only = bool(target_entries)
    elif args.cited_only:
        target_entries = entries
        print(
            "warning: cited-only requested but aux file was not found or had no cite keys; "
            f"checking all BibTeX entries instead: {aux_path}"
        )
    else:
        target_entries = entries

    matched = existing_matched_keys(target_entries, ref_dir, args.pdf_pages, args.no_pdf_text)
    csv_keys = missing_keys_from_csv(missing_csv) if args.from_missing_csv and missing_csv else set()
    if csv_keys:
        missing = [entry for entry in target_entries if entry.key in csv_keys and entry.key not in matched]
    else:
        missing = [entry for entry in target_entries if entry.key not in matched]
    missing.sort(key=lambda entry: (entry.fields.get("year", ""), entry.key))
    if args.limit:
        missing = missing[: args.limit]

    session = requests.Session()
    session.headers.update(
        {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
            "(KHTML, like Gecko) Chrome/125.0 Safari/537.36 KH_thesisReferenceDownloader/1.1",
            "Accept": "application/pdf,text/html,application/json;q=0.9,*/*;q=0.8",
            "Accept-Language": "en-US,en;q=0.9,ko;q=0.8",
        }
    )

    if not args.no_parksparks:
        password = load_parksparks_password(args.parksparks_password, args.parksparks_secret_file)
        if not password:
            print(
                "warning: no parksparks password found; skipping the local paper_search source. "
                f"Set the {PARKSPARKS_PASSWORD_ENV} environment variable, or create a git-ignored "
                "code/.parksparks_secret file containing the password (or pass --parksparks-password)."
            )
            args.no_parksparks = True
        elif parksparks_login(session, args.parksparks_url, password, args.timeout):
            print("parksparks: logged in to the local paper_search server.")
        else:
            print("warning: parksparks login failed (wrong password?); skipping the local paper_search source.")
            args.no_parksparks = True

    reserved = {path.resolve() for path in ref_dir.glob("*.pdf")}
    rows: list[dict[str, str]] = []
    for index, entry in enumerate(missing, start=1):
        target = entry_target_path(entry, ref_dir, reserved)
        reserved.add(target)
        parksparks_urls = [] if args.no_parksparks else parksparks_links(
            entry,
            session,
            args.timeout,
            args.parksparks_url,
        )
        public_urls = public_candidate_urls(entry, session, args.timeout, use_apis=not args.no_apis)
        if not args.no_landing_expansion:
            parksparks_urls = expand_landing_candidates(parksparks_urls, session, args.timeout)
            public_urls = expand_landing_candidates(public_urls, session, args.timeout)
        parksparks_urls = dedupe_urls(parksparks_urls)
        public_urls = dedupe_urls(public_urls)
        urls = dedupe_urls(parksparks_urls + public_urls)
        if not urls:
            rows.append(row(entry, "no_candidate", "", "", target, "no doi/url candidate"))
            print(f"[{index}/{len(missing)}] {entry.key}: no candidate")
            continue
        downloaded = False
        for source, url in urls:
            if args.dry_run:
                rows.append(row(entry, "candidate", source, url, target, "dry run"))
                downloaded = True
                continue
            ok, message = download_pdf(url, target, session, args.timeout)
            rows.append(row(entry, "downloaded" if ok else "failed", source, url, target if ok else Path(""), message))
            if ok:
                downloaded = True
                break
            time.sleep(args.sleep)
        if not downloaded and not args.dry_run:
            rows.append(row(entry, "not_downloaded", "", "", target, "all candidates failed"))
        if args.sleep:
            time.sleep(args.sleep)
        if args.dry_run:
            print(
                f"[{index}/{len(missing)}] {entry.key}: "
                f"{len(parksparks_urls)} parksparks + {len(public_urls)} public candidate(s)"
            )
        else:
            print(f"[{index}/{len(missing)}] {entry.key}: {'downloaded' if downloaded else 'not downloaded'}")

    write_csv(report_path, rows)
    print(f"bib entries: {len(entries)}")
    print(f"target reference entries: {len(target_entries)}{' (cited-only)' if used_cited_only else ''}")
    print(f"ref dir: {ref_dir}")
    print(f"aux: {aux_path if args.cited_only else 'not used'}")
    print(f"missing csv: {missing_csv if csv_keys else 'not used'}")
    print(f"already matched PDFs: {len(matched)}")
    print(f"missing checked: {len(missing)}")
    print(f"report: {report_path}")


def row(entry: BibEntry, status: str, source: str, url: str, target: Path, message: str) -> dict[str, str]:
    return {
        "key": entry.key,
        "status": status,
        "source": source,
        "url": url,
        "target": str(target),
        "message": message,
        "year": entry.fields.get("year", ""),
        "title": entry.fields.get("title", ""),
        "doi": entry.fields.get("doi", ""),
        "reference": entry.reference_text,
    }


def main() -> None:
    parser = argparse.ArgumentParser(
        description=(
            "Download open-access/direct PDFs for this KH_thesis manuscript's "
            "sub/references.bib entries that are missing from ./ref."
        )
    )
    parser.add_argument("--bib", default=str(DEFAULT_BIB), help="Path to references.bib")
    parser.add_argument("--aux", default=str(DEFAULT_DOWNLOAD_AUX), help="Path to LaTeX aux file used to find actually cited keys")
    parser.add_argument("--ref-dir", default=str(DEFAULT_REF_DIR), help="Directory containing reference PDFs")
    parser.add_argument("--report", default=str(DEFAULT_REPORT), help="CSV report path")
    parser.add_argument(
        "--missing-csv",
        default=str(DEFAULT_MISSING_CSV),
        help="CSV from rename_ref_pdfs_by_bib.py listing missing BibTeX keys; used only with --from-missing-csv",
    )
    parser.add_argument("--from-missing-csv", action="store_true", help="Restrict checks to keys listed in --missing-csv")
    parser.add_argument("--cited-only", dest="cited_only", action="store_true", default=True, help="Only check references cited in --aux")
    parser.add_argument("--no-cited-only", dest="cited_only", action="store_false", help="Check all entries in references.bib")
    parser.add_argument("--pdf-pages", type=int, default=3, help="Leading pages used to match existing PDFs")
    parser.add_argument("--no-pdf-text", action="store_true", help="Match existing PDFs using filenames only")
    parser.add_argument("--timeout", type=int, default=DEFAULT_TIMEOUT, help="HTTP timeout in seconds")
    parser.add_argument("--parksparks-url", default=PARKSPARKS_BASE_URL, help="Local paper_search base URL checked before public sources")
    parser.add_argument(
        "--parksparks-password",
        default="",
        help=(
            "Password for the local paper_search login. Prefer the "
            f"{PARKSPARKS_PASSWORD_ENV} environment variable or a git-ignored "
            "code/.parksparks_secret file over passing it on the command line"
        ),
    )
    parser.add_argument(
        "--parksparks-secret-file",
        default="",
        help="Path to a git-ignored file whose first non-comment line is the paper_search password",
    )
    parser.add_argument("--no-parksparks", action="store_true", help="Skip the local parksparks paper_search source")
    parser.add_argument("--no-apis", action="store_true", help="Do not query Crossref/OpenAlex; use only BibTeX URL/DOI resolver candidates")
    parser.add_argument("--no-landing-expansion", action="store_true", help="Do not inspect HTML landing pages for PDF links")
    parser.add_argument("--sleep", type=float, default=0.2, help="Delay between HTTP attempts")
    parser.add_argument("--limit", type=int, default=0, help="Limit number of missing references to check")
    parser.add_argument("--dry-run", action="store_true", help="Only list candidate URLs; do not download")
    args = parser.parse_args()
    run(args)


if __name__ == "__main__":
    main()
