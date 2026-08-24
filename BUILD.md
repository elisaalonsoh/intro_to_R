# Maintaining and Building the Course

This guide is for someone opening the repository for the first time. It explains
where to edit the course, how to render it, and how to create a customized
version without editing generated files.

## 1. Repository structure

Run all commands below from the repository root, the directory containing this
file, `home.Rmd`, and `render.R`.

```text
intro_to_R/
|-- home.Rmd                    Homepage source
|-- home.html                   Generated light homepage
|-- home_dark.html              Generated dark homepage
|-- render.R                    Main HTML build script
|-- render.Rmd                  Documented alternative build script
|-- glossary.R                  Optional glossary helper
|-- cheatsheets/                PDF and image reference sheets
|-- site_elements/              Shared site assets and code
|-- lecture1/
|-- lecture2/
|-- lecture3/
|-- lecture4/
`-- BUILD.md                   This guide
```

Each lecture has the same main layout:

```text
lectureN/
|-- slides.Rmd                  Main editable slide source
|-- slides.html                 Generated light HTML slides
|-- slides_dark.html            Generated dark HTML slides
|-- slides.pdf                  Generated light PDF slides
|-- slides_dark.pdf             Generated dark PDF slides
`-- slides_elements/
	 |-- data/                   Lecture datasets and downloadable data.zip
	 |-- figures/                Images displayed in the lecture
	 |-- libs/                   Libraries copied by knitr/xaringan
	 |-- archive/                Old examples and generated leftovers
	 |-- header.html              Lecture HTML header
	 |-- insert-logo.html        Light-slide navigation logo
	 |-- insert-logo_dark.html   Dark-slide navigation logo
	 |-- theme.css               Lecture-specific theme overrides
	 `-- xaringan-themer.css     Generated base slide theme
```

`site_elements/` contains files shared by the whole course: common R and CSS
code, homepage icons, logos, theme-switch icons, helper scripts, and the single
canonical `functions.xlsx` glossary input.

`archive/` contains material that is kept for reference but is not part of the
main build. Do not edit generated HTML or PDF files directly; change their
`.Rmd` source and render them again.

## 2. Install prerequisites

Install the following software:

1. R, with `rmarkdown`, `xaringan`, `xaringanthemer`, `tidyverse`,
	`kableExtra`, and the packages used by the lecture being edited.
2. Node.js and npm, required for PDF conversion with DeckTape.
3. A Chromium-based browser, used by DeckTape to print HTML slides.

In R, install the common packages with:

```r
install.packages(c(
  "rmarkdown", "xaringan", "xaringanthemer", "tidyverse", "kableExtra",
  "readxl"
))
```

Install DeckTape once from PowerShell, Command Prompt, or a terminal:

```text
npm install -g decktape
```

## 3. Render the HTML course

Open R or RStudio in the repository root and run:

```r
source("render.R")
```

This creates both light and dark HTML versions of all four lectures and both
homepage versions. It also refreshes the root `home.html` and `home_dark.html`.

From a terminal, the equivalent command is:

```text
Rscript render.R
```

The build expects the current working directory to be the repository root.

## 4. Create the PDF slides

DeckTape converts the rendered Remark/Xaringan HTML slides to PDF. After the
HTML build finishes, run the commands below. Always rerun the HTML build after
changing paths, images, headers, or slide content; DeckTape reads the existing
HTML files and does not read the `.Rmd` files directly.

```text
decktape remark lecture1/slides.html lecture1/slides.pdf
decktape remark lecture1/slides_dark.html lecture1/slides_dark.pdf
decktape remark lecture2/slides.html lecture2/slides.pdf
decktape remark lecture2/slides_dark.html lecture2/slides_dark.pdf
decktape remark lecture3/slides.html lecture3/slides.pdf
decktape remark lecture3/slides_dark.html lecture3/slides_dark.pdf
decktape remark lecture4/slides.html lecture4/slides.pdf
decktape remark lecture4/slides_dark.html lecture4/slides_dark.pdf
```

Check the PDFs visually after rendering, especially slides containing large
images, tables, or incremental content.

## 5. Adapt one lecture

Use this workflow when changing lecture content:

1. Open `lectureN/slides.Rmd`.
2. Change the YAML metadata at the top if the title, author, date, theme, or
	included files need to change.
3. Edit the slide content below the YAML. A line containing `---` starts a new
	slide in Xaringan.
4. Put new lecture images in `lectureN/slides_elements/figures/`.
5. Put new lecture datasets in `lectureN/slides_elements/data/`.
6. Reference images with paths such as:

	```html
	<img src="slides_elements/figures/example.png" width="700">
	```

7. Reference data with paths such as:

	```r
	data <- read.csv("slides_elements/data/example.csv")
	```

8. Update or add code examples in the R Markdown chunks.
9. Run `source("render.R")` from the repository root.
10. Recreate the light and dark PDFs with DeckTape.
11. Open the generated HTML and PDF files and check images, links, code, and
	 slide breaks.

Do not place new files directly in the lecture root. Keep the root limited to
`slides.Rmd` and its generated slide outputs.

## 6. Change the visual style

For a single lecture, edit:

- `lectureN/slides_elements/theme.css` for lecture-specific colors, title
  backgrounds, and CSS overrides.
- `lectureN/slides_elements/xaringan-themer.css` only when regenerating the
  base theme with `xaringanthemer`.
- `lectureN/slides_elements/insert-logo.html` and
  `insert-logo_dark.html` for the navigation logo behavior.
- `lectureN/slides_elements/header.html` for the lecture favicon/header.

For site-wide styling or logos, edit the corresponding file in
`site_elements/`. This affects the homepage and/or all lectures, so render the
whole course afterward.

## 7. Change the homepage

Edit `home.Rmd` at the repository root. It controls:

- the homepage introduction and schedule;
- links to lecture HTML, PDF, and data files;
- the contents generated from the four `slides.Rmd` files;
- the function glossary;
- the light/dark homepage switch.

Homepage assets belong in `site_elements/`. After editing, run:

```r
source("render.R")
```

The temporary table-of-contents fragments are generated during rendering and
should not be edited manually.

## 8. Update the glossary

The glossary input is `site_elements/functions.xlsx`. To update the function
list, edit that spreadsheet and rerun the relevant homepage build. The helper
script `glossary.R` can generate documentation URLs, but it requires internet
access and the relevant R packages.

## 9. Before publishing

Use this checklist:

1. Render the HTML files from the repository root.
2. Recreate all eight lecture PDFs.
3. Open both light and dark versions of every lecture.
4. Check that figures, datasets, navigation logos, and homepage links work.
5. Confirm that the homepage links point to the current lecture outputs and
	`slides_elements/data/data.zip` files.
6. Check `git status` and ensure only intended source, asset, and generated
	output changes are present.

The repository does not require a commit as part of the build process.
