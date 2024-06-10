plot_lengths=function(flood_id){
  tib_lengths=wp_segments %>% 
    filter(flood==flood_id) %>% 
    group_by(lang,local) %>%
    tally()
  p=ggplot(tib_lengths,aes(x=1,y=n,fill=local))+
    geom_col()+
    facet_grid(rows=vars(lang))+
    theme(#axis.text.x = element_blank(),
          #axis.ticks.x = element_blank(),
          legend.position="none")+
    xlab(" ")+
    scale_x_continuous(breaks=1,labels=" ")
  p
}
