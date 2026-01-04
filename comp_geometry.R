#' Geometry Component
#' @noRd
ui_geometry <- function() {
  tagList(
    uiOutput("geom_ui"),
    uiOutput("color_ui"),
    uiOutput("fill_ui"),
    uiOutput("shape_ui"),
    uiOutput("size_ui")
  )
}

#' Geometry Server Logic
#' @noRd
server_geometry <- function(input, output, session, data) {
  output$geom_ui <- renderUI({
    selectInput("geom", "Geometry:", 
                choices = c("Scatter" = "point", "Bar" = "bar", "Line" = "line", "Histogram" = "histogram", "Smooth" = "smooth"))
  })
  
  output$color_ui <- renderUI({
    req(data())
    selectInput("color", "Color by:", choices = c("None" = "", names(data())))
  })
  
  output$fill_ui <- renderUI({
    req(data())
    selectInput("fill", "Fill by:", choices = c("None" = "", names(data())))
  })
  
  output$shape_ui <- renderUI({
    req(data())
    selectInput("shape", "Shape by:", choices = c("None" = "", names(data())))
  })
  
  output$size_ui <- renderUI({
    req(data())
    selectInput("size", "Size by:", choices = c("None" = "", names(data())))
  })
}
