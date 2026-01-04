#' Theme Component
#' @noRd
ui_theme <- function() {
  tagList(
    selectInput("theme", "Theme", choices = c("Minimal" = "minimal", "Classic" = "classic", "Black & White" = "bw")),
    textInput("plot_title", "Plot Title", value = "My Plot")
  )
}
