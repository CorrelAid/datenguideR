
<!-- README.md is generated from README.Rmd. Please edit that file -->

# datenguideR <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![Build\_Status](https://travis-ci.org/CorrelAid/datenguideR.svg?branch=master)](https://travis-ci.org/CorrelAid/datenguideR)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/datenguideR)](https://cran.r-project.org/package=datenguideR)
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
datenguideR::dg_meta 
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

Alternatively, you can get a more condensed overview of all available
statistics:

``` r
datenguideR::dg_descriptions %>%
  dplyr::sample_n(10) %>% 
  knitr::kable()
```

| stat\_name | description                                      |
| :--------- | :----------------------------------------------- |
| STENW5     | Gewerbesteuereinnahmen (Aufkommen abzgl. Umlage) |
| AI\_Z15    | Wohnungen je Wohngebäude                         |
| ETG009     | Pachtentgelt je ha                               |
| AI0606     | Wahlbeteiligung, Europawahl                      |
| AI1902     | Haus- und Sperrmüll                              |
| WAS004     | Wassergewinnung                                  |
| AUSNW4     | Nettoausgaben der Gemeinden                      |
| VER009     | Getötete Personen                                |
| AEW008     | Entsorgungs- und Behandlungsanlagen              |
| UMSN3      | Auslandsumsatz                                   |

Pick a statistic and put it into `dg_call()` (infos can be retrieved
from `dg_meta`).

For example:

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
#> # A tibble: 3 x 10
#>    year TIERART2 TIERART3 stat_name stat_description stat_descriptio…
#>   <int>    <int>    <int> <chr>     <chr>            <chr>           
#> 1  2001        8        7 BETR08    Landwirtschaftl… "**Landwirtscha…
#> 2  2003        9        7 BETR08    Landwirtschaftl… "**Landwirtscha…
#> 3  2007       11        5 BETR08    Landwirtschaftl… "**Landwirtscha…
#> # … with 4 more variables: substat_name <chr>, substat_description <chr>,
#> #   GENESIS_source <chr>, GENESIS_source_nr <chr>
```
