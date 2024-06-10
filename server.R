#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
function(input, output, session) {
  
    nlangs=reactive({
      wp_pages %>%
        filter(flood==input$flood) %>% 
        pull(lang) %>%
        unique() %>% 
        length()
    })
    output$flood_info=renderUI({
      tib_flood=wd_events %>%
        filter(flood==input$flood) 
      tib_country=countries %>% filter(country %in% tib_flood$country) %>% 
        mutate(country=purrr::map2_chr(country,HDI,
                                       ~paste0(.x," (",.y,")"))) %>% 
        mutate(language=purrr::map2_chr(language,language_code,
                                        ~paste0(.x," (",.y,")"))) %>% 
        summarise(country=paste0(unique(country_label),collapse=", "),
                  language=paste0(unique(language),collapse=", "))
      tagList(
        HTML(glue::glue("<b>Label:</b> {unique(tib_flood$flood_label)}<br>")),
        HTML(glue::glue("<b>Date:</b> {unique(tib_flood$date)}<br>")),
        HTML(glue::glue("<b>Country:</b> {tib_country$country}<br>")),
        HTML(glue::glue("<b>Local language:</b> {tib_country$language} <br>"))
      )        
    })
    #####################################
    output$legend_class_name=renderPlot({
      plot(legend_class_name)
    },width=100,height=140)
    output$classif=renderPlotly({
      p=plot_segment_class(input$flood)
      ggplotly(p,
               height=100+nlangs()*100)
    })
    ##############################
    output$legend_local=renderPlot({
      plot(legend_local)
    },width=100,height=140)
    output$lengths=renderPlotly({
      p=plot_lengths(input$flood)
      ggplotly(p,
               height=100+nlangs()*100)
    })
    output$articles_history=renderPlotly({
      p=plot_history_revisions(input$flood)
      ggplotly(p,
               height=100+nlangs()*100)
    })
    output$views_history=renderPlotly({
      p=plot_history_views(input$flood)
      ggplotly(p,
               height=100+nlangs()*100)
    })
    output$global_table <- DT::renderDataTable({
      tablename=stringr::str_replace(input$global_table,"^..","")
      print(tablename)
      table=get(tablename)
      result=prepare_table(table)
      result
    })
    output$event_table <- DT::renderDataTable({
      tablename=stringr::str_replace(input$event_table,"^..","")
      print(tablename)
      table=get(tablename) %>% 
        filter(flood==input$flood)
      if("textt" %in% colnames(table)){
        if(!input$show_textt){
          table=table %>% select(-textt)
        }
      }
      result=prepare_table(table)
      result
    })
    output$curation=renderPlotly({
      p=plot_curation(input$flood)
      ggplotly(p,
               height=100+nlangs()*100)
    })
    output$editors=renderPlotly({
      p=plot_editors(input$flood,input$editors_metric)
      ggplotly(p,
               height=100+nlangs()*100)
    })
    ##########################
    output$map =renderLeaflet({
      # Création de la carte 
      wm_map=wm_map %>% 
        mutate(size=!!sym(input$marker_size))
      if(input$marker_size=="deathtoll"){wm_map=wm_map %>% mutate(size=log(size+1))}
      if(input$marker_size=="curation"){wm_map=wm_map %>% mutate(size=(size+1)*5)}
      leaf_wm_map=leaflet(wm_map) %>% # déf carte 
        addProviderTiles(providers$Esri.WorldTopoMap) %>% # ajout fond de carte
        addCircleMarkers(col=~color,
                         radius =~size,
                         layerId=~flood)
    })
      
     observeEvent(input$map_click, {
      click <- input$map_click
      print(click)

      if (!is.null(click)) {
        clicked_point <- st_sf(geometry = st_sfc(st_point(c(click$lng, click$lat))), crs = 4326)
        ind=which.min(st_distance(wm_map,clicked_point))
      }
      print(wm_map$flood[ind])
      updateSelectInput(session,"flood",selected=wm_map$flood[ind])
      leafletProxy("map") %>%
        clearGroup("selected_circle") %>%
        addCircleMarkers(data=wm_map %>% filter(flood==wm_map$flood[ind]), 
                         color="black",
                         group="selected_circle") 
      
      # leafletProxy("map") %>% 
      #   removeShape(layerId="selected_circle") %>% 
      #   addCircleMarkers(data=wm_map %>% filter(flood==wm_map$flood[ind]), 
      #                    color="red",
      #                    layerId="selected_circle")
      }
    
    )
}
