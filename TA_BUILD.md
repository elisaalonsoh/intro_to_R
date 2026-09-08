# Maintaining and Building the Course

This guide is for a TA opening the repository for the first time. It explains
the current layout, the packages required to render every lecture, and the
workflow for adapting the slides.

## 1. Repository structure

```text
intro_to_R/
|-- README.md                  Course information and published links
|-- TA_BUILD.md               This guide
|-- cheatsheets/              PDF and image reference sheets
|-- lecture1/
|-- lecture2/
|-- lecture3/
|-- lecture4/
`-- site_elements/            Shared R code, CSS, and images
```

Each lecture contains one editable source and its assets:

```text
lectureN/
|-- slides.Rmd                Main slide source
|-- slides.html               Generated HTML slides
`-- slides_elements/
    |-- data/                 Lecture datasets
    |-- figures/              Generated or inserted figures
    |-- libs/                 Browser libraries copied by xaringan
    |-- archive/              Reference material, not part of the build
    |-- header.html
    |-- insert-logo.html
    |-- theme.css
    `-- xaringan-themer.css
```

Edit the `.Rmd`, CSS, HTML includes, or data files. Do not edit generated HTML
or files in `slides_elements/libs/` directly. The current repository has no
separate `home.Rmd`, `render.R`, glossary spreadsheet, or downloadable data
archive; the published links are documented in `README.md`.

## 2. Install prerequisites

Install:

1. R and RStudio (or another R IDE).
2. Node.js and npm, required only for creating PDFs with DeckTape.
3. A Chromium-based browser, used by DeckTape.

In a fresh R installation, run this complete package setup once:

```r
install.packages(c(
  "rmarkdown", "knitr", "xaringan", "tidyverse", "ggthemes",
  "kableExtra", "countdown", "stargazer", "here", "rio", "ggpubr",
  "scales", "DT", "reshape2", "plotly", "car", "huxtable", "jtools"
))
```

These packages cover the four active `slides.Rmd` files and the shared code in
`site_elements/style.R`. Packages used only by archived experiments are not
needed for the normal build. Install them if you plan to run those files:

```r
install.packages(c("gganimate", "transformr"))
```

Install DeckTape once from PowerShell or a terminal:

```text
npm install -g decktape
```

## 3. Render the HTML slides

Run this from the repository root. Setting `knit_root_dir` to the lecture
folder is important because the slide sources use paths relative to that
folder.

```r
for (lecture in paste0("lecture", 1:4)) {
  rmarkdown::render(
    file.path(lecture, "slides.Rmd"),
    knit_root_dir = lecture
  )
}
```

To render only one lecture:

```r
rmarkdown::render("lecture2/slides.Rmd", knit_root_dir = "lecture2")
```

Open the generated `lectureN/slides.html` and check figures, datasets, links,
code output, and slide breaks.

## 4. Create PDF slides

After rendering the HTML, run DeckTape from the repository root:

```text
decktape remark lecture1/slides.html lecture1/slides.pdf
decktape remark lecture2/slides.html lecture2/slides.pdf
decktape remark lecture3/slides.html lecture3/slides.pdf
decktape remark lecture4/slides.html lecture4/slides.pdf
```

DeckTape reads the existing HTML and does not read the `.Rmd` files directly,
so rerender HTML after changing slide content, paths, images, or headers.

## 5. Adapt a lecture

1. Edit `lectureN/slides.Rmd` and its YAML metadata or R Markdown chunks.
2. Put images in `lectureN/slides_elements/figures/`.
3. Put datasets in `lectureN/slides_elements/data/`.
4. Reference assets relative to the lecture, for example
   `slides_elements/data/example.csv`.
5. Render the changed lecture using the command above.
6. Recreate its PDF with DeckTape if the published PDF should change.

A line containing `---` starts a new Xaringan slide. Keep lecture-specific
assets inside that lecture and shared styling or helper code in
`site_elements/`.

## 6. Change the visual style

For one lecture, edit its `slides_elements/theme.css`, `header.html`, or
`insert-logo.html`. The `xaringan-themer.css` file is generated theme CSS and
should only be changed when deliberately regenerating the theme.

Changes to `site_elements/style.R` or shared assets can affect multiple
lectures, so rerender all four lectures afterward.

## 7. Before publishing

1. Render all four HTML slide decks.
2. Recreate any changed PDFs with DeckTape.
3. Open the generated HTML and PDF files and check figures, data links,
   navigation, code output, and slide breaks.
4. Check `git status` and keep only intended source, asset, and generated-output
   changes.

The repository does not require a commit as part of the build process.
