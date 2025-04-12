#' Basic GET request from SharePoint using JWT authentication
#'
#' Implement a GET request for a given URI using JWT authentication.
#'
#' @param uri an API request.
#'
#' @return
#' The result of the request.
#'
#' @details
#' The requests always ask for JSON data, but may on occasion (especially when
#' the request fails) return XML. Authentication is handled via JWT token.
#'
#' @export
#' @importFrom httr GET
#' @importFrom httr accept
#' @importFrom httr http_status
#' @importFrom httr status_code
#' @importFrom httr content
spget <- function(uri) {
  if (getOption("icesSharePoint.messages", default = FALSE)) {
    message("GETing ... ", uri)
  }
  
  # Get JWT token
  jwt <- getOption("icesConnect.jwt")
  if (is.null(jwt)) {
    stop("JWT token not set. Use set_jwt_auth() or options(icesConnect.jwt = token) to set a JWT token.")
  }
  
  # Make request with JWT authentication
  x <- httr::GET(
    uri,
    httr::add_headers(Authorization = paste("Bearer", jwt)),
    httr::accept("application/json; odata=verbose")
  )
  
  message(httr::http_status(x)$message)
  
  if (httr::status_code(x) == 401) {
    stop("Unauthorized: JWT token may be invalid or expired.")
  }
  
  httr::content(x)
}

#' REST API request from SharePoint
#'
#' Implement a REST API request using JWT authentication. This function wraps up an API request into
#' a single URI and calls it.
#'
#' @param service an API request.
#' @param site a SharePoint site name, e.g. '/ExpertGroups/WGNSSK'. The default
#'             is to take the value of getOption("icesSharePoint.site").
#' @param site_collection a SharePoint site collection, will almost exclusively
#'             be 'https://community.ices.dk'. The default
#'             is to take the value of getOption("icesSharePoint.site_collection").
#'
#' @return
#' The result of the request.
#'
#' @details
#' The requests always ask for JSON data, but may on occasion (especially when
#' the request fails) return XML.
#'
#' @examples
#' \dontrun{
#'  set_jwt_auth(jwt_file = "jwt.txt")
#'  x <- spservice("sitegroups/getbyname('ICES%20staff')/Users")
#'  cbind(sapply(x$results, "[[", "Title"),
#'        sapply(x$results, "[[", "Email"))
#' }
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
#' Implement a POST request for a given URI using JWT authentication.
#'
#' @param uri an API request.
#' @param ... additional arguments to POST.
#'
#' @return
#' The result of the request - often there is no response from a POST.
#'
#' @details
#' The requests always ask for JSON data, but may on occasion (especially when
#' the request fails) return XML.
#'
#' @export
#' @importFrom httr POST
#' @importFrom httr http_status
#' @importFrom httr status_code
#' @importFrom httr content
sppost <- function(uri, ...) {
  if (getOption("icesSharePoint.messages", default = FALSE))
    message("POSTing ... ", uri)
  
  # Get JWT token
  jwt <- getOption("icesConnect.jwt")
  if (is.null(jwt)) {
    stop("JWT token not set. Use set_jwt_auth() or options(icesConnect.jwt = token) to set a JWT token.")
  }
  
  # Make request with JWT authentication
  x <- httr::POST(
    uri,
    httr::add_headers(Authorization = paste("Bearer", jwt)),
    ...
  )
  
  message(httr::http_status(x)$message)
  
  if (httr::status_code(x) == 401) {
    stop("Unauthorized: JWT token may be invalid or expired.")
  }
  
  invisible(httr::content(x))
}

#' Get Form Digest Value
#'
#' Request a FormDigestValue (authentication token) for SharePoint operations 
#' that require it.
#'
#' @param site a SharePoint site name
#' @param site_collection a SharePoint site collection
#'
#' @return The FormDigestValue string
#'
#' @importFrom xml2 as_list
SP_fdv <- function(site, site_collection) {
  if (missing(site_collection))
    site_collection <- getOption("icesSharePoint.site_collection")
  
  if (missing(site))
    site <- getOption("icesSharePoint.site")
  
  # Get JWT token
  jwt <- getOption("icesConnect.jwt")
  if (is.null(jwt)) {
    stop("JWT token not set. Use set_jwt_auth() or options(icesConnect.jwt = token) to set a JWT token.")
  }
  
  # Request FormDigestValue (authentication token)
  uri <- paste0(site_collection, site, "/_api/contextinfo")
  x <- httr::POST(
    uri, 
    httr::add_headers(Authorization = paste("Bearer", jwt))
  )
  
  if (httr::status_code(x) == 401) {
    stop("Unauthorized: JWT token may be invalid or expired.")
  }
  
  xml2::as_list(httr::content(x))$GetContextWebInformation$FormDigestValue[[1]]
}
