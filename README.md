
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
#> # A tibble: 3 x 9
#>    year TIERART2 TIERART3 stat_name stat_description substat_name
#>   <int>    <int>    <int> <chr>     <chr>            <chr>       
#> 1  2001        8        7 BETR08    Landwirtschaftl… TIERA8      
#> 2  2003        9        7 BETR08    Landwirtschaftl… TIERA8      
#> 3  2007       11        5 BETR08    Landwirtschaftl… TIERA8      
#> # … with 3 more variables: substat_description <chr>,
#> #   GENESIS_source <chr>, GENESIS_source_nr <chr>
```

If you give no parameters for a substat, it will default to return
results for all of them.

``` r
dg_call(region_id = "11", 
        year = c(2001, 2003, 2007), 
        stat_name = 'BETR08', 
        substat_name = 'TIERA8') 
#> # A tibble: 3 x 15
#>    year TIERART2 TIERART210 TIERART3 TIERART304 TIERART309 TIERART4
#>   <int>    <int>      <int>    <int>      <int>      <int>    <int>
#> 1  2001        3          0        8         15          8        6
#> 2  2003        0          9       12          0          9        7
#> 3  2007        3         11        5          0          0        8
#> # … with 8 more variables: TIERART502 <int>, GESAMT <int>,
#> #   stat_name <chr>, stat_description <chr>, substat_name <chr>,
#> #   substat_description <chr>, GENESIS_source <chr>,
#> #   GENESIS_source_nr <chr>
```

### AllRegions

Just leave `region_id` blank and provide either a `nuts_nr` or `lau_nr`
to get data for multiple regions at once.

``` r

dg_call(nuts_nr = 1,
        year = c(2001, 2003, 2007), 
        stat_name = 'BETR08', 
        substat_name = 'TIERA8') 
#> Joining, by = "id"
#> # A tibble: 48 x 15
#>    name  year     id TIERART2 TIERART210 TIERART3 TIERART304 TIERART309
#>    <chr> <chr> <dbl>    <int>      <int>    <int>      <int>      <int>
#>  1 Saar… 2001     10      199         67      374        383        964
#>  2 Saar… 2003     10      930        261      374        337        179
#>  3 Saar… 2007     10      267        792      128        222        316
#>  4 Berl… 2001     11        3          0        8         15          8
#>  5 Berl… 2003     11        0          9       12          0          9
#>  6 Berl… 2007     11        3         11        5          0          0
#>  7 Bran… 2001     12     3376       1243      449        969        663
#>  8 Bran… 2003     12     3084        700     1183        899        666
#>  9 Bran… 2007     12     1043       2913      403        750       1502
#> 10 Meck… 2001     13      772        497      564       1104        304
#> # … with 38 more rows, and 7 more variables: TIERART4 <int>,
#> #   TIERART502 <int>, GESAMT <int>, stat_name <chr>,
#> #   stat_description <chr>, substat_name <chr>, substat_description <chr>
```

``` r

dg_call(nuts_nr = 1,
        stat_name =  "BAU018",
        substat_name = "BAUAHZ",
        year = 2016)
#> Joining, by = "id"
#> # A tibble: 16 x 14
#>    name  year     id BAUAHZ1 BAUAHZ2 BAUAHZ3 BAUAHZ4 BAUAHZ5 BAUAHZ6 GESAMT
#>    <chr> <chr> <dbl>   <int>   <int>   <int>   <int>   <int>   <int>  <int>
#>  1 Saar… 2016     10       1      93      29     369      13       2    231
#>  2 Berl… 2016     11     105     121      57      10     305       9      3
#>  3 Bran… 2016     12      74       8     324     843       6     156    275
#>  4 Meck… 2016     13      23     172     571      50      10     299     17
#>  5 Sach… 2016     14      97      15     383       2      86     798   1381
#>  6 Sach… 2016     15       0      37      32       9     189     438    705
#>  7 Thür… 2016     16     719      10      29     198       4      37    441
#>  8 Schl… 2016      1    1143     447     539      87      22       1     47
#>  9 Hamb… 2016      2      72       2     155      31       6       3     41
#> 10 Nied… 2016      3     125     121    1755      30    1359       6   3396
#> 11 Brem… 2016      4      48       1      11      36     105       0      9
#> 12 Nord… 2016      5       7     144    1452    3666     201      51   1811
#> 13 Hess… 2016      6     119     720      27     668       5      47   1586
#> 14 Rhei… 2016      7      49     937    1657      51      14     595     11
#> 15 Bade… 2016      8     927    1500     105    1609     315       6   4462
#> 16 Baye… 2016      9    2371     509      47       6     196    4909   8038
#> # … with 4 more variables: stat_name <chr>, stat_description <chr>,
#> #   substat_name <chr>, substat_description <chr>
```
