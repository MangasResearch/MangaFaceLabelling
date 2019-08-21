library(data.table)
label <- "hap"

data_faces <- data.table(path=character(), label=numeric(), marked=logical(), manga=character())
manga_state <- data.table(busy=vector(length = 109), complete=vector(length = 109))

init <- function(){
  for(i in 1:nrow(manga_state)) {
    row <- manga_state[i,]
    if(row$complete == FALSE){
      if(row$busy == FALSE){
        manga_state[i,"busy"] <<- TRUE
        saveRDS(manga_state,"manga_state")
      }
    }
  }
}
get_image <- function(){
  if(label == "hap")
  {
    current_image <- "www/dataset/img1.jpg"
    label <<- "sad"
  }
  else if(label == "sad")
    current_image <- "www/dataset/img2.jpg"
  else
    current_image <- "www/dataset/img3.jpg"
  
  return(current_image)
}

get_prelabel <- function(){
 
  return(label) 
}
set_label <- function(current_image, my_label){
  label <<- my_label
  print(paste("Imagem atual dentro do set_label:",current_image))
  print(paste("label atual dentro do set_label:",my_label))
}