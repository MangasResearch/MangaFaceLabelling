#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(imager)
source("dataset.R")

# Conecta ao banco de dados no início da seção
#conn <- load_bd_connection()

# Definir tabela inicial
index <- 1
tbl <- get_table()

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    values <- reactiveValues(index=1, tbl = get_table(),
                             current_row = get_row(tbl, index))
    
    
    # Desconectar BD no fim da seção
    cancel.onSessionEnded <- session$onSessionEnded(function() {
        print("desconectando BD")
        #on.exit(dbDisconnect(conn), add = TRUE)
    })
    
    # Atualizar opções mostradas na tela
    output$options <- renderUI({
        radioButtons("expr", "Selecione a opção que define melhor a face mostrada ao lado:",
                     c("Não é face" = 0,
                       "Felicidade" = 1,
                       "Raiva" = 2,
                       "Seriedade" = 3,
                       "Surpresa" = 4,
                       "Medo" = 5,
                       "Nojo" = 6,
                       "Tristeza" = 7,
                       "Timidez" = 8), selected = values$current_row$label)
    })
    
    # Carregar imagem na GUI.    
    output$showCurrentFace <- renderPlot({
        print(values$current_row$ref)
        img <- load.image(values$current_row$ref)
        plot(img, axes=FALSE)
    }, height = 400)
    
    # Receber opção selecionada pelo usuário
    observeEvent(input$Submit, {
        # Atualizar dataframe
        print(paste("Opção selecionada:",input$expr))
        values$tbl$label[values$index] <- input$expr
        # Obter próxima linha da tabela
        values$index <- values$index + 1
        if (values$index < 5)
            values$current_row <- get_row(values$tbl, values$index)
    })
    
    # Destruir botão de confirmar se condição é verdadeira
    observeEvent(input$Submit, {
        if (values$index == 5){
            print("Destruindo botão")
            removeUI(selector='#Submit', immediate=TRUE)
            values$index <- 4
        }
    }, autoDestroy=TRUE)
    
})