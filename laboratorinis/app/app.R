library(shiny)
library(tidyverse)
library(shinythemes)
ui <- fluidPage( theme = shinytheme("cosmo"),
                 navbarPage(
                         ("2020 m. imoniu SoDra duomenys"),
                         
                         tabPanel("Atlyginimo ir apdraustuju kaita",
                                  
                                  sidebarPanel(
                                          selectizeInput("imones_pav", choices = NULL, label = "Imones pavadinimas")
                                  ),
                                  
                                  
                                  mainPanel(
                                          plotOutput("plotWage"),
                                          plotOutput("plotIns")
                                  )
                         ),
                         
                         tabPanel("Imoniu duomenys",
                                  
                                  sidebarPanel(
                                        selectizeInput("imones_pav1", choices = NULL, label = "Imones pavadinimas"),
                                        #selectizeInput(inputId = "imones_pav", label = "Įmonės pavadinimas", choices = unique(data$name), selected = NULL),
                                        checkboxGroupInput("stulp", "Duomenys")
                                  ),
                                  
                                  mainPanel(
                                          tableOutput("table")
                                  )
                                  
                         )
                 )
)

server <- function(input, output, session) {
        data <- read_csv("https://raw.githubusercontent.com/gabijapr/KTU-duomenu-vizualizacija/main/laboratorinis/data/lab_sodra.csv")
        data <- data %>% mutate("men" = as.integer(substr(month, 5, 6)))
        

        
        updateSelectizeInput(session, "imones_pav", choices = data$name, server = TRUE)
        updateSelectizeInput(session, "imones_pav1", choices = data$name, server = TRUE)
        
        updateCheckboxGroupInput(session, "stulp",
                                 choices = colnames(data),
                                 selected = colnames(data)
        )
        
        
        output$table <- renderTable(
                data %>% filter(name == input$imones_pav1) %>%
                        select(input$stulp),
                digits = 0
        )
        
        output$plotWage <- renderPlot(
                data %>%filter(name == input$imones_pav) %>%
                        ggplot(aes(x = men, y = avgWage)) +
                        geom_line(color = "darkslategrey", size = 1.2) +
                        geom_point()+
                        scale_x_continuous(breaks = 1:12, limits = c(1, 12)) +
                        labs(x = 'Menuo', y = 'Vidutinis atlyginimas') +
                        theme_bw()
        )
        
        output$plotIns <- renderPlot(
                data %>%filter(name == input$imones_pav) %>%
                        ggplot(aes(x = men, y = numInsured)) +
                        geom_col(color = "darkslategrey") +
                        scale_x_continuous(breaks = 1:12, limits = c(1, 12)) +
                        labs(x = 'Menuo', y = 'Apdraustu darbuotoju skaicius') +
                        theme_bw()
                
        )
}


shinyApp(ui = ui, server = server)

