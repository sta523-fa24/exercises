library(shiny)
library(tidyverse)

ui = fluidPage(
  title = "Beta-Binomial",
  titlePanel("Beta-Binomial Visualizer"),
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      h4("Data:"),
      sliderInput(
        inputId = "x", label = "# of heads",
        min = 0, max = 100, value = 7  
      ),
      sliderInput(
        inputId = "n", label = "# of flips",
        min = 0, max = 100, value = 10  
      ),
      h4("Prior:"),
      numericInput(
        inputId = "a", label = "Prior # of heads",
        min=0, value=5
      ),
      numericInput(
        inputId = "b", label = "Prior # of tails",
        min=0, value=5
      )
    ),
    mainPanel = mainPanel(
      plotOutput(outputId = "plot"),
      tableOutput(outputId = "table")
    )
  )
)

server = function(input, output, session) {
  
  observe({
    updateSliderInput(inputId = "x", max = input$n)
  })
  
  d = reactive({
    validate(
      need(input$a >= 0, "Number of prior heads needs to be 0 or greater"),
      need(input$b >= 0, "Number of prior tails needs to be 0 or greater")
    )
    
    
    
    output$plot = renderPlot({
      ggplot(d(), aes(x=p, y=density, color = distribution)) +
        geom_line(size=1.5)
    })
    
    output$table = renderTable({
      d() |>
        group_by(distribution) |>
        summarize(
          mean = sum(p*density) / n(),
          median = p[(cumsum(density/n())) >= 0.5][1],
          q025 = p[(cumsum(density/n())) >= 0.025][1],
          q975 = p[(cumsum(density/n())) >= 0.975][1],
        )
    })
    
    d = tibble(
      p = seq(0, 1, length.out = 1001) 
    ) |>
      mutate(
        prior = dbeta(p, input$a, input$b),
        likelihood = dbinom(x = input$x, size = input$n, prob = p) |>
          (\(x) {x/ (sum(x) / n())})(),
        posterior = dbeta(p, input$x + input$a, input$n - input$x + input$b)
      ) |>
      pivot_longer(
        cols = -p,
        names_to = "distribution", values_to = "density"
      ) |>
      mutate(
        distribution = forcats::as_factor(distribution)
      )
    
    print(d)
    
    d
  })
  
}

shinyApp(ui = ui, server = server)
