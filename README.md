
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

  - **Statistic** AI0506 *(Wahlbeteiligung, Bundestagswahl)*

<!-- end list -->

``` r
dg_call(region_id = "11",
        year = 2002,
        stat_name = 'AI0506')
#> New names:
#> * `` -> ...4
#> * `` -> ...5
#> * `` -> ...6
#> * `` -> ...7
#> # A tibble: 1 x 14
#>   message  line column ...4  ...5  ...6  ...7  code  id    name   year
#>   <chr>   <int>  <int> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <int>
#> 1 "Float~     3     32 regi~ AI05~ 0     AI05~ INTE~ 11    Berl~  2002
#> # ... with 3 more variables: AI0506 <lgl>, GENESIS_source <chr>,
#> #   GENESIS_source_nr <chr>
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
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> * ... and 43 more problems
#> # A tibble: 6 x 60
#>   ...1  ...2  ...3  ...4  ...5  ...6  line...7 column...8 line...9
#>   <chr> <chr> <chr> <chr> <chr> <chr>    <int>      <int>    <int>
#> 1 "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~        4          7        4
#> 2 "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~        4          7        4
#> 3 "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~        4          7        4
#> 4 "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~        4          7        4
#> 5 "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~        4          7        4
#> 6 "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~        4          7        4
#> # ... with 51 more variables: column...10 <int>, line...11 <int>,
#> #   column...12 <int>, line...13 <int>, column...14 <int>,
#> #   line...15 <int>, column...16 <int>, line...17 <int>,
#> #   column...18 <int>, ...19 <chr>, ...20 <chr>, ...21 <chr>, ...22 <chr>,
#> #   ...23 <chr>, ...24 <chr>, ...25 <chr>, ...26 <chr>, ...27 <chr>,
#> #   ...28 <chr>, ...29 <chr>, ...30 <chr>, ...31 <chr>, ...32 <chr>,
#> #   ...33 <chr>, ...34 <chr>, ...35 <chr>, ...36 <chr>, ...37 <chr>,
#> #   ...38 <chr>, ...39 <chr>, ...40 <chr>, ...41 <chr>, ...42 <chr>,
#> #   ...43 <chr>, ...44 <chr>, ...45 <chr>, ...46 <chr>, ...47 <chr>,
#> #   ...48 <chr>, id <chr>, name <chr>, year <int>, TIERA8 <lgl>,
#> #   GENESIS_source <chr>, GENESIS_source_nr <chr>, param_name <chr>,
#> #   stat_name <chr>, stat_description <chr>, substat_name <chr>,
#> #   substat_description <chr>, param_description <chr>
```

If you give no parameters for a substat, it will default to return
results for all of them.

