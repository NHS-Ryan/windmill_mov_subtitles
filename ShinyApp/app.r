library(shiny)
source("global.R")  # Loads the data and required libraries
source("ui.R")  
source("server.R")

shinyApp(ui = ui, server = server)



