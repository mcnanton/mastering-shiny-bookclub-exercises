library(shiny)
library(ggplot2)

datasets <- c("economics", "faithfuld", "seals")
ui <- fluidPage(
    selectInput("dataset", "Dataset", choices = datasets),
    verbatimTextOutput("summary"),
    renderPlot("plot") #Error 2: tableOutput("plot")
)

server <- function(input, output, session) {
    dataset <- reactive({
        get(input$dataset, "package:ggplot2")
    })
    output$summary <- renderPrint({ #Error 3: output$summmry
        summary(dataset())
    })
    output$plot <- renderPlot({
        plot(dataset()) #Error 1: plot(dataset)
    }, res = 96)
}

shinyApp(ui, server)