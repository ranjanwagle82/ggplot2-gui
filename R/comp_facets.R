#' Facets Component
#' @noRd
ui_facets <- function() {
  tagList(
    uiOutput("facet_row_ui"),
    uiOutput("facet_col_ui")
  )
}

#' Facets Server Logic
#' @noRd
server_facets <- function(input, output, session, data) {
  output$facet_row_ui <- renderUI({
    req(data())
    selectInput("facet_row", "Facet Row:", choices = c("None" = "", names(data())))
  })
  
  output$facet_col_ui <- renderUI({
    req(data())
    selectInput("facet_col", "Facet Col:", choices = c("None" = "", names(data())))
  })
}
