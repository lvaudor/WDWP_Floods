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
  tabsetPanel(
  tabPanel("💧 General",
           fluidRow(
             column(width=2,
                    p(),
                    img(src='WDWP_Floods.png',  height="100px", width="100px", align = "left")
                    ),
             column(width=10,  
                    h3("WPWD Floods app"),
                    p("App development and maintenance: L. Vaudor"),
                    p("The code for the app is available online on github ")
                   )),
           p("This app documents the Wikidata-Wikipedia dataset about floods used in the article:"),
           HTML("<i>Online reports and narrations of flood events worldwide</i>, Vaudor L., Bajemon L., Genouel M., Piégay H., Montagne D., [journal, issue, year]"),
           
           

  ),#tabPanel
  tabPanel("🌍 All Events 📊",
           fluidRow(column(width=2,
                           wellPanel(
                             selectInput("flood",
                                         "flood event:",
                                         unique(wp_segments$flood))
                           ),
                           uiOutput("flood_info"),
                           div(class = "limited-height",plotOutput("legend_local")),
                           div(class = "limited-height",plotOutput("legend_class_name"))
           ),#column
           column(width=10,
                  fluidRow(
                    column(width=3,
                           radioButtons("marker_size",
                                        "symbols size",
                                        c("deathtoll",
                                          "curation"),
                                        selected="deathtoll")
                    ),
                    column(width=9,
                           leafletOutput("map"))
                  )#fluidRow
           )#column
           )#fluidRow
           ),#tabPanel
  tabPanel("🌍 All Events 🗃",
           selectInput("global_table",
                       "table",
                       choices=c("📍 wd_events",
                                 "🏳 countries"),
                       selected="📍 wd_events"),
           DT::dataTableOutput("global_table")
  ),#tabPanel global tables
  tabPanel("📍 Per Event 📊",
           fluidRow(
              column(width=2,
                     plotlyOutput("lengths")),
              column(width=3,
                     plotlyOutput("classif")),
              column(width=6,
                     plotlyOutput("views_history")),
              column(width=1,
                     plotlyOutput("curation"))
            )#fluidRow
        ),#tabPanel events view
   tabPanel("📍 Per Event  🗃",
        selectInput("event_table",
                    "table",
                    choices=c("📰 wp_pages",
                              "🖊 wp_revisions",
                              "💬 wp_segments"),
                    selected="📰 wp_pages"),
        conditionalPanel(condition="input.event_table=='📰 wp_pages'",
                         checkboxInput("show_textt",
                                       "show translated text",
                                       value=FALSE)
        ),#conditionalPanel
        DT::dataTableOutput("event_table")
    )#tabPanel events table
  )#navlistPanel
)
