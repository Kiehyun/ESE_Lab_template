%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Publications of the Korean Astronomical Society (PKAS)
% LaTeX 2e class file for articles (version 2014/05/19)
% Questions? Comments? Bug reports? Contact: pkas@kasi.re.kr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% FUNDAMENTAL DECLARATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{jkase}
\LoadClass[a4paper,twocolumn,twoside,10pt]{article}
\usepackage{titling}
%\pretitle{\begin{center}\Large\fontfamily{ptm}\selectfont\scshape\bfseries}
\pretitle{\begin{center} \bfseries \sf}%\fontfamily{ptm}\selectfont\scshape\bfseries}
\posttitle{\end{center}\vspace{-4mm}}
\preauthor{\begin{center}\small}
\postauthor{\end{center}}
\predate{\vspace{-5mm}\begin{center}\small}
\postdate{\end{center}}

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
\renewcommand{\tabular}{\fontsize{8.5pt}{10.2pt}\selectfont\oldtabular}
\usepackage{lscape}
\usepackage{booktabs}
\newcommand\tabnote[1]{\vspace{-1.2em}\footnotesize\parbox{\linewidth}{\vspace{0.7em}#1}}

\newenvironment{tablist}%
  {\footnotesize\begin{list}{$^{\mathrm{\alph{enumi}}}$}%
     {\topsep=0.7em\itemsep=0em\parsep=0mm\partopsep=0mm\usecounter{enumi}}%
   }{\end{list}\vskip-1.7em}

% Bibliography setup: APA7 with Biber
\usepackage{csquotes}
\usepackage[backend=biber,style=apa,sortcites=true]{biblatex}
\DeclareLanguageMapping{english}{english-apa}
\addbibresource{./sub/references.bib}

\renewcommand{\bibfont}{\fontsize{8.7pt}{10.2pt}\selectfont\rmfamily}
\setlength{\bibhang}{1.7em}
\setlength{\bibitemsep}{0.15\baselineskip}
\setlength{\bibparsep}{0pt}
\defbibenvironment{bibliography}
  {\list
     {}
     {\setlength{\leftmargin}{\bibhang}%
      \setlength{\itemindent}{-\leftmargin}%
      \setlength{\itemsep}{\bibitemsep}%
      \setlength{\parsep}{\bibparsep}}}
  {\endlist}
  {\item}
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
\geometry{a4paper,left=12.5mm,right=12.5mm,top=22mm,bottom=17mm,headheight=10mm,footskip=10mm}
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
\captionsetup[table]{labelfont=bf}%,labelsep=,justification=centering,skip=6pt}
\captionsetup[figure]{labelfont=bf,skip=6pt,belowskip=-1em}

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
\linespread{1.0}
\makeatletter
\renewcommand\normalsize{%
  \@setfontsize\normalsize{9.5pt}{12.7pt}%
  \abovedisplayskip 8pt plus 2pt minus 4pt%
  \abovedisplayshortskip \z@ plus 2pt%
  \belowdisplayshortskip 4pt plus 2pt minus 2pt%
  \belowdisplayskip \abovedisplayskip%
  \let\@listi\@listI%
}
\normalsize
\makeatother

%%% ARTICLE HEAD: TITLE, AUTHORS, ABSTRACT, ETC. %%%%%%%%%%%%%%%%%%%%

\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\pagestyle{fancy}

\fancyhead[ce]{\small\sffamily\runningauthor}
\fancyhead[co]{\small\sffamily\runningtitle}
\fancyfoot[ro]{\thepage}
\fancyfoot[le]{\thepage}

% plain style (submission/review mode): only page number in footer
\fancypagestyle{plain}{%
  \fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
  \fancyfoot[ro]{\thepage}%
  \fancyfoot[le]{\thepage}%
}

%%% Anonymization / mode booleans (defined here so jkasehead can use them) %%%%
% Main .tex file must call \anonymizedsubmissiontrue / \finalcopytrue etc.
\newif\ifanonymizedsubmission  \anonymizedsubmissionfalse
\newif\ifreviewcopy            \reviewcopyfalse
\newif\iffinalcopy             \finalcopyfalse

%%% Bilingual front-matter setter commands %%%%%%%%%%%%%%%%%%%%%%%%%%%

\makeatletter

% Internal storage macros
\def\@titleKOR{}
\def\@authorsKOR{}
\def\@affilKOR{}
\def\@titleENG{}
\def\@authorsENG{}
\def\@affilENG{}
\def\@firstpageauthorblock{}
\def\@firstpagefootnotetext{}

% Setter commands (call these in the preamble of the main .tex file)
\newcommand{\titleKOR}[1]{\def\@titleKOR{#1}}
\newcommand{\authorsKOR}[1]{\def\@authorsKOR{#1}}
\newcommand{\affilKOR}[1]{\def\@affilKOR{#1}}
\newcommand{\titleENG}[1]{\def\@titleENG{#1}}
\newcommand{\authorsENG}[1]{\def\@authorsENG{#1}}
\newcommand{\affilENG}[1]{\def\@affilENG{#1}}
\newcommand{\firstpageauthorblock}[1]{\def\@firstpageauthorblock{#1}}
\newcommand{\firstpagefootnotetext}[1]{\def\@firstpagefootnotetext{#1}}

\makeatother

%%% \jkasehead: JKASE journal front-matter layout %%%%%%%%%%%%%%%%%%%%
%
%  1. Full-width bilingual title block
%     (Korean title / Korean author+affil block / English title /
%      English authors / English affiliation)
%  2. Horizontal rule
%  3. Side-by-side panel: ARTICLE INFO (left) | ABSTRACT (right)
%  4. Bottom rule + corresponding-author footnote
%
\makeatletter

\newcommand{\jkasejournalbanner}{%
  \iffinalcopy
    \begingroup
    \noindent\makebox[\textwidth][r]{%
      \fontsize{8.5pt}{10pt}\selectfont
      Journal of the Korean Association for Science Education, \volume(\issue), \beginpage$\sim$\endpage, \year
    }\par
    \vspace{7mm}%
    \noindent
    \colorbox{gray!35}{%
      \parbox[c][22mm][c]{0.145\textwidth}{%
        \centering
        {\color{gray!65}\rule{0.12\textwidth}{16mm}}%
      }%
    }%
    \hfill
    \colorbox{gray!55}{%
      \parbox[c][22mm][c]{0.835\textwidth}{%
        \centering
        {\sffamily\bfseries\color{white}\fontsize{17pt}{20pt}\selectfont
        Journal of the Korean Association for Science Education\par}%
        \vspace{1mm}%
        {\sffamily\bfseries\color{white}\fontsize{10pt}{12pt}\selectfont
        Journal homepage: www.koreascience.org\par}%
      }%
    }%
    \par\vspace{9mm}%
    \endgroup
  \fi
}

\def\jkasehead{%
  \jkasejournalbanner
  %--- Full-width title + author block --------------------------------
  \begin{center}%
    % Korean title
    {\setstretch{1.10}\sffamily\bfseries\fontsize{17.2pt}{21pt}\selectfont \@titleKOR\par}%
    % Korean authors + short affiliation (hidden in submission/review mode)
    \ifanonymizedsubmission\else
      \vspace{3.2mm}%
      {\setstretch{1.08}\@firstpageauthorblock\par}%
    \fi
    \vspace{4.6mm}%
    % English title
    {\setstretch{1.04}\sffamily\bfseries\fontsize{13.2pt}{15.8pt}\selectfont \@titleENG\par}%
    % English authors + affiliation (hidden in submission/review mode)
    \ifanonymizedsubmission\else
      \vspace{2.3mm}%
      {\sffamily\bfseries\fontsize{11.0pt}{13.2pt}\selectfont \@authorsENG\par}%
      \vspace{0.45mm}%
      {\sffamily\mdseries\fontsize{9.8pt}{11.8pt}\selectfont \@affilENG\par}%
    \fi
  \end{center}%
  \vspace{3mm}%
  %--- ARTICLE INFO | ABSTRACT panel ----------------------------------
  \vspace{1mm}%
  \noindent%
  \begin{minipage}[t]{0.225\textwidth}%
    \vspace{0pt}%
    \noindent{\sffamily\bfseries\footnotesize%
      A\,R\,T\,I\,C\,L\,E\enspace I\,N\,F\,O}\par%
    \vspace{0.8mm}%
    \noindent\rule{\linewidth}{0.4pt}\par%
    \vspace{-1.65mm}%
    {{\fontspec{Times New Roman}\itshape\fontsize{9pt}{10.5pt}\selectfont Article history:}}\par%
    \vspace{0.35mm}%
    {\begingroup\small\setstretch{0.92}\selectfont Received \received\par\endgroup}%
    \vspace{0.2mm}%
    {\begingroup\small\setstretch{0.92}\selectfont Received in revised form \revised\par\endgroup}%
    \vspace{0.2mm}%
    {\begingroup\small\setstretch{0.92}\selectfont\strut Accepted \accepted\par\endgroup}%
    \vspace{2.2mm}%
    \noindent\rule{\linewidth}{0.4pt}\par%
    \vspace{-1.65mm}%
    {{\fontspec{Times New Roman}\itshape\fontsize{9pt}{10.5pt}\selectfont Key words:}}\par%
    \vspace{0.35mm}%
    {\begingroup\small\setstretch{0.92}\selectfont\keywordsENG\par\endgroup}%
    \vspace{0.8mm}%
  \end{minipage}%
  \hspace{0.040\textwidth}%
  \begin{minipage}[t]{0.735\textwidth}%
    \vspace{0pt}%
    \noindent{\sffamily\bfseries\footnotesize A\,B\,S\,T\,R\,A\,C\,T}\par%
    \vspace{0.8mm}%
    \noindent\rule{\linewidth}{0.4pt}\par%
    \vspace{0.45mm}%
    {\begingroup\small\setstretch{\jkaseabstractstretch}\selectfont\abstracttextENG\par\endgroup}%
    \vspace{0.8mm}%
  \end{minipage}%
  \par%
  \vspace{0.8mm}%
  \noindent\rule{\textwidth}{0.8pt}%
  \vspace{9.0mm}%
  % Corresponding author footnote (@ is already a letter inside .cls)
  \ifx\@firstpagefootnotetext\@empty\else%
    \blfootnote{\@firstpagefootnotetext}%
  \fi%
}

% Centralized front-matter spacing control
\newcommand{\jkaseabstractstretch}{1.01}

% Backward compatibility: legacy documents call \jgtehead
\let\jgtehead\jkasehead

%%% \jkasetail / \ksgtail: Korean abstract before references %%%%%%%%%
%
%  Outputs: 국문요약 heading + Korean abstract body + 주제어 line
%  Place this command immediately before \printbibliography calls.
%
\def\jkasetail{%
  \vspace{2\baselineskip}%
  \noindent{\bfseries\sffamily\large 국문요약\par}%
  \vspace{0.5\baselineskip}%
  {\setlength{\parindent}{1.0em}\indent\abstracttextKOR\par}%
  \vspace{\baselineskip}%
  \noindent{\sffamily\bfseries 주제어:} \keywordsKOR\par%
  \vspace{2\baselineskip}%
}

% Alias: \ksgtail = \jkasetail
\let\ksgtail\jkasetail

\makeatother

%%% THE END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\endinput

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Publications of the Korean Astronomical Society (PKAS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
