
library(rmarkdown)

for (j in 1:4) {
    render(input = paste0("lecture", j, "/slides.Rmd"),
           output_options = list(includes = list(after_body = "slides_elements/insert-logo.html")),
           output_file = paste0("lecture", j, "/slides.html"))
}
render(input = "home.Rmd", output_file = "home.html")
