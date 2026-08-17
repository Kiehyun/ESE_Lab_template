# References — 공용 참고문헌 폴더

이 폴더는 **연구 전 과정(연구 계획서 → 발표 → 학위논문 → 학술지)에서 참고하는 논문을 한곳에 모으는**
공용 폴더입니다. 각 템플릿 폴더 안에 따로 두던 `ref/` 폴더 대신, 이 폴더 하나에 모아 Obsidian 볼트
전체에서 함께 활용합니다.

## 파일 이름 규칙 (APA7)

논문 한 편마다 아래 **두 파일을 같은 이름**으로 둡니다.

| 종류 | 이름 형식 | 예시 |
| --- | --- | --- |
| PDF 원문 | `저자_연도-논문제목.pdf` | `Keeling_1960-Concentration and isotopic abundances of CO2.pdf` |
| 요약 노트 | `저자_연도-논문제목.md` | `Keeling_1960-Concentration and isotopic abundances of CO2.md` |

- **저자**는 APA7 방식의 제1저자 성(family name)을 씁니다(예: `Keeling`, `홍길동`).
- **파일명은 70바이트 이내**로 자릅니다. 긴 제목은 뒷부분을 줄이거나 핵심어만 남깁니다.
  (NAS·클라우드 동기화의 파일명 길이 제한을 피하기 위함입니다.)
- PDF와 `.md`를 같은 이름으로 짝지어 두면, Obsidian에서 요약 노트를 열고 바로 옆 원문 PDF를
  확인할 수 있고 검색·그래프·백링크로 문헌을 연결하기 좋습니다.

## 요약 노트(.md)에 담을 내용

`Keeling_1960-...md`를 예시로 참고하세요. 보통 다음을 담습니다.

- 프론트매터: 서지정보(title/authors/year/journal/doi), **인용키(citekey)**, 태그, 짝 PDF 이름
- 한 줄 요약, 핵심 내용, 인용할 문장(+쪽수), 관련 노트 `[[…]]`
- `.bib`에 등록한 인용키로 본문에서 `\parencite{key}` / `\citep{key}` 인용

## 버전 관리(git)

- **요약 노트(`.md`)는 저장소에 커밋**합니다 — 볼트의 핵심 자산입니다.
- **원문 PDF(`.pdf`)는 커밋하지 않습니다**(저작권·용량). `.gitignore`의 `**/*.pdf`로 제외되며,
  각자 자신의 볼트(디스크)에만 둡니다. 특정 PDF를 꼭 커밋해야 하면 `.gitignore`에
  `!References/파일.pdf` 예외를 추가하세요.

## 참고문헌 정리 도구

`.bib`의 항목과 대조해 PDF 파일명을 이 규칙에 맞게 자동 정리해 주는 도구가 저장소 루트의
`code/rename_ref_pdfs_by_bib.py`에 있습니다. 대상 폴더는 `--ref-dir`로 지정할 수 있습니다
(예: 원고 폴더에서 `python ../code/rename_ref_pdfs_by_bib.py --ref-dir ../References`). 자세한 사용법은
각 템플릿 Readme의 "참고문헌 PDF 도구" 절을 참고하세요.

## 컬렉션 (모아 둔 주제)

- **과학의 본성(Nature of Science, NOS)** — 핵심 문헌 41편 요약 노트. 목차: [[_과학의 본성 (NOS) 컬렉션]] (파일: `_과학의 본성 (NOS) 컬렉션.md`).
  [jehyunlee/paper-curation](https://github.com/jehyunlee/paper-curation)의 6섹션 리뷰 방법으로 작성했습니다.
