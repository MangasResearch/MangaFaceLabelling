library(tibble)

# connect to the database
conn <- DBI::dbConnect(RPostgres::Postgres(), 
                 dbname = Sys.getenv("DBNAME"),
                 host = Sys.getenv("HOST"), 
                 port = Sys.getenv("PORT"),
                 user = Sys.getenv("USERNAME"), 
                 password = Sys.getenv("PASSWORD"))

# create our dataset table with an appropriate 
# SERIAL data type for the primary key.
create_table <- "
CREATE TABLE dataset(
  id SERIAL PRIMARY KEY,
  ref text NOT NULL,
  label integer,
  busy boolean NOT NULL,
  marked boolean NOT NULL
);"

DBI::dbExecute(conn, create_table)
           
# made up data
df <- tibble(ref=f)
df$label <- rep(0, nrow(df))
df[, c("busy", "marked")] <- rep(FALSE, nrow(df))

# write data frame to database
DBI::dbWriteTable(conn, "dataset", df, append=TRUE, row.names=FALSE)




  
