library(shiny)
library(vroom)
library(tidyverse)
#devtools::install_github("hadley/neiss")

injuries <- vroom::vroom("neiss/injuries.tsv.gz")
products <- vroom::vroom("neiss/products.tsv")
population <- vroom::vroom("neiss/population.tsv")

# Define UI for application that draws a histogram
ui <- fluidPage(

)

# Define server logic required to draw a histogram
server <- function(input, output) {


}

# Run the application 
shinyApp(ui = ui, server = server)
