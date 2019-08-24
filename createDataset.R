library(readr)

# connect to the database
conn <- load_bd_connection()

# create our mangas table with an appropriate 
# SERIAL data type for the primary key.
create_table <- "
CREATE TABLE mangas(
  id SERIAL PRIMARY KEY,
  ref text NOT NULL,
  label integer,
  busy boolean NOT NULL,
  marked boolean NOT NULL
);"

dbExecute(conn, create_table)
           
# made up data
df <- read_csv("ex.csv")
df[, c("busy", "marked")] <- rep(FALSE, nrow(df))

# write data frame to database
dbWriteTable(conn, "mangas", df, append=TRUE, row.names=FALSE)




  