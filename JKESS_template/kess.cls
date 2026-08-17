%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Publications of the Korean Astronomical Society (PKAS)
% LaTeX 2e class file for articles (version 2014/05/19)
% Questions? Comments? Bug reports? Contact: pkas@kasi.re.kr
% Korean journal submission template adaptation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% FUNDAMENTAL DECLARATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{kess}
\LoadClass[a4paper,onecolumn,twoside,10pt]{article}
\usepackage{titling}
%\pretitle{\begin{center}\Large\fontfamily{ptm}\selectfont\scshape\bfseries}
\pretitle{\vspace*{-2.8cm}\begin{center} \bfseries \sf}%\fontfamily{ptm}\selectfont\scshape\bfseries)
\posttitle{\end{center}\vspace{-2mm}}
\preauthor{\begin{center}\small}
\postauthor{\end{center}}
\predate{\vspace{-9mm}\begin{center}\small}
\postdate{\end{center}\vspace{-2mm}}

% Avoid conflict with abstract.sty which defines onecolabstract
% \newenvironment{onecolabstract}{\begin{abstract}}{\end{abstract}}

\renewenvironment{enumerate}%
  {\begin{list}{\arabic{enumi}.}%
     {\topsep=0.25em\itemsep=0.25em\parsep=0mm\partopsep=0mm\usecounter{enumi}}%
   }{\end{list}}
   
\renewenvironment{itemize}%
  {\begin{list}{$\bullet$}%
     {\topsep=0.25em\itemsep=0.25em\parsep=0mm\partopsep=0mm}%
   }{\end{list}}
   
\def\acknowledgments{
  \section*{\centering \textbf{Acknowledgments}}%
  \addcontentsline{toc}{section}{Acknowledgments}%
}

\usepackage[auth-sc]{authblk}
\setlength{\affilsep}{0.333em}
\renewcommand\Authand{ \& }
\renewcommand\Authands{, }

\renewenvironment{appendix}{\par
\def\@hangfrom##1{\setbox\@tempboxa\hbox{{##1}}%
      \hangindent \parindent\noindent\box\@tempboxa}
\def\sectcounterend{.}
\def\@seccntformat##1{\appendixname\ \csname the##1\endcsname\sectcounterend{~~}}
  \setcounter{section}{0}%
  \setcounter{subsection}{0}%
  \renewcommand\thesection{\@Alph\c@section}%
  \renewcommand\thesubsection{\@Alph\c@section.\@arabic\c@subsection}%
  \renewcommand\thesubsubsection{\thesubsection.\@arabic\c@subsubsection}%
}

