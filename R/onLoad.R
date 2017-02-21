

.onLoad <- function(libname, pkgname) {

  # default package options
  opts <-
    c(
      "icesSharePoint.messages" = "FALSE",
      "icesSharePoint.site_collection" = "'https://community.ices.dk'",
      "icesSharePoint.site" = "''",
      "icesSharePoint.wd" = "''"
    )
  # set only those not previouslyt set
  for (i in setdiff(names(opts), names(options()))) {
    eval(parse(text = paste0("options(", i , "=", opts[i], ")")))
  }

  # read environment file
  readRenviron(.SP_eviron_file)

  invisible()
}
