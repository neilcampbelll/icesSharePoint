
#' @export
spget <- function(uri) {
  if (getOption("icesSharePoint.messages", default = FALSE))
    message("GETing ... ", uri)
  x <- httr::GET(uri,
                 SP_cred(),
                 httr::accept("application/json; odata=verbose"))
  httr::content(x)
}

#' @export
spservice <- function(service, site, site_collection) {

  if (missing(site_collection))
    site_collection <- getOption("icesSharePoint.site_collection")

  if (missing(site))
    site <- getOption("icesSharePoint.site")

  uri <- paste0(site_collection, site, "/_api/web/", utils::URLencode(service))
  res <- spget(uri)

  # if result is of type d$results$ ...
  if (is.list(res) && identical(names(res), "d")) {
    res$d$results
  } else {
    res
  }
}
