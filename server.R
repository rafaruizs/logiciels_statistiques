
#install.packages("shiny")
#install.packages("maptools")
#install.packages("ggplot2")
#install.packages("RColorBrewer")

library(shiny)
library(ggplot2)
library(proto)
library(maptools)
library(RColorBrewer)

map <- readShapePoly(paste(getwd(), "/www/map/LIMADMIN.shp", sep=""))

getColumnList <- function(data) {
  
  if (is.null(data)) {
    return()
  }
  
  #return(as.list(names(data)[-1]))
  return(sapply(names(data), function(x) { return(class(data[[x]]))}, simplify=F))
  
}


# Define server logic required to draw a histogram
shinyServer(function(input, output) {  
  
  Data <- reactive({
    
    inFile <- input$file1
    if (is.null(inFile)) {
      return(NULL)
    }
    
    dataset <- read.table(inFile$datapath, sep=",", header=T)
    return(dataset)
    
  })
  
  Colonnes <- reactive({
    return(getColumnList(Data()))
  })

  output$columns <- renderUI({
    
    column_list <- getColumnList(Data())
    
    #column_with_types <- sapply(names(column_list), function(x) { paste(x, column_list[[x]]) })
    if (!is.null(column_list)) {  
      
      i <- 1
      column_with_types <- list()
      name_list <- c()
      for (c in names(column_list)) {
        label <- paste(c, ' (', column_list[[c]], ')', sep='')
        name_list <- c(name_list, label)
        column_with_types <- c(column_with_types, i) 
        i <- i + 1
      }
      names(column_with_types) <- as.list(name_list)
      checkboxGroupInput('columns', 'Colonnes', column_with_types)
    }
    else {
      return()
    }
  })
  
  output$colAgglo <- renderUI({
    
    selectInput("colAgglo","Colonne Agglomeration", names(Colonnes()))
    
  })
  
  output$contents <- renderPlot({
    
    var <- input$columns 
    
    
    if(is.null(var)) return(NULL)
    
    dt <- Data()
    col <- names(Colonnes())[var]
    
    ds <- dt[[col]]
    
    maxy <- max(ds)
    chunk <- (maxy-min(ds))/4
    breaks <- c(0, min(ds)+chunk, min(ds)+2*chunk, min(ds)+3*chunk, maxy)
    
    plotvar <- unlist(dt[[col]])
    nclr <- 9
    plotclr <- brewer.pal(nclr, "Reds")
    fillRed <- colorRampPalette(plotclr)
    plotvar[plotvar >= maxy] <- maxy -1
    colcode <- fillRed(maxy)[round(plotvar) + 1]
    plot(map, col = colcode, border="dark grey", axes=F, las=1)
    
  })
  
  #output$contents <- renderTable({
    
    #if (is.null(Data())) return(NULL)
    #data.frame(Data())
    
  #})
  
})