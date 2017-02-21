
#' @export
spfile.create <- function(fname, file, dir, site, site_collection, text = "") {

  # create service
  service <- sprintf("GetFolderByServerRelativeUrl('%s')/Files/add(url='%s',overwrite=true)", dir, fname)
  uri <- paste0(site_collection, site, "/_api/web/", utils::URLencode(service))

  # build POST body (i.e. the file contents)
  if (missing(file)) {
    body <- text
  } else {
    body <- paste(readLines(file), collapse = "\n")
  }

  sppost(uri,
         body = body,
         httr::add_headers("X-RequestDigest" = SP_fdv(site, site_collection)))

}


#' @export
spfile.delete <- function(fname, dir, site, site_collection) {

  # create service
  service <- sprintf("GetFileByServerRelativeUrl('%s/%s/%s')", site, dir, fname)
  uri <- paste0(site_collection, site, "/_api/web/", utils::URLencode(service))

  # call the service
  sppost(uri,
         httr::add_headers("X-RequestDigest" = SP_fdv(site, site_collection),
                           "X-HTTP-Method" = "DELETE"))
}


#' @export
spfile.update <- function(fname, file, dir, site, site_collection, text = "") {

  # Check out the file first to prevent other users from changing it.
  # Then, check it back in after you've made your changes.
  # See the CheckOut method and the CheckIn method.

  # create service
  service <- sprintf("GetFileByServerRelativeUrl('%s/%s/%s')/$value", site, dir, fname)
  uri <- paste0(site_collection, site, "/_api/web/", URLencode(service))

  # build POST body (i.e. the file contents)
  if (missing(file)) {
    body <- text
  } else {
    body <- paste(readLines(file), collapse = "\n")
  }

  # call the service
  sppost(uri,
         body = body,
         httr::add_headers("X-RequestDigest" = SP_fdv(),
                           "X-HTTP-Method" = "PUT"))
}
