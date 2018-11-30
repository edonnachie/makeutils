#' Copy a Makefile template to project root directory
#'
#' This function is inspired by the `usethis` package. It copies a Makefile
#' template to the project root, containing generic rules for building R
#' projects.
#' @return Output of file.copy, signifying success of operation
#' @export
use_make <- function() {
  file.copy(
    system.file("Makefile_generic.txt", package = "makeutils"),
    here::here("Makefile")
  )
}
