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
library(glue)
source("dataset.R")

# A read-only data set that will load once, when Shiny starts, and will be
# available to each user session
conn <- load_bd_connection()

shinyServer(function(input, output, session) {
    # Variáveis usadas pelas operações do shinyserver.
    values <- reactiveValues(current_image = get_image(), pre_label = get_prelabel(), 
                             username = "user-sama")
    
    onStop(function() cat("Session stopped\n"))
    
    # Desconectar BD no fim da seção
    cancel.onSessionEnded <- session$onSessionEnded(function() {
        print("desconectando BD")
        on.exit(dbDisconnect(conn), add = TRUE)
    })
    
    # Exibir o pop-up solicitando nome do usuário.
    shinyalert(
        title = "Como prefere ser chamado?", type = "input"
    )
    
    
    # Atualizar radioButton a ser mostrado na tela
    output$radioButton <- renderUI({
        div(
            radioButtons("expr", "Expressões:",
                         c("Felicidade" = "hap",
                           "Raiva" = "ang",
                           "Seriedade" = "ser",
                           "Surpresa" = "sur",
                           "Medo" = "fea",
                           "Nojo" = "dis",
                           "Tristeza" = "sad",
                           "Timidez" = "shy"), selected = values$pre_label, inline=T),
            style="text-align: center;")
    })
    
    # Capturar nome definido pelo usuário no shinyalert.
    observeEvent(input$shinyalert, {
        if(input$shinyalert != '')
            values$username <- input$shinyalert
        print(paste0("Seja bem vindo, ", values$username))
    })
    
    # output$tbl <- renderTable({
    #     dbReadTable(conn, "dataset")
    # })
    
    # Definir texto de ajuda para o usuário.
    output$helpText <- renderUI({
                helpText(glue("Olá, {values$username}, desejo boas vindas a ferramenta de ",
                              "marcação de faces de mangás. Como você já pode ter notado, ao lado ",
                              "há uma imagem e 7 opções. A tarefa pedida, é que você marque ",
                              "a emoção que mais se assemelhe a face mostrada. Quando você tiver ",
                              "certeza sobre a opção, você pode clicar no botão 'confirmar' que ",
                              "irá salvar sua escolha e te mostrará a próxima imagem. Se a tarefa ",
                              "estiver muito cansativa/chata, você pode deixar de marcar a qualquer ",
                              "momento. Então, {values$username}, simples, não?\n",
                              "Agradeço desde já por sua ajuda.")
                         )
            })
    
    # Carregar imagem na GUI.    
    output$showCurrentFace <- renderPlot({
        img <- load.image(values$current_image)
        #div(img(src = values$current_image, height = 200), style="text-align: center;")
        plot(img, axes=FALSE)
    }, height = 350)
    
    # Obter a imagem atual a ser exibida na GUI.
    selected <- eventReactive(input$Submit,{
        expr <- input$expr
        set_label(values$current_image, expr)
        values$current_image <- get_image()
        values$pre_label <- get_prelabel()
        return(expr)
    })
    
    observeEvent(input$Submit, {
        selected()
    })
    
    # Atualizar texto dos exemplos com o nome do usuário
    output$introExamples <- renderUI({
        p(glue("Olá, {values$username}, nesta seção, você pode encontrar alguns exemplos ",
        "de faces e suas expressões correspondentes."))
    })
    
})