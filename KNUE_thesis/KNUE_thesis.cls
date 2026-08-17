% KNUE_thesis.cls
% Korean Thesis Class File
% Based on article.cls with Korean language support and custom formatting

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{KNUE_thesis}[2026/11/17 Korean Thesis Class]

% Optional watermark:
%   \documentclass[watermark]{KNUE_thesis}   -> show KNUE logo watermark
%   \documentclass{KNUE_thesis}              -> no watermark
%
% Optional cover trim box:
%   \documentclass[trimbox]{KNUE_thesis}     -> show 190 mm x 260 mm cover trim box
%   \documentclass[notrimbox]{KNUE_thesis}   -> hide cover trim box
\newif\ifKNUE@watermark
\KNUE@watermarkfalse
\newif\ifCoverShowTrimBox
\CoverShowTrimBoxtrue
\DeclareOption{watermark}{\KNUE@watermarktrue}
\DeclareOption{nowatermark}{\KNUE@watermarkfalse}
\DeclareOption{trimbox}{\CoverShowTrimBoxtrue}
\DeclareOption{notrimbox}{\CoverShowTrimBoxfalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

% Inherit from article class
\LoadClass[11pt,oneside,a4paper]{article}

% ========== Package Requirements ==========
\RequirePackage{ifxetex,ifluatex}
\RequirePackage{fix-cm}
\RequirePackage{geometry}
\RequirePackage{setspace}
\RequirePackage{fancyhdr}
\RequirePackage{etoolbox}

% ========== Jupyter nbconvert Support Packages ==========
% For Verbatim environment and syntax highlighting
\RequirePackage{fancyvrb}
% For code highlighting colors
\RequirePackage{xcolor}
% For tcolorbox (notebook cells styling)
\RequirePackage{tcolorbox}

% ========== TikZ with positioning library ==========
\RequirePackage{tikz}
\usetikzlibrary{positioning,shapes,arrows.meta,fit}
\providecommand{\CoverTrimDefaultWidth}{190mm}
\providecommand{\CoverTrimDefaultHeight}{260mm}
\tikzset{cover trim box/.style={line width=0.25pt}}
\providecommand{\CoverTrimBoxStyle}{cover trim box}

% ========== Font Setup (XeLaTeX/LuaLaTeX) ==========
% Select OS-native Korean fonts. Body text uses a Myeongjo/serif family,
% while captions, tables, figures, and notebook graphics use a Gothic/sans family.
\newcommand{\KNUE@missinghangulserif}{%
    \PackageError{KNUE_thesis}{No Korean serif font found}{Install one Korean serif font such as Batang, AppleMyungjo, NanumMyeongjo, Noto Serif CJK KR, or UnBatang. On Ubuntu, install fonts-nanum or fonts-noto-cjk.}%
}
\newcommand{\KNUE@missinghangulsans}{%
    \PackageError{KNUE_thesis}{No Korean sans font found}{Install one Korean sans font such as Malgun Gothic, Apple SD Gothic Neo, NanumGothic, Noto Sans CJK KR, or UnDotum. On Ubuntu, install fonts-nanum or fonts-noto-cjk.}%
}
\newcommand{\KNUE@setlatinfonts}{%
    \ifwindows
        % TeX Gyre Termes: TeX Live 에 기본 포함된 Times 호환 세리프체(로마자 본문용).
        % 시스템 Times New Roman 유무와 무관하게 동일하게 렌더된다.
        \IfFontExistsTF{TeX Gyre Termes}{\setmainfont{TeX Gyre Termes}}{\setmainfont{Latin Modern Roman}}%
        \IfFontExistsTF{Arial}{\setsansfont{Arial}}{\setsansfont{Latin Modern Sans}}%
        \IfFontExistsTF{Consolas}{\setmonofont{Consolas}}{\setmonofont{Latin Modern Mono}}%
    \else\ifmacosx
        \IfFontExistsTF{Times New Roman}{\setmainfont{Times New Roman}}{\setmainfont{Latin Modern Roman}}%
        \IfFontExistsTF{Helvetica}{\setsansfont{Helvetica}}{\setsansfont{Latin Modern Sans}}%
        \IfFontExistsTF{Menlo}{\setmonofont{Menlo}}{\setmonofont{Latin Modern Mono}}%
    \else\iflinux
        \IfFontExistsTF{Liberation Serif}{\setmainfont{Liberation Serif}}{\setmainfont{Latin Modern Roman}}%
        \IfFontExistsTF{Liberation Sans}{\setsansfont{Liberation Sans}}{\setsansfont{Latin Modern Sans}}%
        \IfFontExistsTF{Liberation Mono}{\setmonofont{Liberation Mono}}{\setmonofont{Latin Modern Mono}}%
    \else
        \setmainfont{Latin Modern Roman}%
        \setsansfont{Latin Modern Sans}%
        \setmonofont{Latin Modern Mono}%
    \fi\fi\fi
    \renewcommand{\familydefault}{\rmdefault}%
}
\newcommand{\KNUE@sethangulserif}{%
    \ifwindows
        \IfFontExistsTF{Batang}{%
            \setmainhangulfont{Batang}[AutoFakeBold=2.0,AutoFakeSlant=0.2]%
        }{%
            \IfFontExistsTF{NanumMyeongjo}{%
                \setmainhangulfont{NanumMyeongjo}[AutoFakeSlant=0.2]%
            }{%
                \IfFontExistsTF{Noto Serif CJK KR}{%
                    \setmainhangulfont{Noto Serif CJK KR}[AutoFakeSlant=0.2]%
                }{%
                    \IfFontExistsTF{UnBatang}{\setmainhangulfont{UnBatang}[AutoFakeSlant=0.2]}{\KNUE@missinghangulserif}%
                }%
            }%
        }%
    \else\ifmacosx
        \IfFontExistsTF{AppleMyungjo}{%
            \setmainhangulfont{AppleMyungjo}[AutoFakeBold=2.0,AutoFakeSlant=0.2]%
        }{%
            \IfFontExistsTF{NanumMyeongjo}{%
                \setmainhangulfont{NanumMyeongjo}[AutoFakeSlant=0.2]%
            }{%
                \IfFontExistsTF{Noto Serif CJK KR}{%
                    \setmainhangulfont{Noto Serif CJK KR}[AutoFakeSlant=0.2]%
                }{%
                    \IfFontExistsTF{UnBatang}{\setmainhangulfont{UnBatang}[AutoFakeSlant=0.2]}{\KNUE@missinghangulserif}%
                }%
            }%
        }%
    \else\iflinux
        \IfFontExistsTF{NanumMyeongjo}{%
            \setmainhangulfont{NanumMyeongjo}[AutoFakeSlant=0.2]%
        }{%
            \IfFontExistsTF{UnBatang}{%
                \setmainhangulfont{UnBatang}[AutoFakeSlant=0.2]%
            }{%
                \IfFontExistsTF{Noto Serif CJK KR}{%
                    \setmainhangulfont{Noto Serif CJK KR}[AutoFakeSlant=0.2]%
                }{%
                    \KNUE@missinghangulserif%
                }%
            }%
        }%
    \else
        \IfFontExistsTF{NanumMyeongjo}{%
            \setmainhangulfont{NanumMyeongjo}[AutoFakeSlant=0.2]%
        }{%
            \IfFontExistsTF{Noto Serif CJK KR}{%
                \setmainhangulfont{Noto Serif CJK KR}[AutoFakeSlant=0.2]%
            }{%
                \IfFontExistsTF{UnBatang}{\setmainhangulfont{UnBatang}[AutoFakeSlant=0.2]}{\KNUE@missinghangulserif}%
            }%
        }%
    \fi\fi\fi
}
\newcommand{\KNUE@sethangulsans}{%
    \ifwindows
        \IfFontExistsTF{Malgun Gothic}{%
            \setsanshangulfont{Malgun Gothic}[AutoFakeSlant=0.2]%
            \setmonohangulfont{Malgun Gothic}[AutoFakeSlant=0.2]%
        }{%
            \IfFontExistsTF{NanumGothic}{%
                \setsanshangulfont{NanumGothic}[AutoFakeSlant=0.2]%
                \setmonohangulfont{NanumGothic}[AutoFakeSlant=0.2]%
            }{%
                \IfFontExistsTF{Noto Sans CJK KR}{%
                    \setsanshangulfont{Noto Sans CJK KR}[AutoFakeSlant=0.2]%
                    \setmonohangulfont{Noto Sans CJK KR}[AutoFakeSlant=0.2]%
                }{%
                    \IfFontExistsTF{UnDotum}{%
                        \setsanshangulfont{UnDotum}[AutoFakeSlant=0.2]%
                        \setmonohangulfont{UnDotum}[AutoFakeSlant=0.2]%
                    }{\KNUE@missinghangulsans}%
                }%
            }%
        }%
    \else\ifmacosx
        \IfFontExistsTF{Apple SD Gothic Neo}{%
            \setsanshangulfont{Apple SD Gothic Neo}[AutoFakeSlant=0.2]%
            \setmonohangulfont{Apple SD Gothic Neo}[AutoFakeSlant=0.2]%
        }{%
            \IfFontExistsTF{NanumGothic}{%
                \setsanshangulfont{NanumGothic}[AutoFakeSlant=0.2]%
                \setmonohangulfont{NanumGothic}[AutoFakeSlant=0.2]%
            }{%
                \IfFontExistsTF{Noto Sans CJK KR}{%
                    \setsanshangulfont{Noto Sans CJK KR}[AutoFakeSlant=0.2]%
                    \setmonohangulfont{Noto Sans CJK KR}[AutoFakeSlant=0.2]%
                }{%
                    \IfFontExistsTF{UnDotum}{%
                        \setsanshangulfont{UnDotum}[AutoFakeSlant=0.2]%
                        \setmonohangulfont{UnDotum}[AutoFakeSlant=0.2]%
                    }{\KNUE@missinghangulsans}%
                }%
            }%
        }%
    \else\iflinux
        \IfFontExistsTF{NanumGothic}{%
            \setsanshangulfont{NanumGothic}[AutoFakeSlant=0.2]%
            \setmonohangulfont{NanumGothic}[AutoFakeSlant=0.2]%
        }{%
            \IfFontExistsTF{UnDotum}{%
                \setsanshangulfont{UnDotum}[AutoFakeSlant=0.2]%
                \setmonohangulfont{UnDotum}[AutoFakeSlant=0.2]%
            }{%
                \IfFontExistsTF{Noto Sans CJK KR}{%
                    \setsanshangulfont{Noto Sans CJK KR}[AutoFakeSlant=0.2]%
                    \setmonohangulfont{Noto Sans CJK KR}[AutoFakeSlant=0.2]%
                }{%
                    \KNUE@missinghangulsans%
                }%
            }%
        }%
    \else
        \IfFontExistsTF{NanumGothic}{%
            \setsanshangulfont{NanumGothic}[AutoFakeSlant=0.2]%
            \setmonohangulfont{NanumGothic}[AutoFakeSlant=0.2]%
        }{%
            \IfFontExistsTF{Noto Sans CJK KR}{%
                \setsanshangulfont{Noto Sans CJK KR}[AutoFakeSlant=0.2]%
                \setmonohangulfont{Noto Sans CJK KR}[AutoFakeSlant=0.2]%
            }{%
                \IfFontExistsTF{UnDotum}{%
                    \setsanshangulfont{UnDotum}[AutoFakeSlant=0.2]%
                    \setmonohangulfont{UnDotum}[AutoFakeSlant=0.2]%
                }{\KNUE@missinghangulsans}%
            }%
        }%
    \fi\fi\fi
}
\newcommand{\KNUE@setupfonts}{%
    \KNUE@setlatinfonts
    % 한글 폰트: 저장소에 번들한 나눔명조(명조체)/나눔고딕(고딕체)을 fonts/ 에서
    % 직접 로드한다. OS(Windows/macOS/Ubuntu)와 무관하게 동일하게 렌더되며 시스템
    % 폰트 폴백에 의존하지 않는다. (위의 \KNUE@sethangulserif/\KNUE@sethangulsans 는
    % 폰트를 시스템에서 찾는 폴백 정의로 남겨 두었으나 기본 경로에서는 호출하지 않는다.
    % 번들 폰트를 쓰지 않으려면 아래 세 줄을 지우고 두 폴백 명령을 호출하면 된다.)
    \setmainhangulfont{NanumMyeongjo}[Path=./fonts/, Extension=.otf, BoldFont=*Bold, AutoFakeSlant=0.2]%
    \setsanshangulfont{NanumGothic}[Path=./fonts/, Extension=.otf, BoldFont=*Bold, AutoFakeSlant=0.2]%
    \setmonohangulfont{NanumGothic}[Path=./fonts/, Extension=.otf, BoldFont=*Bold, AutoFakeSlant=0.2]%
}
\ifxetex
    \RequirePackage{fontspec}
    \RequirePackage{ifplatform}
    \RequirePackage{kotex}
    \defaultfontfeatures{Ligatures=TeX}
    \KNUE@setupfonts
\else\ifluatex
    \RequirePackage{fontspec}
    \RequirePackage{ifplatform}
    \RequirePackage{kotex}
    \defaultfontfeatures{Ligatures=TeX}
    \KNUE@setupfonts
\else
    \RequirePackage{kotex}
\fi\fi

% ========== Page Layout ==========
% A4 paper: 210mm × 297mm
\geometry{
    a4paper,
    top=50mm,
    bottom=50mm,
    left=35mm,
    right=35mm,
    headsep=15mm,
    footskip=15mm
}

% ========== Line Spacing ==========
\setstretch{1.8}  % 180% line spacing for body text

% ========== Header and Footer ==========
\pagestyle{fancy}
\fancyhf{}
\fancyfoot[C]{- \thepage\ -}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}

