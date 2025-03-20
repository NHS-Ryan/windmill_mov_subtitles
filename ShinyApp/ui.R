# Define UI
ui <- fluidPage(
  titlePanel("Country Information Explorer"),
  sidebarLayout(
    sidebarPanel(
      selectInput("country", "Select Country:", 
                  choices = c("All", sort(unique(data$Country))), selected = "All"),
      selectInput("language", "Select Primary Language:", 
                  choices = c("All", sort(unique(data$`Most Commonly Spoken Language`))), selected = "All"),
      
      # Conditional dropdown for X-Axis variable
      conditionalPanel(
        condition = "input.tabs == 'Visualisation'",  # Show only when Visualisation tab is active
        selectInput("x_var", "Select X Axis Variable:", 
                    choices = c("Median Income ($)", 
                                "Target Population (millions)", 
                                "5 Year Average GDP Change %"), 
                    selected = "Median Income ($)")
      )
    ),
    mainPanel(
      tabsetPanel(id = "tabs",  # ID added to reference in conditionalPanel
                  tabPanel("Data Table", DTOutput("table")),
                  tabPanel("Visualisation", plotlyOutput("plot", height = "600px")),  
                  tabPanel("Notes", uiOutput("notes"))
      )
    )
  )
)

