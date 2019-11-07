
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
        stat_name = 'BETR08', 
        substat_name = 'TIERA8', 
        parameter = c("TIERART2", "TIERART3")) 
#> # A tibble: 6 x 7
#>   id    name    year TIERA8  value GENESIS_source          GENESIS_source_…
#>   <chr> <chr>  <int> <chr>   <int> <chr>                   <chr>           
#> 1 11    Berlin  2001 TIERAR…     8 Allgemeine Agrarstrukt… 41120           
#> 2 11    Berlin  2001 TIERAR…     7 Allgemeine Agrarstrukt… 41120           
#> 3 11    Berlin  2003 TIERAR…     9 Allgemeine Agrarstrukt… 41120           
#> 4 11    Berlin  2003 TIERAR…     7 Allgemeine Agrarstrukt… 41120           
#> 5 11    Berlin  2007 TIERAR…    11 Allgemeine Agrarstrukt… 41120           
#> 6 11    Berlin  2007 TIERAR…     5 Allgemeine Agrarstrukt… 41120
```

If you give no parameters for a substat, it will default to return
results for all of them.

``` r
dg_call(region_id = "11", 
        year = c(2001, 2003, 2007), 
        stat_name = 'BETR08', 
        substat_name = 'TIERA8') 
#> # A tibble: 23 x 7
#>    id    name    year TIERA8  value GENESIS_source         GENESIS_source_…
#>    <chr> <chr>  <int> <chr>   <int> <chr>                  <chr>           
#>  1 11    Berlin  2001 GESAMT     37 Allgemeine Agrarstruk… 41120           
#>  2 11    Berlin  2001 TIERAR…     3 Allgemeine Agrarstruk… 41120           
#>  3 11    Berlin  2001 TIERAR…     8 Allgemeine Agrarstruk… 41120           
#>  4 11    Berlin  2001 TIERAR…     6 Allgemeine Agrarstruk… 41120           
#>  5 11    Berlin  2001 TIERAR…     0 Allgemeine Agrarstruk… 41120           
#>  6 11    Berlin  2001 TIERAR…     7 Allgemeine Agrarstruk… 41120           
#>  7 11    Berlin  2001 TIERAR…     8 Allgemeine Agrarstruk… 41120           
#>  8 11    Berlin  2001 TIERAR…    15 Allgemeine Agrarstruk… 41120           
#>  9 11    Berlin  2003 GESAMT     33 Allgemeine Agrarstruk… 41120           
#> 10 11    Berlin  2003 TIERAR…     0 Allgemeine Agrarstruk… 41120           
#> # … with 13 more rows
```

### AllRegions

Just leave `region_id` blank and provide either a `nuts_nr` or `lau_nr`
to get data for multiple regions at once.

``` r

dg_call(nuts_nr = 1,
        year = c(2001, 2003, 2007), 
        stat_name = 'BETR08', 
        substat_name = 'TIERA8') 
#> # A tibble: 383 x 7
#>    id     year TIERA8   value name   GENESIS_source        GENESIS_source_…
#>    <chr> <int> <chr>    <int> <chr>  <chr>                 <chr>           
#>  1 10     2001 GESAMT    1494 Saarl… Allgemeine Agrarstru… 41120           
#>  2 10     2001 TIERART…   374 Saarl… Allgemeine Agrarstru… 41120           
#>  3 10     2001 TIERART2   964 Saarl… Allgemeine Agrarstru… 41120           
#>  4 10     2001 TIERART…   199 Saarl… Allgemeine Agrarstru… 41120           
#>  5 10     2001 TIERART…    67 Saarl… Allgemeine Agrarstru… 41120           
#>  6 10     2001 TIERART3   275 Saarl… Allgemeine Agrarstru… 41120           
#>  7 10     2001 TIERART4   237 Saarl… Allgemeine Agrarstru… 41120           
#>  8 10     2001 TIERART…   383 Saarl… Allgemeine Agrarstru… 41120           
#>  9 10     2003 GESAMT    1428 Saarl… Allgemeine Agrarstru… 41120           
#> 10 10     2003 TIERART…   337 Saarl… Allgemeine Agrarstru… 41120           
#> # … with 373 more rows
```

``` r

dg_call(nuts_nr = 1,
        stat_name =  "BAU018",
        substat_name = "BAUAHZ",
        year = 2016)
#> # A tibble: 112 x 7
#>    id     year BAUAHZ   value name    GENESIS_source       GENESIS_source_…
#>    <chr> <int> <chr>    <int> <chr>   <chr>                <chr>           
#>  1 10     2016 INSGESA…   369 Saarla… Statistik der Bauge… 31111           
#>  2 10     2016 BAUAHZ2      1 Saarla… Statistik der Bauge… 31111           
#>  3 10     2016 BAUAHZ4      2 Saarla… Statistik der Bauge… 31111           
#>  4 10     2016 BAUAHZ5     29 Saarla… Statistik der Bauge… 31111           
#>  5 10     2016 BAUAHZ1     13 Saarla… Statistik der Bauge… 31111           
#>  6 10     2016 BAUAHZ3     93 Saarla… Statistik der Bauge… 31111           
#>  7 10     2016 BAUAHZ6    231 Saarla… Statistik der Bauge… 31111           
#>  8 11     2016 BAUAHZ2      9 Berlin  Statistik der Bauge… 31111           
#>  9 11     2016 INSGESA…   305 Berlin  Statistik der Bauge… 31111           
#> 10 11     2016 BAUAHZ1    105 Berlin  Statistik der Bauge… 31111           
#> # … with 102 more rows
```

``` r
dg_call(nuts_nr = 2, 
        stat_name = "GEBWOR", 
        substat_name = "BAUAT2")
#> # A tibble: 319 x 7
#>    id     year BAUAT2    value name   GENESIS_source       GENESIS_source_…
#>    <chr> <int> <chr>     <int> <chr>  <chr>                <chr>           
#>  1 145    2011 BAUALT2…   2634 Chemn… Gebäude- und Wohnun… 31211           
#>  2 145    2011 BAUALT1…  73313 Chemn… Gebäude- und Wohnun… 31211           
#>  3 145    2011 BAUALT1…  28517 Chemn… Gebäude- und Wohnun… 31211           
#>  4 145    2011 BAUALT0… 115561 Chemn… Gebäude- und Wohnun… 31211           
#>  5 145    2011 BAUALT1…  19734 Chemn… Gebäude- und Wohnun… 31211           
#>  6 145    2011 BAUALT1…   9026 Chemn… Gebäude- und Wohnun… 31211           
#>  7 145    2011 BAUALT2…   9965 Chemn… Gebäude- und Wohnun… 31211           
#>  8 145    2011 BAUALT1…  42270 Chemn… Gebäude- und Wohnun… 31211           
#>  9 145    2011 BAUALT1…  20728 Chemn… Gebäude- und Wohnun… 31211           
#> 10 145    2011 BAUALT2…   6363 Chemn… Gebäude- und Wohnun… 31211           
#> # … with 309 more rows
```

<!-- # ```{r} -->

<!-- # library(datenguideR) -->

<!-- # debugonce(datenguideR:::add_substat_info) -->

<!-- # dg_call(lau_nr = 1, parent_chr = 10041,  -->

<!-- #         stat_name =  "BAU018", -->

<!-- #         substat_name = "BAUAHZ",) -->

<!-- # ``` -->

## Credits and acknowledgements

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
