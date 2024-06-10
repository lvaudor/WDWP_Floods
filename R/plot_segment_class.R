plot_segment_class=function(flood_id){
  tib=wp_segments %>% 
    filter(flood==flood_id) %>% 
    group_by(class,class_name,lang) %>% 
    tally() %>% 
    mutate(class=stringr::str_replace(class,"class_",""))
  my_plot=ggplot(tib,aes(x=class,y=n,fill=class_name))+
    geom_col()+
    scale_fill_manual(breaks=tib_classes$class_name, values=tib_classes$color)+
    theme(#axis.text.x = element_blank(),
          #axis.ticks.x = element_blank(),
          legend.position="none")+
    #xlab("")+
    ylab("n_segments")+
    facet_grid(rows=vars(lang))
  my_plot
}
