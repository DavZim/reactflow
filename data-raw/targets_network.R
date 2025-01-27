if (requireNamespace("targets", quietly = TRUE)) {
  
  file <- "data.csv"
  if (file.exists(file) || file.exists("_targets.R")) 
    stop("Found data.csv or _targets.R in current directory, aborting to not overwrite existing files.")
  
  on.exit(file.remove(file), add = TRUE)
  
  n <- 1000
  data <- data.frame(x = rnorm(n), y = rnorm(n))
  write.csv(data, file, row.names = FALSE)
  
  script <- "
      library(targets)
      
      get_data <- function(file) {
        read.csv(file)
      }
      
      fit_model <- function(data) {
        lm(y ~ x, data) |> coefficients()
      }
      
      plot_model <- function(model, data, plot_title) {
        plot(data$x, data$y, main = plot_title)
        abline(a = model[1], b = model[2], col = \"red\")
      }
      
      list(
        tar_target(file, \"data.csv\", format = \"file\"),
        tar_target(data, get_data(file)),
        tar_target(plot_title, \"My Targets Plot\"),
        tar_target(model, fit_model(data)),
        tar_target(plot, plot_model(model, data, plot_title))
      )"
  writeLines(script, "_targets.R")
  on.exit(file.remove("_targets.R"), add = TRUE)
  
  targets::tar_make()
  on.exit(unlink("_targets", recursive = TRUE, force = TRUE), add = TRUE)
  
  script2 <- gsub("My Targets Plot", "My Targets Plot using reactflow", script)
  writeLines(script2, "_targets.R")
  
  targets_network <- targets::tar_network()
  targets_meta <- targets::tar_meta()
  
  usethis::use_data(targets_network, overwrite = TRUE)
  usethis::use_data(targets_meta, overwrite = TRUE)
}
