#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(markdown)

# Define UI for application that draws a histogram
shinyUI(tagList(
    #shinythemes::themeSelector(),
    navbarPage(
        theme = shinythemes::shinytheme("journal"),  
        "MangasR",
        tabPanel("Ferramenta",
                 tags$head(tags$style(type="text/css", ".container-fluid {max-width: 90%;}")),
                 sidebarPanel(
                     uiOutput("options"),
                     div(actionButton("Submit", label = "Confirmar", icon("fas fa-robot"), 
                                      class = "btn-primary"), style="text-align:right;")
                 ),
                 mainPanel(
                     div(plotOutput("showCurrentFace", height = "300px"), align = "center")
                 )
        ),
        tabPanel("Sobre", 
                 sidebarPanel(
                     #div(img(src = "suzumiya.gif", width="100%"), style="text-align: center;"),
                     HTML("<b>Mini-dica</b>:"),
                     br(),
                     br(),
                    "Se a tarefa estiver muito cansativa/chata, você pode deixar
                     de marcar a qualquer momento e poderá sair do site e retornar
                     mais tarde caso deseje continuar a marcação se ainda houverem
                     faces disponíveis.",
                     br(),
                     br(),
                     br(),
                     br(),
                     div(img(src = "konata.gif", width="100%"), style="text-align: center;")
                 ),
                 mainPanel(
                 includeMarkdown("www/about.md")
                 )
        ),
        tabPanel("Ajuda", includeMarkdown("www/help.md")))
))