% Plain page style for chapter pages
\fancypagestyle{plain}{%
    \fancyhf{}
    \fancyfoot[C]{- \thepage\ -}
    \renewcommand{\headrulewidth}{0pt}
    \renewcommand{\footrulewidth}{0pt}
}

% ========== Section Formatting ==========
\usepackage{titlesec}

% Change section numbering to Roman numerals (I, II, III)
\renewcommand{\thesection}{\Roman{section}}
% Change subsection numbering to Arabic numerals (1, 2, 3)
\renewcommand{\thesubsection}{\arabic{subsection}}
% Change subsubsection numbering to Korean characters (가, 나, 다)
\makeatletter
\def\korean@char#1{%
  \ifcase#1\or 가\or 나\or 다\or 라\or 마\or 바\or 사\or 아\or 자\or 차\or 카\or 타\or 파\or 하\else *#1\fi
}
\renewcommand{\thesubsubsection}{\korean@char{\value{subsubsection}}}
\makeatother

% Format section headings with dots after numbers
\titleformat{\section}
  {\normalfont\Large\bfseries}{\thesection.}{1em}{}
\titleformat{\subsection}
  {\normalfont\large\bfseries}{\thesubsection.}{1em}{}
\titleformat{\subsubsection}
  {\normalfont\normalsize\bfseries}{\thesubsubsection.}{1em}{}

