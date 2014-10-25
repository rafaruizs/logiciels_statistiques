
reactiveBar <- function (outputId)
{
  HTML(paste("<div id=\"", outputId, "\" class=\"montreal-map-output\"></div>", sep=""))
}

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Projet Logiciels Statistiques"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      
      # upload du dataset
      fileInput('file1', 'Choisir votre ensemble de données',
                accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
      
      uiOutput("columns"),
      
      # variable reprsentant l'agglomeration
      uiOutput("colAgglo")
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      includeHTML("style.css"),
      includeHTML("script.js"),
      textOutput("message"),
      reactiveBar(outputId = "mtlplot")
      # plotOutput("contents")
    )
  )
))