# Author: Manuel Jiménez Bernal - manu.asi2@gmail.com
# Iliberi S.A. Granada,Spain - 02/2016

######## SOM GENERATOR ###########

library(png) # For writePNG function
library(kohonen)
library(shiny)
library(ggplot2)
library(jsonlite)
options(shiny.maxRequestSize=500*1024^2) 

#Comienzo de la estructura interactiva en el servidor

shinyServer(function(input, output, session) {

#Leer datos desde fichero CSV. Todos los valores deben ser numéricos.

  dataInput <- reactive({
    inFile <- input$file1
    players<-read.csv(inFile$datapath, header=input$header, sep=input$sep,quote=input$quote,stringsAsFactors=FALSE)
   
  })



#Función reactiva que genera la estructura del SOM

  generaSOM <- reactive({ 
    head(dataInput())
    players.sc <- scale(dataInput())
    set.seed(15675)
    players.som <- som(players.sc, grid = somgrid(input$slider1, input$slider2, input$fig))
  })

#Función que genera el gráfico con el resultado del SOM con los distintos parámetros, se utiliza la paleta de colores creada con anterioridad.
#Esta función se realiza aparte con el fin de que sea llamada por los distintos métodos reactivos.

  generaGrafico = function(){
    if (is.null(input$file1))
      return(NULL)
    else{
      coolBlueHotRed <- function(n, alpha = 1) {
       rainbow(n, end=4/6, alpha=alpha)[n:1]
      }
      plot(generaSOM(),type = input$select, main = "SOM", palette.name = coolBlueHotRed)
    }
  }

# Función que convierte un objeto de la clase 'kohonen' en una tabla renderizable.

  somToTable = function(){
    as.table( as.matrix(generaSOM()) )
  }

#Envío al UI del renderizado de la gráfica.
  output$salida<-renderPlot({
    generaGrafico()
  },height = 800, width = 800 )

 
#Manejador para la descarga de la imagen del gráfico.
  output$downloadData <- downloadHandler(
    filename = "shinyplot.png",
    content = function(file) {
        png(file)
        generaGrafico()
        dev.off()
    })

#Manejador de la descarga de la estructura del SOM en formato CSV
  output$downloadTabla <- downloadHandler(
    filename = "som.csv",
    content = function(file) {
      write.table(somToTable(), file, sep = ",",row.names = FALSE)
    }
  )



})