% ========== Table of Contents ==========
\usepackage{titletoc,tocloft}
\setcounter{tocdepth}{2}
\setcounter{secnumdepth}{3}

\renewcommand{\cftsecleader}{\cftdotfill{\cftdotsep}}
\renewcommand{\cftsubsecleader}{\cftdotfill{\cftdotsep}}

% Format section numbers with periods
\setlength{\cftsecnumwidth}{2.5em}
\renewcommand{\cftsecpresnum}{}
\renewcommand{\cftsecaftersnum}{.\ }

% Format subsection numbers with periods
\setlength{\cftsubsecnumwidth}{2.5em}
\renewcommand{\cftsubsecpresnum}{}
\renewcommand{\cftsubsecaftersnum}{.\ }

% Format subsubsection numbers with periods
\setlength{\cftsubsubsecnumwidth}{2.5em}
\renewcommand{\cftsubsubsecpresnum}{}
\renewcommand{\cftsubsubsecaftersnum}{.\ }

% Format figure and table entries with consistent spacing
% Make them align with section entries by adjusting indentation
% Widen number boxes so caption text does not collide with labels
\setlength{\cftfignumwidth}{6.55em}
\setlength{\cfttabnumwidth}{6.25em}
\setlength{\cftfigindent}{0pt}
\setlength{\cfttabindent}{0pt}
% Avoid duplicating labels in LoF/LoT (caption already provides "그림"/"표")
\renewcommand{\cftfigpresnum}{}
\renewcommand{\cftfigaftersnum}{\hspace{0.12em}}
\renewcommand{\cfttabpresnum}{}
\renewcommand{\cfttabaftersnum}{\hspace{0.12em}}
\renewcommand{\cftfigleader}{\cftdotfill{\cftdotsep}}
\renewcommand{\cfttableader}{\cftdotfill{\cftdotsep}}

