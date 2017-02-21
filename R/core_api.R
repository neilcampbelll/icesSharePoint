#' Basic GET request from SharePoint
#'
#' Implement a GET request for a given uri.
#'
#' @param uri an api request.
#'
#' @return
#' The result of the request.
#'
#' @details
#' The requests always ask for json data, but may on occasion (esp when
#' the request fails) return xml.
#'
#'
#' @export

spget <- function(uri) {
  if (getOption("icesSharePoint.messages", default = FALSE))
    message("GETing ... ", uri)
  x <- httr::GET(uri,
                 SP_cred(),
                 httr::accept("application/json; odata=verbose"))
  httr::content(x)
}

#' REST API request from SharePoint
#'
#' Implement a REST API request.  This function wraps up an API request into
#' single uri and calls it
#'
#' @param service an api request.
#' @param site a SharePoint site name, e.g. '/ExpertGroups/WGNSSK'. The default
#'             is to take the value of getOption("icesSharePoint.site").
#' @param site_collection a SharePoint site collection, will almost exclusively
#'             be 'https://community.ices.dk', so these functions should work for other
#'             SharePoint sites outside ICES. The default
#'             is to take the value of getOption("icesSharePoint.site_collection").
#'
#' @return
#' The result of the request.
#'
#' @details
#' The requests always ask for json data, but may on occasion (esp when
#' the request fails) return xml.
#'
#' @examples
#' \dontrun{
#'  x <- spservice("sitegroups/getbyname('ICES%20staff')/Users")
#' cbind(sapply(x$results, "[[", "Title"),
#'       sapply(x$results, "[[", "Email"))
#' }
#' @export

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
    res$d
  } else {
    res
  }
}