``` r
dg_call(region_id = "11", 
        year = c(2001, 2003, 2007), 
        stat_name = 'BETR08', 
        substat_name = 'TIERA8') 
#> New names:
#> * `` -> ...1
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> * ... and 187 more problems
#> # A tibble: 24 x 204
#>    ...1   ...2  ...3  ...4  ...5  ...6  ...7  ...8  ...9  ...10 ...11 ...12
#>    <chr>  <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr>
#>  1 "Floa~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~
#>  2 "Floa~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~
#>  3 "Floa~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~
#>  4 "Floa~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~
#>  5 "Floa~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~
#>  6 "Floa~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~
#>  7 "Floa~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~
#>  8 "Floa~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~
#>  9 "Floa~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~
#> 10 "Floa~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~ "Flo~
#> # ... with 14 more rows, and 192 more variables: ...13 <chr>, ...14 <chr>,
#> #   ...15 <chr>, ...16 <chr>, ...17 <chr>, ...18 <chr>, ...19 <chr>,
#> #   ...20 <chr>, ...21 <chr>, ...22 <chr>, ...23 <chr>, ...24 <chr>,
#> #   line...25 <int>, column...26 <int>, line...27 <int>,
#> #   column...28 <int>, line...29 <int>, column...30 <int>,
#> #   line...31 <int>, column...32 <int>, line...33 <int>,
#> #   column...34 <int>, line...35 <int>, column...36 <int>,
#> #   line...37 <int>, column...38 <int>, line...39 <int>,
#> #   column...40 <int>, line...41 <int>, column...42 <int>,
#> #   line...43 <int>, column...44 <int>, line...45 <int>,
#> #   column...46 <int>, line...47 <int>, column...48 <int>,
#> #   line...49 <int>, column...50 <int>, line...51 <int>,
#> #   column...52 <int>, line...53 <int>, column...54 <int>,
#> #   line...55 <int>, column...56 <int>, line...57 <int>,
#> #   column...58 <int>, line...59 <int>, column...60 <int>,
#> #   line...61 <int>, column...62 <int>, line...63 <int>,
#> #   column...64 <int>, line...65 <int>, column...66 <int>,
#> #   line...67 <int>, column...68 <int>, line...69 <int>,
#> #   column...70 <int>, line...71 <int>, column...72 <int>, ...73 <chr>,
#> #   ...74 <chr>, ...75 <chr>, ...76 <chr>, ...77 <chr>, ...78 <chr>,
#> #   ...79 <chr>, ...80 <chr>, ...81 <chr>, ...82 <chr>, ...83 <chr>,
#> #   ...84 <chr>, ...85 <chr>, ...86 <chr>, ...87 <chr>, ...88 <chr>,
#> #   ...89 <chr>, ...90 <chr>, ...91 <chr>, ...92 <chr>, ...93 <chr>,
#> #   ...94 <chr>, ...95 <chr>, ...96 <chr>, ...97 <chr>, ...98 <chr>,
#> #   ...99 <chr>, ...100 <chr>, ...101 <chr>, ...102 <chr>, ...103 <chr>,
#> #   ...104 <chr>, ...105 <chr>, ...106 <chr>, ...107 <chr>, ...108 <chr>,
#> #   ...109 <chr>, ...110 <chr>, ...111 <chr>, ...112 <chr>, ...
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
#>    name     id  year TIERA8 GENESIS_source GENESIS_source_~ param_name
#>    <chr> <dbl> <int> <lgl>  <chr>          <chr>            <chr>     
#>  1 Saar~    10  2001 NA     Allgemeine Ag~ 41120            TIERART2  
#>  2 Saar~    10  2001 NA     Allgemeine Ag~ 41120            TIERART210
#>  3 Saar~    10  2001 NA     Allgemeine Ag~ 41120            TIERART3  
#>  4 Saar~    10  2001 NA     Allgemeine Ag~ 41120            TIERART304
#>  5 Saar~    10  2001 NA     Allgemeine Ag~ 41120            TIERART309
#>  6 Saar~    10  2001 NA     Allgemeine Ag~ 41120            TIERART4  
#>  7 Saar~    10  2001 NA     Allgemeine Ag~ 41120            TIERART502
#>  8 Saar~    10  2001 NA     Allgemeine Ag~ 41120            GESAMT    
#>  9 Saar~    10  2003 NA     Allgemeine Ag~ 41120            TIERART2  
#> 10 Saar~    10  2003 NA     Allgemeine Ag~ 41120            TIERART210
#> # ... with 374 more rows, and 5 more variables: stat_name <chr>,
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
#>    name     id  year BAUAHZ GENESIS_source GENESIS_source_~ param_name
#>    <chr> <dbl> <int> <lgl>  <chr>          <chr>            <chr>     
#>  1 Saar~    10  2016 NA     Statistik der~ 31111            BAUAHZ1   
#>  2 Saar~    10  2016 NA     Statistik der~ 31111            BAUAHZ2   
#>  3 Saar~    10  2016 NA     Statistik der~ 31111            BAUAHZ3   
#>  4 Saar~    10  2016 NA     Statistik der~ 31111            BAUAHZ4   
#>  5 Saar~    10  2016 NA     Statistik der~ 31111            BAUAHZ5   
#>  6 Saar~    10  2016 NA     Statistik der~ 31111            BAUAHZ6   
#>  7 Saar~    10  2016 NA     Statistik der~ 31111            GESAMT    
#>  8 Berl~    11  2016 NA     Statistik der~ 31111            BAUAHZ1   
#>  9 Berl~    11  2016 NA     Statistik der~ 31111            BAUAHZ2   
#> 10 Berl~    11  2016 NA     Statistik der~ 31111            BAUAHZ3   
#> # ... with 102 more rows, and 5 more variables: stat_name <chr>,
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
#>    name     id  year BAUAT2 GENESIS_source GENESIS_source_~ param_name
#>    <chr> <dbl> <int> <lgl>  <chr>          <chr>            <chr>     
#>  1 Chem~   145  2011 NA     Gebäude- und ~ 31211            BAUALT000~
#>  2 Chem~   145  2011 NA     Gebäude- und ~ 31211            BAUALT191~
#>  3 Chem~   145  2011 NA     Gebäude- und ~ 31211            BAUALT194~
#>  4 Chem~   145  2011 NA     Gebäude- und ~ 31211            BAUALT197~
#>  5 Chem~   145  2011 NA     Gebäude- und ~ 31211            BAUALT198~
#>  6 Chem~   145  2011 NA     Gebäude- und ~ 31211            BAUALT199~
#>  7 Chem~   145  2011 NA     Gebäude- und ~ 31211            BAUALT199~
#>  8 Chem~   145  2011 NA     Gebäude- und ~ 31211            BAUALT200~
#>  9 Chem~   145  2011 NA     Gebäude- und ~ 31211            BAUALT200~
#> 10 Chem~   145  2011 NA     Gebäude- und ~ 31211            BAUALT200~
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
