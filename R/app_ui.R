#' The application User-Interface
#'
#' @import shiny
#' @noRd
app_ui <- function() {
  fluidPage(
    tags$head(
      tags$style(HTML("
        .data-container {
          background-color: #e8f5e9; /* Light Green */
          padding: 20px;
          border-radius: 8px;
          margin-bottom: 20px;
          border: 1px solid #a5d6a7;
          box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .input-container {
          background-color: #f0f8ff; /* AliceBlue */
          padding: 20px;
          border-radius: 8px;
          margin-bottom: 20px;
          border: 1px solid #d1d5db;
          box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .shiny-input-container {
          margin-bottom: 0 !important;
        }
        h4 {
          margin-top: 0;
          color: #2c3e50;
          border-bottom: 2px solid #3498db;
          padding-bottom: 5px;
          display: inline-block;
          margin-bottom: 15px;
        }
        .code-editor-container {
            margin-top: 20px;
            border-top: 1px solid #eee;
            padding-top: 20px;
        }
        #code_editor {
            font-family: 'Courier New', Courier, monospace;
            font-size: 14px;
        }
        .header-row {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 20px;
        }
        .plot-controls {
          margin-top: 10px; 
          padding: 10px; 
          background-color: #f9f9f9; 
          border-radius: 5px; 
          border: 1px solid #eee;
        }
        .download-buttons {
          margin-top: 20px; 
          text-align: center;
        }
      "))
    ),
    
    # Header
    ui_header(),
    
    # 1. Data Upload Section
    ui_data(),
    
    # 2. Plot Options Section
    div(class = "input-container",
        h4("2. Plot Options"),
        flowLayout(
          cellArgs = list(style = "min-width: 200px; max-width: 300px;"),
          
          # Components
          ui_axes(),
          ui_geometry(),
          ui_facets(),
          ui_theme()
        )
    ),
    
    # Main Plot Area
    mainPanel(
      width = 12,
      ui_plot(),
      ui_code()
    )
  )
}
