#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(magick)
source("dataset.R")

# Conecta ao banco de dados no início da seção
conn <- init_bd_connection()

# Definir tabela inicial
index <- 1
data_faces <- request_bd(conn)
max_index <- nrow(data_faces)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    values <- reactiveValues(index=1, data = data_faces,
                             current_row = get_row(data_faces, index))
    
    #############################################################################
    # Botão de voltar
    observeEvent(input$Back, {
        if(values$index >= 2){
            values$index <- values$index - 1
            print(paste("Back-ID:", values$index))
            values$current_row <- get_row(values$data, values$index)
        }
    })
    
    # Receber opção selecionada pelo usuário
    observeEvent(input$Submit, {
        # Atualizar dataframe
        print(paste("Opção selecionada:",input$expr))
        values$data$label[values$index] <- input$expr
        values$data$marked[values$index] <- TRUE
        # Obter próxima linha da tabela
        values$index <- values$index + 1
        if (values$index <= max_index)
            values$current_row <- get_row(values$data, values$index)
        else{
            #atualizar Banco de dados
            print('update')
            update_db(conn, values$data)

            #requisitar novos dados
            print('new request!')
            values$data <- request_bd(conn)
            max_index <<- nrow(values$data)
            if(max_index != 0){
                values$index <- 1
                values$current_row <- get_row(values$data, values$index)
            }
        }
    })
    
    # Destruir botão de confirmar se condição é verdadeira
    observeEvent(input$Submit, {
        if (values$index > max_index | max_index == 0){
            print("Destruindo botão")
            removeUI(selector='#Submit', immediate=TRUE)
        }
    }, autoDestroy=TRUE)
        


    # Desconectar BD no fim da seção
    cancel.onSessionEnded <- session$onSessionEnded(function() {
        update_db(conn, values$data)        
        on.exit(dbDisconnect(conn), add = TRUE)
    })

   #############################################################################
    # Atualizar opções mostradas na tela
    output$options <- renderUI({
        div(
            HTML("<b>Selecione a opção que define melhor a face mostrada abaixo:</b>"),
            div(plotOutput("showCurrentFace", height = "100%"), align = "center"),
            fluidRow(
                   radioButtons("expr", "Opções:",
                                c("Não é face" = 0,
                                  "Não se sabe" = 1,
                                  "Felicidade/ Confiança" = 2,
                                  "Raiva/ Intimidação" = 3,
                                  "Seriedade/ Crítico" = 4,
                                  "Apreensão/ Nervosismo"= 5,
                                  "Sofrimento/ Depressão" = 6,
                                  "Nojo ou Desprezo" = 7,
                                  "Tristeza" = 8,
                                  "Timidez ou Vergonha" = 9,
                                  "Medo" = 10,
                                  "Surpresa" = 11,
                                  "Inconsciente/ Sono" = 12), selected = values$current_row$label)
            )
            
        )
    })


output$showCurrentFace <-  renderImage({
       outfile <- tempfile(fileext=".bmp")
       im <- image_read(values$current_row$ref)
       im <- image_scale(im, "x150")
       image_write(im, path = outfile, format = "bmp")
       list(src = outfile)
    }, deleteFile = TRUE)
})
