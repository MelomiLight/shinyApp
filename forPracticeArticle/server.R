library(DT)
library(tidyr)
library(rgdal)
library(dplyr)
library(plotly)
library(leaflet)
library(sf)
function(input,output,session){
  #structure
  output$structure<-renderPrint(
    my_data %>%
      str(show_col_types = FALSE)
  )
  
  output$dataT<-renderDataTable(
    datatable(powerData)  
  )
  
  output$dataT2<-renderDataTable(
    datatable(produceData)  
  )
  
  output$dataT3<-renderDataTable(
    datatable(mapData)  
  )
  output$dataT4<-renderDataTable(
    datatable(amountData)  
  )
  
  output$histplot<-renderPlotly(
    p <- powerData %>%
      plot_ly(x = ~year, y = ~power, type = "bar", 
              marker = list(color = "blue"), 
              opacity = 0.8, 
              text = ~paste("Мощность: ", power, " МВт<br>Год: ", year),
              hoverinfo = "text",
              xaxis = list(title = "Год"), 
              yaxis = list(title = "Мощность (МВт)"), 
              showlegend = FALSE) %>%
      layout(title = "Установленная мощность в период", 
             plot_bgcolor = "rgba(0,0,0,0)", 
             paper_bgcolor = "rgba(0,0,0,0)",
             font = list(color = "black", size = 14),
             margin = list(l = 50, r = 50, b = 50, t = 80, pad = 0))
    
    
    
    
  )
  output$barplot<-renderPlotly(
    p2 <- produceData %>%
      plot_ly(x = ~year, y = ~percent, mode = "markers+lines", 
              marker = list(size = 8, color = "blue", line = list(color = "white", width = 1)),
              line = list(color = "blue", width = 3),
              text = ~paste("Процент: ", percent, " %<br>Год: ", year),
              hoverinfo = "text",
              xaxis = list(title = "Год"), 
              yaxis = list(title = "Процент (%)")) %>%
      layout(title = "Процент использования ВИЭ", 
             plot_bgcolor = "rgba(0,0,0,0)", 
             paper_bgcolor = "rgba(0,0,0,0)",
             font = list(color = "black", size = 14),
             margin = list(l = 50, r = 50, b = 50, t = 80, pad = 0))
    
    
    
    
  )
  
  output$Pplot <- renderPlotly(
    p2 <- amountData %>%
      plot_ly(x = ~year, y = ~amount, type = "bar",
              marker = list(color = "blue", line = list(color = "white", width = 1)),
              text = ~paste("Количество: ", amount, "<br>Год: ", year),
              hoverinfo = "text",
              xaxis = list(title = "Год"), 
              yaxis = list(title = "Количество")) %>%
      layout(title = "Количество реализованных ВИЭ", 
             plot_bgcolor = "rgba(0,0,0,0)", 
             paper_bgcolor = "rgba(0,0,0,0)",
             font = list(color = "black", size = 14),
             margin = list(l = 50, r = 50, b = 50, t = 80, pad = 0))
  )
  bb_data <- mapData
  bb_data <- data.frame(bb_data)
  bb_data$latitude <-  as.numeric(bb_data$latitude)
  bb_data$longitude <-  as.numeric(bb_data$longitude)
  bb_data=filter(bb_data, latitude != "NA") # removing NA values
  
  bb_data <- mutate(bb_data, cntnt=paste0('<strong>Type: </strong>',type,
                                          '<br><strong>Data:</strong> ', date,
                                          '<br><strong>Power:</strong> ', power)) 
  
  # create a color paletter for category type in the data file
  
  pal <- colorFactor(pal = c("#1b9e77", "#d95f02", "#7570b3","#1b249e"), domain = c("ГЭС", "ВЭС", "СЭС","БиоЭс"))
  
  output$bbmap <- renderLeaflet({
    leaflet(bb_data) %>% 
      addCircles(lng = ~longitude, lat = ~latitude) %>% 
      addTiles() %>%
      addCircleMarkers(data = bb_data, lat =  ~latitude, lng =~longitude, 
                       radius = 3, popup = ~as.character(cntnt), 
                       color = ~pal(type),
                       stroke = FALSE, fillOpacity = 0.8)%>%
      addLegend(pal=pal, values=bb_data$type,opacity=1, na.label = "Not Available")%>%
      addEasyButton(easyButton(
        icon="fa-crosshairs", title="ME",
        onClick=JS("function(btn, map){ map.locate({setView: true}); }")))
  })
  
  output$data <-DT::renderDataTable(datatable(
    bb_data[,c()],filter = 'top',
    colnames = c("type","date","power")
  ))
  
}