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

#' @importFrom httr GET
#' @importFrom httr accept
#' @importFrom httr http_status
#' @importFrom httr status_code
#' @importFrom httr http_status
#' @importFrom httr content
spget <- function(uri) {
  if (getOption("icesSharePoint.messages", default = FALSE)) {
    message("GETing ... ", uri)
  }

  x <- httr::GET(
    uri,
    SP_cred(),
    httr::accept("application/json; odata=verbose")
  )

  message(httr::http_status(x)$message)

  if (httr::status_code(x) == 403) {
    try(SP_clearpassword(), silent = TRUE)
  }

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



#' Basic POST request from SharePoint
#'
#' Implement a POST request for a given uri.
#'
#' @param uri an api request.
#' @param ... additional arguments to POST.
#'
#' @return
#' The result of the request - often there is not response from a POST.
#'
#' @details
#' The requests always ask for json data, but may on occasion (esp when
#' the request fails) return xml.
#'
#' @export

#' @importFrom httr POST
#' @importFrom httr http_status
#' @importFrom httr status_code
#' @importFrom httr content
sppost <- function(uri, ...) {
  if (getOption("icesSharePoint.messages", default = FALSE))
    message("POSTing ... ", uri)
  x <- httr::POST(uri,
                  SP_cred(),
                  ...)
  message(httr::http_status(x)$message)

  if (httr::status_code(x) == 403) {
    try(SP_clearpassword(), silent = TRUE)
  }

  invisible(httr::content(x))
}


# credential functions -------
#' @importFrom keyring key_set
#' @importFrom keyring key_get
#' @importFrom httr authenticate
SP_cred <- function() {
  username <- site_collection <- getOption("icesSharePoint.username")
  # NULL means use user system login and password values
  if (!is.null(username)) {
    password <- try(
      keyring::key_get("icesSharePoint", username),
      silent = TRUE
    )

    if (inherits(password, "try-error")) {
      keyring::key_set(
        service = "icesSharePoint",
        username = username
      )
      password <- keyring::key_get("icesSharePoint", username)
    }

    httr::authenticate(username, password, type = "ntlm")
  } else {
    httr::authenticate(":", ":", type = "ntlm")
  }
}

#' @importFrom keyring key_delete
#' @importFrom xml2 as_list
SP_clearpassword <- function() {
  username <- site_collection <- getOption("icesSharePoint.username")
  keyring::key_delete("icesSharePoint", username = username)
}

SP_fdv <- function(site, site_collection) {

  if (missing(site_collection))
    site_collection <- getOption("icesSharePoint.site_collection")

  if (missing(site))
    site <- getOption("icesSharePoint.site")

  # request FormDigestValue (authentication token)
  uri <- paste0(site_collection, site, "/_api/contextinfo")
  x <- httr::POST(uri, SP_cred())
  xml2::as_list(httr::content(x))$GetContextWebInformation$FormDigestValue[[1]]
}
