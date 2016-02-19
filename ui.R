# Author: Manuel Jiménez Bernal - manu.asi2@gmail.com
# Iliberi S.A. Granada,Spain - 02/2016

######## SOM GENERATOR ###########

library(shiny)

shinyUI(fluidPage(
  titlePanel("Self-Organized-Maps"),

  fluidRow(
    sidebarPanel(
   
       radioButtons('sep', 'Separador',c(Coma=',','Punto y Coma'=';',Tab='\t'),',',),
       radioButtons('quote', 'Quote',c(Ninguno='','Dobles Comillas'='"','Comillas Simples'="'"),'"'),
         checkboxInput('header', 'Cabecera', TRUE),
      tags$hr(),
      tags$br(),
      fileInput('file1', 'Selecciona documento CSV',accept=c('text/csv','text/comma-separated-values,text/plain','.csv')),
     
      selectInput("select", label = "Variables", 
                  choices = list("All immediate neighbours" = "dist.neighbours",
                                  "Changes" = "changes",
                                  "Counts" = "counts",
                                  "Quality" = "quality",
                                  "Codes" = "codes"),
                  selected = 1),
      selectInput("fig", label = "Forma", 
                  choices = list("Hexagonal" = "hexagonal", "Rectangular" = "rectangular"),
                  selected = 1),

      sliderInput("slider1", label = "Granularidad X", min = 1, 
                    max = 50, value = 5),
      sliderInput("slider2", label = "Granularidad Y", min = 1, 
                    max = 50, value = 5),
       downloadButton('downloadData', 'Descargar Grafico (PNG)'),
       downloadButton('downloadTabla', 'Descargar SOM (CSV)')
    ),
  
    mainPanel(
      navbarPage(
        title = 'SOM Generator',
        tabPanel('Tabla',      helpText(" Esta tabla muestra el contenido de los datos introducidos. Con el fin de generar los diagramas todos los valores deben ser numéricos."),
                  DT::dataTableOutput('tabla')   ),
        tabPanel('Diagramas',     plotOutput('salida', width = "100%",click = "plot_click",hover = "plot_hover") )
        )
    )  
  )
))