library(DBI)
library(tibble)

#Conectar BD
load_bd_connection <- function(){
  DBI::dbConnect(RPostgres::Postgres(), 
                 dbname = Sys.getenv("DBNAME"),
                 host = Sys.getenv("HOST"), 
                 port = Sys.getenv("PORT"),
                 user = Sys.getenv("USERNAME"), 
                 password = Sys.getenv("PASSWORD"))
}

init <- function(conn){
  
  query <- "
    WITH subquery AS (
       SELECT * FROM dataset WHERE MARKED = False LIMIT  10
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

get_table <- function(){
  df <- tibble(ref=c("www/dataset/img1.jpg", "www/dataset/img2.jpg", 
                     "www/dataset/img3.jpg", "www/dataset/rikka.png"), 
               label=sample(1:8, 4))
  return(df)
}

get_row <- function(df, ind){
  return(df[ind, ])
}


