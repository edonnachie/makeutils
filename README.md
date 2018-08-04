# makeutils
Utility functions to parse and work with Makefiles

This R package contains utility functions for working with Makefiles. Its primary purpose is to extract rules and create a tidy data.frame (more accurately, a "tibble") with a mapping between targets and dependencies.

## Installation

```r
devtools::install_github("edonnachie/makeutils")
```

## Basic use

```r
library(makeutils)
parse_makefile("Makefile")
```

## Related Packages

Other packages are available to create Makefiles using R ([`MakefileR`](https://github.com/krlmlr/MakefileR), [`datamake`](https://github.com/jchrom/datamake)). These packages appear to be dormant, with focus turning to more modern systems such as ([`drake`](https://github.com/ropensci/drake)).

## License

This package is released under a GPL-3 license. It is provided as-is with no guarantee for functionality.
