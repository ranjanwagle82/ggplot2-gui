#' Data Component
#' @noRd
ui_data <- function() {
  div(class = "data-container",
      h4("1. Data Source"),
      flowLayout(
        cellArgs = list(style = "min-width: 200px; max-width: 300px;"),
        fileInput("file", "Upload Data (CSV/Excel)", accept = c(".csv", ".xlsx")),
        selectInput("factor_vars", "Treat as Factor:", choices = NULL, multiple = TRUE)
      )
  )
}

#' Data Server Logic
#' @noRd
server_data <- function(input, output, session) {
  # 1. Data Handling (File Upload -> mtcars default)
  raw_data <- reactive({
    if (!is.null(input$file)) {
      ext <- tools::file_ext(input$file$name)
      switch(ext,
             csv = read.csv(input$file$datapath, stringsAsFactors = FALSE),
             xlsx = readxl::read_excel(input$file$datapath),
             {
               showNotification("Invalid file type", type = "error")
               mtcars
             }
      )
    } else {
      mtcars
    }
  })
  
  # Update Factor Choices
  observe({
    updateSelectInput(session, "factor_vars", choices = names(raw_data()))
  })
  
  # Processed Data (Factors)
  data <- reactive({
    df <- raw_data()
    if (!is.null(input$factor_vars)) {
      for (var in input$factor_vars) {
        df[[var]] <- as.factor(df[[var]])
      }
    }
    df
  })
  
  return(data)
}
