
<!-- README.md is generated from README.Rmd. Please edit that file -->

# datenguideR <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->

[![Build\_Status](https://travis-ci.org/CorrelAid/datenguideR.svg?branch=master)](https://travis-ci.org/CorrelAid/datenguideR)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/datenguideR)](https://cran.r-project.org/package=datenguideR)
[![Codecov test
coverage](https://codecov.io/gh/CorrelAid/datenguideR/branch/master/graph/badge.svg)](https://codecov.io/gh/CorrelAid/datenguideR?branch=master)
<!-- badges: end -->

## Usage

First, install package from GitHub:

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
| -: | :--------------------- | :---- | :----- |
| 10 | Saarland               | nuts1 | DG     |
| 11 | Berlin                 | nuts1 | DG     |
| 12 | Brandenburg            | nuts1 | DG     |
| 13 | Mecklenburg-Vorpommern | nuts1 | DG     |
| 14 | Sachsen                | nuts1 | DG     |
| 15 | Sachsen-Anhalt         | nuts1 | DG     |
| 16 | Thüringen              | nuts1 | DG     |
|  1 | Schleswig-Holstein     | nuts1 | DG     |
|  2 | Hamburg                | nuts1 | DG     |
|  3 | Niedersachsen          | nuts1 | DG     |
|  4 | Bremen                 | nuts1 | DG     |
|  5 | Nordrhein-Westfalen    | nuts1 | DG     |
|  6 | Hessen                 | nuts1 | DG     |
|  7 | Rheinland-Pfalz        | nuts1 | DG     |
|  8 | Baden-Württemberg      | nuts1 | DG     |
|  9 | Bayern                 | nuts1 | DG     |

Get all available meta data on statistics, substatistics, and
parameters:

``` r
datenguideR::dg_descriptions
#> # A tibble: 3,419 x 7
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
#> # … with 3,409 more rows, and 3 more variables: substat_description <chr>,
#> #   param_name <chr>, param_description <chr>
```

Pick a statistic and put it into `dg_call()` (infos can be retrieved
from `dg_descriptions`).

For example:

  - **Statistic** AI0506 *(Wahlbeteiligung, Bundestagswahl)*

<!-- end list -->

``` r
dg_call(region_id = "11",
        year = 2002,
        stat_name = 'AI0506')
#> # A tibble: 1 x 6
#>   id    name    year AI0506 GENESIS_source            GENESIS_source_nr
#>   <chr> <chr>  <int>  <dbl> <chr>                     <chr>            
#> 1 11    Berlin  2002   77.6 Regionalatlas Deutschland 99910
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
        stat_name = 'BETR08', 
        substat_name = 'TIERA8', 
        parameter = c("TIERART2", "TIERART3")) 
#> # A tibble: 6 x 12
#>   id    name   year TIERA8 GENESIS_source GENESIS_source_… param_name
#>   <chr> <chr> <int>  <int> <chr>          <chr>            <chr>     
#> 1 11    Berl…  2001      8 Allgemeine Ag… 41120            TIERART2  
#> 2 11    Berl…  2001      7 Allgemeine Ag… 41120            TIERART3  
#> 3 11    Berl…  2003      9 Allgemeine Ag… 41120            TIERART2  
#> 4 11    Berl…  2003      7 Allgemeine Ag… 41120            TIERART3  
#> 5 11    Berl…  2007     11 Allgemeine Ag… 41120            TIERART2  
#> 6 11    Berl…  2007      5 Allgemeine Ag… 41120            TIERART3  
#> # … with 5 more variables: stat_name <chr>, stat_description <chr>,
#> #   substat_name <chr>, substat_description <chr>, param_description <chr>
```

If you give no parameters for a substat, it will default to return
results for all of them.

``` r
dg_call(region_id = "11", 
        year = c(2001, 2003, 2007), 
        stat_name = 'BETR08', 
        substat_name = 'TIERA8') 
#> # A tibble: 24 x 12
#>    id    name   year TIERA8 GENESIS_source GENESIS_source_… param_name
#>    <chr> <chr> <int>  <int> <chr>          <chr>            <chr>     
#>  1 11    Berl…  2001      3 Allgemeine Ag… 41120            TIERART2  
#>  2 11    Berl…  2001      0 Allgemeine Ag… 41120            TIERART210
#>  3 11    Berl…  2001      8 Allgemeine Ag… 41120            TIERART3  
#>  4 11    Berl…  2001     15 Allgemeine Ag… 41120            TIERART304
#>  5 11    Berl…  2001      8 Allgemeine Ag… 41120            TIERART309
#>  6 11    Berl…  2001      6 Allgemeine Ag… 41120            TIERART4  
#>  7 11    Berl…  2001      7 Allgemeine Ag… 41120            TIERART502
#>  8 11    Berl…  2001     37 Allgemeine Ag… 41120            GESAMT    
#>  9 11    Berl…  2003      0 Allgemeine Ag… 41120            TIERART2  
#> 10 11    Berl…  2003      9 Allgemeine Ag… 41120            TIERART210
#> # … with 14 more rows, and 5 more variables: stat_name <chr>,
#> #   stat_description <chr>, substat_name <chr>, substat_description <chr>,
#> #   param_description <chr>
```

### AllRegions

Just leave `region_id` blank and provide either a `nuts_nr` or `lau_nr`
to get data for multiple regions at once.

``` r

dg_call(nuts_nr = 1,
        year = c(2001, 2003, 2007), 
        stat_name = 'BETR08', 
        substat_name = 'TIERA8') 
#> Joining, by = c("id", "name")
#> # A tibble: 384 x 12
#>    name     id  year TIERA8 GENESIS_source GENESIS_source_… param_name
#>    <chr> <dbl> <int>  <int> <chr>          <chr>            <chr>     
#>  1 Saar…    10  2001    199 Allgemeine Ag… 41120            TIERART2  
#>  2 Saar…    10  2001     67 Allgemeine Ag… 41120            TIERART210
#>  3 Saar…    10  2001    374 Allgemeine Ag… 41120            TIERART3  
#>  4 Saar…    10  2001    383 Allgemeine Ag… 41120            TIERART304
#>  5 Saar…    10  2001    964 Allgemeine Ag… 41120            TIERART309
#>  6 Saar…    10  2001    275 Allgemeine Ag… 41120            TIERART4  
#>  7 Saar…    10  2001    237 Allgemeine Ag… 41120            TIERART502
#>  8 Saar…    10  2001   1494 Allgemeine Ag… 41120            GESAMT    
#>  9 Saar…    10  2003    930 Allgemeine Ag… 41120            TIERART2  
#> 10 Saar…    10  2003    261 Allgemeine Ag… 41120            TIERART210
#> # … with 374 more rows, and 5 more variables: stat_name <chr>,
#> #   stat_description <chr>, substat_description <chr>,
#> #   param_description <chr>, year_id <chr>
```

``` r

dg_call(nuts_nr = 1,
        stat_name =  "BAU018",
        substat_name = "BAUAHZ",
        year = 2016)
#> Joining, by = c("id", "name")
#> # A tibble: 112 x 12
#>    name     id  year BAUAHZ GENESIS_source GENESIS_source_… param_name
#>    <chr> <dbl> <int>  <int> <chr>          <chr>            <chr>     
#>  1 Saar…    10  2016      1 Statistik der… 31111            BAUAHZ1   
#>  2 Saar…    10  2016     93 Statistik der… 31111            BAUAHZ2   
#>  3 Saar…    10  2016     29 Statistik der… 31111            BAUAHZ3   
#>  4 Saar…    10  2016    369 Statistik der… 31111            BAUAHZ4   
#>  5 Saar…    10  2016     13 Statistik der… 31111            BAUAHZ5   
#>  6 Saar…    10  2016      2 Statistik der… 31111            BAUAHZ6   
#>  7 Saar…    10  2016    231 Statistik der… 31111            GESAMT    
#>  8 Berl…    11  2016    105 Statistik der… 31111            BAUAHZ1   
#>  9 Berl…    11  2016    121 Statistik der… 31111            BAUAHZ2   
#> 10 Berl…    11  2016     57 Statistik der… 31111            BAUAHZ3   
#> # … with 102 more rows, and 5 more variables: stat_name <chr>,
#> #   stat_description <chr>, substat_description <chr>,
#> #   param_description <chr>, year_id <chr>
```

``` r
dg_call(nuts_nr = 2, 
        stat_name = "GEBWOR", 
        substat_name = "BAUAT2", 
        long_format = T)
#> Joining, by = c("id", "name")
#> # A tibble: 319 x 12
#>    name     id  year BAUAT2 GENESIS_source GENESIS_source_… param_name
#>    <chr> <dbl> <int>  <int> <chr>          <chr>            <chr>     
#>  1 Chem…   145  2011 328111 Gebäude- und … 31211            BAUALT000…
#>  2 Chem…   145  2011 115561 Gebäude- und … 31211            BAUALT191…
#>  3 Chem…   145  2011  73313 Gebäude- und … 31211            BAUALT194…
#>  4 Chem…   145  2011  28517 Gebäude- und … 31211            BAUALT197…
#>  5 Chem…   145  2011  42270 Gebäude- und … 31211            BAUALT198…
#>  6 Chem…   145  2011   9965 Gebäude- und … 31211            BAUALT199…
#>  7 Chem…   145  2011  19734 Gebäude- und … 31211            BAUALT199…
#>  8 Chem…   145  2011   2634 Gebäude- und … 31211            BAUALT200…
#>  9 Chem…   145  2011  20728 Gebäude- und … 31211            BAUALT200…
#> 10 Chem…   145  2011   6363 Gebäude- und … 31211            BAUALT200…
#> # … with 309 more rows, and 5 more variables: stat_name <chr>,
#> #   stat_description <chr>, substat_description <chr>,
#> #   param_description <chr>, year_id <chr>
```

<!-- # ```{r} -->

<!-- # library(datenguideR) -->

<!-- # debugonce(datenguideR:::add_substat_info) -->

<!-- # dg_call(lau_nr = 1, parent_chr = 10041,  -->

<!-- #         stat_name =  "BAU018", -->

<!-- #         substat_name = "BAUAHZ",) -->

<!-- # ``` -->

## Credits and acknowledgements

datenguideR builds on the amazing work of [Datenguide](https://datengui.de/) and their [GraphQL API](https://github.com/datenguide/datenguide-api). We especially thank [Simon Jockers](https://twitter.com/sjockers), [Simon Wörpel](https://twitter.com/simonwoerpel), and [Christian Rijke](https://twitter.com/crijke) for their constructive feedback, helpful comments, and overall support while developing the package.

The data is retrieved via the Datenguide API from the German Federal Statistical Office and the statistical offices of the German states. Data being used via this package has to be credited according to the [Datenlizenz Deutschland – Namensnennung – Version 2.0](https://www.govdata.de/dl-de/by-2-0).

This package was created with [devtools](https://github.com/r-lib/devtools), [usethis](https://github.com/r-lib/usethis), and [roxygen2](https://github.com/r-lib/roxygen2). Continuous integration was done with [Travis CI](https://travis-ci.org/).
