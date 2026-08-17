# TPT Submission Template

*The Physics Teacher* (TPT) anonymous submission template. The previous manuscript content has been removed, and the folder now works as a clean starting point for a new classroom-facing physics teaching article.

## 투고·심사 규정 / Submission Guidelines (Documents/)

*The Physics Teacher* 제출 안내 문서가 들어 있습니다(참고용 — 최신본은 공식 홈페이지 확인).

- 제출 안내: [Documents/How_to_Submit_TPT.md](Documents/How_to_Submit_TPT.md)
- 공식 페이지: <https://pubs.aip.org/aapt/pte>

## Journal and Society

TPT is a journal for physics teachers and is associated with the American Association of Physics Teachers (AAPT) and AIP Publishing. It emphasizes practical articles that teachers can understand, adapt, and use in real classrooms.

Good fits include physics classroom activities, demonstrations, lab designs, teaching tips, accessible modeling or computation activities, examples of student reasoning, and concise explanations that connect physics content to teaching practice. Manuscripts that primarily announce new physics research or report a conventional research project are usually not the best fit for TPT.

## Submission Notes

- Check the current AAPT/TPT author instructions and the AIP submission system before submitting.
- Search recent TPT issues for similar articles so the manuscript clearly adds a useful classroom contribution.
- Initial submission is commonly prepared as one self-contained PDF with the manuscript text, figures, and material needed for review.
- Keep the review manuscript anonymous unless the journal asks otherwise.
- Revised submissions may require a point-by-point response and production-ready source files, so keep editable text, figures, and tables organized.

## Editing Notes

- `TPT_main.tex` is anonymous by default.
- Author names, affiliations, acknowledgments, school names, file paths, and identifying details should stay out of the review manuscript.
- TPT usually does not use a separate abstract; make the first paragraph a clear summary of the article's practical value.
- The body is split into short files in `sub/` so sections can be edited independently.
- Figures should be legible in print, graphs should have labeled axes and units, and tables should be understandable without relying on surrounding prose.
- The build script no longer depends on manuscript-specific image-generation scripts.

## Main Files

- `TPT_main.tex`: title, anonymous front matter, document settings
- `sub/0-preamble.tex`: packages, fonts, line spacing, bibliography settings
- `sub/1-Introduction.tex`: opening summary and teaching problem
- `sub/2-TheoreticalBackground.tex`: concise background
- `sub/3-Methods.tex`: classroom implementation or activity sequence
- `sub/4-Results.tex`: teaching insights, student responses, or discussion
- `sub/5-Discussion.tex`: conclusion
- `sub/6-Tables.tex`: tables
- `sub/references.bib`: BibLaTeX reference entries
- `Documents/How_to_Submit_TPT.md`: submission notes

## Prerequisites

This template builds with **LuaLaTeX** and **biber**; it does not build with `pdfLaTeX` or `XeLaTeX`. Before building, make sure you have:

- A LaTeX distribution such as TeX Live (full scheme recommended) or MiKTeX.
- `lualatex` and `biber` available on your PATH. The build script checks for both and stops if either is missing.

See [3-VSCODE_TeXLive_SETUP.md](../manual/3-VSCODE_TeXLive_SETUP.md) for installation. Use `.\TPT_main_build.cmd` on Windows or `./TPT_main_build.sh` on macOS/Linux.

## Build

```powershell
.\TPT_main_build.cmd
```

Generated PDF:

- `TPT_main.pdf`

Clean build artifacts:

```powershell
.\TPT_main_build.cmd clean
```

## Reference PDF Tools (repo-root `code/` folder)

The repo-root `code/` folder contains two Python scripts for managing reference PDFs (run them from this template folder with `../code/`).

| File | Purpose |
| --- | --- |
| `../code/rename_ref_pdfs_by_bib.py` | Matches the BibTeX entries in `sub/references.bib` against the PDFs in the `ref/` folder and renames the PDFs to readable `Author. (Year). Title. Journal.pdf` names. It writes CSV reports for matched, unmatched, and missing references. |
| `../code/download_missing_ref_pdfs.py` | Downloads reference PDFs that are listed in `references.bib` but missing from the `ref/` folder, using open-access sources, DOIs, and the lab paper-search server. |

### Installing the required modules

The two scripts use the following Python packages.

- `pymupdf` — extracts PDF body text (for filename matching)
- `pypdf` — fallback text extraction when PyMuPDF fails
- `requests` — paper downloads (download script only)

Install them on Python 3.10 or newer. Running them inside the `knue-python` conda environment from this repository's [4-PYTHON_CONDA_VSCODE_SETUP.md](../manual/4-PYTHON_CONDA_VSCODE_SETUP.md) is recommended.

```powershell
conda activate knue-python
pip install pymupdf pypdf requests
```

If you do not use conda, install the same packages into your Python.

```powershell
pip install pymupdf pypdf requests
```

On Windows, if typing `python` only opens the Microsoft Store page instead of running, make sure the conda environment is activated, or that Python is installed and on your PATH.

### Running the scripts

Open the template folder as your working folder and run the scripts from there. It is safest to preview first with `--dry-run`, which does not change any files.

```powershell
# 1) Tidy PDF names in the ref folder (preview first)
python ../code/rename_ref_pdfs_by_bib.py --dry-run
# Actually rename
python ../code/rename_ref_pdfs_by_bib.py

# 2) Download missing reference PDFs (list candidates first)
python ../code/download_missing_ref_pdfs.py --dry-run
# Actually download
python ../code/download_missing_ref_pdfs.py
```

See all options, such as `--bib` and `--ref-dir`, with `--help`.

```powershell
python ../code/rename_ref_pdfs_by_bib.py --help
python ../code/download_missing_ref_pdfs.py --help
```

### Lab paper-search server password

`download_missing_ref_pdfs.py` also checks the lab paper-search server (`parksparks`) alongside the public sources. That server requires a login, and the password is not stored in the code. Provide it in one of two ways.

- Set the password in the `PARKSPARKS_PASSWORD` environment variable.
- Or save the password as a single line in `../code/.parksparks_secret`. This file is listed in `.gitignore`, so it is not committed to the repository.

If no password is provided or it is wrong, the script skips the search server and keeps downloading from the public sources. Ask the lab administrator for the password.
