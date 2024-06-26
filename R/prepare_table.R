
prepare_table=function(table,selection="none"){
  table=unique(table)
  if("flood" %in% colnames(table)){
    table=table %>% 
      mutate(flood=linkify(url=flood,text=flood))
  } 
  if("article" %in% colnames(table)){
    table=table %>% 
      mutate(article=linkify(url=article))
  } 
  ind_large=which(colnames(table) %in% c("text","textt","flood_label"))
  result=DT::datatable(table,escape=FALSE,selection="single") %>%
         DT::formatStyle(columns =ind_large, width='600px') 
  return(result)
}