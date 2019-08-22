library(DBI)

label <- "hap"

#Conectar BD
load_bd_connection <- function(){
  DBI::dbConnect(RPostgres::Postgres(), 
                 dbname = "",
                 host = "", 
                 port = "",
                 user = "", 
                 password = "")
}

init <- function(conn){
  
  query <- "
    WITH subquery AS (
       SELECT * FROM dataset WHERE MARKED = False LIMIT  2
    )
    UPDATE dataset
    SET busy=TRUE
    FROM subquery
    WHERE dataset.id=subquery.id
    RETURNING dataset.*;
    "
    # Começar transação
    dbBegin(conn)
    dbExecute(conn, "LOCK TABLE dataset IN ACCESS EXCLUSIVE MODE;")
    tbl <- dbGetQuery(conn, query)
    # Dar commit na transação
    dbCommit(conn)
    
    return(tbl)
}


# Atualizar banco de dados com um dataframe
# https://stackoverflow.com/questions/20546468/how-to-pass-data-frame-for-update-with-r-dbi
update_changes <- function(conn, df){
  
}

## conectar banco de dados
# conn <- load_bd_connection()
## carregar tabela com faces não marcadas
# table_user <- init(conn)


get_image <- function(){
  if(label == "hap")
    current_image <- "www/dataset/img1.jpg"
  else if(label == "sad")
    current_image <- "www/dataset/img2.jpg"
  else
    current_image <- "www/dataset/img3.jpg"
  
  return(current_image)
}

get_prelabel <- function(){
 
  return("sad") 
}
set_label <- function(current_image, my_label){
  label <<- my_label
  print(paste("Imagem atual dentro do set_label:",current_image))
  print(paste("label atual dentro do set_label:",my_label))
}