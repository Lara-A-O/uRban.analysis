
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="man/figures/urban_analysis_logo.png" align="right" height="200"/>

# uRban.analysis

This package aims to support decision-makers with ready-to-use analyses
of urban phenomena, especially urban heat.

## Requirements

This package requires following packages

\-`dplyr` -`geodata` -`ggplot2` -`ggspatial` -`sf` -`terra` -`tidyterra`

``` r
#Check if packages are missing and install automatically 
packages_needed <- c("terra", "sf", "ggplot2", "dplyr", "tidyterra", "geodata", "ggspatial")
not_installed <- packages_needed[!(packages_needed %in% installed.packages () [,"Package"])]
if(length(not_installed)) install.packages(not_installed)

print(paste(length(not_installed), "package had to be installed."))
#> [1] "0 package had to be installed."
```

## Installation

You can install the development version of uRban.analysis from
[GitHub](https://github.com/) with:

``` r
Package installation can be done directly by calling: 
  'devtools::install_github("Lara-A-O/uRban.analysis")'

pak::pak("Lara-A-O/uRban.analysis")
```

## Functions

| Function | Short Description |
|----|----|
| `get_city_boundary()` | Gets the boundary of a german city |
| `get_LST()` | Calculates the Land Surface Temperature (LST) for the city out of a given Landsat Acquisition |
| `LST_plotted()` | Creates a ready-to-use map of the LST |
| `get_LULC()` | Prepares the corine dataset for the next steps |
| `LULC_plotted()` | Creates a ready-to-use map of the Land Use/Land Cover (LULC) of the city |
| `statistics_LULC_LST()` | Creates boxplots of the temperature distribution within the LULC Classes |

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(uRban.analysis)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
