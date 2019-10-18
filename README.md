
<!-- README.md is generated from README.Rmd. Please edit that file -->

# datenguideR <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![Build_Status](https://travis-ci.org/CorrelAid/datenguideR.svg?branch=master)](https://travis-ci.org/CorrelAid/datenguideR)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/datenguideR)](https://cran.r-project.org/package=datenguideR)
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
#> # A tibble: 914 x 6
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
#>  9 AEW002    Entsorgte/behan… "**Entsorgte/be… <NA>        
#> 10 AEW003    Abgegebene Abfa… "**Abgegebene A… <NA>        
#> # … with 904 more rows, and 2 more variables: substat_description <chr>,
#> #   parameter <list>
```

Alternatively, you can get a more condensed overview of all available
statistics:

``` r
datenguideR::dg_descriptions %>%
  dplyr::sample_n(10) %>% 
  knitr::kable()
```

| stat\_name | description                                        |
| :--------- | :------------------------------------------------- |
| GEW013     | Gewerbeabmeldungen (ohne Automatenaufsteller)      |
| AENW05     | Abgelagerte Abfallmenge in Deponien                |
| KIND34     | Betreute Kinder von unter 14 Jahren                |
| PEN081     | Einpendler(innen) über Kreisgrenzen (Arbeitsort)   |
| PER005     | Tätige Personen                                    |
| STENW5     | Gewerbesteuereinnahmen (Aufkommen abzgl. Umlage)   |
| AI0708     | Ant ET Finanz-, Vers., Unt-dl., Grundst-, Wohngsw. |
| AI1902     | Haus- und Sperrmüll                                |
| BWS005     | BWS zu Herstellungspreisen in jeweiligen Preisen   |
| AI1405     | Plätze in Pflegeheimen je 1.000 Einw. ab 65 Jahre  |

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
dg_call(region_id = "11", year = c(2001, 2007), stat_name = 'BETR08', substat_name = 'TIERA8', parameter = c("TIERART2", "TIERART3"))
#> # A tibble: 4 x 4
#>   id    name    year TIERA8
#>   <chr> <chr>  <int>  <int>
#> 1 11    Berlin  2001      8
#> 2 11    Berlin  2001      7
#> 3 11    Berlin  2007     11
#> 4 11    Berlin  2007      5
```
