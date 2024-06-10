plot_history_views=function(flood_id){
  tib1=wp_views %>% 
    filter(flood==flood_id) %>% 
    arrange(lang,month) %>% 
    mutate(type="views",
           info=as.character(nviews)) %>% 
    select(x=month,
           y=nviews,
           lang,
           info,
           type) %>% 
    mutate(y=y/max(y))
  tib2=wp_revisions %>% 
    dplyr::filter(flood==flood_id) %>% 
    dplyr::arrange(lang,timestamp) %>% 
    dplyr::mutate(info=glue::glue("{user_name} {comment}")) %>% 
    mutate(type="edits") %>% 
    select(x=timestamp,
           y=size,
           lang,
           info=info) %>% 
    mutate(y=y/max(y))
  tib=bind_rows(tib1,tib2)
  ggplot(tib, aes(x=x, y=y,col=type))+
    facet_grid(rows=vars(lang))+
    geom_path()+
    geom_point()+
    theme(legend.position=("none"))+
    scale_y_continuous(limits=c(0,max(tib$y)))
}
