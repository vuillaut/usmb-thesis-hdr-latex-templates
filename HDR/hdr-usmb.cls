%% hdr-usmb.cls
%% LaTeX class for HDR (Habilitation à Diriger des Recherches)
%% Université Savoie Mont Blanc

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{hdr-usmb}[2024/01/01 HDR USMB Class]

\DeclareOption{draft}{\PassOptionsToClass{draft}{book}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax
\LoadClass[12pt,a4paper,twoside,openright]{book}

\RequirePackage{geometry}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
% replace [english] with [french] after: apt install texlive-lang-french
\RequirePackage[english]{babel}
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{setspace}
\RequirePackage{emptypage}
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}
\RequirePackage{titletoc}
\RequirePackage{hyperref}
\RequirePackage{ifthen}
\RequirePackage{calc}
\RequirePackage{array}
\RequirePackage{booktabs}
\RequirePackage{enumitem}
\RequirePackage{caption}
\RequirePackage{subcaption}
\RequirePackage{amsmath,amssymb,amsthm}
\RequirePackage{url}
\RequirePackage{eso-pic}   % reliable full-page background for titlepage

\geometry{
  a4paper,
  top    = 22mm,
  bottom = 21mm,
  left   = 25mm,
  right  = 19mm,
  headheight = 15pt,
  includehead
}

\definecolor{usmb@blue}  {RGB}{0,  72, 140}
\definecolor{usmb@red}   {RGB}{190, 30,  45}
\definecolor{usmb@grey}  {RGB}{100,100,100}
\definecolor{usmb@lgrey} {RGB}{220,220,220}

