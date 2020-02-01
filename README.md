
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
| :- | :--------------------- | :---- | :----- |
| 01 | Schleswig-Holstein     | nuts1 | DG     |
| 02 | Hamburg                | nuts1 | DG     |
| 03 | Niedersachsen          | nuts1 | DG     |
| 04 | Bremen                 | nuts1 | DG     |
| 05 | Nordrhein-Westfalen    | nuts1 | DG     |
| 06 | Hessen                 | nuts1 | DG     |
| 07 | Rheinland-Pfalz        | nuts1 | DG     |
| 08 | Baden-Württemberg      | nuts1 | DG     |
| 09 | Bayern                 | nuts1 | DG     |
| 10 | Saarland               | nuts1 | DG     |
| 11 | Berlin                 | nuts1 | DG     |
| 12 | Brandenburg            | nuts1 | DG     |
| 13 | Mecklenburg-Vorpommern | nuts1 | DG     |
| 14 | Sachsen                | nuts1 | DG     |
| 15 | Sachsen-Anhalt         | nuts1 | DG     |
| 16 | Thüringen              | nuts1 | DG     |

Get all available meta data on statistics, substatistics, and
parameters:

``` r
datenguideR::dg_descriptions
#> # A tibble: 3,419 x 11
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
#> # … with 3,409 more rows, and 7 more variables: substat_description <chr>,
#> #   param_name <chr>, param_description <chr>, stat_description_en <chr>,
#> #   stat_description_full_en <chr>, substat_description_en <chr>,
#> #   param_description_en <chr>
```

You can also use `dg_search` to look for a variable of interest. The
function will match your string with any strings in the
`dg_descriptions` data frame, returning only rows with those matches.

Looking for variables where the string *“vote”* appears somewhere in the
documentation:

``` r
dg_search("vote")
#> # A tibble: 90 x 11
#>    stat_name stat_description stat_descriptio… substat_name
#>    <chr>     <chr>            <chr>            <chr>       
#>  1 AI0501    Zweitstimmenant… "**Zweitstimmen… <NA>        
#>  2 AI0502    Zweitstimmenant… "**Zweitstimmen… <NA>        
#>  3 AI0503    Zweitstimmenant… "**Zweitstimmen… <NA>        
#>  4 AI0504    Zweitstimmenant… "**Zweitstimmen… <NA>        
#>  5 AI0505    Zweitstimmenant… "**Zweitstimmen… <NA>        
#>  6 AI0506    Wahlbeteiligung… "**Wahlbeteilig… <NA>        
#>  7 AI0601    Stimmenanteil C… "**Stimmenantei… <NA>        
#>  8 AI0602    Stimmenanteil S… "**Stimmenantei… <NA>        
#>  9 AI0603    Stimmenanteil F… "**Stimmenantei… <NA>        
#> 10 AI0604    Stimmenanteil G… "**Stimmenantei… <NA>        
#> # … with 80 more rows, and 7 more variables: substat_description <chr>,
#> #   param_name <chr>, param_description <chr>, stat_description_en <chr>,
#> #   stat_description_full_en <chr>, substat_description_en <chr>,
#> #   param_description_en <chr>
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
#> New names:
#> * message -> message...1
#> * `` -> ...4
#> * `` -> ...5
#> * code -> code...6
#> * name -> name...8
#> * … and 3 more problems
#> Warning: Unknown or uninitialised column: 'source'.
#> # A tibble: 1 x 16
#>   message...1  line column ...4  ...5  code...6 type  name...8 message...9
#>   <chr>       <int>  <int> <chr> <chr> <chr>    <chr> <chr>    <chr>      
#> 1 [exception…     3      1 regi… AI05… INTERNA… Feat… General… [exception…
#> # … with 7 more variables: code...10 <int>, className <chr>, id <chr>,
#> #   name...16 <chr>, stat_name <chr>, stat_description <chr>,
#> #   stat_description_en <chr>
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
#> New names:
#> * message -> message...1
#> * `` -> ...4
#> * `` -> ...5
#> * code -> code...6
#> * name -> name...8
#> * … and 3 more problems
#> Warning: Unknown or uninitialised column: 'source'.
#> NULL
```

If you give no parameters for a substat, it will default to return
results for all of them.

``` r
dg_call(region_id = "11", 
        year = c(2001, 2003, 2007), 
        stat_name =  "BETR08", 
        substat_name = "TIERA8") 
#> New names:
#> * message -> message...1
#> * `` -> ...4
#> * `` -> ...5
#> * code -> code...6
#> * name -> name...8
#> * … and 3 more problems
#> Warning: Unknown or uninitialised column: 'source'.
#> NULL
```

### AllRegions

Just leave `region_id` blank and provide either a `nuts_nr` or `lau_nr`
to get data for multiple regions at once.

``` r
dg_call(nuts_nr = 1,
        year = c(2001, 2003, 2007), 
        stat_name = "BETR08", 
        substat_name = "TIERA8") 
#> NULL
```

``` r
dg_call(nuts_nr = 1,
        stat_name =  "BAU018",
        substat_name = "BAUAHZ",
        year = 2016)
#> NULL
```

``` r
dg_call(nuts_nr = 2, 
        stat_name = "GEBWOR", 
        substat_name = "BAUAT2")
#> NULL
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
