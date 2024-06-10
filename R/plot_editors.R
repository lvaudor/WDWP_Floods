plot_editors=function(flood_id, metric="delta"){
  tib=wp_revisions %>% 
    filter(flood==flood_id) %>% 
    group_by(user_name,lang) %>% 
    summarise(delta=sum(delta),
              nedits=n(),
              .groups="drop") %>% 
    mutate(metric=!!sym(metric))
  p=ggplot(tib, aes(x=user_name,y=metric))+
    geom_col()+
    coord_flip()+
    facet_grid(rows=vars(lang), scales="free_y")
  return(p)
}