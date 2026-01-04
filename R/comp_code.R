#' Code Component
#' @noRd
ui_code <- function() {
  div(class = "code-editor-container",
      h4("Code Editor"),
      p("Edit the code below and click 'Update Plot' to see changes."),
      textAreaInput("code_editor", label = NULL, value = "", width = "100%", height = "200px"),
      actionButton("run_code", "Update Plot", icon = icon("play"), class = "btn-primary")
  )
}

#' Code Server Logic
#' @noRd
server_code <- function(input, output, session, data, current_plot) {
  
  # Helper to generate code string based on inputs
  generate_code <- reactive({
    req(input$x, input$y, input$geom)
    
    # Start constructing code
    code <- paste0("ggplot(data, aes(x = ", input$x, ", y = ", input$y, "))")
    
    # Aesthetics
    aes_args <- c()
    if (!is.null(input$color) && input$color != "") aes_args <- c(aes_args, paste0("color = ", input$color))
    if (!is.null(input$fill) && input$fill != "") aes_args <- c(aes_args, paste0("fill = ", input$fill))
    if (!is.null(input$shape) && input$shape != "") aes_args <- c(aes_args, paste0("shape = ", input$shape))
    if (!is.null(input$size) && input$size != "") aes_args <- c(aes_args, paste0("size = ", input$size))
    
    if (length(aes_args) > 0) {
      code <- paste0(code, " + aes(", paste(aes_args, collapse = ", "), ")")
    }
    
    # Geom
    geom_func <- switch(input$geom,
                        "point" = "geom_point(alpha = 0.7)",
                        "bar" = "geom_bar(stat = 'identity', alpha = 0.7)",
                        "line" = "geom_line()",
                        "histogram" = "geom_histogram(alpha = 0.7)",
                        "smooth" = "geom_smooth()",
                        "geom_point()"
    )
    code <- paste0(code, " + ", geom_func)
    
    # Facets
    if (!is.null(input$facet_row) && input$facet_row != "" && !is.null(input$facet_col) && input$facet_col != "") {
      code <- paste0(code, " + facet_grid(", input$facet_row, " ~ ", input$facet_col, ")")
    } else if (!is.null(input$facet_row) && input$facet_row != "") {
      code <- paste0(code, " + facet_wrap(~", input$facet_row, ")")
    } else if (!is.null(input$facet_col) && input$facet_col != "") {
      code <- paste0(code, " + facet_wrap(~", input$facet_col, ")")
    }
    
    # Scales
    if (!is.null(input$scale_x) && input$scale_x == "Scale X continuous") {
      code <- paste0(code, " + scale_x_continuous()")
    } else if (!is.null(input$scale_x) && input$scale_x == "Scale X discrete") {
      code <- paste0(code, " + scale_x_discrete()")
    }
    
    # Theme
    theme_func <- switch(input$theme,
                         "minimal" = "theme_minimal()",
                         "classic" = "theme_classic()",
                         "bw" = "theme_bw()",
                         "theme_minimal()"
    )
    code <- paste0(code, " + ", theme_func)
    
    # Labels
    title <- input$plot_title
    xlab <- if(input$x_label != "") input$x_label else input$x
    ylab <- if(input$y_label != "") input$y_label else input$y
    
    code <- paste0(code, " + labs(title = '", title, "', x = '", xlab, "', y = '", ylab, "')")
    
    code
  })
  
  # Observer: When Inputs Change -> Update Code Editor & Plot
  observeEvent(c(input$x, input$y, input$geom, input$color, input$fill, input$shape, input$size, 
                 input$facet_row, input$facet_col, input$scale_x, input$theme, 
                 input$plot_title, input$x_label, input$y_label, input$factor_vars), {
                   
                   code_str <- generate_code()
                   updateTextAreaInput(session, "code_editor", value = code_str)
                   
                   # Evaluate and update plot
                   tryCatch({
                     data_env <- data() 
                     eval_env <- new.env()
                     assign("data", data_env, envir = eval_env)
                     assign("ggplot", ggplot2::ggplot, envir = eval_env)
                     assign("aes", ggplot2::aes, envir = eval_env)
                     
                     p <- eval(parse(text = code_str), envir = list(data = data_env), enclos = environment(ggplot))
                     current_plot$obj <- p
                   }, error = function(e) {
                     # Handle error silently
                   })
                 })
  
  # Observer: When "Update Plot" Button Clicked -> Run Code from Editor
  observeEvent(input$run_code, {
    req(input$code_editor)
    code_str <- input$code_editor
    
    tryCatch({
      data_env <- data()
      p <- eval(parse(text = code_str), envir = list(data = data_env), enclos = environment(ggplot))
      current_plot$obj <- p
    }, error = function(e) {
      showNotification(paste("Error in code:", e$message), type = "error")
    })
  })
}
