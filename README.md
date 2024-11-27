
<!-- README.md is generated from README.Rmd. Please edit that file -->

# reactflow

An experimental R package to use
[`@xyflow/react`](https://reactflow.dev) in R and shiny. Not working at
the moment!

## Development

Clone the repository

``` r
system("yarn install")
system("yarn run webpack")

devtools::document()
devtools::install(quick = TRUE)

# start a shiny app that should display a flow
shiny::runApp()
```
