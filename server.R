#if(!require(pacman)){install.packages("pacman")}
#library(pacman)
library(shiny)
library(data.table)
library(dplyr)

utilization <- fread("utilization_table.csv")
hops <- fread("hops_alphas.csv")

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