plot_articles_history=function(flood_id){

    tib=filter(wp_revisions,flood==flood_id) %>% 
      mutate(timestamp=as.POSIXct(timestamp)) %>% 
      mutate(timestamp=lubridate::ymd(timestamp)) %>% 
      arrange(lang,timestamp)
    p=ggplot(tib,aes(x=timestamp,fill=local))+
      geom_histogram()+
      facet_grid(rows=vars(lang))
    p

}