\newcommand{\hdrAuthor}     [1]{\gdef\@hdrAuthor{#1}}
\newcommand{\hdrTitle}      [1]{\gdef\@hdrTitle{#1}}
\newcommand{\hdrSpeciality} [1]{\gdef\@hdrSpeciality{#1}}
\newcommand{\hdrDate}       [1]{\gdef\@hdrDate{#1}}
\newcommand{\hdrLogo}       [1]{\gdef\@hdrLogo{#1}}

\gdef\@hdrAuthor    {Prénom NOM}
\gdef\@hdrTitle     {Titre de l'HDR}
\gdef\@hdrSpeciality{Informatique}
\gdef\@hdrDate      {JJ mois AAAA}
\gdef\@hdrLogo      {logos/usmb-logo}

\newcounter{jury@count}
\setcounter{jury@count}{0}

\newcommand{\juryMember}[3]{%
  \stepcounter{jury@count}%
  \expandafter\gdef\csname jury@name@\thejury@count\endcsname{#1}%
  \expandafter\gdef\csname jury@func@\thejury@count\endcsname{#2}%
  \expandafter\gdef\csname jury@role@\thejury@count\endcsname{#3}%
}

% ── Cover page dimensions ─────────────────────────────────────────────────
% All lengths are absolute from the page edge (not affected by geometry margins).
%
%   \hdr@sidebarW   : width of the grey bar
%   \hdr@textGap    : white gap between bar right edge and text column left edge
%   \hdr@borderInset: how far the outer border sits from each page edge
%   \hdr@rightMargin: gap between text column right edge and page right edge
%
\newlength{\hdr@sidebarW}
\setlength{\hdr@sidebarW}{52mm}    % ← widen/narrow the grey sidebar
\newlength{\hdr@textGap}
\setlength{\hdr@textGap}{8mm}      % ← gap between sidebar and text
\newlength{\hdr@borderInset}
\setlength{\hdr@borderInset}{8mm}  % ← outer border inset
\newlength{\hdr@rightMargin}
\setlength{\hdr@rightMargin}{12mm} % ← right side margin of text column

% ── Cover page ────────────────────────────────────────────────────────────
% Uses eso-pic \AddToShipoutPictureBG* which draws at absolute page coordinates,
% guaranteed to work even inside the book titlepage environment.
\newcommand{\makecover}{%
  \begin{titlepage}%
    \thispagestyle{empty}%
    \setlength{\parindent}{0pt}%
    %
    % ── Background layer (eso-pic) ───────────────────────────────────────
    \AddToShipoutPictureBG*{%
      % Full-height grey sidebar flush with left edge
      \AtPageLowerLeft{%
        \color{usmb@lgrey}\rule{\hdr@sidebarW}{\paperheight}%
      }%
      % Border: top rule
      \AtPageUpperLeft{%
        \raisebox{-\hdr@borderInset}{%
          \hspace{\hdr@borderInset}%
          \color{black!60}\rule{\dimexpr\paperwidth-2\hdr@borderInset}{0.5pt}%
        }%
      }%
      % Border: bottom rule
      \AtPageLowerLeft{%
        \raisebox{\hdr@borderInset}{%
          \hspace{\hdr@borderInset}%
          \color{black!60}\rule{\dimexpr\paperwidth-2\hdr@borderInset}{0.5pt}%
        }%
      }%
      % Border: left rule
      \AtPageLowerLeft{%
        \hspace{\hdr@borderInset}%
        \raisebox{\hdr@borderInset}{%
          \color{black!60}\rule{0.5pt}{\dimexpr\paperheight-2\hdr@borderInset}%
        }%
      }%
      % Border: right rule
      \AtPageLowerLeft{%
        \hspace{\dimexpr\paperwidth-\hdr@borderInset-0.5pt}%
        \raisebox{\hdr@borderInset}{%
          \color{black!60}\rule{0.5pt}{\dimexpr\paperheight-2\hdr@borderInset}%
        }%
      }%
    }%
    %
    % ── Content column ───────────────────────────────────────────────────
    % Positioned right of the sidebar, top-aligned
    % Indent from page left = sidebar + gap (absolute), minus the geometry left margin
    % so that \hspace* adds exactly the right amount inside the text area.
    \hspace*{\dimexpr\hdr@sidebarW+\hdr@textGap-\Gm@lmargin}%
    \begin{minipage}[t]{\dimexpr\paperwidth-\hdr@sidebarW-\hdr@textGap-\hdr@rightMargin}%
      %
      % Logo: flush right
      \vspace{-20mm}
      \begin{flushright}
        \ifthenelse{\equal{\@hdrLogo}{}}{}{%
          \includegraphics[height=35mm,keepaspectratio]{\@hdrLogo}%
        }%
      \end{flushright}%
      \vspace{8mm}%
      %
      % Manuscrit HDR
      {\fontsize{14}{17}\bfseries\selectfont Manuscrit HDR}\par
      \vspace{4mm}%
      %
      % Degree header
      {\fontsize{10}{13}\selectfont Pour obtenir le diplôme d'}\par
      \vspace{2mm}%
      {\fontsize{12}{15}\bfseries\selectfont HABILITATION à DIRIGER des RECHERCHES}\par
      \vspace{1mm}%
      {\fontsize{12}{15}\bfseries\selectfont de l'UNIVERSITE SAVOIE MONT BLANC}\par
      \vspace{3mm}%
      %
      % Speciality
      {\fontsize{10}{13}\selectfont Spécialité~: \@hdrSpeciality}\par
      \vspace{2mm}%
      %
      % Legal reference
      {\fontsize{9}{12}\selectfont
        Arrêtés ministériels des 23 novembre 1988 et 13 février 1992}\par
      \vspace{10mm}%
      %
      % Author
      {\fontsize{10}{13}\selectfont Présenté par}\par
      \vspace{3mm}%
      {\fontsize{13}{16}\bfseries\selectfont \@hdrAuthor}\par
      \vspace{12mm}%
      %
      % Title
      {\fontsize{22}{28}\bfseries\selectfont Titre~: \@hdrTitle}\par
      \vspace{8mm}%
      %
      % Defense date
      {\fontsize{10}{13}\selectfont
        HDR soutenue publiquement le \textbf{«~\@hdrDate~»},}\par
      \vspace{1mm}%
      {\fontsize{10}{13}\selectfont devant le jury composé de~:}\par
      \vspace{5mm}%
      %
      % Jury list
      \hdr@printjury%
    \end{minipage}%
  \end{titlepage}%
  \cleardoublepage
}

% Jury: stacked flush-left, bold name + small details — matches original template
\newcommand{\hdr@juryrow}[1]{%
  \ifcsname jury@name@#1\endcsname
    {\bfseries\csname jury@name@#1\endcsname}\\
    {\fontsize{9}{11}\selectfont
      \csname jury@func@#1\endcsname, \csname jury@role@#1\endcsname}\\[4pt]
  \fi
}
\newcommand{\hdr@printjury}{%
  \hdr@juryrow{1}\hdr@juryrow{2}\hdr@juryrow{3}%
  \hdr@juryrow{4}\hdr@juryrow{5}\hdr@juryrow{6}%
}

% ── Headers / footers ─────────────────────────────────────────────────────
\pagestyle{fancy}
\fancyhf{}
\fancyhead[LE]{\small\color{usmb@grey}\leftmark}
\fancyhead[RO]{\small\color{usmb@grey}\rightmark}
\fancyfoot[C]{\small\thepage}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0pt}
\fancypagestyle{plain}{%
  \fancyhf{}%
  \fancyfoot[C]{\small\thepage}%
  \renewcommand{\headrulewidth}{0pt}%
}

% ── Chapter / section styling ─────────────────────────────────────────────
\titleformat{\chapter}[display]
  {\normalfont\huge\bfseries\color{usmb@blue}}
  {\chaptertitlename\ \thechapter}{12pt}{\Huge}
  [\vspace{2pt}\titlerule]
\titleformat{\section}
  {\normalfont\Large\bfseries\color{usmb@blue}}{\thesection}{1em}{}
\titleformat{\subsection}
  {\normalfont\large\bfseries}{\thesubsection}{1em}{}
\titleformat{\subsubsection}
  {\normalfont\normalsize\bfseries}{\thesubsubsection}{1em}{}

% ── Hyperref ──────────────────────────────────────────────────────────────
\hypersetup{
  colorlinks=true, linkcolor=usmb@blue, citecolor=usmb@red, urlcolor=usmb@blue,
  pdftitle={\@hdrTitle}, pdfauthor={\@hdrAuthor},
  pdfsubject={Habilitation à Diriger des Recherches},
  bookmarks=true, bookmarksnumbered=true
}

% ── Theorem environments ──────────────────────────────────────────────────
\theoremstyle{definition}
\newtheorem{definition}{Définition}[chapter]
\newtheorem{theorem}{Théorème}[chapter]
\newtheorem{lemma}[theorem]{Lemme}
\newtheorem{proposition}[theorem]{Proposition}
\newtheorem{corollary}[theorem]{Corollaire}
\theoremstyle{remark}
\newtheorem{remark}{Remarque}[chapter]
\newtheorem{example}{Exemple}[chapter]

\newcommand{\todo}[1]{\textcolor{usmb@red}{\textbf{[TODO: #1]}}}

\endinput
