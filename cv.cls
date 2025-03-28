\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cv}[2025/03/28 CV]

\LoadClass[a4paper]{article}
\RequirePackage[a4paper, left=2cm, top=2cm, bottom=2cm, right=2cm]{geometry}
\RequirePackage{lastpage}
\RequirePackage{fancyhdr}
\RequirePackage{xcolor}
\definecolor{headercolor}{named}{black}

% Size for the header, i.e., the name
\newcommand{\CVheadersize}{\LARGE}
% Size for the titles before and after the name
\newcommand{\titlesize}{\CVheadersize}

% Use sans-serif fonts for everything.
% Title and sections are always in sans-serif.
\DeclareOption{sffamily}{\renewcommand{\familydefault}{\sfdefault}}
% Use color in headers; alternatively redefine headercolor
\DeclareOption{usecolor}{\definecolor{headercolor}{RGB}{0,108,75}}
% Print the titles before/after the name in \normalsize,
% and not in the same size as the name.
\DeclareOption{normalsizetitle}{\renewcommand{\titlesize}{\normalsize}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\RequirePackage{enumitem}
\setlist{topsep=0.2\baselineskip,itemsep=0pt}
% Triangles look nicer than the usual bullets
\setlist[itemize]{label=\raisebox{1pt}{$\triangleright$}}

\setlength{\parindent}{0.5em}
\setlength{\parskip}{0.2\baselineskip}

% Width of the left column
\newlength{\datecolwidth}
\setlength{\datecolwidth}{4.8cm}
% Distance between two blocks. This is in addition to parskip.
\newlength{\blockskip}
\setlength{\blockskip}{0.3\baselineskip}
% Space before a \section
\newlength{\beforesectionskip}
\setlength{\beforesectionskip}{1ex}
% Adjusting the distance between the section title and the horizontal line.
\newlength{\sectionruleskip}
\setlength{\sectionruleskip}{-0.8\baselineskip}
% Space after a \section
\newlength{\aftersectionskip}
\setlength{\aftersectionskip}{0ex}
% Space after the title
\newlength{\titleskip}
\setlength{\titleskip}{0.5ex}

\fancypagestyle{cvpage}{%
    \fancyhf{}
    \fancyfoot[C]{\thepage/\pageref{LastPage}}
    \renewcommand{\headrulewidth}{0pt}
    \renewcommand{\footrulewidth}{0pt}
}
\pagestyle{cvpage}

% Titles that go before the name
\newcommand{\beforename}[1]{\gdef\@beforename{#1~}}
% Titles that go after the name; adds a comma
\newcommand{\aftername}[1]{\gdef\@aftername{, #1}}
\def\@beforename{}
\def\@aftername{}

% Print titles, name and date.
\renewcommand{\maketitle}{%
	\noindent\bfseries\sffamily
	%\@author\ --\ \@title \hfill
	\textcolor{headercolor}{\titlesize\@beforename{\CVheadersize\@author}\@aftername} \hfill
	\normalsize\normalfont \@date
    \vskip \titleskip
}

% This is a very hacky way to make a grid of links to socials and stuff.
\newenvironment{linkblock}[1]
{%
\newcounter{linkcolcounter}\setcounter{linkcolcounter}{0}
\newcommand{\icontext}[2]{%
    \stepcounter{linkcolcounter}
    \faicon{##1}\hspace{0.5em}##2
    \ifnum#1=\value{linkcolcounter} %
        \setcounter{linkcolcounter}{0}\\%
    \else
        &%
    \fi
}
\begin{tabular}{@{}*{#1}l}
}
{%
\end{tabular}
}

\newcommand{\cvsection}[1]{%
    \vskip \beforesectionskip 
    \noindent{\Large\bfseries\sffamily\color{headercolor}%
    #1\hspace{0.1em}}
    \vskip \sectionruleskip
    \noindent{\color{headercolor}\rule{\textwidth}{0.75pt}}
    \vskip \aftersectionskip
}
% Starred and unstarred section should do the same,
% so we just pass on to `\cvsection` in either case.
% This is mostly to make the bibliography title look correct.
\renewcommand{\section}{\@ifstar\cvsection\cvsection}

\newcommand{\cvblock}[1]{#1\vskip \blockskip}
% Only left and right column, no additional text
\newcommand{\cventry}[2]{%
    \cvblock{%
    \makebox[\datecolwidth][l]{#1}
    \begin{minipage}[t]{\dimexpr\textwidth-\datecolwidth-\parindent-2pt\relax}
    \begin{flushleft}
       #2
    \end{flushleft}
    \end{minipage}
    }
}
% Left and right column, indented block of stuff below
% #1: left column
% #2: right column
% #3: indented block of text
\newcommand{\bigcventry}[3]{%
    \cventry{#1}{#2\par#3}
}
% Projectname with date in parentheses in the left column, short description in the right column, long description below.
% #1: project name
% #2: date
% #3: short description
% #4: long description
\newcommand{\projectblock}[4]{%
    \cvblock{%
    \cventry{#1 (#2)}{#3}%
    \vskip -\blockskip
    \makebox[\parindent][l]{}
    \begin{minipage}[t]{\dimexpr\textwidth-2\parindent-2pt\relax}
        #4
    \end{minipage}
    }
}

% 
\newenvironment{cvblurb}
    {\vspace{0.4\baselineskip}
     \begin{minipage}[t]{\dimexpr\textwidth-\parindent-2pt\relax}}
    {\end{minipage}\vspace{0.2\baselineskip}}

% A utility to correctly typeset the dash in time intervals 
\newcommand{\fromto}[2]{#1--#2}
