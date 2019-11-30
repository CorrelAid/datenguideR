library(DT)
library(datenguideR)
library(markdown)

all_stats <- dg_descriptions %>%
  select(stat_name,stat_description,stat_description_full) %>%
  distinct()

stat_vec <- all_stats %>% pull(stat_name)
names(stat_vec) <- all_stats %>% pull(stat_description)

ui <- basicPage(
  h2("Datenguide Data for Berlin"),
  selectInput("statistic", "Statistic:",
  stat_vec),
  DT::dataTableOutput("mytable"),
  uiOutput('stat_desc')
)

server <- function(input, output) {
  data <- reactive({
    dg_call(region_id = "11",
            stat_name = input$statistic)
  }) 
  
  output$mytable = DT::renderDataTable({
    data()
  })
  output$stat_desc <- renderUI({
    s <- input$statistic
    all_stats %>% 
      filter(stat_name == s) %>%
      pull(stat_description_full) %>%
      markdownToHTML(text=.) %>%
      HTML()
  })
}

shinyApp(ui, server)