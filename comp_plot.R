#' Plot Component
#' @noRd
ui_plot <- function() {
  tagList(
    # Plot Container with centering
    div(style = "display: flex; justify-content: center; align-items: center; width: 100%; overflow: auto;",
        uiOutput("plot_container")
    ),
    
    # Plot Size Controls
    div(class = "plot-controls",
        h5("Plot Size"),
        fluidRow(
          column(4, numericInput("plot_width", "Width", value = 10, step = 0.5)),
          column(4, numericInput("plot_height", "Height", value = 7, step = 0.5)),
          column(4, selectInput("plot_units", "Units", 
                                choices = c("in", "cm", "mm", "px"), 
                                selected = "in"))
        )
    ),
    
    # Download Buttons (Bottom)
    div(class = "download-buttons",
        downloadButton("download_png", "Export PNG"),
        downloadButton("download_pdf", "Export PDF"),
        downloadButton("download_svg", "Export SVG")
    )
  )
}

#' Plot Server Logic
#' @noRd
server_plot <- function(input, output, session, current_plot) {
  
  # Helper to convert to pixels for on-screen display
  # Assuming 96 DPI for screen rendering approximation
  get_plot_dims_px <- reactive({
    w <- input$plot_width
    h <- input$plot_height
    u <- input$plot_units
    
    if (is.null(w) || is.null(h) || is.null(u)) return(list(width = 600, height = 400))
    
    # Conversion factors to pixels (approximate for screen)
    # 1 inch = 96 px
    # 1 cm = 37.8 px
    # 1 mm = 3.78 px
    
    list(
      width = switch(u,
                     "in" = w * 96,
                     "cm" = w * 37.8,
                     "mm" = w * 3.78,
                     "px" = w,
                     w),
      height = switch(u,
                      "in" = h * 96,
                      "cm" = h * 37.8,
                      "mm" = h * 3.78,
                      "px" = h,
                      h)
    )
  })

  # Dynamic Plot Container
  output$plot_container <- renderUI({
    dims <- get_plot_dims_px()
    plotOutput("plot", width = paste0(dims$width, "px"), height = paste0(dims$height, "px"))
  })
  
  # Render Plot
  output$plot <- renderPlot({
    req(current_plot$obj)
    current_plot$obj
  }, res = 96) # Set default resolution for the plot device
  
  # Downloads
  output$download_png <- downloadHandler(
    filename = function() { paste0("plot-", Sys.Date(), ".png") },
    content = function(file) {
      req(current_plot$obj)
      ggsave(file, plot = current_plot$obj, device = "png", 
             width = input$plot_width, height = input$plot_height, units = input$plot_units)
    }
  )
  
  output$download_pdf <- downloadHandler(
    filename = function() { paste0("plot-", Sys.Date(), ".pdf") },
    content = function(file) {
      req(current_plot$obj)
      ggsave(file, plot = current_plot$obj, device = "pdf", 
             width = input$plot_width, height = input$plot_height, units = input$plot_units)
    }
  )
  
  output$download_svg <- downloadHandler(
    filename = function() { paste0("plot-", Sys.Date(), ".svg") },
    content = function(file) {
      req(current_plot$obj)
      ggsave(file, plot = current_plot$obj, device = "svg", 
             width = input$plot_width, height = input$plot_height, units = input$plot_units)
    }
  )
}
