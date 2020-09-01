;;; ox-fart-glitter.el --- Export your org file to minutes fart PDF file -*- lexical-binding: t -*-

;; Author: Matthias David <matthias@gnu.re>
;; URL: https://github.com/DarkBuffalo/ox-fart
;; Version: 0.2
;; Package-Requires: ((emacs "24.4"))
;; Keywords: org, outlines, report, exporter, meeting, minutes

;;; Commentary:
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; This is a another exporter for org-mode that translates Org-mode file to
;; beautiful PDF file
;;
;; EXAMPLE ORG FILE HEADER:
;;
;;   #+title:Readme ox-fart
;;   #+author: Matthias David
;;   #+options: toc:nil
;;   #+ou:Zoom
;;   #+quand: 20/2/2021
;;   #+projet: ox-fart
;;   #+absent: C. Robert,T. tartanpion
;;   #+present: K. Soulet,I. Payet
;;   #+excuse:Sophie Fonsec,Karine Soulet
;;   #+logo: logo.png
;;
;;; Code:

(require 'ox)
(require 'cl-lib)


(add-to-list 'org-latex-classes
             '("fart-glitter"                          ;class-name
               "\\documentclass[twoside]{article}

\\usepackage{concmath}
\\renewcommand*\\familydefault{\\ttdefault} %% Only if the base font of the document is to be typewriter style

\\RequirePackage[T1]{fontenc}
\\usepackage[utf8]{inputenc}
\\RequirePackage{babel}
\\RequirePackage{array}

\\RequirePackage[dvipsnames,table]{xcolor}	%% gestion des couleurs
\\RequirePackage{etoolbox}
\\RequirePackage[footnote]{snotez}	%% placer les notes de pied de page sur le coté
\\RequirePackage[toc]{multitoc}
\\RequirePackage{calc}

\\RequirePackage{everysel}
\\EverySelectfont{%%
\\fontdimen2\\font=0.4em %% interword space
\\fontdimen3\\font=0.2em %% interword stretch
\\fontdimen4\\font=0.1em %% interword shrink
\\fontdimen7\\font=0.1em %% extra space
\\hyphenchar\\font=`\\-  %% to allow hyphenation
}


\\usepackage[a4paper,left=15mm,
top=15mm,headsep=2\\baselineskip,
textwidth=132mm,marginparsep=8mm,
marginparwidth=40mm,textheight=58\\baselineskip,
headheight=\\baselineskip]{geometry}


%%------------------------------------------------------------------------------
%%	HEADERS
%%------------------------------------------------------------------------------

\\renewcommand{\\sectionmark}[1]{\\markright{\\spacedlowsmallcaps{#1}}} %% The header for all pages (oneside) or for even pages (twoside)
\\renewcommand{\\subsectionmark}[1]{\\markright{\\thesubsection~#1}} %% Uncomment when using the twoside option - this modifies the header on odd pages
%%\\lehead{\\mbox{\\llap{\\small\\thepage\\kern1em\\color{gray} \\vline}\\color{gray}\\hspace{0.5em}\\rightmark\\hfil}} %% The header style

\\PassOptionsToPackage{protrusion=true,final}{microtype}

\\newenvironment{fullpage}
    {\\skip\\noindent\\begin{minipage}
    {\\textwidth+\\marginparwidth+\\marginparsep}\\skip\\smallskip}
    {\\end{minipage}\\vspace{1mm}}
\\makeatletter



%% DOC %<--------------------------------------------------------------------->%

% Whether the language is English;
% defaults to true
\\newbool{francais}
\\booltrue{francais}

%% Override and use FR instead of FR English if Babel is loaded
\\DeclareOption{francais}  %%{\\PassOptionsToPackage{french}{babel,datetime2}}
\\ProcessOptions\\relax

%% Command to provide alternative translations in French and English
\\newcommand{\\FrenchEnglish}[2]{\\ifbool{francais}{#1}{#2}}

%% This} separating line is used across several documents,
\\newcommand{\\@separator}{%%
\\rule{0ex}{2ex}%%
   %% Place the dashed rule 1X high
  %%\\textcolor{dark}
{\\rule{\\textwidth}{1pt}}%%
}


%% LABEL %<------------------------------------------------------------------->%
%% Standard style for labels, small and bold
\\newcommand{\\@labeltext}{\\large\\scshape}

\\newcommand*{\\@absentlabel}{\\FrenchEnglish{ABSENT}{ABSENT}}

\\newcommand*{\\@abstractlabel}{\\FrenchEnglish{EXTRAIT}{ABSTRACT}}
%% No star for \\@abstract, it can expand to multiple paragraphs
\\newcommand{\\@abstract}{Set with \\texttt{\\textbackslash abstract\\{\\}}}
\\renewcommand*{\\abstract}{\\renewcommand*{\\@abstract}}

\\newcommand*{\\@academiclabel}
            {\\FrenchEnglish{Academic objectives}{Faglig målsetting}}
\\newcommand*{\\@academic}{\\texttt{\\textbackslash academic\\{\\}}}
\\newcommand*{\\academic}{\\renewcommand*{\\@academic}}

\\newcommand*{\\@accumulatedlabel}
            {\\FrenchEnglish{Accumulated}{Akkumulerte kostnader}}

\\newcommand*{\\@addresslabel} {\\FrenchEnglish{Addresse}{Address}}
\\newcommand*{\\@address}{}
\\newcommand*{\\address}[1]{\\renewcommand{\\@address}{#1}}

\\newcommand*{\\@agreedlabel}{\\FrenchEnglish{AS AGREED}{AS AGREED}}

\\newcommand*{\\@attachmentlabel}{\\FrenchEnglish{ATTACHMENTS}{ATTACHMENTS}}
\\newcommand{\\@attachments}{Set with \\texttt{\\textbackslash attachments\\{\\}}}
\\newcommand{\\attachments}{\\renewcommand{\\@attachments}}
\\newcommand*{\\@attachmentpages}
            {[+ set with \\texttt{\\textbackslash attachmentpages\\{\\}]}}
\\newcommand*{\\attachmentpages}{\\renewcommand*{\\@attachmentpages}}
\\newcommand*{\\@attachmentrequest}
            {\\FrenchEnglish{If not, explain in an attachment}
                          {Avvik fra planen kommenteres i vedlegg}}

\\newcommand*{\\@attentionlabel}{\\FrenchEnglish{FOR YOUR ATTENTION}{BEHANDLING}}

\\newcommand*{\\@approvedlabel}{\\FrenchEnglish{APPROUVE PAR}{APPROVED BY}}
\\newcommand*{\\@approved}{Set with \\texttt{\textbackslash approved\\{\\}}}
\\newcommand*{\\approved}{\\renewcommand*{\\@approved}}

%% No star for \\@asplannedlabel, it is on two lines
\\newcommand{\\@asplannedlabel}
           {\\FrenchEnglish{AS PLANNED\\YES~/~NO}{FØLGER PLAN\\JA~/~NEI}}

\\newcommand*{\\@attnlabel}{\\FrenchEnglish{FOR THE ATTENTION OF}{VED}}
\\newcommand*{\\@attn}{Set with \\texttt{\\textbackslash attn\\{\\}}}
\\newcommand*{\\attn}{\\renewcommand*{\\@attn}}

\\newcommand*{\\@authorlabel}{\\FrenchEnglish{Auteur(s)}{Author(s)}}
\\newcommand*{\\@Authorlabel}{\\FrenchEnglish{AUTEUR(S)}{AUTHOR(S)}}

\\newcommand*{\\@checkedlabel}{\\FrenchEnglish{VERIFIE PAR}{CHECKED BY}}
\\newcommand*{\\@checked}{Set with \\texttt{\textbackslash checked\\{\\}}}
\\newcommand*{\\checked}{\\renewcommand*{\\@checked}}

\\newcommand*{\\@classificationlabel}{\\FrenchEnglish{SECRETAIRE}{GRADERING}}


\\newcommand*{\\@datelabel}{\\FrenchEnglish{DATE}{DATE}}


\\newcommand*{\\@email}{}
\\newcommand*{\\email}[1]{\\renewcommand{\\@email}{#1}}

\\newcommand*{\\@enclosurelabel}{\\FrenchEnglish{ENCLOSURE}{BILAG}}

\\newcommand*{\\@expenditurelabel}{\\FrenchEnglish{EXPENDITURE}{MEDGÅTTE KOSTNADER}}
\\newcommand*{\\@expshortlabel}{\\FrenchEnglish{Expenditure}{Kostnader}}

\\newcommand*{\\@faxlabel}{\\FrenchEnglish{Telefax}{Telefaks}}
\\newcommand*{\\@fax}{}
\\newcommand*{\\fax}[1]{\\renewcommand{\\@fax}{#1}}

\\newcommand*{\\@faxnumberlabel}{\\FrenchEnglish{FAX NUMBER}{TELEFAKSNUMMER}}
\\newcommand*{\\@faxnumber}{Set with \\texttt{\\textbackslash faxnumber\\{\\}}}
\\newcommand*{\\faxnumber}{\\renewcommand*{\\@faxnumber}}

\\newcommand*{\\@firstexplabel}
            {\\FrenchEnglish{PLANNED EXPENDITURE\newline
                           FOR 1\\textsuperscript{st} YEAR}
                          {ØKONOMISK RAMME\newline STARTÅRET}}
\\newcommand*{\\@firstexp}{\\texttt{\\textbackslash firstexp\\{\\}}}
\\newcommand*{\\firstexp}{\\renewcommand*{\\@firstexp}}

\\newcommand*{\\@fromlabel}{\\FrenchEnglish{DE}{FROM}}

\\newcommand*{\\@historylabel}{\\FrenchEnglish{Document History}{Historikk}}

\\newcommand*{\\@excusedlabel}{\\FrenchEnglish{EXCUSE}{EXCUSE}}

\\newcommand*{\\@durationlabel}{\\FrenchEnglish{DUREE}{DURATION}}
\\newcommand*{\\@duration}{Set with \\texttt{\\textbackslash duration\\{\\}}}
\\newcommand*{\\duration}{\\renewcommand*{\\@duration}}

\\newcommand*{\\@initiatorlabel}{\\FrenchEnglish{INITIATEUR}{INITIATED BY}}
\\newcommand*{\\@initiator}{Set with \\texttt{\\textbackslash initiator\\{\\}}}
\\newcommand*{\\initiator}{\\renewcommand*{\\@initiator}}

\\newcommand*{\\@institute}{}
\\newcommand*{\\institute}[1]{\\renewcommand{\\@institute}{#1}}

\\newcommand*{\\@ISBN}{Set with \\texttt{\\textbackslash isbn\\{\\}}}
\\newcommand*{\\isbn}{\\renewcommand*{\\@ISBN}}

\\newcommand*{\\@keywordlabel}{\\FrenchEnglish{MOTS CLES}{KEYWORDS}}
%% No star for \\@keywords, it can expand to multiple lines
\\newcommand{\\@keywords}{Set with \\texttt{\\textbackslash keywords\\{\\}}}
\\newcommand*{\\keywords}{\\renewcommand*{\\@keywords}}

\\newcommand*{\\@lastexp}{\texttt{\textbackslash lastexp\\{\\}}}
\\newcommand*{\\lastexp}{\\renewcommand*{\\@lastexp}}

\\newcommand*{\\@lasthrs}{\texttt{\textbackslash lasthrs\\{\\}}}
\\newcommand*{\\lasthrs}{\\renewcommand*{\\@lasthrs}}

\\newcommand*{\\@lastperiodlabel}{\\FrenchEnglish{Last period}{Siste periode}}

\\newcommand*{\\@locationlabel}{\\FrenchEnglish{Lieu}{Location}}
\\newcommand*{\\@location}{}
\\newcommand*{\\location}[1]{\\renewcommand{\\@location}{#1}}

\\newcommand*{\\@managerlabel}{\\FrenchEnglish{PROJECT MANAGER}{PROSJEKTLEDER}}
\\newcommand*{\\@manager}{Set with \\texttt{\\textbackslash manager\\{\\}}}
\\newcommand*{\\manager}{\\renewcommand*{\\@manager}}

\\newcommand*{\\@motto}{\\FrenchEnglish{Technology for a better society}
                                   {Teknologi for et bedre samfunn}}

\\newcommand*{\\name}{\\def\\fromname}
\\name{Set with \\texttt{\\textbackslash name\\{\\}}}

\\newcommand*{\\@objectivelabel}{\\FrenchEnglish{OBJECTIVE}{OBJECTIVE}}

\\newcommand*{\\@offernumberlabel}{\\FrenchEnglish{OFFER NUMBER}{TILBUDSNUMMER}}
\\newcommand*{\\@offernumber}{Set with \\texttt{\\textbackslash offer\\{\\}}}
\\newcommand*{\\offer}{\\renewcommand*{\\@offernumber}}
\\newcommand*{\\proposal}{\\renewcommand*{\\@offernumber}}

\\newcommand*{\\@onbudget}{\\texttt{\\textbackslash onbudget\\{\\}}}
\\newcommand*{\\onbudget}{\\renewcommand*{\\@onbudget}}

\\newcommand*{\\@onschedule}{\\texttt{\\textbackslash onschedule\\{\\}}}
\\newcommand*{\\onschedule}{\\renewcommand*{\\@onschedule}}

\\newcommand*{\\@orderreference}
            {[Set with \\texttt{\\textbackslash orderreference\\{\\}}]}
\\newcommand*{\\orderreference}{\\renewcommand*{\\@orderreference}}

\\newcommand*{\\@orderdated}{Set with \\texttt{\\textbackslash orderdated\\{\\}}}
\\newcommand*{\\orderdated}{\\renewcommand*{\\@orderdated}}

\\newcommand*{\\@orderby}{Set with \\texttt{\\textbackslash orderby\\{\\}}}
\\newcommand*{\\orderby}{\\renewcommand*{\\@orderby}}

\\newcommand*{\\@ourreflabel}{\\FrenchEnglish{Our reference}{Vår referanse}}
\\newcommand*{\\@ourref}{Set with \\texttt{\\textbackslash ourref\\{\\}}}
\\newcommand*{\\ourref}{\\renewcommand*{\\@ourref}}

\\newcommand*{\\@pageslabel}
            {\\FrenchEnglish{NUMBER OF PAGES AND ATTACHMENTS}
                          {ANTALL SIDER OG VEDLEGG}}

\\newcommand*{\\@participantlabel}{\\FrenchEnglish{PARTICIPANT}{PARTICIPANT}}
\\newcommand*{\\@participantslabel}{\\FrenchEnglish{PARTICIPANTS}{PARTICIPANTS}}

\\newcommand*{\\@phonelabel}{\\FrenchEnglish{Telephone}{Phone}}
\\newcommand*{\\@phone}{}
\\newcommand*{\\phone}[1]{\\renewcommand{\\@phone}{#1}}

\\newcommand*{\\@planexplabel}
            {\\FrenchEnglish{Planned expenditure}{Total kostnadsplan}}
\\newcommand*{\\@planexp}{\\texttt{\\textbackslash planexp\\{\\}}}
\\newcommand*{\\planexp}{\\renewcommand*{\\@planexp}}

\\newcommand*{\\@planlabel}{\\FrenchEnglish{Planned}{Planned}}

\\newcommand*{\\@preparedlabel}{\\FrenchEnglish{PREPARE PAR}{PREPARED BY}}
\\newcommand*{\\@prepared}{Set with \\texttt{\\textbackslash prepared\\{\\}}}
\\newcommand*{\\prepared}{\\renewcommand*{\\@prepared}}

\\newcommand*{\\@presentlabel}{\\FrenchEnglish{PRESENT}{PRESENT}}

\\newcommand*{\\@projectlabel}{\\FrenchEnglish{PROJET}{PROJECT}}
\\newcommand*{\\@project}{Set with \\texttt{\\textbackslash project\\{\\}}}
\\newcommand*{\\project}{\\renewcommand*{\\@project}}

\\newcommand*{\\@projectmemolabel}
            {\\FrenchEnglish{PROJECT MEMO NUMBER}{PROSJEKTNOTATNUMMER}}
\\newcommand*{\\@projectmemo}{Set with \\texttt{\\textbackslash projectmemo\\{\\}}}
\\newcommand*{\\projectmemo}{\\renewcommand*{\\@projectmemo}}

\\newcommand*{\\@projectname}{Set with \\texttt{\\textbackslash projectname\\{\\}}}
\\newcommand*{\\projectname}{\\renewcommand*{\\@projectname}}

\\newcommand*{\\@recipientlabel}{\\FrenchEnglish{TO}{TIL}}
\\newcommand*{\\@recipient}{Set with \\texttt{\\textbackslash recipient\\{\\}}}
\\newcommand*{\\recipient}{\\renewcommand*{\\@recipient}}

\\newcommand*{\\@referencelabel}{\\FrenchEnglish{REFERENCE}{REFERENCE}}

\\newcommand*{\\@reportlabel}{\\FrenchEnglish{Rapport}{Report}}

\\newcommand*{\\@reportnumberlabel}{\\FrenchEnglish{RAPPORT N°}{REPORT NUMBER}}
\\newcommand*{\\@reportnumber}{Set with \\texttt{\\textbackslash reportnumber\\{\\}}}
\\newcommand*{\\reportnumber}{\\renewcommand*{\\@reportnumber}}

\\newcommand*{\\@responsiblelabel}{\\FrenchEnglish{RESPONSIBLE}{RESPONSIBLE}}

\\newcommand*{\\@schedulelabel}{\\FrenchEnglish{Schedule}{Tidsramme}}

\\newcommand*{\\signature}{\\def\\fromsig}
\\signature{}
\\newcommand*{\\@signaturelabel}{\\FrenchEnglish{SIGNATURE}{SIGNATUR}}

\\newcommand*{\\@startlabel}{\\FrenchEnglish{STARTING YEAR}{STARTÅR}}
\\newcommand*{\\@start}{\\texttt{\\textbackslash start\\{\\}}}
\\newcommand*{\\start}{\\renewcommand*{\\@start}}

\\newcommand*{\\@statuslabel}{STATUS}
\\newcommand*{\\@statusdatelabel}
            {\\FrenchEnglish{STATUS AS OF DATE}{STATUS PER DATO}}

\\newcommand*{\\@statusdate}{Set with \\texttt{\\textbackslash statusdate\\{\\}}}
\\newcommand*{\\statusdate}{\\renewcommand*{\\@statusdate}}

\\newcommand*{\\@summaryclassificationlabel}
            {\\FrenchEnglish{CLASSIFICATION THIS PAGE}{GRADERING DENNE SIDE}}

\\newcommand*{\\@tasklistlabel}{\\FrenchEnglish{Task List}{Oppgaveliste}}
\\newcommand*{\\@tasknumberlabel}{\\#}
\\newcommand*{\\@tasklabel}{\\FrenchEnglish{TASK}{OPPGAVE}}


\\newcommand*{\\@versionlabel}{\\FrenchEnglish{VERSION}{VERSJON}}
\\newcommand*{\\@versiondescriptionlabel}
            {\\FrenchEnglish{VERSION DESCRIPTION}{VERSJONSBESKRIVELSE}}
\\newcommand*{\\@version}{Set with \\texttt{\\textbackslash version\\{\\}}}
\\newcommand*{\\version}{\\renewcommand*{\\@version}}

\\newcommand*{\\@wageslabel}{\\FrenchEnglish{Of which wages}{Herav timekost}}
\\newcommand*{\\@wages}{\\texttt{\\textbackslash wages\\{\\}}}
\\newcommand*{\\wages}{\\renewcommand*{\\@wages}}

\\newcommand*{\\@wheremeeting}{Set with \\texttt{\\textbackslash wheremeeting\\{\\}}}
\\newcommand*{\\wheremeeting}{\\renewcommand*{\\@wheremeeting}}

\\newcommand*{\\@whenmeeting}{Set with \\texttt{\\textbackslash whenmeeting\\{\\}}}
\\newcommand*{\\whenmeeting}{\\renewcommand*{\\@whenmeeting}}

\\newcommand*{\\@yourreflabel}{\\FrenchEnglish{Your reference}{Deres referanse}}
\\newcommand*{\\@yourref}{Set with \\texttt{\\textbackslash yourref\\{\\}}}
\\newcommand*{\\yourref}{\\renewcommand*{\\@yourref}}

%% MINUTES %<------------------------------------------------------->%

\\ProcessOptions\\relax

\\PassOptionsToPackage{table}{xcolor}

\\renewcommand*{\\@authorlabel}{\\FrenchEnglish{ECRIT PAR}{WRITTEN BY}}

%% Setting up header and footer
\\RequirePackage{nccfancyhdr,lastpage}
\\pagestyle{fancy}

%% Header
\\renewcommand{\\headrulewidth}{0pt}

%% Footer
\\renewcommand{\\footrulewidth}{0pt}
\\fancyfoot[c]{%%
  \\color{black}
  \\@separator\\newline\\\\
  ~~%%
  \\begin{minipage}[c]{0.5\\textwidth}
    \\small{\\textbf{\\@projectlabel}}\\newline
    \\@project
  \\end{minipage}%%
  \\hfill
  \\thepage\\ \\FrenchEnglish{de}{of} \\pageref{LastPage}
  %%~~\\newline
  \\@separator
}


%% The logo box.
\\newcommand{\\@rlogo}{
  \\noindent
  \\scriptsize
  \\raggedleft
  \\setlength{\\parskip}{1ex}
  \\includegraphics[height=70px]{\\@mainlogo}
}


\\RequirePackage{xparse}
\\newcommand{\\@participantstable}{}
\\NewDocumentCommand \\participant { O{present} m }{
    \\g@addto@macro \\@participantstable {
        \\multicolumn{2}{l}{#2}
          & \\ifstrequal{#1}{present}    {$\\bullet$}{}
          & \\ifstrequal{#1}{absent}     {$\\bullet$}{}
          & \\ifstrequal{#1}{excused}    {$\\bullet$}{}\\\\
    }
}

\\RequirePackage{tabularx,ltxtable}
\\newcommand{\\@tasktable}{}
\\newcommand{\\tasklist}{%%
  \\section*{\\@tasklistlabel}
  \\vspace{-\\baselineskip}
  \\begin{longtable}{rp{0.55\\textwidth}p{0.2\\textwidth}l}
    \\multicolumn{4}{@{}c@{}}{\\@separator}\\\\*
    \\@labeltext \\@tasknumberlabel & \\@labeltext \\@tasklabel &
    \\@labeltext \\@responsiblelabel & \\@labeltext \\@duelabel\\\\*
    \\multicolumn{4}{@{}c@{}}{\\@separator}
    \\@tasktable\\\\*
  \\end{longtable}
}
\\newcounter{sinteftask}
\\newcommand{\\task}[3]{%%
    \\g@addto@macro \\@tasktable {%%
      \\\\
      \\refstepcounter{sinteftask}\\thesinteftask & #1 & #2 & #3 \\\\*
      \\multicolumn{4}{@{}c@{}}{\\@separator}%%
    }%%
}


%% Recipient address and information colophon
\\RequirePackage{colortbl,tabularx,setspace,rotating}
\\renewcommand{\\maketitle}{%%
  %%\\sffamily%%
  \\noindent%%
  \\begin{minipage}[b]{0.7\\textwidth}
    \\setlength{\\parskip}{2ex}%%
    \\Huge\\@title
    %% ~ ensures \\ does not crash when \@wheremeeting is empty
    \\Large\\\\\\@wheremeeting~\\\\\\@whenmeeting
  \\end{minipage}
  \\hfill
  \\begin{minipage}[b]{0.20\\textwidth}
    %% Bring the colophon and address back up a bit
    \\vspace*{-25pt} %%https://fr.overleaf.com/project/5f2c14ff95d5d40001ccdf96
   \\@rlogo
  \\end{minipage}
  \\vspace{1ex}%%
  \\noindent%%
  \\@separator\\\\
  \\rowcolors{4}{}{gray}
  \\begin{tabularx}{\\textwidth}{XXccc}
    \\rowcolor{white}
      \\parbox{\\linewidth}{{\\@labeltext \\@initiatorlabel}\\\\\\@initiator}
      & \\parbox{\\linewidth}{{\\@labeltext \\@authorlabel}\\\\\\@author}
      & \\raisebox{-1cm}{\\begin{sideways}\\parbox{2cm}{\\raggedright\\@labeltext\\@presentlabel}\\end{sideways}}
      & \\raisebox{-1cm}{\\begin{sideways}\\parbox{2cm}{\\raggedright\\@labeltext\\@absentlabel}\\end{sideways}}
      & \\raisebox{-1cm}{\\begin{sideways}\\parbox{2cm}{\\raggedright\\@labeltext\\@excusedlabel}\\end{sideways}}\\\\
    \\rowcolor{white} \\multicolumn{5}{@{}c@{}}{\\@separator}\\\\
    \\rowcolor{white} \\@labeltext \\@participantslabel\\\\
    \\@participantstable
  \\end{tabularx}
  \\rowcolors{1}{}{} %% Back to normal
  \\@separator\\\\
  \\begin{minipage}{0.45\\textwidth}
    {\\@labeltext \\@projectlabel}\\\\
    \\@project
  \\end{minipage}
  \\hfill
  \\begin{minipage}{0.3\\textwidth}
    {\\@labeltext \\@datelabel}\\\\
    \\@date
  \\end{minipage}
  \\begin{minipage}{0.2\\textwidth}
    {\\@labeltext \\@durationlabel}\\\\
    \\@duration
  \\end{minipage}\\\\
  \\@separator
  \\noindent
}

\\makeatother

" ;;import de la feuille de syle dans texmf
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*a{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))



(defgroup org-export-fart nil
  "Options specific to Fart back-end."
  :tag "Org Fart PDF"
  :group 'ox-fart-glitter)


(org-export-define-derived-backend 'fart 'latex
  :options-alist
  '((:latex-class "LATEX_CLASS" nil "fart-glitter" t)
    (:present "PRESENT" nil nil)
    (:absent "ABSENT" nil nil)
    (:excuse "EXCUSE" nil nil)
    (:secretaire "SECRETAIRE" nil " " t)
    (:dure "DURE" nil " ")
    (:ou "OU" nil " ")
    (:quand "QUAND" nil " ")
    (:initiateur "INITIATEUR" nil " ")
    (:projet "PROJET" nil " ")
    (:with-toc nil "toc" 1 )
    (:latex-hyperref-p nil "texht" org-latex-with-hyperref t)
    (:resume "resume" nil nil)
    (:logo "LOGO" nil " "))
  :translate-alist '((template . ox-fart-glitter-template))
  :menu-entry
  '(?g "Export to Fart-glitter layout"
       ((?L "As LaTeX buffer" ox-fart-glitter-export-as-latex)
        (?l "As LaTeX file" ox-fart-glitter-export-to-latex)
        (?p "As PDF file" ox-fart-glitter-export-to-pdf)
        (?o "As PDF and Open"
            (lambda (a s v b)
              (if a (ox-fart-glitter-export-to-pdf t s v b)
                (org-open-file (ox-fart-glitter-export-to-pdf nil s v b))))))))

(defun ox-fart-glitter-template (contents info)
  "INFO are the header data and CONTENTS is the content of the org file and return complete document string for this export."
  (concat
   ;; Time-stamp.
   (and (plist-get info :time-stamp-file)
        (format-time-string "%% Créé le %d/%m/%Y %a %H:%M \n"))
   ;; Document class and packages.
   (let* ((class (plist-get info :latex-class))
          (class-options (plist-get info :latex-class-options))
          (header (nth 1 (assoc class org-latex-classes)))
          (document-class-string
           (and (stringp header)
                (if (not class-options) header
                  (replace-regexp-in-string
                   "^[\t]*\\\\documentclass\\(\\(\\[[^]]*\\]\\)?\\)"
                   class-options header t nil 1)))))
     (if (not document-class-string)
         (user-error "Unknown LaTeX class `%s'" class)
       (org-latex-guess-babel-language
        (org-latex-guess-inputenc
         (org-element-normalize-string
          (org-splice-latex-header
           document-class-string
           org-latex-default-packages-alist ; Defined in org.el.
           org-latex-packages-alist nil     ; Defined in org.el.
           (concat (org-element-normalize-string (plist-get info :latex-header))
                   (plist-get info :latex-header-extra)))))
        info)))

   ;; Now the core content
   (let ((toc (plist-get info :with-toc))
         (from (plist-get info :from))
         (subject (plist-get info :subject))
         (fromname (plist-get info :fromname))
         (cc (plist-get info :cc)))
     (concat "



"(when (plist-get info :org-latex-with-hyperref)
   (format "{%s}" (plist-get info :org-latex-with-hyperref) ))"

\\author{"(org-export-data (plist-get info :author) info)"}
\\title{"(org-export-data (plist-get info :title) info)"}

\\wheremeeting{"(when (plist-get info :ou)
   (format "%s" (plist-get info :ou) )) "}
\\whenmeeting{"(when (plist-get info :quand)
   (format "%s" (plist-get info :quand) )) "}
\\initiator{"(when (plist-get info :initiateur)
   (format "%s" (plist-get info :initiateur) )) "}
\\project{"(when (plist-get info :projet)
             (format "%s" (plist-get info :projet) )) "}
\\duration{"(when (plist-get info :dure)
             (format "%s" (plist-get info :dure) )) "}

\\makeatletter
"(when (plist-get info :logo)
   (format "\\newcommand{\\@mainlogo}{%s}" (plist-get info :logo) )) "
\\makeatother

"

(when (plist-get info :present)
   (mapconcat (lambda (element)
                (format "\\participant[present]{%s}" element))
              (split-string (plist-get info :present) ",")
              "\n"))

(when (plist-get info :absent)
  (mapconcat (lambda (element)
               (format "\\participant[absent]{%s}" element))
             (split-string (plist-get info :absent) ",")
             "\n"))

(when (plist-get info :excuse)
  (mapconcat (lambda (element)
               (format "\\participant[excused]{%s}" element))
             (split-string (plist-get info :excuse) ",")
             "\n"))
"
\\begin{document}
\\begin{fullpage}
\\maketitle
"(when (plist-get info :with-toc)
   (concat
    (format "\\setcounter{tocdepth}{%d}" (plist-get info :with-toc) )
    "\\tableofcontents" ) )"
\\end{fullpage}
\\pagenumbering{arabic}
" contents "
\\singlespacing
\\end{document}
"))))

;;;###autoload
(defun ox-fart-glitter-export-as-latex
    (&optional async subtreep visible-only body-only ext-plist)
  "Export current buffer as a Fart latex.

If narrowing is active in the current buffer, only export its
narrowed part.

If a region is active, export that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting buffer should be accessible
through the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the headline properties
first.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

When optional argument BODY-ONLY is non-nil, only write content.

EXT-PLIST, when provided, is a proeprty list with external
parameters overriding Org default settings, but still inferior to
file-local settings.

Export is done in a buffer named \"*ox-fart-glitter Fart Export*\".  It
will be displayed if `org-export-show-temporary-export-buffer' is
non-nil."
  (interactive)
  (let (ox-fart-glitter-special-contents)
    (org-export-to-buffer 'fart "*Org Fart Export*"
      async subtreep visible-only body-only ext-plist
      (lambda () (LaTeX-mode)))))

;;;###autoload
(defun ox-fart-glitter-export-to-latex
    (&optional async subtreep visible-only body-only ext-plist)
  "Export current buffer as a Fart (tex).

If narrowing is active in the current buffer, only export its
narrowed part.

If a region is active, export that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting file should be accessible through
the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the headline properties
first.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

When optional argument BODY-ONLY is non-nil, only write contents.

EXT-PLIST, when provided, is a property list with external
parameters overriding Org default settings, but still inferior to
file-local settings.

When optional argument PUB-DIR is set, use it as the publishing
directory.

Return output file's name."
  (interactive)
  (let ((outfile (org-export-output-file-name ".tex" subtreep))
        (ox-fart-glitter-special-contents))
    (org-export-to-file 'fart outfile
      async subtreep visible-only body-only ext-plist)))

;;;###autoload
(defun ox-fart-glitter-export-to-pdf
    (&optional async subtreep visible-only body-only ext-plist)
  "Export current buffer as a Fart (pdf).

If narrowing is active in the current buffer, only export its
narrowed part.

If a region is active, export that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting file should be accessible through
the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the headline properties
first.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

When optional argument BODY-ONLY is non-nil, only write code
between \"\\begin{letter}\" and \"\\end{letter}\".

EXT-PLIST, when provided, is a property list with external
parameters overriding Org default settings, but still inferior to
file-local settings.

Return PDF file's name."
  (interactive)
  (let ((file (org-export-output-file-name ".tex" subtreep))
	(ox-fart-glitter-special-contents))
    (org-export-to-file 'fart file
      async subtreep visible-only body-only ext-plist
      (lambda (file) (org-latex-compile file)))))

;;;###autoload
(defun ox-fart-glitter-export-to-pdf-and-open
    (&optional async subtreep visible-only body-only ext-plist)
  "Export current buffer as a Fart (pdf) and open.
If narrowing is active in the current buffer, only export its
narrowed part.

If a region is active, export that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting file should be accessible through
the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the headline properties
first.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

When optional argument BODY-ONLY is non-nil, only write code
between \"\\begin{letter}\" and \"\\end{letter}\".

EXT-PLIST, when provided, is a property list with external
parameters overriding Org default settings, but still inferior to
file-local settings.

Return PDF file's name."
  (interactive)
  (let ((outfile (org-export-output-file-name ".tex" subtreep)))
    (org-export-to-file 'fart outfile
      async subtreep visible-only body-only ext-plist
      (lambda (file) (org-latex-compile file)))))

(provide 'ox-fart-glitter)
;;; ox-fart-glitter.el ends here
