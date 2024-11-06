library(shiny)
library(tidyverse)

palette = c(Green = "#7fc97f", Purple = "#beaed4", Orange = "#dfc086")

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
      ),
      h4("Options:"),
      checkboxInput(inputId = "options", label = "Show options", value = FALSE),
      conditionalPanel(
        "input.options == true",
        selectInput(
          inputId = "prior", label = "Color of prior distribution", 
          choices = palette, selected = palette[1]
        ),
        selectInput(
          inputId = "likelihood", label = "Color of likelihood distribution", 
          choices = palette, selected = palette[2]
        ),
        selectInput(
          inputId = "posterior", label = "Color of posterior distribution", 
          choices = palette, selected = palette[3]
        )
      )

    ),
    mainPanel = mainPanel(
      plotOutput(outputId = "plot"),
      tableOutput(outputId = "table")
    )
  )
)

server = function(input, output, session) {
  
  observe({ # Selected a new prior color
    choices = c(input$prior, input$likelihood, input$posterior)
    if (input$prior == input$likelihood) {
      updateSelectInput(inputId = "likelihood", select = setdiff(palette, choices))
    } else if (input$prior == input$posterior) {
      updateSelectInput(inputId = "posterior", select = setdiff(palette, choices))
    }
  }) |>
    bindEvent(input$prior)
  
  
  observe({ # Selected a new likelihood color
    choices = c(input$prior, input$likelihood, input$posterior)
    if (input$prior == input$likelihood) {
      updateSelectInput(inputId = "prior", select = setdiff(palette, choices))
    } else if (input$likelihood == input$posterior) {
      updateSelectInput(inputId = "posterior", select = setdiff(palette, choices))
    }
  }) |>
    bindEvent(input$likelihood)
  
  observe({ # Selected a new posterior color
    choices = c(input$prior, input$likelihood, input$posterior)
    if (input$posterior == input$likelihood) {
      updateSelectInput(inputId = "likelihood", select = setdiff(palette, choices))
    } else if (input$prior == input$posterior) {
      updateSelectInput(inputId = "prior", select = setdiff(palette, choices))
    }
  }) |>
    bindEvent(input$posterior)
  
  
  observe({
    updateSliderInput(inputId = "x", max = input$n)
  })
  
  d = reactive({
    validate(
      need(input$a >= 0, "Number of prior heads needs to be 0 or greater"),
      need(input$b >= 0, "Number of prior tails needs to be 0 or greater")
    )
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
    
    #print(d)
    
    d
  })
  
  output$plot = renderPlot({
    
    choices = c(input$prior, input$likelihood, input$posterior)
    
    ggplot(d(), aes(x=p, y=density, color = distribution)) +
      geom_line(size=1.5) +
      geom_ribbon(aes(ymax=density, fill=distribution), ymin=0, alpha=0.5) +
      scale_color_manual(values = choices) +
      scale_fill_manual(values = choices)
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
  
  
  
}

shinyApp(ui = ui, server = server)
