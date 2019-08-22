#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyalert)
library(shinythemes)

shinyUI(fluidPage(
    
    theme = shinytheme("lumen"),
    
    # Mensagem de boas vindas solicitando nome do usuário
    useShinyalert(),
    
    # App title ----
    titlePanel("MangaFace Labelling Tool"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            h2("Seja bem-vindo(a)"),
            br(),
            # carregar texto de ajuda para o usuário ----
            uiOutput('helpText'),
            div(img(src = "rikka.gif", height = 200), style="text-align: center;"),
            br(),
            "Conto com a sua ajuda para essa missão, ",
            span("Jeca.", style = "color:blue")
        ),
        
        # Main panel for displaying outputs ----
        mainPanel(
            # Output: Tabset w/ plot, summary, and table ----
            tabsetPanel(type = "tabs",
                        tabPanel("Faces", 
                                  h2("Face atual"),
                                 # tableOutput("tbl"),
                                  p("Selecione a expressão abaixo que caracterize melhor a face mostrada:"),
                                  br(),
                                 div(plotOutput("showCurrentFace", height = "300px"), align = "center"), 
                                 #uiOutput(outputId = "showCurrentFace"),
                                  br(),
                                  uiOutput("radioButton"),
                                  div(actionButton("Submit", icon("fas fa-robot"), label="Confirmar"),style="text-align: center")
                        ),
                        tabPanel("Exemplos", 
                                  h2("Exemplos"),
                                  uiOutput("introExamples"),
                                 fluidRow(
                                     column(12, align="center",
                                            div(style="display: inline-block;",img(src="RisingGirl_204_3_9.0_426.0_325.0_641.0.jpg", height=200),
                                                p("Surpresa")
                                                ),
                                            div(style="display: inline-block;",img(src="PlatinumJungle_127_2_852.0_246.0_1168.0_614.0.jpg", height=200),
                                                p("Tristeza")
                                                )
                                            ),
                                      column(12, align="center",
                                             div(style="display: inline-block;",img(src="WarewareHaOniDearu_023_4_84_391_200_485.jpg", height=200),
                                                 p("Felicidade")
                                                 ),
                                             div(style="display: inline-block;",img(src="WarewareHaOniDearu_027_2_325_273_519_449.jpg", height=200),
                                                 p("Surpresa")
                                                 )
                                             )
                                 )
                        ) #Panel
            )
        ) # MainPanel
    )
))