\renewcommand*\contentsname{목 차}
\renewcommand*\listfigurename{그림 목차}
\renewcommand*\listtablename{표 목차}

% TOC 항목 글자 크기 11pt
\renewcommand{\cftsecfont}{\fontsize{11pt}{13.2pt}\selectfont}
\renewcommand{\cftsecpagefont}{\fontsize{11pt}{13.2pt}\selectfont}
\renewcommand{\cftsubsecfont}{\fontsize{11pt}{13.2pt}\selectfont}
\renewcommand{\cftsubsecpagefont}{\fontsize{11pt}{13.2pt}\selectfont}
\renewcommand{\cftsubsubsecfont}{\fontsize{11pt}{13.2pt}\selectfont}
\renewcommand{\cftsubsubsecpagefont}{\fontsize{11pt}{13.2pt}\selectfont}
\renewcommand{\cftfigfont}{\fontsize{11pt}{13.2pt}\selectfont}
\renewcommand{\cftfigpagefont}{\fontsize{11pt}{13.2pt}\selectfont}
\renewcommand{\cfttabfont}{\fontsize{11pt}{13.2pt}\selectfont}
\renewcommand{\cfttabpagefont}{\fontsize{11pt}{13.2pt}\selectfont}

% ========== List Formatting ==========
% Load enumitem with shortlabels to avoid conflicts
\usepackage[shortlabels]{enumitem}
\setlist[itemize]{leftmargin=2em, topsep=0pt, partopsep=0pt}
\setlist[enumerate]{leftmargin=2em, topsep=0pt, partopsep=0pt}

