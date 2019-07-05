
<!-- README.md is generated from README.Rmd. Please edit that file -->

# datenguideR <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/Projects)](https://cran.r-project.org/package=Projects)
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

Show overview of all available variables:

``` r
datenguideR::dg_descriptions %>%
  dplyr::sample_n(10) %>% 
  knitr::kable()
```

| name   | description                                        |
| :----- | :------------------------------------------------- |
| AI0303 | Anteil betreute Kinder 3-5 Jahre in Tageseinricht. |
| BEVZ21 | Bevölkerung in privaten Haushalten                 |
| ERWN09 | Arbeitslosenquote bez. auf alle Erwerbspers.       |
| name   | NA                                                 |
| PFL023 | mit erheblich eingeschränkter Alltagskompetenz     |
| PFL012 | Pflegebedürftige der Pflegeheime m.Kurzzeitpflege  |
| UNT019 | Handwerksunternehmen                               |
| AI0401 | Gewerbeanmeldungen je 10.000 Einwohner             |
| AI0708 | Ant ET Finanz-, Vers., Unt-dl., Grundst-, Wohngsw. |
| AI0809 | Anteil arbeitslose Ausländer an Arbeitslosen insg. |

Pick a variable and put it into `dg_call`.

For example:

  - *AI0202*: Bevölkerungsentwicklung im Jahr je 10.000 Einw.

<!-- end list -->

``` r
dg_call(variable = "AI0202", year = 1990:2018, regions = "11")
#> # A tibble: 13 x 4
#>    id    name    year AI0202
#>    <chr> <chr>  <int>  <dbl>
#>  1 11    Berlin  1995    0  
#>  2 11    Berlin  2000    0  
#>  3 11    Berlin  2005    0  
#>  4 11    Berlin  2006   26  
#>  5 11    Berlin  2007   35.9
#>  6 11    Berlin  2008   45  
#>  7 11    Berlin  2009   32  
#>  8 11    Berlin  2010   52.4
#>  9 11    Berlin  2011    0  
#> 10 11    Berlin  2012  147. 
#> 11 11    Berlin  2013  137. 
#> 12 11    Berlin  2014  139. 
#> 13 11    Berlin  2015  144.
```

This is a

![](http://www.wipsociology.org/wp-content/uploads/2017/12/banner.png)

But after

![](https://media1.tenor.com/images/72bf7922ac0b07b2f7f8f630e4ae01d2/tenor.gif?itemid=11364811)

it’s going to be

![](https://media.giphy.com/media/5fQyd7jM58m5y/giphy.gif)

![](https://media.giphy.com/media/26n6xUPFFv1DtdO80/giphy.gif)
