
library(shiny)

ui <- fluidPage(
    textInput("name", "What's your name?"),
    textOutput("greeting")
)

 server1 <- function(input, output, server) {
     output$greeting <- renderText({paste0("Hello ", input$name)}) #Error: "name" , {}, input$greeting
 }

 server2 <- function(input, output, server) {
     #greeting <- paste0("Hello ", input$name) #Error: output$greeting, paste() in non-reactive context w/reactive input
     output$greeting <- renderText({paste0("Hello ", input$name)})
 }

server3 <- function(input, output, server) {
    output$greting <- paste0("Hello", input$name) #Error: typo "greting", , paste0() in non-reactive context w/reactive input
}

# Run the application 
shinyApp(ui = ui, server = server1)
