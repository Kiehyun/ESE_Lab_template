% 한국교원대학교 학위논문 발표용 Beamer 클래스 파일입니다.
% KNUE thesis/dissertation presentation Beamer class file.
%
% 이 파일은 발표의 공통 디자인을 정의합니다.
% This file defines the shared presentation design.
%
% 사용자는 보통 이 파일보다 KNUE_beamer_main.tex와 sub/*.tex를 먼저 수정합니다.
% Users usually edit KNUE_beamer_main.tex and sub/*.tex before editing this file.
%
% 빌드 엔진은 LuaLaTeX입니다.
% Build engine: LuaLaTeX.

% LaTeX2e 형식의 클래스 파일임을 선언합니다.
% Declare that this class uses the LaTeX2e format.
\NeedsTeXFormat{LaTeX2e}

% 클래스 이름과 버전 정보를 제공합니다.
% Provide the class name and version information.
\ProvidesClass{KNUE_beamer_class}[2026/05/07 KNUE Beamer presentation class]

% 16:9 화면비의 Beamer 발표 문서를 기본으로 사용합니다.
% Use Beamer as the base class with a 16:9 aspect ratio.
\LoadClass[12pt,aspectratio=169]{beamer}

% 왼쪽 사이드바가 있는 Berkeley 테마를 사용합니다.
% Use the Berkeley theme, which provides a left sidebar.
\usetheme{Berkeley}

% 왼쪽 사이드바 너비를 고정해 제목과 본문 영역이 흔들리지 않게 합니다.
% Fix the left sidebar width so titles and body content stay aligned.
\setbeamersize{sidebar width left=2.2cm}
\newlength{\knuesidebarwidth}
\setlength{\knuesidebarwidth}{2.2cm}

% 사이드바를 제외한 실제 본문 너비를 계산합니다.
% Calculate the usable main content width after subtracting the sidebar.
\newlength{\knuemainwidth}
\setlength{\knuemainwidth}{\paperwidth}
\addtolength{\knuemainwidth}{-\knuesidebarwidth}

% ========== Core Packages / 핵심 패키지 ==========

% 컴파일 엔진을 확인합니다.
% Detect the compilation engine.
\RequirePackage{ifxetex,ifluatex}

% 색상 선택 명령에서 조건문을 사용합니다.
% Provide conditional logic for theme color selection.
\RequirePackage{ifthen}

% 색상 정의와 색상 혼합에 사용합니다.
% Define and mix colors.
\RequirePackage{xcolor}

% 그림과 로고를 삽입합니다.
% Insert figures and logos.
\RequirePackage{graphicx}

% 발표용 표를 깔끔하게 만들 때 사용합니다.
% Improve table styling for presentation slides.
\RequirePackage{booktabs}
\RequirePackage{array}
\RequirePackage{multirow}

% 도식, 흐름도, placeholder 상자를 그릴 때 사용합니다.
% Draw diagrams, flow charts, and placeholder boxes.
\RequirePackage{tikz}

% 코드 예시가 필요할 때 사용할 수 있습니다.
% Support code examples when needed.
\RequirePackage{listings}

% 그림/표 캡션과 하위 그림을 지원합니다.
% Support captions and subfigures.
\RequirePackage{caption}
\RequirePackage{subcaption}

% PDF 북마크를 안정적으로 생성합니다.
% Generate stable PDF bookmarks.
\RequirePackage{bookmark}

% 템플릿 예시 그림과 연구 절차 도식에 필요한 TikZ 라이브러리입니다.
% TikZ libraries used for template diagrams and research-process figures.
\usetikzlibrary{positioning,calc,shapes,arrows.meta}

% ========== Font Error Messages / 글꼴 오류 메시지 ==========

% 한글 명조/serif 글꼴을 찾지 못했을 때 보여 줄 오류 메시지입니다.
% Error shown when no Korean serif font is available.
\newcommand{\KNUE@missinghangulserif}{%
  \PackageError{KNUE_beamer_class}{No Korean serif font found}{Install a Korean serif font such as Batang, AppleMyungjo, NanumMyeongjo, Noto Serif CJK KR, or UnBatang. On Ubuntu, install fonts-nanum or fonts-noto-cjk.}%
}

% 한글 고딕/sans 글꼴을 찾지 못했을 때 보여 줄 오류 메시지입니다.
% Error shown when no Korean sans font is available.
\newcommand{\KNUE@missinghangulsans}{%
  \PackageError{KNUE_beamer_class}{No Korean sans font found}{Install a Korean sans font such as Malgun Gothic, Apple SD Gothic Neo, NanumGothic, Noto Sans CJK KR, or UnDotum. On Ubuntu, install fonts-nanum or fonts-noto-cjk.}%
}

% ========== Latin Font Setup / 영문 글꼴 설정 ==========

% 운영체제별로 사용 가능한 기본 영문 글꼴을 선택합니다.
% Choose available default Latin fonts for each operating system.
\newcommand{\KNUE@setlatinfonts}{%
  % Windows에서는 Times New Roman, Arial, Consolas를 우선 사용합니다.
  % On Windows, prefer Times New Roman, Arial, and Consolas.
  \ifwindows
    \IfFontExistsTF{Times New Roman}{\setmainfont{Times New Roman}}{\setmainfont{Latin Modern Roman}}%
    \IfFontExistsTF{Arial}{\setsansfont{Arial}}{\setsansfont{Latin Modern Sans}}%
    \IfFontExistsTF{Consolas}{\setmonofont{Consolas}}{\setmonofont{Latin Modern Mono}}%
  % macOS에서는 Times New Roman, Helvetica, Menlo를 우선 사용합니다.
  % On macOS, prefer Times New Roman, Helvetica, and Menlo.
  \else\ifmacosx
    \IfFontExistsTF{Times New Roman}{\setmainfont{Times New Roman}}{\setmainfont{Latin Modern Roman}}%
    \IfFontExistsTF{Helvetica}{\setsansfont{Helvetica}}{\setsansfont{Latin Modern Sans}}%
    \IfFontExistsTF{Menlo}{\setmonofont{Menlo}}{\setmonofont{Latin Modern Mono}}%
  % Linux/Dev Container에서는 Liberation 계열 글꼴을 우선 사용합니다.
  % On Linux/Dev Containers, prefer the Liberation font family.
  \else\iflinux
    \IfFontExistsTF{Liberation Serif}{\setmainfont{Liberation Serif}}{\setmainfont{Latin Modern Roman}}%
    \IfFontExistsTF{Liberation Sans}{\setsansfont{Liberation Sans}}{\setsansfont{Latin Modern Sans}}%
    \IfFontExistsTF{Liberation Mono}{\setmonofont{Liberation Mono}}{\setmonofont{Latin Modern Mono}}%
  % 그 외 환경에서는 TeX Live 기본 Latin Modern 글꼴을 사용합니다.
  % In other environments, fall back to TeX Live's Latin Modern fonts.
  \else
    \setmainfont{Latin Modern Roman}%
    \setsansfont{Latin Modern Sans}%
    \setmonofont{Latin Modern Mono}%
  \fi\fi\fi
  % 발표 화면은 Beamer 기본처럼 sans/Gothic 계열을 사용합니다.
  % Keep the Beamer default visual tone with the sans/Gothic family.
  \renewcommand{\familydefault}{\sfdefault}%
}

% ========== Korean Serif Font Setup / 한글 명조 글꼴 설정 ==========

% 본문과 표지에 사용할 한글 명조 계열 글꼴을 운영체제별로 선택합니다.
% Choose a Korean serif font for body/title text on each operating system.
\newcommand{\KNUE@sethangulserif}{%
  % Windows: Batang을 우선 사용하고, 없으면 Nanum/Noto/UnBatang 순서로 찾습니다.
  % Windows: prefer Batang, then Nanum/Noto/UnBatang.
  \ifwindows
    \IfFontExistsTF{Batang}{\setmainhangulfont{Batang}[AutoFakeBold=2.0,AutoFakeSlant=0.2]}{%
      \IfFontExistsTF{NanumMyeongjo}{\setmainhangulfont{NanumMyeongjo}[AutoFakeSlant=0.2]}{%
        \IfFontExistsTF{Noto Serif CJK KR}{\setmainhangulfont{Noto Serif CJK KR}[AutoFakeSlant=0.2]}{%
          \IfFontExistsTF{UnBatang}{\setmainhangulfont{UnBatang}[AutoFakeSlant=0.2]}{\KNUE@missinghangulserif}}}}%
  % macOS: AppleMyungjo를 우선 사용하고, 없으면 Nanum/Noto/UnBatang 순서로 찾습니다.
  % macOS: prefer AppleMyungjo, then Nanum/Noto/UnBatang.
  \else\ifmacosx
    \IfFontExistsTF{AppleMyungjo}{\setmainhangulfont{AppleMyungjo}[AutoFakeBold=2.0,AutoFakeSlant=0.2]}{%
      \IfFontExistsTF{NanumMyeongjo}{\setmainhangulfont{NanumMyeongjo}[AutoFakeSlant=0.2]}{%
        \IfFontExistsTF{Noto Serif CJK KR}{\setmainhangulfont{Noto Serif CJK KR}[AutoFakeSlant=0.2]}{%
          \IfFontExistsTF{UnBatang}{\setmainhangulfont{UnBatang}[AutoFakeSlant=0.2]}{\KNUE@missinghangulserif}}}}%
  % Linux: Dev Container에 들어 있는 NanumMyeongjo를 우선 사용합니다.
  % Linux: prefer NanumMyeongjo, which is installed in the Dev Container.
  \else\iflinux
    \IfFontExistsTF{NanumMyeongjo}{\setmainhangulfont{NanumMyeongjo}[AutoFakeSlant=0.2]}{%
      \IfFontExistsTF{UnBatang}{\setmainhangulfont{UnBatang}[AutoFakeSlant=0.2]}{%
        \IfFontExistsTF{Noto Serif CJK KR}{\setmainhangulfont{Noto Serif CJK KR}[AutoFakeSlant=0.2]}{\KNUE@missinghangulserif}}}%
  % 기타 환경에서도 Nanum/Noto/UnBatang 순서로 찾습니다.
  % In other environments, search Nanum/Noto/UnBatang in order.
  \else
    \IfFontExistsTF{NanumMyeongjo}{\setmainhangulfont{NanumMyeongjo}[AutoFakeSlant=0.2]}{%
      \IfFontExistsTF{Noto Serif CJK KR}{\setmainhangulfont{Noto Serif CJK KR}[AutoFakeSlant=0.2]}{%
        \IfFontExistsTF{UnBatang}{\setmainhangulfont{UnBatang}[AutoFakeSlant=0.2]}{\KNUE@missinghangulserif}}}%
  \fi\fi\fi
}

% ========== Korean Sans Font Setup / 한글 고딕 글꼴 설정 ==========

% 발표 슬라이드의 본문, 표, 작은 글씨에는 고딕 계열이 읽기 좋습니다.
% Sans/Gothic fonts are easier to read for slide body text, tables, and small text.
\newcommand{\KNUE@sethangulsans}{%
  % Windows: Malgun Gothic을 우선 사용합니다.
  % Windows: prefer Malgun Gothic.
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
          }{\KNUE@missinghangulsans}}}}%
  % macOS: Apple SD Gothic Neo를 우선 사용합니다.
  % macOS: prefer Apple SD Gothic Neo.
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
          }{\KNUE@missinghangulsans}}}}%
  % Linux: NanumGothic, UnDotum, Noto Sans CJK KR 순서로 찾습니다.
  % Linux: search NanumGothic, UnDotum, and Noto Sans CJK KR in order.
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
        }{\KNUE@missinghangulsans}}}%
  % 기타 환경에서도 설치된 한글 고딕 글꼴을 순서대로 찾습니다.
  % In other environments, search installed Korean sans fonts in order.
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
        }{\KNUE@missinghangulsans}}}%
  \fi\fi\fi
}

% ========== Engine-Specific Font Loading / 컴파일 엔진별 글꼴 로딩 ==========

% XeLaTeX에서는 fontspec, ifplatform, kotex를 사용해 한글과 영문 글꼴을 설정합니다.
% With XeLaTeX, use fontspec, ifplatform, and kotex for Korean and Latin fonts.
\ifxetex
  \RequirePackage{fontspec}
  \RequirePackage{ifplatform}
  \RequirePackage{kotex}
  \defaultfontfeatures{Ligatures=TeX}
  \KNUE@setlatinfonts
  \KNUE@sethangulserif
  \KNUE@sethangulsans
% LuaLaTeX도 같은 글꼴 설정을 사용합니다. 이 템플릿의 권장 엔진입니다.
% LuaLaTeX uses the same font setup and is the recommended engine for this template.
\else\ifluatex
  \RequirePackage{fontspec}
  \RequirePackage{ifplatform}
  \RequirePackage{kotex}
  \defaultfontfeatures{Ligatures=TeX}
  \KNUE@setlatinfonts
  \KNUE@sethangulserif
  \KNUE@sethangulsans
% pdfLaTeX로 빌드하면 한글/글꼴 설정이 맞지 않으므로 명시적으로 오류를 냅니다.
% Raise an explicit error for pdfLaTeX because the Korean/font setup will not match.
\else
  \PackageError{KNUE_beamer_class}{This template must be built with LuaLaTeX or XeLaTeX}{Use latexmk -pdf -lualatex KNUE_beamer_main.tex.}
\fi\fi

% ========== Theme Colors / 테마 색상 ==========

% 파란색 테마입니다. 기본값으로 사용됩니다.
% Blue theme. This is the default.
\definecolor{knueblue}{RGB}{0,70,140}
\definecolor{knuedarkblue}{RGB}{0,51,102}
\definecolor{knuelightblue}{RGB}{224,238,248}

% 녹색 테마입니다.
% Green theme.
\definecolor{knuegreen}{RGB}{0,105,75}
\definecolor{knuedarkgreen}{RGB}{0,80,55}
\definecolor{knuelightgreen}{RGB}{220,240,232}

% 붉은색 테마입니다.
% Red theme.
\definecolor{knuered}{RGB}{135,30,30}
\definecolor{knuedarkred}{RGB}{105,20,20}
\definecolor{knuelightred}{RGB}{245,225,220}

% 사용자가 blue, green, red 중 하나를 골라 전체 발표 색상을 바꿀 수 있게 합니다.
% Let users switch the whole presentation palette among blue, green, and red.
\newcommand\themecolor[1]{%
  % green이 선택되면 녹색 팔레트를 현재 테마 색으로 복사합니다.
  % If green is selected, copy the green palette into the active theme colors.
  \ifthenelse{\equal{#1}{green}}{%
    \colorlet{KNUEPrimary}{knuegreen}%
    \colorlet{KNUEPrimaryDark}{knuedarkgreen}%
    \colorlet{KNUEPrimaryLight}{knuelightgreen}%
  }{%
    % red가 선택되면 붉은색 팔레트를 현재 테마 색으로 복사합니다.
    % If red is selected, copy the red palette into the active theme colors.
    \ifthenelse{\equal{#1}{red}}{%
      \colorlet{KNUEPrimary}{knuered}%
      \colorlet{KNUEPrimaryDark}{knuedarkred}%
      \colorlet{KNUEPrimaryLight}{knuelightred}%
    }{%
      % 그 외 값은 모두 기본 파란색 테마로 처리합니다.
      % Any other value falls back to the default blue theme.
      \colorlet{KNUEPrimary}{knueblue}%
      \colorlet{KNUEPrimaryDark}{knuedarkblue}%
      \colorlet{KNUEPrimaryLight}{knuelightblue}%
    }%
  }%
  % 표지와 기본 정보 텍스트의 색상을 설정합니다.
  % Set colors for title-page and metadata text.
  \setbeamercolor{title}{bg=white,fg=KNUEPrimary}%
  \setbeamercolor{author}{fg=KNUEPrimary}%
  \setbeamercolor{institute}{fg=KNUEPrimary}%
  \setbeamercolor{date}{fg=KNUEPrimary}%
  % 로고 배경, 사이드바, 프레임 제목 색상을 설정합니다.
  % Set colors for the logo area, sidebar, and frame titles.
  \setbeamercolor{logo}{bg=KNUEPrimary}%
  \setbeamercolor{sidebar}{bg=KNUEPrimary}%
  \setbeamercolor{frametitle}{bg=white,fg=KNUEPrimary}%
  % 사이드바 글자는 배경색 위에서 잘 보이도록 흰색 계열로 설정합니다.
  % Use white sidebar text for contrast against the colored background.
  \setbeamercolor{section in sidebar}{use=sidebar,bg=sidebar.bg,fg=white}%
  \setbeamercolor{section in sidebar shaded}{parent=section in sidebar,fg=white!70}%
  \setbeamercolor{subsection in sidebar}{parent=section in sidebar}%
  \setbeamercolor{subsection in sidebar shaded}{parent=subsection in sidebar,fg=white!70}%
  % 목차와 목록 표식의 색상을 현재 테마에 맞춥니다.
  % Match ToC and item marker colors to the active theme.
  \setbeamercolor{section in toc}{bg=white,fg=KNUEPrimaryDark}%
  \setbeamercolor{subsection in toc}{fg=KNUEPrimaryDark}%
  \setbeamercolor{item}{fg=KNUEPrimary}%
  % 일반 block, alertblock, exampleblock의 색상을 설정합니다.
  % Set colors for regular blocks, alert blocks, and example blocks.
  \setbeamercolor{block title}{bg=KNUEPrimaryDark,fg=white}%
  \setbeamercolor{block body}{bg=black!6,fg=black}%
  \setbeamercolor{block title alerted}{bg=knuered,fg=white}%
  \setbeamercolor{block body alerted}{bg=knuelightred,fg=black}%
  \setbeamercolor{block title example}{bg=knuegreen,fg=white}%
  \setbeamercolor{block body example}{bg=knuelightgreen,fg=black}%
  % 로고 파일이 있으면 Beamer의 기본 로고 영역에도 등록합니다.
  % Register the logo with Beamer's default logo area when the file exists.
  \IfFileExists{logo/Knue_logo.png}{\logo{\includegraphics[width=1.25cm]{logo/Knue_logo.png}}}{\logo{}}%
}

% ========== Equation Font Option / 수식 글꼴 선택 ==========

% 수식을 serif(rm) 또는 sans-serif(sf) 느낌으로 바꾸는 간단한 선택 명령입니다.
% Simple option for switching math style between serif (rm) and sans-serif (sf).
\newcommand{\KNUE@mathsfoption}{sf}
\newcommand{\KNUE@mathrmoption}{rm}
\newcommand\equationfont[1]{%
  \def\KNUE@mathchoice{#1}%
  \ifx\KNUE@mathchoice\KNUE@mathsfoption
    \renewcommand\mathfamilydefault{\sfdefault}%
  \fi
  \ifx\KNUE@mathchoice\KNUE@mathrmoption
    \renewcommand\mathfamilydefault{\rmdefault}%
  \fi
}

% ========== Header, Footer, and Frame Title / 머리글, 바닥글, 슬라이드 제목 ==========

% 슬라이드 제목은 굵게 표시합니다.
% Display frame titles in bold.
\setbeamerfont{frametitle}{series=\bfseries}

% 왼쪽 사이드바가 페이지 맨 위에서 시작하도록 상단 바를 비웁니다.
% Leave the headline empty so the left sidebar can start at the top edge.
\setbeamertemplate{headline}{}
\setbeamerfont{section in head/foot}{size=\tiny,series=\bfseries}
\setbeamercolor{section in head/foot}{fg=black!35,bg=white}

% 하단 컨트롤 바에는 Beamer 이동 아이콘과 현재/전체 슬라이드 번호를 표시합니다.
% The bottom control bar shows Beamer navigation icons and current/total slide numbers.
\setbeamerfont{page number in head/foot}{size=\scriptsize}
\setbeamercolor{page number in head/foot}{fg=black!55,bg=black!3}
\setbeamercolor{navigation symbols}{fg=black!50}
\setbeamercolor{navigation symbols dimmed}{fg=black!30}
\newcommand{\KNUEControlNavigation}{%
  \insertslidenavigationsymbol%
  \hspace{0.15cm}%
  \insertframenavigationsymbol%
  \hspace{0.15cm}%
  \insertsectionnavigationsymbol%
  \hspace{0.15cm}%
  \insertdocnavigationsymbol%
}
\setbeamertemplate{footline}{%
  \leavevmode%
  \hbox{%
    \begin{beamercolorbox}[wd=\knuesidebarwidth,ht=2.8ex,dp=1.2ex]{sidebar}%
    \end{beamercolorbox}%
    \begin{beamercolorbox}[wd=\knuemainwidth,ht=2.8ex,dp=1.2ex,rightskip=0.35cm plus1fil]{page number in head/foot}%
      \usebeamerfont{page number in head/foot}%
      \hspace*{0.25cm}%
      \KNUEControlNavigation%
      \hfill%
      \insertframenumber{} / \inserttotalframenumber%
    \end{beamercolorbox}%
  }%
}

% 기본 탐색 아이콘은 숨겨 발표 화면을 단순하게 유지합니다.
% Hide the default navigation symbols to keep the slide clean.
\setbeamertemplate{navigation symbols}{}

% Beamer 내부 명령을 쓰기 위해 @ 문자를 명령 이름에 사용할 수 있게 합니다.
% Allow @ in command names while customizing internal Beamer templates.
\makeatletter

% 왼쪽 사이드바의 최상단에 로고를 배치하고, 그 아래에 짧은 제목과 목차를 표시합니다.
% Place the logo at the top of the left sidebar, followed by the short title and table of contents.
\setbeamertemplate{sidebar left}{%
  \begingroup
  \hbadness=10000%
  \beamer@tempdim=\knuesidebarwidth%
  \advance\beamer@tempdim by -6pt%
  {%
    \vskip0.45cm%
    \makebox[\knuesidebarwidth][c]{%
      \IfFileExists{logo/Knue_logo.png}{%
        \begin{tikzpicture}[baseline=(knuelogo.base)]
          % 로고 PNG의 투명 배경을 그대로 사용합니다.
          % Preserve the transparent background in the logo PNG.
          \node[inner sep=0pt] (knuelogo)
            {\includegraphics[width=0.85cm]{logo/Knue_logo.png}};%
        \end{tikzpicture}%
      }{}%
    }%
    \vskip0.35em%
  }%
  {%
    \usebeamerfont{title in sidebar}%
    \hskip3pt%
    \usebeamercolor[fg]{title in sidebar}%
    \insertshorttitle[width=\beamer@tempdim,center,respectlinebreaks]\par%
    \vskip0.45em%
  }%
  \insertverticalnavigation{\knuesidebarwidth}%
  \vfill
  \endgroup
}

% 프레임 제목을 본문 너비에 맞춰 밑줄 형태로 표시합니다.
% Render frame titles with an underline aligned to the main content width.
\setbeamertemplate{frametitle}{%
  \nointerlineskip
  \ifx\insertframetitle\@empty
  \else
    \begin{beamercolorbox}[wd=\knuemainwidth,ht=3ex,dp=1.2ex]{frametitle}
      \hspace*{7pt}\underline{\makebox[0.78\knuemainwidth][l]{\Large\insertframetitle}}
    \end{beamercolorbox}
  \fi
}
\makeatother

% ========== Title Page / 표지 ==========

% 표지에서는 로고와 제목의 시각적 무게가 균형을 이루도록 제목 글꼴을 별도로 조정합니다.
% Tune title-page fonts so the logo and title block feel visually balanced.
\setbeamerfont{title}{size=\Large,series=\bfseries}
\setbeamerfont{subtitle}{size=\small}
\setbeamerfont{author}{size=\normalsize}
\setbeamerfont{institute}{size=\small}
\setbeamerfont{date}{size=\normalsize}

% 표지 슬라이드의 레이아웃을 정의합니다.
% Define the custom title-page layout.
\setbeamertemplate{title page}{%
  \nointerlineskip
  \hspace*{\dimexpr -0.5\paperwidth + 0.5\textwidth\relax}%
  \begin{minipage}[c][0.86\paperheight][c]{\paperwidth}
  \centering
  \begin{tikzpicture}[remember picture,overlay]
    % 표지 상단은 전체 페이지 폭을 기준으로 중앙 정렬합니다.
    % Center the title-page header against the full physical page width.
    \node[anchor=north,inner sep=0pt,text width=0.88\paperwidth,align=center]
      at ([yshift=-0.68cm]current page.north)
      {%
        \usebeamerfont{subtitle}\usebeamercolor[fg]{subtitle}%
        \IfFileExists{logo/Knue_logo.png}{%
          \raisebox{-0.13cm}{\includegraphics[width=0.54cm]{logo/Knue_logo.png}}\hspace{0.18cm}%
        }{}%
        \insertsubtitle
      };%
    \draw[KNUEPrimary,line width=0.55pt]
      ([xshift=0.8cm,yshift=-1.84cm]current page.north west) --
      ([xshift=-0.8cm,yshift=-1.84cm]current page.north east);%
    \node[anchor=center,inner sep=0pt,text width=0.88\paperwidth,align=center]
      at ([yshift=-0.50cm]current page.center)
      {%
        % 제목, 발표자, 소속, 날짜를 전체 페이지 기준 가운데 정렬로 출력합니다.
        % Print title, presenter, affiliation, and date centered on the full page.
        {\usebeamerfont{title}\usebeamercolor[fg]{title}\setlength{\baselineskip}{1.08\baselineskip}\inserttitle\par}%
        \vspace{0.48cm}%
        {\usebeamerfont{author}\usebeamercolor[fg]{author}\insertauthor\par}%
        \vspace{0.16cm}%
        {\usebeamerfont{institute}\usebeamercolor[fg]{institute}\insertinstitute\par}%
        \vspace{0.16cm}%
        {\usebeamerfont{date}\usebeamercolor[fg]{date}\insertdate\par}%
      };%
    % plain 표지 프레임에도 하단 페이지 번호를 표시합니다.
    % Show the bottom page number on the plain title frame as well.
    \node[anchor=south east,inner sep=0pt,text=black!55,font=\scriptsize]
      at ([xshift=-0.35cm,yshift=0.28cm]current page.south east)
      {\insertframenumber{} / \inserttotalframenumber};%
  \end{tikzpicture}%
  \end{minipage}%
}

% ========== Template Helper Box / 템플릿 자리표시자 상자 ==========

% 그림이나 표가 아직 없을 때 사용할 자리표시자 상자입니다.
% Placeholder box for slides where a figure or table will be added later.
\newcommand{\placeholderbox}[2]{%
  \begin{center}
  \begin{tikzpicture}
    \node[
      draw=KNUEPrimary,
      rounded corners=2pt,
      fill=KNUEPrimaryLight,
      minimum width=#1,
      minimum height=#2,
      align=center,
      text width=#1
    ] {그림, 표, 모형, 연구 일정 등을 여기에 배치합니다.\\[2pt]\scriptsize Place a figure, table, model, or timeline here.};
  \end{tikzpicture}
  \end{center}
}

% 클래스가 불러와졌을 때 기본 테마 색상을 파란색으로 설정합니다.
% Set the default theme color to blue when the class is loaded.
\themecolor{blue}
