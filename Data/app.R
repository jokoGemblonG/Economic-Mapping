library(shiny)
library(shinydashboard)
#-----------------HEADER-------------------------------
header <- dashboardHeader(title = "Economic-Dashboard")  

#-----------------SIDEBAR------------------------------
sidebar <- dashboardSidebar(
  sidebarMenu(
    
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    
    selectInput(
      inputId = "data",
      label = "Pilih Data Set:",
      choices = c("Data Jumlah Penduduk"= "jumlah",
                  "Data Kepadatan Penduduk"= "kepadatan",
                  "Data Persentase Kemiskinan" = "kemiskinan",
                  "Data Tingkat Pengangguran"= "pengangguran"),
      selected = "jumlah"),
    
    selectInput(
      inputId = "provinsi",
      label = "Pilih Provinsi:",
      choices = c("Aceh" = "AC",
                  "Sumatra Utara"= "SU",
                  "Sumatra Barat" = "SB",
                  "Riau" = "RI",
                  "Kepulauan Riau"= "KR",
                  "Jambi" = "JA",
                  "Sumatra Selatan" = "SS",
                  "Bengkulu" = "BE",
                  "Lampung" = "LA",
                  "Bangka Belitung" = "BB",
                  "Jakarta"= "JK",
                  "Jawa Barat" = "JB",
                  "Banten" = "BT",
                  "Jawa Tengah" = "JT",
                  "Yogyakarta" = "YO",
                  "Jawa Timur" = "JI",
                  "Bali" = "BA",
                  "Nusa Tenggara Barat" = "NB",
                  "Nusa Tenggara Timur" = "NT",
                  "Kalimantan Barat" = "KB",
                  "Kalimantan Tengah" = "KT",
                  "Kalimantan Selatan" = "KS",
                  "Kalimantan Timur" = "KI",
                  "Kalimantan Utara" = "KU",
                  "Sulawesi Utara" = "SA",
                  "Gorontalo" = "GO",
                  "Sulawesi Tengah" = "ST",
                  "Sulawesi Selatan" = "SN",
                  "Sulawesi Barat" = "SR",
                  "Sulawesi Tenggara" = "SG",
                  "Maluku Utara" = "MU",
                  "Maluku" = "MA",
                  "Papua" = "PA",
                  "Papua Barat" = "PB"))

  )
)



#-----------------------TABEL---------------------------
tabel <- dataTableOutput("tabel")

#-----------------------DOWNLOAD BUTTON-----------------
download <- downloadButton("downloadData", "Download")

#----------------------BODY-----------------------------
body <- dashboardBody(tabel,download)

#----------------------FINAL UI---------------------------
ui <- dashboardPage(title = 'Economic Dashboard', header, sidebar, body, skin='purple')




#----------------------Server--------------------------

server <- function(input,output){
  data <- reactive({
    if (input$data == "jumlah"){
      df1 <- read.csv("https://raw.githubusercontent.com/jokoGemblonG/Economic-Mapping/main/Data/Jumlah%20Penduduk%202021.csv",
                      sep = ",", header = T)
      return(df1)
    }
    
    else if (input$data == "kepadatan"){
      df2 <- read.csv("https://raw.githubusercontent.com/jokoGemblonG/Economic-Mapping/main/Data/Kepadatan%20Penduduk%202021.csv",
                      sep = ",", header = T)
      return(df2)
    }
    
    else if (input$data == "kemiskinan"){
      df3 <- read.csv("https://raw.githubusercontent.com/jokoGemblonG/Economic-Mapping/main/Data/Penduduk%20Miskin%202021.csv",
                      sep = ",", header = T)
      return(df3)
    }
    
    else if (input$data == "pengangguran"){
      df4 <- read.csv("https://raw.githubusercontent.com/jokoGemblonG/Economic-Mapping/main/Data/Tingkat%20Pengangguran%202021.csv",
                      sep = ",", header = T)
      return(df4)
    }
  })
  x <- reactive({
    req(data())
    if(input$data == "pengangguran"){
      a <- data()
      colnames(a) <- c("Provinsi", "Tingkat Pengangguran")
      return(a)
    }
    else if(input$data == "jumlah"){
      b <- data()
      colnames(b) <- c("Provinsi", "Jumlah Penduduk")
      return(b)
    }
    else if(input$data == "kepadatan"){
      c <- data()
      colnames(c) <- c("Provinsi", "Kepadatan Penduduk")
      return(c)
    } 
    else if(input$data == "kemiskinan"){
      d <- data()
      colnames(d) <- c("Provinsi", "Presentase") 
      return(d)
    }
    
  })

  
  output$tabel <- renderDataTable(
    data(), options = list(pageLength = 10)
  )
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$data, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(data(), file, row.names = FALSE)
    }
  )
  
}

shinyApp(ui, server)
