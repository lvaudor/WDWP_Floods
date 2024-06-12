plot_curation=function(flood_id){
  tib=wp_pages %>% 
    filter(flood==flood_id)
  ggplot(tib,aes(x=1,y=curation, col=local))+
    facet_grid(rows=vars(lang))+
    geom_vline(aes(xintercept=1),alpha=0.5)+
    geom_point()+
    scale_y_continuous(limits=c(-1,1), breaks=c(-1,0,1))+
    scale_x_continuous(breaks=1,labels=" ")+
    xlab(" ")+
    theme(legend.position="none")+
    scale_color_manual(values=c(col_DFO,col_WD))
}
