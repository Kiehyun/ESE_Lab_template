%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Physics Teacher (TPT) manuscript helper class
%
% This local class implements the manuscript conventions described in
% AAPT's "Information for Contributors to TPT" page:
% - no abstract block;
% - title-only front matter for anonymous submission/review;
% - sequential superscript endnotes/references at the end;
% - line numbers for initial submission/review, removed for final files;
% - tables numbered with Roman numerals.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% FUNDAMENTAL DECLARATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tpt}
\LoadClass[letterpaper,onecolumn,oneside,12pt]{article}
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

% Bibliography setup for The Physics Teacher: numbered endnotes/references.
\usepackage{csquotes}
\usepackage[
  backend=biber,
  style=numeric-comp,
  sorting=none,
  giveninits=true,
  maxbibnames=3,
  minbibnames=1,
  sortcites=true,
]{biblatex}
\AtBeginDocument{%
  \let\parencite\supercite
  \let\kparencite\supercite
  \let\cite\supercite
}
\renewcommand{\bibfont}{\small}
\defbibheading{bibliography}[\refname]{\section*{Endnotes and References}}

\usepackage{amssymb}
\usepackage{graphicx}
\usepackage{epstopdf}
\usepackage{url}

\newcommand\email[1]{\texttt{#1}}

\usepackage{geometry}
\geometry{letterpaper,left=1in,right=1in,top=1in,bottom=1in,headsep=4mm,footskip=8mm}
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
\captionsetup[table]{font=small,labelfont=bf,justification=raggedright,singlelinecheck=false}
\captionsetup[figure]{font=small,labelfont=bf,skip=6pt,belowskip=-1em}
\renewcommand{\thetable}{\Roman{table}}
\renewcommand{\tablename}{Table}
\usepackage[pagewise,mathlines]{lineno}
\AtBeginDocument{%
  \ifcsname ifDocFinal\endcsname
    \ifDocFinal\else\linenumbers\fi
  \else
    \linenumbers
  \fi
}

\makeatletter
\renewcommand*\l@section{\@dottedtocline{1}{0em}{2em}}
\renewcommand*\l@subsection{\@dottedtocline{2}{2em}{2.75em}}
\renewcommand*\l@subsubsection{\@dottedtocline{3}{4.75em}{3.5em}}
\makeatother

\let\savenumberline\numberline
\def\numberline#1{\savenumberline{#1.}}

\linespread{1}

%%% ARTICLE HEAD: TITLE, AUTHORS, ABSTRACT, ETC. %%%%%%%%%%%%%%%%%%%%


\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\pagestyle{fancy}
% Footer: page number centered
\fancyfoot[C]{\thepage}

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

% TPT front matter: title only for anonymous review; no abstract.
\def\kessheadcontent{%
\vspace*{-5mm}%
\begin{center}
  {\bfseries\Large \kessgettitleeng\par}
  \ifcsname ifDocFinal\endcsname
    \ifDocFinal
      \vspace{3mm}
      {\large \kessgetauthoreng\par}
      \vspace{1.5mm}
      {\normalsize \kessgetaffileng\par}
    \fi
  \fi
\end{center}
\vspace{2mm}%
\ifcsname saythanks\endcsname\csname saythanks\endcsname\fi%
}

% \kesshead: default one-column output; final mode may redefine this in the main file.
\def\kesshead{%
  \kessheadcontent%
}

% TPT does not use abstracts. Keep this macro empty for compatibility with
% older main files that may still call \kasetail.
\def\kasetail{%
}

%%% THE END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\endinput

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Publications of the Korean Astronomical Society (PKAS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
