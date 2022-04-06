library(shiny)

ui <- fluidPage(
    sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),
    sliderInput("y", label = "And y is", min = 1, max = 50, value = 30),
    paste("then the product is:"),
    textOutput("product")
)

server <- function(input, output, session) {
    output$product <- renderText({ 
        #input$x * 5 #Error: cant find "x" because "x * 5" doesn't point to input
        input$x * input$y
    })
}

shinyApp(ui, server)

