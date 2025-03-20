library(shiny)

server <- function(input, output) {
  
  filtered_data <- reactive({
    df <- data
    if (input$country != "All") {
      df <- df %>% filter(Country == input$country)
    }
    if (input$language != "All") {
      df <- df %>% filter(`Most Commonly Spoken Language` == input$language)
    }
    df
  })
  
  output$table <- renderDT({
    datatable(filtered_data(), options = list(pageLength = 10))
  })
  
  output$plot <- renderPlotly({
    x_var <- input$x_var  # Get selected X-axis variable
    
    p <- ggplot(filtered_data(), aes(
      x = .data[[x_var]], 
      y = `Market Score`, 
      size = `Target Population (millions)`,
      color = `Market Score`,  # Add color based on Market Score
      text = paste("Country:", .data[["Country"]],  # Fix the Country issue
                   "<br>Target Population:", .data[["Target Population (millions)"]], "million",
                   "<br>Population:", .data[["Population (millions)"]], "million",
                   "<br>Market Score:", .data[["Market Score"]]))) +
      geom_point(alpha = 0.8) +  
      scale_size(range = c(2, 10)) +  
      scale_color_gradient(low = "blue", high = "red") +  # Color gradient from low to high Market Score
      labs(title = "Market Score vs. Selected X-Axis",
           x = x_var,
           y = "Market Score",
           color = "Market Score") +  # Add color legend
      theme_minimal() +
      theme(legend.position = "none")
    
    ggplotly(p, tooltip = "text")  # Convert to interactive plotly graph
  })
  
  output$notes <- renderUI({
    temp_file <- tempfile(fileext = ".md")  # Create a temporary file
    download.file("https://raw.githubusercontent.com/NHS-Ryan/windmill_mov_subtitles/main/README.md", temp_file, quiet = TRUE)
    
    # Read markdown content as text
    markdown_content <- paste(readLines(temp_file), collapse = "\n")
    
    # Render markdown
    withTags({
      div(HTML(markdown::markdownToHTML(text = markdown_content, fragment.only = TRUE)))
    })
  })
  
  
}
