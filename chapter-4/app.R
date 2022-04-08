library(shiny)
library(vroom)
library(tidyverse)
#devtools::install_github("hadley/neiss")

injuries <- vroom::vroom("neiss/injuries.tsv.gz")
products <- vroom::vroom("neiss/products.tsv")
population <- vroom::vroom("neiss/population.tsv")

set.seed(10)

prod_codes <- setNames(products$prod_code, products$title)
#This is a convenience function that sets the names on an object and returns the object. 
#It is most useful at the end of a function definition where one is creating the object to be returned 
#and would prefer not to store it under a name just so the names can be assigned

ui <- fluidPage(
  fluidRow(
    column(8,
           selectInput("code", "Product",
                       choices = setNames(products$prod_code, products$title),
                       width = "100%"
           )
    ),
    column(2, selectInput("y", "Y axis", c("rate", "count"))),
    column(2, selectInput("rows", "Number of rows", choices = seq(2,10)))
  ),
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  ),
  fluidRow(
    column(12, plotOutput("age_sex"))
  ),
  fluidRow(
    column(2, actionButton("story", "Tell me a story")),
    column(10, textOutput("narrative"))
  )
)

server <- function(input, output, session) {
  
  count_top <- function(df, var, n) {
    df %>%
      mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = as.numeric(input$rows)-1)) %>%
      #mutate({{ var }} := fct_infreq(fct_lump({{ var }}, n = n))) %>% #1st lumps all levels except for the 5 most frequent, then reorders (inc. "Other")
      group_by({{ var }}) %>%
      summarise(n = as.integer(sum(weight)))
  }
  

  narrative_sample <- eventReactive(
    list(input$story, selected()),
      selected() %>% pull(narrative) %>% sample(1))
  
  output$narrative <- renderText(narrative_sample())
  
  selected <- reactive(injuries %>% filter(prod_code == input$code))
  
  output$diag <- renderTable(count_top(selected(), diag), width = "100%")
  
  output$body_part <- renderTable(count_top(selected(), body_part), width = "100%")
  
  output$location <- renderTable(count_top(selected(), location), width = "100%")
  
  summary <- reactive({
    selected() %>%
      count(age, sex, wt = weight) %>%
      left_join(population, by = c("age", "sex")) %>%
      mutate(rate = n / population * 1e4)
  })
  
  output$age_sex <- renderPlot({
    if (input$y == "count") {
      summary() %>%
        ggplot(aes(age, n, colour = sex)) +
        geom_line() +
        labs(y = "Estimated number of injuries")
    } else {
      summary() %>%
        ggplot(aes(age, rate, colour = sex)) +
        geom_line(na.rm = TRUE) +
        labs(y = "Injuries per 10,000 people")
    }
  }, res = 96)
  
}

# Run the application 
shinyApp(ui = ui, server = server)
