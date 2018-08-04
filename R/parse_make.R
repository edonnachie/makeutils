extract_rules <- function(mk){
  out <- list()
  rule <- 0
  continued <- FALSE
  for (i in seq_along(mk)) {
    # Skip comments
    if (grepl("^#", mk[i])) next

    # Find rules
    # 1. No whitespace at start of line
    # 2. Colon (TODO: can quoted colons be ignored?)
    # 3. No "=", as this designates a variable
    if (grepl("^[^ \t]", mk[[i]]) &
        !grepl("=", mk[[i]]) &
        grepl(":", mk[i])) {
      rule <- rule + 1
      out[[rule]] <- mk[i]
      continued <- grepl("\\\\$", mk[i])
    } else if (continued) {
      # Continue rule if previous line was escaped
      out[[rule]] <- paste0(out[[rule]], mk[i])
      continued <- grepl("\\\\$", mk[i])
    }
  }
  out <- lapply(out, function(x) gsub("\t", "", x))
  out <- lapply(out, function(x) gsub("\\\\", "", x))
  return(out)
}

#' @importFrom tibble tibble
#' @importFrom dplyr mutate
#' @importFrom dplyr filter
#' @importFrom tidyr unnest
#' @importFrom tidyr separate
#' @importFrom tidyr separate_rows
#' @importFrom purr map
parse_rule <- function(rule) {
  tibble::tibble(rule = rule) %>%
    tidyr::separate(rule, sep = ":",
                    into = c("target", "prerequisite")) %>%
    tidyr::separate_rows(prerequisite, sep = " +") %>%
    dplyr::mutate(target = gsub(" ", "", target),
                   prerequisite = gsub(" ", "", prerequisite)) %>%
    dplyr::filter(prerequisite != "",
                  target != prerequisite,
                  target != ".PHONY") %>%
    dplyr::mutate(is_pattern = grepl("%", target) | grepl("%", prerequisite))
}


#' Extract targets and dependencies from a Makefile
#'
#' The function tries to identify all rules contained in a Makefile,
#' returning a tidy data frame with a mapping between targets and
#' dependencies. Each rule from the Makefile is thus transformed
#' to give one row per dependency. The original Makefile rules are
#' preserved in the columns ´rule_id` and `rule`.
#'
#' No attempt is made to fully parse the Makefile according to the
#' GNU make specification. In particular, the following elements are
#' ignored: imported files, commands, comments, variables.
#'
#' @param makefile A filename or file connection specifying the Makefile (Default: "Makefile")
#' @return a tibble
#' @importFrom tibble tibble
#' @importFrom dplyr mutate
#' @importFrom tidyr unnest
#' @importFrom purr map
#' @export
parse_makefile <- function(makefile = "Makefile") {
  mk <- readLines(makefile)
  mk_rules <- extract_rules(mk)
  mk_rules_df <- tibble::tibble(
    "rule_id" = 1:length(mk_rules),
    "rule" = unlist(mk_rules)
    ) %>%
    dplyr::mutate(parsed = purrr::map(rule, parse_rule)) %>%
    tidyr::unnest()
  return(mk_rules_df)
}
