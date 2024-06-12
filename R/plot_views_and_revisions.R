plot_views_and_revisions=function(flood_id){
  tib1=wp_views %>% 
    filter(flood==flood_id) %>% 
    arrange(lang,month) %>% 
    mutate(type="views",
           info=as.character(nviews)) %>% 
    select(time=month,
           y=nviews,
           lang,
           info,
           type) %>% 
    mutate(y=round(y/max(y,na.rm=TRUE)*100,2))
  tib2=wp_revisions %>% 
    dplyr::filter(flood==flood_id) %>% 
    dplyr::arrange(lang,timestamp) %>% 
    dplyr::mutate(info=glue::glue("{user_name} {comment}")) %>% 
    select(time=timestamp,
           y=size,
           lang,
           info=info) %>% 
    mutate(type="edits") %>% 
    mutate(y=round(y/max(y,na.rm=TRUE)*100,2))
  tib=bind_rows(tib1,tib2)
  ggplot(tib, aes(x=time, y=y,col=type))+
    facet_grid(rows=vars(lang))+
    geom_path()+
    geom_point()+
    theme(legend.position=("none"))+
    scale_y_continuous(limits=c(0,max(tib$y)))+
    scale_color_manual(values=c("#A9A9A9","#0C57A8"))
}
