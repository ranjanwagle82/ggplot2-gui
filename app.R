# Launch the Shiny Application
# This file allows RStudio to recognize the project as a Shiny App and providing a 'Run App' button.

# 1. Load required packages
library(shiny)
library(ggplot2)
library(readxl)
library(tools)

# 2. Source all R components
# Using a local helper to ensure correct working directory context
source_directory <- function(path) {
  files <- list.files(path, pattern = "\\.R$", full.names = TRUE)
  for (file in files) {
    source(file)
  }
}

if (dir.exists("R")) {
  source_directory("R")
} else {
  # Fallback if running from inside R directory or elsewhere
  source_directory(".")
}

# 3. Run the application
run_app()
