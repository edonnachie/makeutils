#' Copy a Makefile template to project root directory
#'
#' This function is inspired by the `usethis` package. It copies a Makefile
#' template to the project root, containing generic rules for building R
#' projects. If a Makefile already exists, the template is created as
#' `Makefile_template`.
#'
#' @return Output of file.copy, signifying success of operation
#' @export
use_make <- function() {
  outfile <- here::here("Makefile")
  if (file.exists(outfile)) outfile <- here::here("Makefile_template")
  file.copy(
    system.file("Makefile_generic.txt", package = "makeutils"),
    outfile
  )
}
