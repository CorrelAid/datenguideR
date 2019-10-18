
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

| id|name                   |level |parent |
|--:|:----------------------|:-----|:------|
| 10|Saarland               |nuts1 |DG     |
| 11|Berlin                 |nuts1 |DG     |
| 12|Brandenburg            |nuts1 |DG     |
| 13|Mecklenburg-Vorpommern |nuts1 |DG     |
| 14|Sachsen                |nuts1 |DG     |
| 15|Sachsen-Anhalt         |nuts1 |DG     |
| 16|Thüringen              |nuts1 |DG     |
|  1|Schleswig-Holstein     |nuts1 |DG     |
|  2|Hamburg                |nuts1 |DG     |
|  3|Niedersachsen          |nuts1 |DG     |
|  4|Bremen                 |nuts1 |DG     |
|  5|Nordrhein-Westfalen    |nuts1 |DG     |
|  6|Hessen                 |nuts1 |DG     |
|  7|Rheinland-Pfalz        |nuts1 |DG     |
|  8|Baden-Württemberg      |nuts1 |DG     |
|  9|Bayern                 |nuts1 |DG     |

Get all available meta data on statistics, substatistics, and parameters:

``` r
datenguideR::dg_meta
```

Alternatively, you can get a more condensed overview of all available statistics:

``` r
datenguideR::dg_descriptions %>%
  dplyr::sample_n(10) %>% 
  knitr::kable()
```

|name   |description                                        |
|:------|:--------------------------------------------------|
|AI0209 |Lebendgeborene je 10.000 Einwohner                 |
|ERWN10 |Arbeitslosenquote bez. auf abhäng. Erwerbsp.       |
|AI_Z06 |Anteil Personen mit MHG 20 bis 59 Jahre            |
|ERW006 |Arbeitslose                                        |
|PFL004 |Personal der Pflegeheime                           |
|RME009 |Räume in Wohnungen mit 7 oder mehr Räumen          |
|WAS005 |Einw. m. Anschl. an d. öffentl. Wasserversorgung   |
|ARBST2 |geleistete Arbeiterstunden                         |
|AI0304 |Anteil Schulabgänger mit allgem. Hochschulreife    |
|EKM014 |verfüg. Einkommen der priv. Haushalte je Einwohner |

Pick a statistic and put it into `dg_call()` (infos can be retrieved from `dg_meta`).

For example:

  - **Statistic:** BETR08 *(Landwirtschaftliche Betriebe mit Tierhaltung)*
  - **Substatistic:** TIERA8 *(Landwirtschaftliche Betriebe mit Viehhaltung)*
  - **Parameter:** 
    - TIERART2 *(Rinder)*
    - TIERART3 *(Schweine)*

<!-- end list -->

``` r
dg_call(region_id = "11", year = c(2001, 2007), stat_name = 'BETR08', substat_name = 'TIERA8', parameter = c("TIERART2", "TIERART3"))
# A tibble: 4 x 6
  id    name    year TIERA8 GENESIS_stat_name                           GENESIS_stat_nr
  <chr> <chr>  <int>  <int> <chr>                                       <chr>          
1 11    Berlin  2001      8 Allgemeine Agrarstrukturerhebung (bis 2007) 41120          
2 11    Berlin  2001      7 Allgemeine Agrarstrukturerhebung (bis 2007) 41120          
3 11    Berlin  2007     11 Allgemeine Agrarstrukturerhebung (bis 2007) 41120          
4 11    Berlin  2007      5 Allgemeine Agrarstrukturerhebung (bis 2007) 41120 
```
