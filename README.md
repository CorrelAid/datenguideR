
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
#>    stat_name stat_description stat_descriptio~ substat_name
#>    <chr>     <chr>            <chr>            <chr>       
#>  1 AENW01    Entsorgte/behan~ "**Entsorgte/be~ <NA>        
#>  2 AENW02    Abgelagerte Abf~ "**Abgelagerte ~ <NA>        
#>  3 AENW03    Entsorg.u.Behan~ "**Entsorg.u.Be~ <NA>        
#>  4 AENW04    Entsorgte/behan~ "**Entsorgte/be~ <NA>        
#>  5 AENW05    Abgelagerte Abf~ "**Abgelagerte ~ <NA>        
#>  6 AENW06    Entsorg.u.Behan~ "**Entsorg.u.Be~ <NA>        
#>  7 AEW001    Entsorgungs- un~ "**Entsorgungs-~ <NA>        
#>  8 AEW001    Entsorgungs- un~ "**Entsorgungs-~ EBANL1      
#>  9 AEW001    Entsorgungs- un~ "**Entsorgungs-~ EBANL1      
#> 10 AEW001    Entsorgungs- un~ "**Entsorgungs-~ EBANL1      
#> # ... with 3,409 more rows, and 3 more variables:
#> #   substat_description <chr>, param_name <chr>, param_description <chr>
```

Pick a statistic and put it into `dg_call()` (infos can be retrieved
from `dg_descriptions`).

For example:

  - **Statistic:** AI0506 *(Wahlbeteiligung, Bundestagswahl)*

<!-- end list -->

``` r
dg_call(region_id = "11",
        year = 2002,
        stat_name = "AI0506")
#> # A tibble: 1 x 6
#>   id    name    year value GENESIS_source            GENESIS_source_nr
#>   <chr> <chr>  <int> <dbl> <chr>                     <chr>            
#> 1 11    Berlin  2002  77.6 Regionalatlas Deutschland 99910
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
#> # A tibble: 6 x 12
#>   id    name   year TIERA8 value GENESIS_source GENESIS_source_~ stat_name
#>   <chr> <chr> <int> <chr>  <int> <chr>          <chr>            <chr>    
#> 1 11    Berl~  2001 TIERA~     8 Allgemeine Ag~ 41120            BETR08   
#> 2 11    Berl~  2001 TIERA~     7 Allgemeine Ag~ 41120            BETR08   
#> 3 11    Berl~  2003 TIERA~     9 Allgemeine Ag~ 41120            BETR08   
#> 4 11    Berl~  2003 TIERA~     7 Allgemeine Ag~ 41120            BETR08   
#> 5 11    Berl~  2007 TIERA~    11 Allgemeine Ag~ 41120            BETR08   
#> 6 11    Berl~  2007 TIERA~     5 Allgemeine Ag~ 41120            BETR08   
#> # ... with 4 more variables: stat_description <chr>, substat_name <chr>,
#> #   substat_description <chr>, param_description <chr>
```

If you give no parameters for a substat, it will default to return
results for all of them.

``` r
dg_call(region_id = "11", 
        year = c(2001, 2003, 2007), 
        stat_name =  "BETR08", 
        substat_name = "TIERA8") 
#> # A tibble: 23 x 12
#>    id    name   year TIERA8 value GENESIS_source GENESIS_source_~ stat_name
#>    <chr> <chr> <int> <chr>  <int> <chr>          <chr>            <chr>    
#>  1 11    Berl~  2001 GESAMT    37 Allgemeine Ag~ 41120            BETR08   
#>  2 11    Berl~  2001 TIERA~     3 Allgemeine Ag~ 41120            BETR08   
#>  3 11    Berl~  2001 TIERA~     8 Allgemeine Ag~ 41120            BETR08   
#>  4 11    Berl~  2001 TIERA~     6 Allgemeine Ag~ 41120            BETR08   
#>  5 11    Berl~  2001 TIERA~     0 Allgemeine Ag~ 41120            BETR08   
#>  6 11    Berl~  2001 TIERA~     7 Allgemeine Ag~ 41120            BETR08   
#>  7 11    Berl~  2001 TIERA~     8 Allgemeine Ag~ 41120            BETR08   
#>  8 11    Berl~  2001 TIERA~    15 Allgemeine Ag~ 41120            BETR08   
#>  9 11    Berl~  2003 GESAMT    33 Allgemeine Ag~ 41120            BETR08   
#> 10 11    Berl~  2003 TIERA~     0 Allgemeine Ag~ 41120            BETR08   
#> # ... with 13 more rows, and 4 more variables: stat_description <chr>,
#> #   substat_name <chr>, substat_description <chr>, param_description <chr>
```

### AllRegions

Just leave `region_id` blank and provide either a `nuts_nr` or `lau_nr`
to get data for multiple regions at once.

``` r
dg_call(nuts_nr = 1,
        year = c(2001, 2003, 2007), 
        stat_name = "BETR08", 
        substat_name = "TIERA8") 
