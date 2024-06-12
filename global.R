library(shiny)
library(tidyverse)
library(sf)
library(leaflet)
library(plotly)
library(cowplot)
col_WD="#e82a8e"
col_DFO="#607d73"
mymax=function(x){
  if(is.null(x)|all(is.na(x))){return(NA)}
  return(max(x,na.rm=TRUE))
}
datapath="data"
countries_raw=readRDS(glue::glue("{datapath}/countries.RDS"))
countries=countries_raw %>% select(country,country_label,coords_country,HDI) %>% unique()
languages=countries_raw %>% select(language,language_code,lang_type,country,country_label) %>% unique()
  
wp_pages=readRDS(glue::glue("{datapath}/wp_pages_curation.RDS")) %>% 
  select(-text,-title)
wd_events=readRDS(glue::glue("{datapath}/wd_events.RDS")) %>% 
  left_join(wp_pages %>% select(flood,curation),
            relationship = "many-to-many",by="flood") %>% 
  group_by(flood) %>% 
  mutate(curation=mymax(curation)) %>% 
  ungroup() %>%
  unique()
wp_views=readRDS(glue::glue("{datapath}/wp_views.RDS"))

wp_segments=readRDS(glue::glue("{datapath}/wp_segments.RDS")) %>%  
  left_join(wp_pages %>% select(flood,article,lang,local),by="article",
            relationship="many-to-many")
wp_revisions=readRDS(glue::glue("{datapath}/wp_revisions.RDS")) %>% 
  left_join(wp_pages %>% select(flood,article,lang,local),by="article",
            relationship="many-to-many") %>%  
  mutate(timestamp=lubridate::ymd_hms(timestamp))


wm_map=readRDS(glue::glue("{datapath}/wm_map.RDS"))
complete_map=wm_map %>% 
  st_drop_geometry() %>% 
  left_join(wp_pages,by="flood") %>% 
  group_by(flood) %>% 
  summarise(curation=mymax(curation))
wm_map=left_join(wm_map,complete_map,by="flood")
tib_classes=wp_segments %>%
  select(class,class_name,color) %>%
  unique()

plot_classes=ggplot(wp_segments %>% group_by(class_name) %>% tally(),
       aes(x=class_name,y=n,fill=class_name))+
       geom_col()+
       theme_minimal()+
       scale_fill_manual(breaks=tib_classes$class_name, values=tib_classes$color)
legend_class_name=ggdraw(cowplot::get_legend(plot_classes))

plot_local=ggplot(wp_pages,
                  aes(x=local,fill=local))+
  geom_bar()+
  theme_minimal()+
  scale_fill_manual(values=c(col_DFO,col_WD))
legend_local=ggdraw(cowplot::get_legend(plot_local))

