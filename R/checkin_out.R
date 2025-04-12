#' Check-in and Check-out Files
#'
#' Check out the file first to prevent other users from changing it.
#' Then, check it back in after you've made your changes.
#'
#' @param file a name of a file on SharePoint.
#' @param directory a directory name.
#' @param site a SharePoint site name, e.g. '/ExpertGroups/WGNSSK'.
#' @param site_collection a SharePoint site collection, will almost exclusively
#'             be 'https://community.ices.dk', so these functions should work for other
#'             SharePoint sites outside ICES.
#' @param comment the checkin comment
#'
#' @return
#' invisibly returns the response from the SharePoint server
#'
#' @seealso
#' \code{\link{spfile.create}} To upload a file.
#'
#' @export
#' @rdname checkinout

spcheckout <- function(file, directory, site, site_collection) {
  if (missing(site_collection))
    site_collection <- getOption("icesSharePoint.site_collection")
  
  if (missing(site))
    site <- getOption("icesSharePoint.site")
  
  # create service
  service <- sprintf("GetFileByServerRelativeUrl('%s/%s/%s')/checkout",
                     site, directory, file)
  uri <- paste0(site_collection, site, "/_api/web/", utils::URLencode(service))
  
  # call the service
  sppost(uri,
         httr::add_headers("X-RequestDigest" = SP_fdv(site, site_collection)))
}


#' @export
#' @rdname checkinout
spundocheckout <- function(file, directory, site, site_collection) {
  if (missing(site_collection))
    site_collection <- getOption("icesSharePoint.site_collection")
  
  if (missing(site))
    site <- getOption("icesSharePoint.site")
  
  # create service
  service <- sprintf("GetFileByServerRelativeUrl('%s/%s/%s')/undocheckout",
                     site, directory, file)
  uri <- paste0(site_collection, site, "/_api/web/", utils::URLencode(service))
  
  # call the service
  sppost(uri,
         httr::add_headers("X-RequestDigest" = SP_fdv(site, site_collection)))
}


#' @export
#' @rdname checkinout
spcheckin <- function(comment, file, directory, site, site_collection) {
  if (missing(site_collection))
    site_collection <- getOption("icesSharePoint.site_collection")
  
  if (missing(site))
    site <- getOption("icesSharePoint.site")
  
  # create service
  service <- sprintf("GetFileByServerRelativeUrl('%s/%s/%s')/CheckIn(comment='%s',checkintype=0)",
                     site, directory, file, comment)
  uri <- paste0(site_collection, site, "/_api/web/", utils::URLencode(service))
  
  # call the service
  sppost(uri,
         httr::add_headers("X-RequestDigest" = SP_fdv(site, site_collection)))
}