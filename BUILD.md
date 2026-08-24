# Building the course

Run these commands from the repository root.

## HTML slides and homepages

```r
source("render.R")
```

This renders light and dark HTML versions for lectures 1 to 4 and the two homepages.

## PDF slides

PDF files are made from the rendered HTML slides with DeckTape:

```text
npx decktape remark lecture1/slides.html lecture1/slides.pdf
npx decktape remark lecture1/slides_dark.html lecture1/slides_dark.pdf
```

Repeat for `lecture2`, `lecture3`, and `lecture4`.

Install DeckTape once with:

```text
npm install -g decktape
```

The slide sources are `lectureN/slides.Rmd`. Lecture-specific support files are in `lectureN/slides_elements/`. Shared assets and code are in `site_elements/`.
