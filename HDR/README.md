# HDR Manuscript — Université Savoie Mont Blanc

This is a complete LaTeX project to write an HDR (Habilitation à Diriger des Recherches)
manuscript for Université Savoie Mont Blanc.

## Project structure

```
hdr-thesis/
├── main.tex                  ← Entry point: fill in your metadata here
├── hdr-usmb.cls              ← Document class (cover, layout, styles)
├── hdr-extras.sty            ← Extra environments & macros
├── references.bib            ← BibTeX bibliography
├── .latexmkrc                ← latexmk config
│
├── logos/
│   └── usmb-logo.jpeg        ← Official USMB logo (extracted from template)
│
├── front/
│   ├── acknowledgements.tex  ← Remerciements
│   ├── abstract.tex          ← Résumé / Abstract (bilingual)
│   └── publications.tex      ← Publication list
│
├── chapters/
│   ├── ch01-introduction.tex
│   ├── ch02-scientific-context.tex
│   ├── ch03-contributions.tex
│   ├── ch04-synthesis.tex
│   └── ch05-perspectives.tex
│
├── appendices/
│   └── appendix-a.tex        ← CV détaillé
│
└── figures/                  ← Place your figures here
```

## How to compile

### Recommended (latexmk):
```bash
latexmk -pdf main.tex
```

### Manual (three passes needed):
```bash
pdflatex main.tex
bibtex main
pdflatex main.tex
pdflatex main.tex
```

### Clean auxiliary files:
```bash
latexmk -c
```

## Customisation

### 1. Fill in your metadata in `main.tex`

```latex
\hdrAuthor    {Prénom NOM}
\hdrTitle     {Titre de votre HDR}
\hdrSpeciality{Informatique}
\hdrDate      {15 juin 2025}
```

### 2. Declare jury members

```latex
\juryMember{Pr. Prénom NOM}{Professeur, Université X}{Rapporteur}
\juryMember{Dr. Prénom NOM}{MCF, Université Y}{Membre}
```
Up to 6 jury members supported.

### 3. Add your content

Replace `\todo{...}` placeholders with your text in each chapter file.

### 4. Key environments provided by `hdr-extras.sty`

| Environment         | Purpose                                 |
|---------------------|-----------------------------------------|
| `keyresult`         | Highlighted box for key results         |
| `contribution`      | Red-framed box for contributions        |
| `hdrabstract`       | Framed abstract block (bilingual)       |
| `publist`           | Numbered publication list               |

### 5. Useful macros

| Macro            | Purpose                         |
|------------------|---------------------------------|
| `\todo{text}`    | Red TODO marker                 |
| `\studentrow{}`  | Row in student supervision table|

## Colours

| Name          | RGB          | Usage                       |
|---------------|--------------|-----------------------------|
| `usmb@blue`   | 0, 72, 140   | Headings, links, frames     |
| `usmb@red`    | 190, 30, 45  | Citations, contribution boxes|
| `usmb@grey`   | 100,100,100  | Secondary text              |
| `usmb@lgrey`  | 230,230,230  | Background shading          |
