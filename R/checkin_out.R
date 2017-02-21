
#' @export
spcheckout <- function(fname, dir, site, site_collection) {

  # create service
  service <- sprintf("GetFileByServerRelativeUrl('%s/%s/%s')/checkout", site, dir, fname)
  uri <- paste0(site_collection, site, "/_api/web/", URLencode(service))

  # call the service
  sppost(uri,
         httr::add_headers("X-RequestDigest" = SP_fdv(site, site_collection)))
}


#' @export
spundocheckout <- function(fname, dir, site, site_collection) {

  # create service
  service <- sprintf("GetFileByServerRelativeUrl('%s/%s/%s')/undocheckout", site, dir, fname)
  uri <- paste0(site_collection, site, "/_api/web/", URLencode(service))

  # call the service
  sppost(uri,
         httr::add_headers("X-RequestDigest" = SP_fdv(site, site_collection)))
}


#' @export
spcheckin <- function(comment, fname, dir, site, site_collection, checkintype = 0) {

  # create service
  service <- sprintf("GetFileByServerRelativeUrl('%s/%s/%s')/CheckIn(comment='%s',checkintype=%i)",
                     site, dir, fname, comment, checkintype)
  uri <- paste0(site_collection, site, "/_api/web/", URLencode(service))

  # call the service
  sppost(uri,
         httr::add_headers("X-RequestDigest" = SP_fdv(site, site_collection)))
}
