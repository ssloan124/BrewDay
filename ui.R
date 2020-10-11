#if(!require(pacman)){install.packages("pacman")}
#library(pacman)
library(shiny)
library(data.table)
library(dplyr)
library(spotifyr)
library(wordcloud)

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
  