\let\oldtabular\tabular
\renewcommand{\tabular}{\small\oldtabular}
\usepackage{lscape}
\usepackage{booktabs}
\newcommand\tabnote[1]{\vspace{-1.2em}\footnotesize\parbox{\linewidth}{\vspace{0.7em}#1}}

\newenvironment{tablist}%
  {\footnotesize\begin{list}{$^{\mathrm{\alph{enumi}}}$}%
     {\topsep=0.7em\itemsep=0em\parsep=0mm\partopsep=0mm\usecounter{enumi}}%
   }{\end{list}\vskip-1.7em}

% Bibliography setup: APA7 with Biber
\usepackage{csquotes}
% Use APA 6th edition formatting via biblatex-apa
% APA6 with biber; suppress initials in in-text citations
\usepackage[
  backend=biber,
  style=apa6,
  sortcites=true,
  uniquename=false,
  uniquelist=false
]{biblatex}
% Ensure "et al." is italicized in citations and bibliography (APA6)
\DefineBibliographyStrings{english}{andothers = {\mkbibemph{et\ al\adddot}}}
\DeclareLanguageMapping{english}{english-apa6}
\addbibresource{./sub/references.bib}

\renewcommand{\bibfont}{\small}
% \renewcommand{\bibsep}{0mm}
% \renewcommand{\bibsection}{%
%   \section*{\centering \textbf{References}}%
%   \addcontentsline{toc}{section}{References}%
% }

\usepackage{amssymb}
\usepackage{graphicx}
\usepackage{epstopdf}
\usepackage{abstract}
\usepackage{url}

\newcommand\email[1]{\texttt{#1}}

\usepackage{geometry}
\geometry{a4paper,left=17.5mm,right=17.5mm,top=33mm,bottom=27mm,headsep=4mm,footskip=6mm}
\setlength{\columnsep}{5mm}

\usepackage{fancyhdr}

\usepackage{titlesec}
% titlelabel{\thetitle.~~}
% titleformat*{\section}{\sffamily\bfseries\MakeUppercase}
% titleformat*{\subsection}{\sffamily\bfseries}
% titleformat*{\subsubsection}{\sffamily\bfseries}
% titlespacing*{\section}{0pt}{*2.5}{*1.2}
\titlespacing*{\subsection}{0pt}{*2}{*1.2}
\titlespacing*{\subsubsection}{0pt}{*2}{*1.2}
\titlespacing*{\paragraph}{0pt}{*0.5}{*1.5}

\usepackage[font=small,format=plain,labelsep=period]{caption}
\captionsetup[table]{font={small,sf},labelfont={bf,sf},textfont=sf,justification=raggedright,singlelinecheck=false}
\captionsetup[figure]{font={small,sf},labelfont={bf,sf},textfont=sf,skip=6pt,belowskip=-1em}

\renewcommand{\abstractname}{{}\vspace{-14mm}}

\makeatletter
\renewcommand*\l@section{\@dottedtocline{1}{0em}{2em}}
\renewcommand*\l@subsection{\@dottedtocline{2}{2em}{2.75em}}
\renewcommand*\l@subsubsection{\@dottedtocline{3}{4.75em}{3.5em}}
\makeatother

\let\savenumberline\numberline
\def\numberline#1{\savenumberline{#1.}}

\makeatletter
\def\blfootnote{\gdef\@thefnmark{}\@footnotetext}
\makeatother

\renewcommand{\footnoterule}{%
  \kern -3pt
  \hrule width 28.3mm height 0.2pt
  \kern 2.8pt
}

\makeatletter
\renewcommand*{\@fnsymbol}[1]{\ensuremath{\ifcase#1\or\dagger\or\ddagger\or\S\or\P\or\parallel\or\sharp\or\flat\or\natural\else\@ctrerr\fi}}
\makeatother

\renewcommand{\thefootnote}{\bfseries\arabic{footnote}}

\makeatletter
\renewcommand\@makefntext[1]{\leftskip=0.9em\hskip-0.6em\@makefnmark#1}
\makeatother

\interfootnotelinepenalty=1000
\linespread{0.93}

%%% ARTICLE HEAD: TITLE, AUTHORS, ABSTRACT, ETC. %%%%%%%%%%%%%%%%%%%%


\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\pagestyle{fancy}

% Header
\fancyhead[ce]{\small\sffamily\AuthorOneKOR}
\fancyhead[co]{\small\sffamily\PaperTitleKOR}
% Footer: page number centered
\fancyfoot[C]{\thepage}

% Ensure first page has no number, rest have centered page number
	\thispagestyle{empty}

% Macros to capture bilingual title/authors/affiliations
\newcommand{\titleKOR}[1]{\def\titletextKOR{#1}}
\newcommand{\authorsKOR}[1]{\def\authorstextKOR{#1}}
\newcommand{\affilKOR}[1]{\def\affiltextKOR{#1}}
\newcommand{\titleENG}[1]{\def\titletextENG{#1}}
\newcommand{\authorsENG}[1]{\def\authorstextENG{#1}}
\newcommand{\affilENG}[1]{\def\affiltextENG{#1}}

\newcommand{\kessgettitlekor}{%
  \ifcsname titletextKOR\endcsname\titletextKOR\else
    \ifcsname PaperTitleKOR\endcsname\PaperTitleKOR\fi
  \fi
}
\newcommand{\kessgettitleeng}{%
  \ifcsname titletextENG\endcsname\titletextENG\else
    \ifcsname PaperTitleENG\endcsname\PaperTitleENG\fi
  \fi
}
\newcommand{\kessgetauthorkor}{%
  \ifcsname authorstextKOR\endcsname\authorstextKOR\fi
}
\newcommand{\kessgetauthoreng}{%
  \ifcsname authorstextENG\endcsname\authorstextENG\fi
}
\newcommand{\kessgetaffilkor}{%
  \ifcsname affiltextKOR\endcsname\affiltextKOR\fi
}
\newcommand{\kessgetaffileng}{%
  \ifcsname affiltextENG\endcsname\affiltextENG\fi
}

% \kessheadcontent: 제목/저자/초록 블록 (1단·2단 공용)
% \kesshead 와 2단 전환용 \twocolumn[\kessheadcontent] 모두에서 사용됨
\def\kessheadcontent{%
\vspace{-7mm}%
\small%
\ifcsname JournalName\endcsname
  \noindent {\sffamily \JournalName, v.~\JournalVolume, no.~\JournalIssue, p.~\JournalBeginPage--\JournalEndPage, \JournalMonth\ \JournalYear}%
  \hfill {pISSN \JournalPISSN}\\
  \noindent {\sffamily \href{\JournalDOI}{\JournalDOI}}%
  \hfill {eISSN \JournalEISSN}\\
\fi
\normalsize%
\vspace{3mm}%
\begin{center}
  {\bfseries\sffamily\Large \kessgettitlekor\par}
  \vspace{3mm}
  {\bfseries\large \kessgetauthorkor\par}
  \vspace{1.5mm}
  {\normalsize \kessgetaffilkor\par}
\end{center}
\vspace{4mm}
\begin{center}
  {\bfseries\sffamily\Large \kessgettitleeng\par}
  \vspace{3mm}
  {\bfseries\large \kessgetauthoreng\par}
  \vspace{1.5mm}
  {\normalsize \kessgetaffileng\par}
\end{center}
\vspace{3mm}
\par\noindent{\rmfamily\bfseries Abstract :}\space%
\ifcsname abstracttextENG\endcsname\expandafter\abstracttextENG\else
  \ifcsname abstracttext\endcsname\expandafter\abstracttext\fi
\fi%
\par\vspace{2mm}%
\noindent{\rmfamily\bfseries Key words:}\space
\ifcsname keywordsENG\endcsname\csname keywordsENG\endcsname\else
  \ifcsname keywords\endcsname\csname keywords\endcsname\fi
\fi%
\vspace{1.5em}%
\par\noindent{\rmfamily\bfseries 요약 :}\space%
\ifcsname abstracttextKOR\endcsname\expandafter\abstracttextKOR\fi%
\vspace{1mm}%
\par\noindent{\rmfamily\bfseries 주요어:}\space
\ifcsname keywordsKOR\endcsname\csname keywordsKOR\endcsname\fi%
\vspace{1em}%
\ifcsname saythanks\endcsname\csname saythanks\endcsname\fi%
}

% \kesshead: 기본(1단) 출력 — DocMode=final 일 때 메인 .tex 파일에서 재정의됨
\def\kesshead{%
  \kessheadcontent%
}

% Tail block to render Korean abstract and keywords at the end of front matter
\def\kasetail{%
  % Add spacing before Korean abstract block
  \vspace{1.5em}%
  % Korean abstract heading
  {\rmfamily\bfseries 요약 :}\space%
  % Insert Korean abstract if provided (\abstracttextKOR)
  \ifcsname abstracttextKOR\endcsname\expandafter\abstracttextKOR\fi%
  \vspace{1mm}%
  % Korean keywords heading and content
  {\rmfamily\bfseries 주제어: }\space\ifcsname keywordsKOR\endcsname\csname keywordsKOR\endcsname\fi%
  \vspace{1em}%
}

%%% THE END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\endinput

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Publications of the Korean Astronomical Society (PKAS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
