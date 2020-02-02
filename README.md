
<!-- README.md is generated from README.Rmd. Please edit that file -->

# datenguideR <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->

[![Build\_Status](https://travis-ci.org/CorrelAid/datenguideR.svg?branch=master)](https://travis-ci.org/CorrelAid/datenguideR)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/datenguideR)](https://cran.r-project.org/package=datenguideR)
[![Codecov test
coverage](https://codecov.io/gh/CorrelAid/datenguideR/branch/master/graph/badge.svg)](https://codecov.io/gh/CorrelAid/datenguideR?branch=master)
<!-- badges: end -->

## Usage

First, install datenguideR from GitHub:

``` r
devtools::install_github("CorrelAid/datenguideR")
```

Load package:

``` r
library(datenguideR)
```

## Examples

Get IDs of all available NUTS-1 regions:

``` r
datenguideR::dg_regions %>%
  dplyr::filter(level == "nuts1") %>%
  knitr::kable()
```

| id | name                   | level | parent |
| :- | :--------------------- | :---- | :----- |
| 01 | Schleswig-Holstein     | nuts1 | DG     |
| 02 | Hamburg                | nuts1 | DG     |
| 03 | Niedersachsen          | nuts1 | DG     |
| 04 | Bremen                 | nuts1 | DG     |
| 05 | Nordrhein-Westfalen    | nuts1 | DG     |
| 06 | Hessen                 | nuts1 | DG     |
| 07 | Rheinland-Pfalz        | nuts1 | DG     |
| 08 | Baden-Württemberg      | nuts1 | DG     |
| 09 | Bayern                 | nuts1 | DG     |
| 10 | Saarland               | nuts1 | DG     |
| 11 | Berlin                 | nuts1 | DG     |
| 12 | Brandenburg            | nuts1 | DG     |
| 13 | Mecklenburg-Vorpommern | nuts1 | DG     |
| 14 | Sachsen                | nuts1 | DG     |
| 15 | Sachsen-Anhalt         | nuts1 | DG     |
| 16 | Thüringen              | nuts1 | DG     |

Get all available meta data on statistics, substatistics, and
parameters:

``` r
datenguideR::dg_descriptions
#> # A tibble: 3,419 x 11
#>    stat_name stat_description stat_descriptio… substat_name
#>    <chr>     <chr>            <chr>            <chr>       
#>  1 AENW01    Entsorgte/behan… "**Entsorgte/be… <NA>        
#>  2 AENW02    Abgelagerte Abf… "**Abgelagerte … <NA>        
#>  3 AENW03    Entsorg.u.Behan… "**Entsorg.u.Be… <NA>        
#>  4 AENW04    Entsorgte/behan… "**Entsorgte/be… <NA>        
#>  5 AENW05    Abgelagerte Abf… "**Abgelagerte … <NA>        
#>  6 AENW06    Entsorg.u.Behan… "**Entsorg.u.Be… <NA>        
#>  7 AEW001    Entsorgungs- un… "**Entsorgungs-… <NA>        
#>  8 AEW001    Entsorgungs- un… "**Entsorgungs-… EBANL1      
#>  9 AEW001    Entsorgungs- un… "**Entsorgungs-… EBANL1      
#> 10 AEW001    Entsorgungs- un… "**Entsorgungs-… EBANL1      
#> # … with 3,409 more rows, and 7 more variables: substat_description <chr>,
#> #   param_name <chr>, param_description <chr>, stat_description_en <chr>,
#> #   stat_description_full_en <chr>, substat_description_en <chr>,
#> #   param_description_en <chr>
```

You can also use `dg_search` to look for a variable of interest. The
function will match your string with any strings in the
`dg_descriptions` data frame, returning only rows with those matches.

Looking for variables where the string *“vote”* appears somewhere in the
documentation:

``` r
dg_search("vote")
#> # A tibble: 90 x 11
#>    stat_name stat_description stat_descriptio… substat_name
#>    <chr>     <chr>            <chr>            <chr>       
#>  1 AI0501    Zweitstimmenant… "**Zweitstimmen… <NA>        
#>  2 AI0502    Zweitstimmenant… "**Zweitstimmen… <NA>        
#>  3 AI0503    Zweitstimmenant… "**Zweitstimmen… <NA>        
#>  4 AI0504    Zweitstimmenant… "**Zweitstimmen… <NA>        
#>  5 AI0505    Zweitstimmenant… "**Zweitstimmen… <NA>        
#>  6 AI0506    Wahlbeteiligung… "**Wahlbeteilig… <NA>        
#>  7 AI0601    Stimmenanteil C… "**Stimmenantei… <NA>        
#>  8 AI0602    Stimmenanteil S… "**Stimmenantei… <NA>        
#>  9 AI0603    Stimmenanteil F… "**Stimmenantei… <NA>        
#> 10 AI0604    Stimmenanteil G… "**Stimmenantei… <NA>        
#> # … with 80 more rows, and 7 more variables: substat_description <chr>,
#> #   param_name <chr>, param_description <chr>, stat_description_en <chr>,
#> #   stat_description_full_en <chr>, substat_description_en <chr>,
#> #   param_description_en <chr>
```

Note: Descriptions of variables are also available in English now\!
Translated via the
[`googleLanguageR`](https://github.com/ropensci/googleLanguageR)
package.

``` r
dg_search("vote") %>% 
  dplyr::select(stat_name, dplyr::contains("_en"))
#> # A tibble: 90 x 5
#>    stat_name stat_descriptio… stat_descriptio… substat_descrip…
#>    <chr>     <chr>            <chr>            <chr>           
#>  1 AI0501    Second Vote Sha… "** CDU / CSU s… <NA>            
#>  2 AI0502    SPD Second Vote… "** SPD second … <NA>            
#>  3 AI0503    FDP Second Vote… "** Second vote… <NA>            
#>  4 AI0504    Second Vote Sha… "** GREEN secon… <NA>            
#>  5 AI0505    Second Vote Sha… "** Second vote… <NA>            
#>  6 AI0506    Voter Turnout, … "** Voter turno… <NA>            
#>  7 AI0601    CDU / CSU, Euro… "** CDU / CSU v… <NA>            
#>  8 AI0602    SPD Vote Share,… "** SPD vote sh… <NA>            
#>  9 AI0603    FDP Share of Vo… "** FDP vote sh… <NA>            
#> 10 AI0604    Share of Votes … "** GREEN share… <NA>            
#> # … with 80 more rows, and 1 more variable: param_description_en <chr>
```

Pick a statistic and put it into `dg_call()` (infos can be retrieved
from `dg_descriptions`).

For example:

  - `stat_name:` AI0506 *(Wahlbeteiligung, Bundestagswahl)*
  - `region_id` 11 (stands for Berlin)

<!-- end list -->

``` r
dg_call(region_id = "11",
        year = 2017,
        stat_name = "AI0506")
#> # A tibble: 1 x 9
#>   id    name   year value GENESIS_source GENESIS_source_… stat_name
#>   <chr> <chr> <int> <dbl> <chr>          <chr>            <chr>    
#> 1 11    Berl…  2017  75.6 Regionalatlas… 99910            AI0506   
#> # … with 2 more variables: stat_description <chr>,
#> #   stat_description_en <chr>
```

A slightly more complex call with substatistics:

  - **Statistic:** BETR08 *(Landwirtschaftliche Betriebe mit
    Tierhaltung)*
  - **Substatistic:** TIERA8 *(Landwirtschaftliche Betriebe mit
    Viehhaltung)*
  - **Parameter:**
      - TIERART2 *(Rinder)*
      - TIERART3 *(Schweine)*

<!-- end list -->

``` r

dg_call(region_id = "11", 
        year = c(2001, 2003, 2007), 
        stat_name = "BETR08", 
        substat_name = "TIERA8", 
        parameter = c("TIERART2", "TIERART3")) 
#> # A tibble: 6 x 15
#>   id    name   year TIERA8 value GENESIS_source GENESIS_source_… stat_name
#>   <chr> <chr> <int> <chr>  <int> <chr>          <chr>            <chr>    
#> 1 11    Berl…  2001 TIERA…     8 Allgemeine Ag… 41120            BETR08   
#> 2 11    Berl…  2001 TIERA…     7 Allgemeine Ag… 41120            BETR08   
#> 3 11    Berl…  2003 TIERA…     9 Allgemeine Ag… 41120            BETR08   
#> 4 11    Berl…  2003 TIERA…     7 Allgemeine Ag… 41120            BETR08   
#> 5 11    Berl…  2007 TIERA…    11 Allgemeine Ag… 41120            BETR08   
#> 6 11    Berl…  2007 TIERA…     5 Allgemeine Ag… 41120            BETR08   
#> # … with 7 more variables: stat_description <chr>, substat_name <chr>,
#> #   substat_description <chr>, param_description <chr>,
#> #   stat_description_en <chr>, substat_description_en <chr>,
#> #   param_description_en <chr>
```

If you give no parameters for a substat, it will default to return
results for all of them.

``` r
dg_call(region_id = "11", 
        year = c(2001, 2003, 2007), 
        stat_name =  "BETR08", 
        substat_name = "TIERA8") 
#> # A tibble: 23 x 15
#>    id    name   year TIERA8 value GENESIS_source GENESIS_source_… stat_name
#>    <chr> <chr> <int> <chr>  <int> <chr>          <chr>            <chr>    
#>  1 11    Berl…  2001 GESAMT    37 Allgemeine Ag… 41120            BETR08   
#>  2 11    Berl…  2001 TIERA…     3 Allgemeine Ag… 41120            BETR08   
#>  3 11    Berl…  2001 TIERA…     8 Allgemeine Ag… 41120            BETR08   
#>  4 11    Berl…  2001 TIERA…     6 Allgemeine Ag… 41120            BETR08   
#>  5 11    Berl…  2001 TIERA…     0 Allgemeine Ag… 41120            BETR08   
#>  6 11    Berl…  2001 TIERA…     7 Allgemeine Ag… 41120            BETR08   
#>  7 11    Berl…  2001 TIERA…     8 Allgemeine Ag… 41120            BETR08   
#>  8 11    Berl…  2001 TIERA…    15 Allgemeine Ag… 41120            BETR08   
#>  9 11    Berl…  2003 GESAMT    33 Allgemeine Ag… 41120            BETR08   
#> 10 11    Berl…  2003 TIERA…     0 Allgemeine Ag… 41120            BETR08   
#> # … with 13 more rows, and 7 more variables: stat_description <chr>,
#> #   substat_name <chr>, substat_description <chr>,
#> #   param_description <chr>, stat_description_en <chr>,
#> #   substat_description_en <chr>, param_description_en <chr>
```

### AllRegions

Instead of specifying a `region_id` for individual Bundesland (state)
data you can also use `nuts_nr` to receive data for *NUTS-1*, *NUTS-2*
and *NUTS-3*.

Just leave `region_id` blank and provide either a `nuts_nr` (or
`lau_nr`) to get data for multiple regions at once.

``` r
dg_call(nuts_nr = 1,
        year = 2017,
        stat_name = "AI0506")
#> # A tibble: 16 x 9
#>    id     year value name  GENESIS_source GENESIS_source_… stat_name
#>    <chr> <int> <dbl> <chr> <chr>          <chr>            <chr>    
#>  1 10     2017  76.6 Saar… Regionalatlas… 99910            AI0506   
#>  2 11     2017  75.6 Berl… Regionalatlas… 99910            AI0506   
#>  3 12     2017  73.7 Bran… Regionalatlas… 99910            AI0506   
#>  4 13     2017  70.9 Meck… Regionalatlas… 99910            AI0506   
#>  5 14     2017  75.4 Sach… Regionalatlas… 99910            AI0506   
#>  6 15     2017  68.1 Sach… Regionalatlas… 99910            AI0506   
#>  7 16     2017  74.3 Thür… Regionalatlas… 99910            AI0506   
#>  8 01     2017  76.3 Schl… Regionalatlas… 99910            AI0506   
#>  9 02     2017  76   Hamb… Regionalatlas… 99910            AI0506   
#> 10 03     2017  76.4 Nied… Regionalatlas… 99910            AI0506   
#> 11 04     2017  70.8 Brem… Regionalatlas… 99910            AI0506   
#> 12 05     2017  75.4 Nord… Regionalatlas… 99910            AI0506   
#> 13 06     2017  77   Hess… Regionalatlas… 99910            AI0506   
#> 14 07     2017  77.7 Rhei… Regionalatlas… 99910            AI0506   
#> 15 08     2017  78.3 Bade… Regionalatlas… 99910            AI0506   
#> 16 09     2017  78.1 Baye… Regionalatlas… 99910            AI0506   
#> # … with 2 more variables: stat_description <chr>,
#> #   stat_description_en <chr>
```

``` r
dg_call(nuts_nr = 1,
        year = c(2001, 2003, 2007), 
        stat_name = "BETR08", 
        substat_name = "TIERA8") 
#> # A tibble: 383 x 15
#>    id     year TIERA8 value name  GENESIS_source GENESIS_source_… stat_name
#>    <chr> <int> <chr>  <int> <chr> <chr>          <chr>            <chr>    
#>  1 10     2001 GESAMT  1494 Saar… Allgemeine Ag… 41120            BETR08   
#>  2 10     2001 TIERA…   374 Saar… Allgemeine Ag… 41120            BETR08   
#>  3 10     2001 TIERA…   964 Saar… Allgemeine Ag… 41120            BETR08   
#>  4 10     2001 TIERA…   199 Saar… Allgemeine Ag… 41120            BETR08   
#>  5 10     2001 TIERA…    67 Saar… Allgemeine Ag… 41120            BETR08   
#>  6 10     2001 TIERA…   275 Saar… Allgemeine Ag… 41120            BETR08   
#>  7 10     2001 TIERA…   237 Saar… Allgemeine Ag… 41120            BETR08   
#>  8 10     2001 TIERA…   383 Saar… Allgemeine Ag… 41120            BETR08   
#>  9 10     2003 GESAMT  1428 Saar… Allgemeine Ag… 41120            BETR08   
#> 10 10     2003 TIERA…   337 Saar… Allgemeine Ag… 41120            BETR08   
#> # … with 373 more rows, and 7 more variables: stat_description <chr>,
#> #   substat_description <chr>, param_description <chr>,
#> #   stat_description_en <chr>, substat_description_en <chr>,
#> #   param_description_en <chr>, year_id <chr>
```

``` r
dg_call(nuts_nr = 1,
        stat_name =  "BAU018",
        substat_name = "BAUAHZ",
        year = 2016)
#> # A tibble: 112 x 15
#>    id     year BAUAHZ value name  GENESIS_source GENESIS_source_… stat_name
#>    <chr> <int> <chr>  <int> <chr> <chr>          <chr>            <chr>    
#>  1 10     2016 INSGE…   369 Saar… Statistik der… 31111            BAU018   
#>  2 10     2016 BAUAH…     1 Saar… Statistik der… 31111            BAU018   
#>  3 10     2016 BAUAH…     2 Saar… Statistik der… 31111            BAU018   
#>  4 10     2016 BAUAH…    29 Saar… Statistik der… 31111            BAU018   
#>  5 10     2016 BAUAH…    13 Saar… Statistik der… 31111            BAU018   
#>  6 10     2016 BAUAH…    93 Saar… Statistik der… 31111            BAU018   
#>  7 10     2016 BAUAH…   231 Saar… Statistik der… 31111            BAU018   
#>  8 11     2016 BAUAH…     9 Berl… Statistik der… 31111            BAU018   
#>  9 11     2016 INSGE…   305 Berl… Statistik der… 31111            BAU018   
#> 10 11     2016 BAUAH…   105 Berl… Statistik der… 31111            BAU018   
#> # … with 102 more rows, and 7 more variables: stat_description <chr>,
#> #   substat_description <chr>, param_description <chr>,
#> #   stat_description_en <chr>, substat_description_en <chr>,
#> #   param_description_en <chr>, year_id <chr>
```

``` r
dg_call(nuts_nr = 2, 
        stat_name = "GEBWOR", 
        substat_name = "BAUAT2")
#> # A tibble: 418 x 15
#>    id     year BAUAT2  value name  GENESIS_source GENESIS_source_…
#>    <chr> <int> <chr>   <int> <chr> <chr>          <chr>           
#>  1 100    2011 BAUAL…  43520 Saar… Gebäude- und … 31211           
#>  2 100    2011 BAUAL…  13117 Saar… Gebäude- und … 31211           
#>  3 100    2011 BAUAL…   7663 Saar… Gebäude- und … 31211           
#>  4 100    2011 BAUAL…   5940 Saar… Gebäude- und … 31211           
#>  5 100    2011 BAUAL…   2044 Saar… Gebäude- und … 31211           
#>  6 100    2011 BAUAL… 141389 Saar… Gebäude- und … 31211           
#>  7 100    2011 BAUAL…  12017 Saar… Gebäude- und … 31211           
#>  8 100    2011 BAUAL…  47962 Saar… Gebäude- und … 31211           
#>  9 100    2011 BAUAL…  25318 Saar… Gebäude- und … 31211           
#> 10 100    2011 BAUAL…   8562 Saar… Gebäude- und … 31211           
#> # … with 408 more rows, and 8 more variables: stat_name <chr>,
#> #   stat_description <chr>, substat_description <chr>,
#> #   param_description <chr>, stat_description_en <chr>,
#> #   substat_description_en <chr>, param_description_en <chr>,
#> #   year_id <chr>
```

<!-- # ```{r} -->

<!-- # library(datenguideR) -->

<!-- # debugonce(datenguideR:::add_substat_info) -->

<!-- # dg_call(lau_nr = 1, parent_chr = 10041,  -->

<!-- #         stat_name =  "BAU018", -->

<!-- #         substat_name = "BAUAHZ",) -->

<!-- # ``` -->

## Credits and Acknowledgements

datenguideR builds on the amazing work of
[Datenguide](https://datengui.de/) and their [GraphQL
API](https://github.com/datenguide/datenguide-api). We especially thank
[Simon Jockers](https://twitter.com/sjockers), [Simon
Wörpel](https://twitter.com/simonwoerpel), and [Christian
Rijke](https://twitter.com/crijke) for their constructive feedback,
helpful comments, and overall support while developing the package.

The data is retrieved via the Datenguide API from the German Federal
Statistical Office and the statistical offices of the German states.
Data being used via this package has to be credited according to the
[Datenlizenz Deutschland – Namensnennung –
Version 2.0](https://www.govdata.de/dl-de/by-2-0).

This package was created with
[devtools](https://github.com/r-lib/devtools),
[usethis](https://github.com/r-lib/usethis), and
[roxygen2](https://github.com/r-lib/roxygen2). Continuous integration
was done with [Travis CI](https://travis-ci.org/).

## Code of Conduct

datenguideR is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.