% ========== Figure and Table Captions ==========
\usepackage{caption}
\usepackage{booktabs}
\usepackage{array}
\usepackage{colortbl}

% Caption setup (font will be set via the configured sans/Gothic family)
\captionsetup{
    font={sf},
    labelsep=space,
    justification=raggedright,
    singlelinecheck=false
}

% Figure numbering: Sequential
\makeatletter
\renewcommand{\thefigure}{\arabic{figure}}
\renewcommand{\thetable}{\arabic{table}}
\makeatother

% Table caption format
\DeclareCaptionLabelFormat{krtable}{표 #2}
\captionsetup[table]{
    name=표,
    labelformat=krtable,
    labelsep=space,
    indent=0pt
}

% Figure caption format
\DeclareCaptionLabelFormat{krfigure}{그림 #2}
\captionsetup[figure]{
    name=그림,
    labelformat=krfigure,
    labelsep=space
}

% ========== Table Enhancement ==========
\usepackage{threeparttable}
\usepackage{makecell}

% ========== Bibliography ==========
% biblatex-apa provides APA 7th edition via style=apa
% APA 7 key rules:
%   - Up to 20 authors listed in references (then et al.)
%   - In-text: 1-2 authors always listed; 3+ use first author + et al.
%   - DOI displayed as hyperlink URL
\usepackage[%
    backend=biber,%
    style=apa,%          % APA 7th edition style
    natbib=true,%        % \citet, \citep compatibility
    maxbibnames=20,%     % APA7: list up to 20 authors before et al.
    minbibnames=20,%
    maxcitenames=2,%     % APA7: 3+ authors -> first author + et al.
    mincitenames=1,%
    uniquelist=false,%
    dashed=false,%       % Always repeat author name (no dash)
    date=year,%          % Show year only (not full date)
    urldate=iso%         % ISO date format for URL access dates
]{biblatex}
\DeclareLanguageMapping{english}{english-apa}
% APA 7: DOI as hyperlink
\DeclareFieldFormat{doi}{%
    \ifhyperref{\href{https://doi.org/#1}{\nolinkurl{https://doi.org/#1}}}{\nolinkurl{https://doi.org/#1}}%
    \nopunct%
}

\DefineBibliographyStrings{english}{%
    bibliography = {참고 문헌},
    references = {참고 문헌},
}

\defbibheading{bibliography}[\bibname]{%
    \section*{\centerline{#1}}%
    \markboth{#1}{#1}%
}

% ========== Hyperref ==========
\usepackage{hyperref}
\hypersetup{
    hidelinks,
    unicode=true,
    bookmarksnumbered=true,
    pdfencoding=auto,
    breaklinks=true
}

% ========== Graphics ==========
\usepackage{graphicx}
\usepackage{xcolor}
\usepackage{tikz}

\graphicspath{{images/}{./}}

% ========== Optional KNUE Logo Watermark ==========
% Enable with \documentclass[watermark]{KNUE_thesis}.
% The logo is placed behind page contents at a size close to the thesis sample.
\makeatletter
\ifKNUE@watermark
    \AddToHook{shipout/background}{%
        \begin{tikzpicture}[remember picture,overlay]
            \node[opacity=0.35] at (current page.center)
                {\includegraphics[width=88mm]{logo/Knue_logo.png}};
        \end{tikzpicture}%
    }
\fi
\makeatother

% ========== Mathematical Packages ==========
\usepackage{amsmath}
\usepackage{amssymb}
\usepackage{amsthm}

% ========== Code Listings ==========
\usepackage{listings}
\usepackage{tcolorbox}
\tcbuselibrary{listings,breakable}

\lstset{
    basicstyle=\ttfamily\small,
    breaklines=true,
    postbreak=\mbox{\textcolor{red}{$\hookrightarrow$}\space},
    numbers=left,
    numberstyle=\tiny,
    keywordstyle=\color{blue},
    commentstyle=\color{gray},
    stringstyle=\color{red},
    showstringspaces=false,
    tabsize=4,
    language=Python
}

% ========== Other Useful Packages ==========
\usepackage{multirow}
\usepackage{longtable}
\usepackage{tabularx}
\usepackage{datetime}
\usepackage{indentfirst}

% Indent first paragraph
\AtBeginDocument{%
    \raggedbottom
    \parindent=1em % 본문 들여쓰기: 1글자(1em)
}

% ========== Command Definitions ==========
% Korean label commands
\newcommand{\chapternameKor}{장}
\newcommand{\sectionname}{절}

% ========== End of KNUE_thesis.cls ==========
\endinput
