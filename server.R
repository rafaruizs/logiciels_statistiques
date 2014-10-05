
#install.packages("shiny")

library(shiny)

getColumnList <- function(data) {
  
  if (is.null(data)) {
    return()
  }
  
  return(as.list(names(data)[-1]))
  
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

  output$columns <- renderUI({
    
    column_list <- getColumnList(Data())
    
    if (!is.null(column_list)) {
      checkboxGroupInput('columns', 'Colonnes', column_list)
    }
    else {
      return()
    }
  })
  
  output$contents <- renderTable({
    
    if (is.null(Data())) return(NULL)
    data.frame(Data())
    
  })
  
})