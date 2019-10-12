
<!-- README.md is generated from README.Rmd. Please edit that file -->

# datenguideR <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/datenguideR)](https://cran.r-project.org/package=datenguideR)
[![Build Status](https://travis-ci.org/CorrelAid/datenguideR.svg?branch=master)](https://travis-ci.org/CorrelAid/datenguideR)
<!-- badges: end -->

## Usage

First, install package from GitHub:

``` r
devtools::install_github("CorrelAid/datenguideR", ref = "dev")
```

Load package:

``` r
library(datenguideR)
```

## Examples

Show overview of all available statistics:

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

Pick a statistic and put it into `dg_call`.

For example:

  - *BETR08*: Landwirtschaftliche Betriebe mit Tierhaltung

<!-- end list -->

``` r
dg_call(region_id = "11", year = c(2001, 2007), stat_name = 'BETR08', substat_name = 'TIERA8', parameter = c("TIERART2", "TIERART3"))
# A tibble: 4 x 4
  id    name    year TIERA8
  <chr> <chr>  <int>  <int>
1 11    Berlin  2001      8
2 11    Berlin  2001      7
3 11    Berlin  2007     11
4 11    Berlin  2007      5
```
