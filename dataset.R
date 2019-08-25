library(DBI)
library(glue)
library(tibble)

#Conectar BD
init_bd_connection <- function(){
  DBI::dbConnect(RPostgres::Postgres(), 
                 dbname = Sys.getenv("DBNAME"),
                 host = Sys.getenv("HOST"), 
                 port = Sys.getenv("PORT"),
                 user = Sys.getenv("USERNAME"), 
                 password = Sys.getenv("PASSWORD"))
}

request_bd <- function(conn){
  
  query <- "
    WITH subquery AS (
       SELECT * FROM dataset WHERE MARKED = False and BUSY = False LIMIT  5
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
update_db <- function(conn, df){
  df$busy <- FALSE
  queries <- glue("UPDATE dataset 
              SET label={df$label}, busy={df$busy}, marked={df$marked} 
              WHERE id={df$id};")
  # Enviar queries para o banco de dados
  #res <- purrr::map_int(queries, ~dbExecute(con, .x))
  res <- lapply(queries, function(x) dbExecute(conn, x))
  #update <- dbSendQuery(conn, 'update dataset set "label"=$2, "marked"=$3 WHERE "id"=$1')
  #dbBind(update, df)  # send the updated data
  #dbClearResult(update)  # release the prepared statement
}


get_row <- function(df, ind){
  return(df[ind, ])
}


