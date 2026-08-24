
library(rmarkdown)

for (dk in c("", "_dark")) {
  for (j in 1:4) {
    render(input = paste0("lecture", j, "/slides.Rmd"),
           params = list(dark = dk != ""),
           output_options = list(includes = list(after_body = paste0("slides_elements/insert-logo", dk, ".html"))), 
           output_file = paste0("lecture", j, "/slides", dk, ".html"))
  } 
  render(input = "home.Rmd",
         params = list(dark = dk != ""), 
         output_file = paste0("home", dk, ".html"))
}
