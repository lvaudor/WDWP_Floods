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
  
    r_flood_selected=reactive({
      id=wd_events$flood[input$global_table_rows_selected]
      if(is.null(input$global_table_rows_selected)){id="wd:Q14628797"}
      print(id)
      id
    })
  
    nlangs=reactive({
      wp_pages %>%
        filter(flood==r_flood_selected()) %>% 
        pull(lang) %>%
        unique() %>% 
        length()
    })
    output$flood_info=renderUI({
      tib_flood=wd_events %>%
        filter(flood==r_flood_selected()) 
      tib_country=countries %>% filter(country %in% tib_flood$country) %>% 
        mutate(country=purrr::map2_chr(country,HDI,
                                       ~paste0(.x," (",.y,")"))) %>% 
        summarise(country=paste0(unique(country_label),collapse=", "))
      result=fluidRow(column(width=6,
                      HTML(paste0("📍 You have selected the event <b>",r_flood_selected(),"</b>"))
                      ),
                      column(width=6,
                             HTML(glue::glue("<b>Label:</b> {unique(tib_flood$flood_label)}<br>")),
                             HTML(glue::glue("<b>Date:</b> {unique(tib_flood$date)}<br>")),
                             HTML(glue::glue("<b>Country:</b> {tib_country$country}<br>"))
                             )
      )        
    })
    #####################################
    output$legend_class_name=renderPlot({
      plot(legend_class_name)
    },width=100,height=140)
    output$classif=renderPlotly({
      p=plot_segment_class(r_flood_selected())
      ggplotly(p,
               height=100+nlangs()*100)
    })
    ##############################
    output$legend_local=renderPlot({
      plot(legend_local)
    },width=100,height=140)
    output$lengths=renderPlotly({
      p=plot_lengths(r_flood_selected())
      ggplotly(p,
               height=100+nlangs()*100)
    })
    output$views_and_revisions=renderPlotly({
      p=plot_views_and_revisions(r_flood_selected())
      ggplotly(p,
               height=100+nlangs()*100)
    })
    output$global_table <- DT::renderDT({
      table=wd_events
      result=prepare_table(table,selection="single")
      result
    })
    output$event_table <- DT::renderDT({
      tablename=stringr::str_replace(input$event_table,"^..","")
      table=get(tablename) %>% 
        filter(flood==r_flood_selected()) %>% 
        select(-flood)
      if("textt" %in% colnames(table)){
        if(!input$show_textt){
          table=table %>% select(-textt)
        }
      }
      result=prepare_table(table)
      result
      })
    output$add_table <- DT::renderDT({
      tablename=stringr::str_replace(input$add_table,"^..","")
      table=get(tablename)
      result=prepare_table(table)
      result
    })
    output$curation=renderPlotly({
      p=plot_curation(r_flood_selected())
      ggplotly(p,
               height=100+nlangs()*100)
    })
    output$editors=renderPlotly({
      p=plot_editors(r_flood_selected(),input$editors_metric)
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
