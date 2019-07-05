
<!-- README.md is generated from README.Rmd. Please edit that file -->

# datenguideR

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

| name    | description                                  |
| :------ | :------------------------------------------- |
| BEV085  | Zuzüge über die Kreisgrenzen                 |
| FLC006  | Gebietsfläche                                |
| PFL008  | Pflegedienste                                |
| PEN099  | Pendlersaldo (über Kreisgrenze)              |
| AI\_Z16 | Eigentümerquote                              |
| PFL021  | Pflegegeldempfänger                          |
| STEU09  | Gewerbesteuerumlage                          |
| AI0706  | Anteil Erwerbstätige Dienstleistungsbereiche |
| AI2104  | Empfänger Arbeitslosengeld II                |
| AI\_Z19 | Durchschnittliche Wohnfläche je Wohnung      |

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