#> # A tibble: 383 x 12
#>    name     id  year TIERA8 value GENESIS_source GENESIS_source_~ stat_name
#>    <chr> <dbl> <int> <chr>  <int> <chr>          <chr>            <chr>    
#>  1 Saar~    10  2001 GESAMT  1494 Allgemeine Ag~ 41120            BETR08   
#>  2 Saar~    10  2001 TIERA~   374 Allgemeine Ag~ 41120            BETR08   
#>  3 Saar~    10  2001 TIERA~   964 Allgemeine Ag~ 41120            BETR08   
#>  4 Saar~    10  2001 TIERA~   199 Allgemeine Ag~ 41120            BETR08   
#>  5 Saar~    10  2001 TIERA~    67 Allgemeine Ag~ 41120            BETR08   
#>  6 Saar~    10  2001 TIERA~   275 Allgemeine Ag~ 41120            BETR08   
#>  7 Saar~    10  2001 TIERA~   237 Allgemeine Ag~ 41120            BETR08   
#>  8 Saar~    10  2001 TIERA~   383 Allgemeine Ag~ 41120            BETR08   
#>  9 Saar~    10  2003 GESAMT  1428 Allgemeine Ag~ 41120            BETR08   
#> 10 Saar~    10  2003 TIERA~   337 Allgemeine Ag~ 41120            BETR08   
#> # ... with 373 more rows, and 4 more variables: stat_description <chr>,
#> #   substat_description <chr>, param_description <chr>, year_id <chr>
```

``` r
dg_call(nuts_nr = 1,
        stat_name =  "BAU018",
        substat_name = "BAUAHZ",
        year = 2016)
#> # A tibble: 112 x 12
#>    name     id  year BAUAHZ value GENESIS_source GENESIS_source_~ stat_name
#>    <chr> <dbl> <int> <chr>  <int> <chr>          <chr>            <chr>    
#>  1 Saar~    10  2016 INSGE~   369 Statistik der~ 31111            BAU018   
#>  2 Saar~    10  2016 BAUAH~     1 Statistik der~ 31111            BAU018   
#>  3 Saar~    10  2016 BAUAH~     2 Statistik der~ 31111            BAU018   
#>  4 Saar~    10  2016 BAUAH~    29 Statistik der~ 31111            BAU018   
#>  5 Saar~    10  2016 BAUAH~    13 Statistik der~ 31111            BAU018   
#>  6 Saar~    10  2016 BAUAH~    93 Statistik der~ 31111            BAU018   
#>  7 Saar~    10  2016 BAUAH~   231 Statistik der~ 31111            BAU018   
#>  8 Berl~    11  2016 BAUAH~     9 Statistik der~ 31111            BAU018   
#>  9 Berl~    11  2016 INSGE~   305 Statistik der~ 31111            BAU018   
#> 10 Berl~    11  2016 BAUAH~   105 Statistik der~ 31111            BAU018   
#> # ... with 102 more rows, and 4 more variables: stat_description <chr>,
#> #   substat_description <chr>, param_description <chr>, year_id <chr>
```

``` r
dg_call(nuts_nr = 2, 
        stat_name = "GEBWOR", 
        substat_name = "BAUAT2")
#> # A tibble: 319 x 12
#>    name     id  year BAUAT2  value GENESIS_source GENESIS_source_~
#>    <chr> <dbl> <int> <chr>   <int> <chr>          <chr>           
#>  1 Chem~   145  2011 BAUAL~   2634 Gebäude- und ~ 31211           
#>  2 Chem~   145  2011 BAUAL~  73313 Gebäude- und ~ 31211           
#>  3 Chem~   145  2011 BAUAL~  28517 Gebäude- und ~ 31211           
#>  4 Chem~   145  2011 BAUAL~ 115561 Gebäude- und ~ 31211           
#>  5 Chem~   145  2011 BAUAL~  19734 Gebäude- und ~ 31211           
#>  6 Chem~   145  2011 BAUAL~   9026 Gebäude- und ~ 31211           
#>  7 Chem~   145  2011 BAUAL~   9965 Gebäude- und ~ 31211           
#>  8 Chem~   145  2011 BAUAL~  42270 Gebäude- und ~ 31211           
#>  9 Chem~   145  2011 BAUAL~  20728 Gebäude- und ~ 31211           
#> 10 Chem~   145  2011 BAUAL~   6363 Gebäude- und ~ 31211           
#> # ... with 309 more rows, and 5 more variables: stat_name <chr>,
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
