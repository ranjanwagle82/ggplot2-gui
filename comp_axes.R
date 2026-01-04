#' Axes Component
#' @noRd
ui_axes <- function() {
  tagList(
    uiOutput("x_ui"),
    uiOutput("y_ui"),
    textInput("x_label", "X Axis Label", value = ""),
    textInput("y_label", "Y Axis Label", value = ""),
    uiOutput("scale_x_ui")
  )
}

#' Axes Server Logic
#' @noRd
server_axes <- function(input, output, session, data) {
  output$x_ui <- renderUI({
    req(data())
    selectInput("x", "X Variable:", choices = names(data()), selected = "mpg")
  })
  
  output$y_ui <- renderUI({
    req(data())
    selectInput("y", "Y Variable:", choices = names(data()), selected = "wt")
  })
  
  output$scale_x_ui <- renderUI({
    req(data(), input$x)
    is_num <- is.numeric(data()[[input$x]])
    choices <- c("Default")
    if(is_num) choices <- c(choices, "Scale X continuous") else choices <- c(choices, "Scale X discrete")
    selectInput("scale_x", "X Scale:", choices = choices)
  })
}
