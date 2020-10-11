#if(!require(pacman)){install.packages("pacman")}
#library(pacman)
library(shiny)
library(data.table)
library(dplyr)

utilization <- fread("utilization_table.csv")
hops <- fread("hops_alphas.csv")


ui <- fluidPage(
  titlePanel("Rain's Out, Grains Out"),
  
  navbarPage("",
    tabPanel("Brew Day",
      wellPanel(
        textInput("Recipe",
                  label = "Recipe",
                  value = ""),
        numericInput("vol",
                     label = "Batch Size (gal)",
                     value = ""),
        numericInput("lbs",
                   label = "Pounds of Grain",
                   value = ""),
        sliderInput("temp",
                   label = "Mash Temperature",
                   min = 145,
                   max = 165,
                   value = c(145,165)),
        textOutput("recipe_name"),
        h3(textOutput("strike_vol")),
        h3(textOutput("strike_temp"))
    )),
    tabPanel("Bottling Day",
      wellPanel(
        numericInput("gi",
                     label = "Initial Gravity Reading",
                     value = 1.07),
        numericInput("gf",
                     label = "Final Gravity Reading",
                     value = ""),
        div(style = "display: inline-block; vertical-align:top",selectInput("hop1",
                      label = "First Hop Addition",
                      choices = hops$Hops,
                      selected = "Amarillo")),
        div(style = "display: inline-block; vertical-align:top",numericInput("oz",
                       "Ounces",
                       value = 5)),
        div(style = "display: inline-block; vertical-align:top",numericInput("boil",
                       "Boil Time",
                       value = 60)),
        br(),
        
        div(style = "display: inline-block; vertical-align:top",selectInput("hop2",
                      label = "Second Hop Addition",
                      choices = hops$Hops,
                      selected = "Amarillo")),
        div(style = "display: inline-block; vertical-align:top", numericInput("oz2",
                       "Ounces",
                       value = 5)),
        div(style = "display: inline-block; vertical-align:top",numericInput("boil2",
                       "Boil Time",
                       value = 60)),
        h3(textOutput("abv")),
        h3(textOutput("ibu"))
        )
		)
)
)
  
server <- function(input, output) {
  
  output$strike_vol <- renderText({
    paste("Strike Water Volume:", input$lbs * .1 + input$vol + 1, "Gallons")
  })
  output$strike_temp <- renderText({
    paste("Strike Water Temperature:", min(input$temp + 8), "to", max(input$temp + 12), "Fahrenheit")
  })
  output$abv <- renderText({
    paste("ABV:", 133 * (input$gi - input$gf) / input$gf, "%")
  }) 
  output$ibu <- renderText({
    
    u1 <- utilization %>% filter(`Gravity vs. Time` == input$boil) %>% select(as.character(input$gi)) %>% as.numeric()
    u2 <- utilization %>% filter(`Gravity vs. Time` == input$boil2) %>% select(as.character(input$gi)) %>% as.numeric()
    
    aau1 <- as.numeric(hops$`Average Alpha Acids`[which(hops$Hops == input$hop1)]) * input$oz
    aau2 <- as.numeric(hops$`Average Alpha Acids`[which(hops$Hops == input$hop2)]) * input$oz2
    
    ibu1 <- u1 * aau1 * 75 / input$vol
    ibu2 <- u2 * aau2 * 75 / input$vol
    
    ibu <- ibu1 + ibu2
    
    paste("IBU:", ibu)
  })
}

shinyApp(ui, server)

#http://howtobrew.com/book/section-1/hops/hop-bittering-calculations
#https://www.homebrewersassociation.org/how-to-brew/how-many-calories-are-in-beer/

#Notes: make word cloud background image
#Make report exportable and editable
