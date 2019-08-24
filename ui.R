#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(tagList(
    #shinythemes::themeSelector(),
    navbarPage(
        theme = shinythemes::shinytheme("journal"),  
        "MangasR",
        tabPanel("Ferramenta",
                 sidebarPanel(
                     uiOutput("options"),
                     div(actionButton("Submit", label = "Confirmar", icon("fas fa-robot"), 
                                      class = "btn-primary"), style="text-align:right;"),
                     HTML("<b>Mini-dica</b>:"),
                     helpText(
                         "Se a tarefa estiver muito cansativa/chata, você pode deixar
                     de marcar a qualquer momento e poderá sair do site e retornar
                     mais tarde caso deseje continuar a marcação se ainda houverem
                     faces disponíveis."),
                     div(img(src = "konata.gif", width="100%"), style="text-align: center;")
                 ),
                 mainPanel(
                     "This panel is intentionally left blank",
                     div(plotOutput("showCurrentFace", height = "300px"), align = "center")
                 )
        ),
        tabPanel("Sobre", includeMarkdown("www/about.md")),
        tabPanel("Ajuda", includeMarkdown("www/help.md")))
))