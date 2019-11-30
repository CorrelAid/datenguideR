  
dg_call(nuts_nr = 1,
        stat_name = "AI0808"
        ) %>%
  group_by(name) %>%
  arrange(year) %>%
  summarize(proportion = last(value)) %>%
  arrange(proportion) %>%
  mutate(name = factor(name,ordered=TRUE,levels = name)) %>%
  ggplot(aes(x = name,y=proportion)) +
  geom_col() +
  coord_flip() +
  labs(title="Langzeitarbeitslose",x = "",y="%") +
  theme_minimal()+ 
  theme(plot.title = element_text(hjust = 0.5),text = element_text(size=25))


dg_call(region_id = "11",
        stat_name = "TIE001",
        substat_name = "TIERA8"
) %>% 
  select(TIERA8,year,value)%>%
  ggplot(aes(x=year,y=value)) +
  facet_wrap(facets = ~TIERA8,ncol = 2,scales='free_y') +
  geom_line(size = 1.5,alpha = 0.2) +
  theme_bw() + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),
        text = element_text(size=15),
        plot.title = element_text(hjust = 0.5)) +
  labs(title = "Different domestic animals in Berlin",x = "Year",y="#Animals")


all_stats <-dg_descriptions %>% 
  as_tibble() %>%
  select(stat_name) %>%
  distinct

all_region_stats <- function(region,max_stats = 50){
  all_stats %>%
  slice(1:max_stats) %>%
  pull(stat_name) %>%
  map_dfr(~{dg_call(region_id = region,stat_name = .x) %>% mutate(stat = .x)})
}

german_stats <- all_region_stats(region="DG")
berlin_state_stats <- all_region_stats(region = '11')
berlin_tempelhof_stats <- all_region_stats(region =  "11007")
berlin_city_stats <- all_region_stats(region = "11000000")

german_stats %>% select(stat) %>% n_distinct()
berlin_stats %>% select(stat) %>% n_distinct()
berlin_tempelhof_stats %>% select(stat) %>% n_distinct()
berlin_city_stats %>% select(stat) %>% n_distinct()


dg_descriptions %>% 
  as_tibble() %>% 
  filter(grepl('arbeit',stat_description))
