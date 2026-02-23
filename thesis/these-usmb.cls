%% these-usmb.cls
%% LaTeX class for doctoral thesis (Thèse de Doctorat)
%% Université Savoie Mont Blanc
%%
%% Strongly inspired by hdr-usmb.cls — same visual identity,
%% different cover text and structure.
%%
%% Usage: \documentclass{these-usmb}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{these-usmb}[2024/01/01 These USMB Class]

% ─────────────────────────────────────────────
%  Base class
% ─────────────────────────────────────────────
\DeclareOption{draft}{\PassOptionsToClass{draft}{book}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax
\LoadClass[12pt,a4paper,twoside,openright]{book}

% ─────────────────────────────────────────────
%  Packages
% ─────────────────────────────────────────────
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
\RequirePackage{eso-pic}   % reliable full-page background

% ─────────────────────────────────────────────
%  Page geometry
%  (original template uses 10mm margins all around)
% ─────────────────────────────────────────────
\geometry{
  a4paper,
  top    = 20mm,
  bottom = 20mm,
  left   = 25mm,
  right  = 20mm,
  headheight = 15pt,
  includehead
}

% ─────────────────────────────────────────────
%  Colours  (same USMB identity as HDR class)
% ─────────────────────────────────────────────
\definecolor{usmb@blue}  {RGB}{0,  72, 140}
\definecolor{usmb@red}   {RGB}{190, 30,  45}
\definecolor{usmb@grey}  {RGB}{100,100,100}
\definecolor{usmb@lgrey} {RGB}{220,220,220}   % sidebar grey

% ─────────────────────────────────────────────
%  Metadata — fill these in main.tex
% ─────────────────────────────────────────────
\newcommand{\theseAuthor}      [1]{\gdef\@theseAuthor{#1}}
\newcommand{\theseTitle}       [1]{\gdef\@theseTitle{#1}}
\newcommand{\theseSpeciality}  [1]{\gdef\@theseSpeciality{#1}}
\newcommand{\theseDate}        [1]{\gdef\@theseDate{#1}}
\newcommand{\theseDirecteur}   [1]{\gdef\@theseDirecteur{#1}}
\newcommand{\theseLaboratoire} [1]{\gdef\@theseLaboratoire{#1}}
\newcommand{\theseEcoleDoc}    [1]{\gdef\@theseEcoleDoc{#1}}
\newcommand{\theseLogo}        [1]{\gdef\@theseLogo{#1}}

% Defaults
\gdef\@theseAuthor     {Prénom NOM}
\gdef\@theseTitle      {Titre de la thèse}
\gdef\@theseSpeciality {Informatique}
\gdef\@theseDate       {JJ mois AAAA}
\gdef\@theseDirecteur  {Pr. Prénom NOM}
\gdef\@theseLaboratoire{Nom du Laboratoire (acronyme)}
\gdef\@theseEcoleDoc   {Nom de l'École Doctorale}
\gdef\@theseLogo       {logos/usmb-logo}

% Sidebar background image (set via \theseSidebarImg{path})
\newcommand{\theseSidebarImg}[1]{\gdef\these@sidebarImg{#1}}
\gdef\these@sidebarImg{logos/sidebar-bg}

% ─────────────────────────────────────────────
%  Jury management (identical API to hdr-usmb)
% ─────────────────────────────────────────────
\newcounter{jury@count}
\setcounter{jury@count}{0}

% \juryMember{Civilité Prénom NOM}{Fonction et lieu}{Rôle}
\newcommand{\juryMember}[3]{%
  \stepcounter{jury@count}%
  \expandafter\gdef\csname jury@name@\thejury@count\endcsname{#1}%
  \expandafter\gdef\csname jury@func@\thejury@count\endcsname{#2}%
  \expandafter\gdef\csname jury@role@\thejury@count\endcsname{#3}%
}

% ─────────────────────────────────────────────
%  Cover page dimensions
% ─────────────────────────────────────────────
%
%  \these@sidebarW   : width of the grey sidebar
%  \these@textGap    : gap between sidebar and text column
%  \these@borderInset: outer border inset from page edge
%  \these@rightMargin: right side margin of text column
%
\newlength{\these@sidebarW}
\setlength{\these@sidebarW}{62mm}

\newlength{\these@textGap}
\setlength{\these@textGap}{8mm}

\newlength{\these@borderInset}
\setlength{\these@borderInset}{8mm}

\newlength{\these@rightMargin}
% Pre-computed sidebar image dimensions (set inside \makecover)
\newlength{\these@imgW}
\newlength{\these@imgH}
\setlength{\these@rightMargin}{12mm}

% ─────────────────────────────────────────────
%  Cover page
% ─────────────────────────────────────────────
\newcommand{\makecover}{%
  \begin{titlepage}%
    \thispagestyle{empty}%
    \setlength{\parindent}{0pt}%
    %
    % ── Background (eso-pic, absolute page coords) ──────────────────────
    % Pre-compute sidebar image dimensions
    \setlength{\these@imgW}{\dimexpr\these@sidebarW-\these@borderInset\relax}
    \setlength{\these@imgH}{\dimexpr\paperheight-2\these@borderInset\relax}
    \AddToShipoutPictureBG*{%
      % Sidebar image: placed inside the border (from borderInset),
      % width = sidebarW - borderInset so it ends exactly at sidebarW from page left
      \AtPageLowerLeft{%
        \hspace{\these@borderInset}%
        \raisebox{\these@borderInset}{%
          \includegraphics[%
            width=\these@imgW,%
            height=\these@imgH,%
            keepaspectratio=false%
          ]{\these@sidebarImg}%
        }%
      }%
      % Border — top
      \AtPageUpperLeft{%
        \raisebox{-\these@borderInset}{%
          \hspace{\these@borderInset}%
          \color{black!60}\rule{\dimexpr\paperwidth-2\these@borderInset}{0.5pt}%
        }%
      }%
      % Border — bottom
      \AtPageLowerLeft{%
        \raisebox{\these@borderInset}{%
          \hspace{\these@borderInset}%
          \color{black!60}\rule{\dimexpr\paperwidth-2\these@borderInset}{0.5pt}%
        }%
      }%
      % Border — left
      \AtPageLowerLeft{%
        \hspace{\these@borderInset}%
        \raisebox{\these@borderInset}{%
          \color{black!60}\rule{0.5pt}{\dimexpr\paperheight-2\these@borderInset}%
        }%
      }%
      % Border — right
      \AtPageLowerLeft{%
        \hspace{\dimexpr\paperwidth-\these@borderInset-0.5pt}%
        \raisebox{\these@borderInset}{%
          \color{black!60}\rule{0.5pt}{\dimexpr\paperheight-2\these@borderInset}%
        }%
      }%
    }%
    %
    % ── Content column ──────────────────────────────────────────────────
    \hspace*{\dimexpr\these@sidebarW+\these@textGap-\Gm@lmargin}%
    \begin{minipage}[t]{\dimexpr\paperwidth-\these@sidebarW-\these@textGap-\these@rightMargin}%
      %
      % Logo — top right, pulled up close to border
      \vspace{-20mm}%
      \begin{flushright}
        \ifthenelse{\equal{\@theseLogo}{}}{}{%
          \includegraphics[height=45mm,keepaspectratio]{\@theseLogo}%
        }%
      \end{flushright}%
      \vspace{8mm}%
      %
      % ── THÈSE ────────────────────────────────────────────────────────
      {\fontsize{16}{19}\bfseries\selectfont THÈSE}\par
      \vspace{3mm}%
      %
      % ── Degree ───────────────────────────────────────────────────────
      {\fontsize{10}{13}\selectfont Pour obtenir le grade de}\par
      \vspace{2mm}%
      {\fontsize{12}{15}\bfseries\selectfont
        DOCTEUR DE L'UNIVERSITÉ SAVOIE MONT BLANC}\par
      \vspace{3mm}%
      %
      % ── Speciality ───────────────────────────────────────────────────
      {\fontsize{10}{13}\selectfont Spécialité~: \@theseSpeciality}\par
      \vspace{1mm}%
      %
      % ── Legal references ─────────────────────────────────────────────
      {\fontsize{8}{11}\selectfont
        Arrêté ministériel~: 25 mai 2016 — Arrêté modificatif~: 26 août 2022}\par
      \vspace{8mm}%
      %
      % ── Author ───────────────────────────────────────────────────────
      {\fontsize{10}{13}\selectfont Présentée par}\par
      \vspace{2mm}%
      {\fontsize{13}{16}\bfseries\selectfont \@theseAuthor}\par
      \vspace{5mm}%
      %
      % ── Supervision & lab ─────────────────────────────────────────────
      {\fontsize{10}{13}\selectfont
        Thèse dirigée par \textbf{\@theseDirecteur}}\par
      \vspace{2mm}%
      {\fontsize{10}{13}\selectfont
        préparée au sein du \textbf{\@theseLaboratoire}}\par
      \vspace{1mm}%
      {\fontsize{10}{13}\selectfont
        et de l'\textbf{\@theseEcoleDoc}}\par
      \vspace{10mm}%
      %
      % ── Title ─────────────────────────────────────────────────────────
      {\fontsize{22}{28}\bfseries\selectfont \@theseTitle}\par
      \vspace{8mm}%
      %
      % ── Defense date ──────────────────────────────────────────────────
      {\fontsize{10}{13}\selectfont
        Thèse soutenue publiquement le \textbf{\@theseDate},}\par
      \vspace{1mm}%
      {\fontsize{10}{13}\selectfont devant le jury composé de~:}\par
      \vspace{5mm}%
      %
      % ── Jury ──────────────────────────────────────────────────────────
      \these@printjury%
    \end{minipage}%
  \end{titlepage}%
  \cleardoublepage
}

% Jury list — stacked flush-left (same style as HDR template)
\newcommand{\these@juryrow}[1]{%
  \ifcsname jury@name@#1\endcsname
    {\bfseries\csname jury@name@#1\endcsname}\\
    {\fontsize{9}{11}\selectfont
      \csname jury@func@#1\endcsname, \csname jury@role@#1\endcsname}\\[4pt]
  \fi
}
\newcommand{\these@printjury}{%
  \these@juryrow{1}\these@juryrow{2}\these@juryrow{3}%
  \these@juryrow{4}\these@juryrow{5}\these@juryrow{6}%
  \these@juryrow{7}\these@juryrow{8}%
}

% ─────────────────────────────────────────────
%  Headers / footers
% ─────────────────────────────────────────────
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

% ─────────────────────────────────────────────
%  Chapter / section styling
% ─────────────────────────────────────────────
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

% ─────────────────────────────────────────────
%  Hyperref
% ─────────────────────────────────────────────
\hypersetup{
  colorlinks=true, linkcolor=usmb@blue, citecolor=usmb@red, urlcolor=usmb@blue,
  pdftitle={\@theseTitle}, pdfauthor={\@theseAuthor},
  pdfsubject={Thèse de Doctorat — Université Savoie Mont Blanc},
  bookmarks=true, bookmarksnumbered=true
}

% ─────────────────────────────────────────────
%  Theorem environments
% ─────────────────────────────────────────────
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
