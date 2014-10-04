
#install.packages("shiny")

library(shiny)

loadUserDataset <- function(inFile = NULL) {
  
  if (is.null(inFile)) {
    return()
  }
  
  data <- read.table(inFile$datapath, sep=",", header=T)
  
  return(data)
  
}

getColumnList <- function(data) {
  
  if (is.null(data)) {
    return()
  }
  
  return(as.list(names(data)[-1]))
  
}


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  data <- as.data.frame(1234)
  

  output$columns <- renderUI({
    
    inFile <- input$file1
    
    data <- loadUserDataset(inFile)
    
    column_list <- getColumnList(data)
    
    if (!is.null(column_list)) {
      checkboxGroupInput('columns', 'Colonnes', column_list)
    }
    else {
      return()
    }
  })
  
  output$contents <- renderTable({
    
    ifelse(!is.null(data), return(data), return())
    
  })
  
})