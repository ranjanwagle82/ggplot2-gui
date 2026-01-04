#' The application server-side
#'
#' @param input,output,session Internal parameters for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import ggplot2
#' @import datasets
#' @import tools
#' @noRd
app_server <- function(input, output, session) {
  
  # Reactive to store the current plot object
  current_plot <- reactiveValues(obj = NULL)
  
  # 1. Data Component
  data <- server_data(input, output, session)
  
  # 2. Header Component (Reset/Clear)
  server_header(input, output, session, data)
  
  # 3. Plot Options Components
  server_axes(input, output, session, data)
  server_geometry(input, output, session, data)
  server_facets(input, output, session, data)
  
  # 4. Code Component (Generates Plot)
  server_code(input, output, session, data, current_plot)
  
  # 5. Plot Component (Renders Plot & Downloads)
  server_plot(input, output, session, current_plot)
  
}
