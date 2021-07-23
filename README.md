
<!-- README.md is generated from README.Rmd. Please edit that file -->

# datenguideR <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->

[![Build_Status](https://travis-ci.org/CorrelAid/datenguideR.svg?branch=master)](https://travis-ci.org/CorrelAid/datenguideR)
[![Codecov test
coverage](https://codecov.io/gh/CorrelAid/datenguideR/branch/master/graph/badge.svg)](https://codecov.io/gh/CorrelAid/datenguideR?branch=master)
[![Licence](https://img.shields.io/badge/licence-GPL--3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)
[![Open Source
Love](https://badges.frapsoft.com/os/v2/open-source.png?v=103)](https://github.com/ellerbrock/open-source-badges/)
<!-- badges: end -->

Access and download German regional statistics from Datenguide
<http://datengui.de>. `datenguideR` provides a wrapper for their GraphQL
API and also includes metadata for all available statistics and regions.

**Overview**

-   [Usage](https://github.com/CorrelAid/datenguideR#usage)
-   [Examples](https://github.com/CorrelAid/datenguideR#examples)
    -   [Search meta data
        (`dg_search`)](https://github.com/CorrelAid/datenguideR#dg_search)
    -   [Main function
        (`dg_call`)](https://github.com/CorrelAid/datenguideR#dg_call)
    -   [Multiple regions (at
        once)](https://github.com/CorrelAid/datenguideR#multiple-regions-with-nuts_nr-or-lau_nr)
    -   [Plot data on maps
        (`dg_map`)](https://github.com/CorrelAid/datenguideR#dg_map)
-   [Use Cases](https://github.com/CorrelAid/datenguideR#use-cases)
-   [Credits and
    Acknowledgements](https://github.com/CorrelAid/datenguideR#credits-and-acknowledgements)
-   [Code of
    Conduct](https://github.com/CorrelAid/datenguideR#code-of-conduct)

## Usage

First, install `datenguideR` from GitHub:

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

| id  | name                   | level | parent |
|:----|:-----------------------|:------|:-------|
| 01  | Schleswig-Holstein     | nuts1 | DG     |
| 02  | Hamburg                | nuts1 | DG     |
| 03  | Niedersachsen          | nuts1 | DG     |
| 04  | Bremen                 | nuts1 | DG     |
| 05  | Nordrhein-Westfalen    | nuts1 | DG     |
| 06  | Hessen                 | nuts1 | DG     |
| 07  | Rheinland-Pfalz        | nuts1 | DG     |
| 08  | Baden-Württemberg      | nuts1 | DG     |
| 09  | Bayern                 | nuts1 | DG     |
| 10  | Saarland               | nuts1 | DG     |
| 11  | Berlin                 | nuts1 | DG     |
| 12  | Brandenburg            | nuts1 | DG     |
| 13  | Mecklenburg-Vorpommern | nuts1 | DG     |
| 14  | Sachsen                | nuts1 | DG     |
| 15  | Sachsen-Anhalt         | nuts1 | DG     |
| 16  | Thüringen              | nuts1 | DG     |

Get all available meta data on statistics, substatistics, and
parameters:

``` r
datenguideR::dg_descriptions
#> # A tibble: 3,419 x 11
#>    stat_name stat_description   stat_description_~ substat_name substat_descrip~
#>    <chr>     <chr>              <chr>              <chr>        <chr>           
#>  1 AENW01    Entsorgte/behande~ "**Entsorgte/beha~ NA           NA              
#>  2 AENW02    Abgelagerte Abfal~ "**Abgelagerte Ab~ NA           NA              
#>  3 AENW03    Entsorg.u.Behandl~ "**Entsorg.u.Beha~ NA           NA              
#>  4 AENW04    Entsorgte/behande~ "**Entsorgte/beha~ NA           NA              
#>  5 AENW05    Abgelagerte Abfal~ "**Abgelagerte Ab~ NA           NA              
#>  6 AENW06    Entsorg.u.Behandl~ "**Entsorg.u.Beha~ NA           NA              
#>  7 AEW001    Entsorgungs- und ~ "**Entsorgungs- u~ NA           NA              
#>  8 AEW001    Entsorgungs- und ~ "**Entsorgungs- u~ EBANL1       Entsorgungs- un~
#>  9 AEW001    Entsorgungs- und ~ "**Entsorgungs- u~ EBANL1       Entsorgungs- un~
#> 10 AEW001    Entsorgungs- und ~ "**Entsorgungs- u~ EBANL1       Entsorgungs- un~
#> # ... with 3,409 more rows, and 6 more variables: param_name <chr>,
#> #   param_description <chr>, stat_description_en <chr>,
#> #   stat_description_full_en <chr>, substat_description_en <chr>,
#> #   param_description_en <chr>
```

### `dg_search`

You can also use `dg_search` to look for a variable of interest. The
function will match your string with any strings in the
`dg_descriptions` data frame, returning only rows with those matches.

Looking for variables where the string *“vote”* appears somewhere in the
documentation:

``` r
dg_search("vote")
#> # A tibble: 90 x 11
#>    stat_name stat_description   stat_description_~ substat_name substat_descrip~
#>    <chr>     <chr>              <chr>              <chr>        <chr>           
#>  1 AI0501    Zweitstimmenantei~ "**Zweitstimmenan~ NA           NA              
#>  2 AI0502    Zweitstimmenantei~ "**Zweitstimmenan~ NA           NA              
#>  3 AI0503    Zweitstimmenantei~ "**Zweitstimmenan~ NA           NA              
#>  4 AI0504    Zweitstimmenantei~ "**Zweitstimmenan~ NA           NA              
#>  5 AI0505    Zweitstimmenantei~ "**Zweitstimmenan~ NA           NA              
#>  6 AI0506    Wahlbeteiligung, ~ "**Wahlbeteiligun~ NA           NA              
#>  7 AI0601    Stimmenanteil CDU~ "**Stimmenanteil ~ NA           NA              
#>  8 AI0602    Stimmenanteil SPD~ "**Stimmenanteil ~ NA           NA              
#>  9 AI0603    Stimmenanteil FDP~ "**Stimmenanteil ~ NA           NA              
#> 10 AI0604    Stimmenanteil GRÜ~ "**Stimmenanteil ~ NA           NA              
#> # ... with 80 more rows, and 6 more variables: param_name <chr>,
#> #   param_description <chr>, stat_description_en <chr>,
#> #   stat_description_full_en <chr>, substat_description_en <chr>,
#> #   param_description_en <chr>
```

Note: Descriptions of variables are also available in English now!
Translated via the
[`googleLanguageR`](https://github.com/ropensci/googleLanguageR)
package.

``` r
dg_search("vote") %>% 
  dplyr::select(stat_name, dplyr::contains("_en"))
#> # A tibble: 90 x 5
#>    stat_name stat_descriptio~ stat_descriptio~ substat_descrip~ param_descripti~
#>    <chr>     <chr>            <chr>            <chr>            <chr>           
#>  1 AI0501    Second Vote Sha~ "** CDU / CSU s~ NA               NA              
#>  2 AI0502    SPD Second Vote~ "** SPD second ~ NA               NA              
#>  3 AI0503    FDP Second Vote~ "** Second vote~ NA               NA              
#>  4 AI0504    Second Vote Sha~ "** GREEN secon~ NA               NA              
#>  5 AI0505    Second Vote Sha~ "** Second vote~ NA               NA              
#>  6 AI0506    Voter Turnout, ~ "** Voter turno~ NA               NA              
#>  7 AI0601    CDU / CSU, Euro~ "** CDU / CSU v~ NA               NA              
#>  8 AI0602    SPD Vote Share,~ "** SPD vote sh~ NA               NA              
#>  9 AI0603    FDP Share of Vo~ "** FDP vote sh~ NA               NA              
#> 10 AI0604    Share of Votes ~ "** GREEN share~ NA               NA              
#> # ... with 80 more rows
```

### `dg_call`

The main function of the package is `dg_call`. It gives access to all
API endpoints.

Simply pick a statistic and put it into `dg_call()` (infos can be
retrieved from `dg_descriptions`).

For example:

-   `stat_name`: AI0506 *(Wahlbeteiligung, Bundestagswahl)*
-   `region_id`: 11 (stands for Berlin)

``` r
dg_call(region_id = "11",
        year = 2017,
        stat_name = "AI0506")
#> New names:
#> * name -> name...2
#> * name -> name...6
#> # A tibble: 1 x 9
#>   id    name...2  year value GENESIS_source  name...6 stat_name stat_description
#>   <chr> <chr>    <int> <dbl> <chr>           <chr>    <chr>     <chr>           
#> 1 11    Berlin    2017  75.6 Regionalatlas ~ 99910    AI0506    Wahlbeteiligung~
#> # ... with 1 more variable: stat_description_en <chr>
```

A slightly more complex call with substatistics:

-   `stat_name`: BETR08 *(Landwirtschaftliche Betriebe mit Tierhaltung)*
-   `substat_name`: TIERA8 *(Landwirtschaftliche Betriebe mit
    Viehhaltung)*
-   `parameter`:
    -   TIERART2 *(Rinder)*
    -   TIERART3 *(Schweine)*

``` r
dg_call(region_id = "11", 
        year = c(2001, 2003, 2007), 
        stat_name = "BETR08", 
        substat_name = "TIERA8", 
        parameter = c("TIERART2", "TIERART3")) 
#> New names:
#> * name -> name...2
#> * name -> name...7
#> # A tibble: 6 x 15
#>   id    name...2  year TIERA8  value GENESIS_source           name...7 stat_name
#>   <chr> <chr>    <int> <chr>   <int> <chr>                    <chr>    <chr>    
#> 1 11    Berlin    2001 TIERAR~     8 Allgemeine Agrarstruktu~ 41120    BETR08   
#> 2 11    Berlin    2001 TIERAR~     7 Allgemeine Agrarstruktu~ 41120    BETR08   
#> 3 11    Berlin    2003 TIERAR~     9 Allgemeine Agrarstruktu~ 41120    BETR08   
#> 4 11    Berlin    2003 TIERAR~     7 Allgemeine Agrarstruktu~ 41120    BETR08   
#> 5 11    Berlin    2007 TIERAR~    11 Allgemeine Agrarstruktu~ 41120    BETR08   
#> 6 11    Berlin    2007 TIERAR~     5 Allgemeine Agrarstruktu~ 41120    BETR08   
#> # ... with 7 more variables: stat_description <chr>, substat_name <chr>,
#> #   substat_description <chr>, param_description <chr>,
#> #   stat_description_en <chr>, substat_description_en <chr>,
#> #   param_description_en <chr>
```

If you give no parameters for a substat, it will default to return
results for all of them.

``` r
dg_call(region_id = "11", 
        year = c(2001, 2003, 2007), 
        stat_name =  "BETR08", 
        substat_name = "TIERA8") 
#> New names:
#> * name -> name...2
#> * name -> name...7
#> # A tibble: 23 x 15
#>    id    name...2  year TIERA8   value GENESIS_source         name...7 stat_name
#>    <chr> <chr>    <int> <chr>    <int> <chr>                  <chr>    <chr>    
#>  1 11    Berlin    2001 TIERART~     3 Allgemeine Agrarstruk~ 41120    BETR08   
#>  2 11    Berlin    2001 TIERART2     8 Allgemeine Agrarstruk~ 41120    BETR08   
#>  3 11    Berlin    2001 TIERART~     6 Allgemeine Agrarstruk~ 41120    BETR08   
#>  4 11    Berlin    2001 TIERART~     0 Allgemeine Agrarstruk~ 41120    BETR08   
#>  5 11    Berlin    2001 TIERART3     7 Allgemeine Agrarstruk~ 41120    BETR08   
#>  6 11    Berlin    2001 TIERART4     8 Allgemeine Agrarstruk~ 41120    BETR08   
#>  7 11    Berlin    2001 TIERART~    15 Allgemeine Agrarstruk~ 41120    BETR08   
#>  8 11    Berlin    2001 GESAMT      37 Allgemeine Agrarstruk~ 41120    BETR08   
#>  9 11    Berlin    2003 TIERART~     0 Allgemeine Agrarstruk~ 41120    BETR08   
#> 10 11    Berlin    2003 TIERART2     9 Allgemeine Agrarstruk~ 41120    BETR08   
#> # ... with 13 more rows, and 7 more variables: stat_description <chr>,
#> #   substat_name <chr>, substat_description <chr>, param_description <chr>,
#> #   stat_description_en <chr>, substat_description_en <chr>,
#> #   param_description_en <chr>
```

### Multiple regions with `nuts_nr` or `lau_nr`

Instead of specifying a `region_id` for individual Bundesland (state)
data you can also use `nuts_nr` to receive data for *NUTS-1*, *NUTS-2*
and *NUTS-3*.

Just leave `region_id` blank and provide either a `nuts_nr` (or
`lau_nr`) to get data for multiple regions at once.

-   `stat_name`: AI0506 *(Wahlbeteiligung, Bundestagswahl)*

``` r
dg_call(nuts_nr = 1,
        year = 2017,
        stat_name = "AI0506")
#> # A tibble: 16 x 9
#>    id     year value name          GENESIS_source     GENESIS_source_~ stat_name
#>    <chr> <int> <dbl> <chr>         <chr>              <chr>            <chr>    
#>  1 10     2017  76.6 Saarland      Regionalatlas Deu~ 99910            AI0506   
#>  2 11     2017  75.6 Berlin        Regionalatlas Deu~ 99910            AI0506   
#>  3 12     2017  73.7 Brandenburg   Regionalatlas Deu~ 99910            AI0506   
#>  4 13     2017  70.9 Mecklenburg-~ Regionalatlas Deu~ 99910            AI0506   
#>  5 14     2017  75.4 Sachsen       Regionalatlas Deu~ 99910            AI0506   
#>  6 15     2017  68.1 Sachsen-Anha~ Regionalatlas Deu~ 99910            AI0506   
#>  7 16     2017  74.3 Thüringen     Regionalatlas Deu~ 99910            AI0506   
#>  8 01     2017  76.3 Schleswig-Ho~ Regionalatlas Deu~ 99910            AI0506   
#>  9 02     2017  76   Hamburg       Regionalatlas Deu~ 99910            AI0506   
#> 10 03     2017  76.4 Niedersachsen Regionalatlas Deu~ 99910            AI0506   
#> 11 04     2017  70.8 Bremen        Regionalatlas Deu~ 99910            AI0506   
#> 12 05     2017  75.4 Nordrhein-We~ Regionalatlas Deu~ 99910            AI0506   
#> 13 06     2017  77   Hessen        Regionalatlas Deu~ 99910            AI0506   
#> 14 07     2017  77.7 Rheinland-Pf~ Regionalatlas Deu~ 99910            AI0506   
#> 15 08     2017  78.3 Baden-Württe~ Regionalatlas Deu~ 99910            AI0506   
#> 16 09     2017  78.1 Bayern        Regionalatlas Deu~ 99910            AI0506   
#> # ... with 2 more variables: stat_description <chr>, stat_description_en <chr>
```

-   `stat_name`: BETR08 *(Landwirtschaftliche Betriebe mit Tierhaltung)*
-   `substat_name`: TIERA8 *(Landwirtschaftliche Betriebe mit
    Viehhaltung)*

``` r
dg_call(nuts_nr = 1,
        year = c(2001, 2003, 2007), 
        stat_name = "BETR08", 
        substat_name = "TIERA8") 
#> # A tibble: 383 x 15
#>    id     year TIERA8  value name   GENESIS_source    GENESIS_source_~ stat_name
#>    <chr> <int> <chr>   <int> <chr>  <chr>             <chr>            <chr>    
#>  1 10     2001 TIERAR~   374 Saarl~ Allgemeine Agrar~ 41120            BETR08   
#>  2 10     2001 TIERAR~   964 Saarl~ Allgemeine Agrar~ 41120            BETR08   
#>  3 10     2001 TIERAR~   199 Saarl~ Allgemeine Agrar~ 41120            BETR08   
#>  4 10     2001 TIERAR~    67 Saarl~ Allgemeine Agrar~ 41120            BETR08   
#>  5 10     2001 TIERAR~   275 Saarl~ Allgemeine Agrar~ 41120            BETR08   
#>  6 10     2001 TIERAR~   237 Saarl~ Allgemeine Agrar~ 41120            BETR08   
#>  7 10     2001 TIERAR~   383 Saarl~ Allgemeine Agrar~ 41120            BETR08   
#>  8 10     2001 GESAMT   1494 Saarl~ Allgemeine Agrar~ 41120            BETR08   
#>  9 10     2003 TIERAR~   337 Saarl~ Allgemeine Agrar~ 41120            BETR08   
#> 10 10     2003 TIERAR~   930 Saarl~ Allgemeine Agrar~ 41120            BETR08   
#> # ... with 373 more rows, and 7 more variables: stat_description <chr>,
#> #   substat_description <chr>, param_description <chr>,
#> #   stat_description_en <chr>, substat_description_en <chr>,
#> #   param_description_en <chr>, year_id <chr>
```

-   `stat_name`: BAU018 *Total non-residential buildings*
-   `substat_name`: BAUAHZ *Main Type of Heating*

``` r
dg_call(nuts_nr = 1,
        stat_name =  "BAU018",
        substat_name = "BAUAHZ",
        year = 2016)
#> # A tibble: 217 x 15
#>    id     year BAUAHZ  value name   GENESIS_source    GENESIS_source_~ stat_name
#>    <chr> <int> <chr>   <int> <chr>  <chr>             <chr>            <chr>    
#>  1 10     2016 INSGES~   369 Saarl~ Statistik der Ba~ 31111            BAU018   
#>  2 10     2016 BAUAHZ2     1 Saarl~ Statistik der Ba~ 31111            BAU018   
#>  3 10     2016 BAUAHZ4     2 Saarl~ Statistik der Ba~ 31111            BAU018   
#>  4 10     2016 BAUAHZ5    29 Saarl~ Statistik der Ba~ 31111            BAU018   
#>  5 10     2016 BAUAHZ1    13 Saarl~ Statistik der Ba~ 31111            BAU018   
#>  6 10     2016 BAUAHZ3    93 Saarl~ Statistik der Ba~ 31111            BAU018   
#>  7 10     2016 BAUAHZ6   231 Saarl~ Statistik der Ba~ 31111            BAU018   
#>  8 10     2016 BAUAHZ1    21 Saarl~ Statistik der Ba~ 31111            BAU018   
#>  9 10     2016 BAUAHZ3    94 Saarl~ Statistik der Ba~ 31111            BAU018   
#> 10 10     2016 INSGES~   321 Saarl~ Statistik der Ba~ 31111            BAU018   
#> # ... with 207 more rows, and 7 more variables: stat_description <chr>,
#> #   substat_description <chr>, param_description <chr>,
#> #   stat_description_en <chr>, substat_description_en <chr>,
#> #   param_description_en <chr>, year_id <chr>
```

<!-- ```{r} -->
<!-- dg_call(nuts_nr = 2,  -->
<!--         stat_name = "GEBWOR",  -->
<!--         substat_name = "BAUAT2") -->
<!-- ``` -->
<!-- # ```{r} -->
<!-- # library(datenguideR) -->
<!-- # debugonce(datenguideR:::add_substat_info) -->
<!-- # dg_call(lau_nr = 1, parent_chr = 10041,  -->
<!-- #         stat_name =  "BAU018", -->
<!-- #         substat_name = "BAUAHZ",) -->
<!-- # ``` -->

### `dg_map`

You can also use `dg_map` to plot retrieved data on a Germany map. This
currently only supports NUTS-1 and NUTS-2. Arguments are (mostly)
identical to `dg_call`.

``` r
dg_map(nuts_nr = 1,
        year = 2017,
        stat_name = "AI0506")
```

<img src="man/figures/README-unnamed-chunk-14-1.png" width="100%" />

The output is a ggplot object and can be manipulated further.

``` r
dg_map(nuts_nr = 1,
        year = 2017,
        stat_name = "AI0506") +
  ggthemes::theme_map() +
  ggplot2::scale_fill_viridis_c("Voter Turnout") +
  ggplot2::ggtitle("Voter Turnout in German Parliamentary Election (2017)") +
  ggplot2::theme(legend.position = "right")
```

<img src="man/figures/README-unnamed-chunk-15-1.png" width="100%" /> You
can also return the data and use your own plotting functions with
`return_data = TRUE`.

``` r
turnout_dat <- dg_map(nuts_nr = 1,
        year = 2017,
        stat_name = "AI0506",
        return_data = T)

turnout_dat
#> Simple feature collection with 16 features and 18 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 5.866251 ymin: 47.27012 xmax: 15.04181 ymax: 55.05653
#> Geodetic CRS:  WGS 84
#> First 10 features:
#>    GID_0  NAME_0    GID_1                 NAME_1                  VARNAME_1
#> 1    DEU Germany  DEU.1_1      Baden-Württemberg                       <NA>
#> 2    DEU Germany  DEU.2_1                 Bayern                    Bavaria
#> 3    DEU Germany  DEU.3_1                 Berlin                       <NA>
#> 4    DEU Germany  DEU.4_1            Brandenburg                       <NA>
#> 5    DEU Germany  DEU.5_1                 Bremen                       <NA>
#> 6    DEU Germany  DEU.6_1                Hamburg                       <NA>
#> 7    DEU Germany  DEU.7_1                 Hessen                      Hesse
#> 8    DEU Germany  DEU.8_1 Mecklenburg-Vorpommern Mecklenburg-West Pomerania
#> 9    DEU Germany  DEU.9_1          Niedersachsen               Lower Saxony
#> 10   DEU Germany DEU.10_1    Nordrhein-Westfalen     North Rhine-Westphalia
#>    NL_NAME_1               TYPE_1 ENGTYPE_1 CC_1 HASC_1 id year value
#> 1       <NA>                 Land     State   08  DE.BW 08 2017  78.3
#> 2       <NA>            Freistaat      <NA>   09  DE.BY 09 2017  78.1
#> 3       <NA>                 Land     State   11  DE.BE 11 2017  75.6
#> 4       <NA>                 Land     State   12  DE.BR 12 2017  73.7
#> 5       <NA>     Freie Hansestadt     State   04  DE.HB 04 2017  70.8
#> 6       <NA> Freie und Hansestadt     State   02  DE.HH 02 2017  76.0
#> 7       <NA>                 Land     State   06  DE.HE 06 2017  77.0
#> 8       <NA>                 Land     State   13  DE.MV 13 2017  70.9
#> 9       <NA>                 Land     State   03  DE.NI 03 2017  76.4
#> 10      <NA>                 Land     State   05  DE.NW 05 2017  75.4
#>               GENESIS_source GENESIS_source_nr stat_name
#> 1  Regionalatlas Deutschland             99910    AI0506
#> 2  Regionalatlas Deutschland             99910    AI0506
#> 3  Regionalatlas Deutschland             99910    AI0506
#> 4  Regionalatlas Deutschland             99910    AI0506
#> 5  Regionalatlas Deutschland             99910    AI0506
#> 6  Regionalatlas Deutschland             99910    AI0506
#> 7  Regionalatlas Deutschland             99910    AI0506
#> 8  Regionalatlas Deutschland             99910    AI0506
#> 9  Regionalatlas Deutschland             99910    AI0506
#> 10 Regionalatlas Deutschland             99910    AI0506
#>                   stat_description             stat_description_en
#> 1  Wahlbeteiligung, Bundestagswahl Voter Turnout, Federal Election
#> 2  Wahlbeteiligung, Bundestagswahl Voter Turnout, Federal Election
#> 3  Wahlbeteiligung, Bundestagswahl Voter Turnout, Federal Election
#> 4  Wahlbeteiligung, Bundestagswahl Voter Turnout, Federal Election
#> 5  Wahlbeteiligung, Bundestagswahl Voter Turnout, Federal Election
#> 6  Wahlbeteiligung, Bundestagswahl Voter Turnout, Federal Election
#> 7  Wahlbeteiligung, Bundestagswahl Voter Turnout, Federal Election
#> 8  Wahlbeteiligung, Bundestagswahl Voter Turnout, Federal Election
#> 9  Wahlbeteiligung, Bundestagswahl Voter Turnout, Federal Election
#> 10 Wahlbeteiligung, Bundestagswahl Voter Turnout, Federal Election
#>                          geometry
#> 1  MULTIPOLYGON (((8.708021 47...
#> 2  MULTIPOLYGON (((9.740664 47...
#> 3  MULTIPOLYGON (((13.17136 52...
#> 4  MULTIPOLYGON (((12.26716 52...
#> 5  MULTIPOLYGON (((8.711424 53...
#> 6  MULTIPOLYGON (((10.2106 53....
#> 7  MULTIPOLYGON (((8.680588 49...
#> 8  MULTIPOLYGON (((11.49583 54...
#> 9  MULTIPOLYGON (((6.761945 53...
#> 10 MULTIPOLYGON (((8.059656 50...
```

## Use Cases

Check out some use cases. For example here:

-   [Correlaid Meetup - datenguideR
    workshop](https://github.com/TripLLL/weRnuts3)

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
[Datenlizenz Deutschland – Namensnennung – Version
2.0](https://www.govdata.de/dl-de/by-2-0).

This package was created with
[devtools](https://github.com/r-lib/devtools),
[usethis](https://github.com/r-lib/usethis), and
[roxygen2](https://github.com/r-lib/roxygen2). Continuous integration
was done with [Travis CI](https://travis-ci.org/).

## Code of Conduct

datenguideR is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.
