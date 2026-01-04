#' Header Component
#' @noRd
ui_header <- function() {
  div(class = "header-row",
      titlePanel("Enhanced ggplot2 GUI"),
      div(
        actionButton("default_btn", "Default", icon = icon("refresh"), class = "btn-info", style = "margin-right: 5px;"),
        actionButton("clear_btn", "Clear", icon = icon("trash"), class = "btn-danger")
      )
  )
}

#' Header Server Logic (Reset/Clear)
#' @noRd
server_header <- function(input, output, session, data) {
  # Default Button (Reset to mtcars defaults)
  observeEvent(input$default_btn, {
    # Reset Factors
    updateSelectInput(session, "factor_vars", selected = character(0))
    
    # Reset Plot Elements
    updateSelectInput(session, "x", selected = names(data())[1])
    updateSelectInput(session, "y", selected = names(data())[2])
    updateSelectInput(session, "geom", selected = "point")
    
    # Reset Aesthetics
    updateSelectInput(session, "color", selected = "")
    updateSelectInput(session, "fill", selected = "")
    updateSelectInput(session, "shape", selected = "")
    updateSelectInput(session, "size", selected = "")
    
    # Reset Facets
    updateSelectInput(session, "facet_row", selected = "")
    updateSelectInput(session, "facet_col", selected = "")
    
    # Reset Style & Labels
    updateSelectInput(session, "scale_x", selected = "Default")
    updateSelectInput(session, "theme", selected = "minimal")
    updateTextInput(session, "plot_title", value = "My Plot")
    updateTextInput(session, "x_label", value = "")
    updateTextInput(session, "y_label", value = "")
    
    # Reset Code Editor
    updateTextAreaInput(session, "code_editor", value = "")
  })
  
  # Clear Button (Clear all selections)
  observeEvent(input$clear_btn, {
    updateSelectInput(session, "factor_vars", selected = character(0))
    updateSelectInput(session, "x", selected = character(0))
    updateSelectInput(session, "y", selected = character(0))
    updateSelectInput(session, "geom", selected = character(0))
    updateSelectInput(session, "color", selected = "")
    updateSelectInput(session, "fill", selected = "")
    updateSelectInput(session, "shape", selected = "")
    updateSelectInput(session, "size", selected = "")
    updateSelectInput(session, "facet_row", selected = "")
    updateSelectInput(session, "facet_col", selected = "")
    updateSelectInput(session, "scale_x", selected = "Default")
    updateSelectInput(session, "theme", selected = "minimal")
    updateTextInput(session, "plot_title", value = "")
    updateTextInput(session, "x_label", value = "")
    updateTextInput(session, "y_label", value = "")
    updateTextAreaInput(session, "code_editor", value = "")
  })
}
