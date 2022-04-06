

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    numericInput("age", "How old are you?", value = NA),
    textInput("name", "What's your name?"),
    textOutput("greeting")
    )
    

server <- function(input, output) {

    output$greeting <- renderText({
        paste0("Hello ", input$name)
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
