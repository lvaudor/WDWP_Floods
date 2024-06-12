#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


# Define UI for application that draws a histogram
fluidPage(
  tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
    ),

  p(),
  navlistPanel(HTML("<img src = 'WDWP_Floods.png', height = '100px',width='100px'>"),
  tabPanel("ℹ️ Info",
           h3("WPWD Floods app"),
           div(class="custom-well",
           wellPanel(
               HTML("The app lets users consult the information about <b>floods</b> collected from <b>Wikidata</b> and <b>Wikipedia</b>."),
               HTML("<li>regarding <b>all events</b> (Wikidata events description) in order to <i>🎯 Pick an event</i></li>"),
               HTML("<li>regarding <b>one event</b> of your choice (Wikipedia articles description) in order to <i>🔎 View the pages</i>' general characteristics, revisions and views information </li>")
           )),
           fluidRow(
             column(width=1,
                    img(src='github-mark.png',  height="50px", width="50px", align = "right")),
             column(width=5,  
                    p("App development and maintenance: L. Vaudor"),
                    HTML("The code for the app is available online on github and the data on [complete here]"),
                    HTML("<a src='https://github.com/lvaudor/WDWP_Floods'>🔗 Link to github repository </a>")
                   ),
             column(width=6,
                    p("This app documents the Wikidata-Wikipedia dataset about floods used in the article:"),
                    HTML("<i>Online reports and narrations of flood events worldwide</i>,
                         Vaudor L., Bajemon L., Genouel M., Piégay H., Montagne D., [journal, issue, year]")
            )),

           
           
           

  ),#tabPanel
  tabPanel("🎯 Pick event",
      div(class="custom-well",
         wellPanel(
            HTML("You can examine <b>all Wikidata events</b> either through the associated interactive <b>table</b> 🗃 or <b>map</b> 🌍. 
                  Pick one event you want to examine further (by <b>clicking line</b> in table or <b>clicking point</b> on map)
                 and go to tab <b>🔎 View pages</b>)")
      )),
      tabsetPanel(
           tabPanel("🗃  Based on Data Tables",
               DT::DTOutput("global_table")
           ),
           tabPanel("🌍 Based on map",
                 fluidRow(
                 column(width=3,
                        radioButtons("marker_size",
                                     "The size of the circles on the map should correspond to:",
                                     c("deathtoll",
                                       "curation"),
                                     selected="deathtoll")
                 ),
                 column(width=9,
                        leafletOutput("map"))
           )#fluidRow
           )#tabPanel based on map
     )#tabsetPanel based on data or map
  ),#tabPanel
 tabPanel("🔎 View pages",
          div(class="custom-well",
              wellPanel(
                uiOutput("flood_info")
              )),
      tabsetPanel(
        tabPanel("🗃 See Data Tables",
             fluidRow(
                column(width=4,
                      selectInput("event_table",
                                  "table",
                                  choices=c("📰 wp_pages",
                                            "🖊 wp_revisions",
                                            "👀 wp_views",
                                            "💬 wp_segments"),
                                  selected="📰 wp_pages")
                      ),
                 column(width=8,
                   conditionalPanel(condition="input.event_table=='📰 wp_pages'",
                       div(class="custom-well",
                           wellPanel(
                              HTML("You can <b>consult the Wikipedia pages</b> by clicking on 🔗 
                                   or add to the table a <b>column with raw text</b> (translated to English) by clicking below"),
                              checkboxInput("show_textt",
                                                "show translated text",
                                                value=FALSE),
                          ))
                   )#conditionalPanel 
                 ),#column
        ),#fluidRow
                 DT::DTOutput("event_table")
        ),#tabPanel Per event Tabels
        tabPanel("📊 See Plots", 
                 div(class="custom-well",
                     wellPanel(
                       fluidRow(
                         column(width=6,
                                HTML("Event-related <b>Wikipedia pages</b> (top-to-bottom) <b>characteristics</b> (left-to-right): 
                           <ul><li>a) <b>Length</b>: total number of text segments (locality as color)</li>
                               <li>b) <b><span style='color: #6b7edd;'>T</span>
                                         <span style='color: #5f2ad3;'>o</span>
                                         <span style='color: #e14774;'>p</span>
                                         <span style='color: #ff4646;'>i</span>
                                         <span style='color: #16968d;'>c</span>
                                         <span style='color: #ffc847;'>s</span>
                                      </b> number of text segments falling into each topic</li>
                               <li>c) <b><span style='color: #0C57A8;'>Views</span> and <span style='color: #A9A9A9;'>Edits</span> history</b>: 
                               <b>monthly views</b> (relative to maximum monthly views for this event -%-)
                               and </b>successive edits</b> through time and <b>resulting page size</b>
                               (relative to maximum page size for this event -%-)</li>
                               <li>d) <b>Curation</b></li>")
                         ),
                         column(width=1,offset=1,
                                div(class = "limited-height",plotOutput("legend_local"))),
                         column(width=1,offset=1,
                                div(class = "limited-height",plotOutput("legend_class_name")))
                       )

                 )),
                 fluidRow(
                   column(width=2,
                          h3("a"),
                          plotlyOutput("lengths")),
                   column(width=3,
                          h3("b"),
                          plotlyOutput("classif")),
                   column(width=6,
                          h3("c"),
                          plotlyOutput("views_and_revisions")),
                   column(width=1,
                          h3("d"),
                          plotlyOutput("curation"))
                 )#fluidRow
        ),#tabPanel Plots
  )#tabsetPanel
  ),# tabPanel per event
  tabPanel("🗄️ Additional",
           div(class="custom-well",
               wellPanel("Here are the complementary tables relative to countries characteristics 🏳 and languages 🈯")
           ),
           selectInput("add_table",
                       "table",
                       choices=c("🏳 countries",
                                 "🈯 languages"),
                       selected="🏳  wd_events"),
           DT::DTOutput("add_table")
  ),
 widths=c(2,10),well=FALSE)#navlistPanel
 
)
