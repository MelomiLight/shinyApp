library(shiny)
library(shinydashboard)
library(leaflet)
dashboardPage(
  dashboardHeader(title="Развитие ВИЭ в Казахстане после ЭКСПО-2017",
                  titleWidth = 650,
                  tags$li(class="dropdown", tags$a(href="https://t.me/ZhumagulMerey",icon("telegram"),"Телеграм",target="_blank")),
                  tags$li(class="dropdown", tags$a(href="https://github.com/MelomiLight/shinyApp",icon("github"),"Исходный код",target="_blank"))
                  
                  ),
  dashboardSidebar(
    #sidebarmenu
    sidebarMenu(
      id="sidebar",
      
      #first menuitem
      menuItem("Набор данных",tabName = "data",icon=icon("database")),
      menuItem(text="Визуализация",tabName="viz",icon=icon("chart-line")),
      menuItem(text="Хороплет карта",tabName="map",icon=icon("map"))
    )
  ),
  dashboardBody(
    tabItems(
      #first tab item
      tabItem(tabName="data",
              #tab box
              tabBox(id="t1",width=12,
                     tabPanel("О чем",icon=icon("address-card"),fluidRow(
                       column(width = 8, tags$img(src="aa.jpg", width =600 , height = 300),
                              tags$br() , 
                              tags$a("https://strategy2050.kz/ru/news/53767/"), align = "center"),
                       column(width = 4, tags$br() ,
                              tags$p("Данные имеют информацию про динамику выработки и  мощности ВИЭ в Казахстане за последние 8-9 лет. А также, список объектов ВИЭ с 2014 года с местоположением объектов.")
                       )
                     )
                     
                     
                     ),
                     tabPanel("Данные",icon=icon("address-card"),dataTableOutput("dataT"),
                              dataTableOutput("dataT2"),
                              dataTableOutput("dataT3"),
                              dataTableOutput("dataT4")),
            
                     )
              ),
      #second tab item or landing page here...
      tabItem(tabName="viz",
              tabBox(id="t2",width=12,
                     tabPanel(title="Количество объектов ВИЭ",value="trends",plotlyOutput("Pplot")),
                     tabPanel(title="Динамика мощности ВИЭ",value="graphic",plotlyOutput("histplot")),
                     tabPanel(title="Процент использования ВИЭ",value="graphic2",plotlyOutput("barplot")),
                     
                     
                     )
              ),
      
      #third tabItem
      tabItem(tabName="map",
              leafletOutput("bbmap", height=1000),
              tabPanel("Data", DT::dataTableOutput("data")),)
      
    )
  )
)


