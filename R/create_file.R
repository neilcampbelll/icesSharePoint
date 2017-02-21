#' Create and delete files
#'
#' Create and delete files on the SharePoint system.
#'
#' @param file a name of a file on sharepoint.
#' @param con a file connection to, or the file name of, the file to upload.
#' @param directory a directory name.
#' @param site a SharePoint site name, e.g. '/ExpertGroups/WGNSSK'.
#' @param site_collection a SharePoint site collection, will almost exclusively
#'             be 'https://community.ices.dk', so these functions should work for other
#'             SharePoint sites outside ICES.
#' @param text if `con` is not supplied, the `text` is assummed to be the contents
#'             of the file, defaulting to "".
#'
#' @return
#' invisibly returns the response from the SharePoint server
#'
#' @seealso
#' \code{\link{spcheckout}} To upload a file.
#'
#' @export
#' @rdname filecreate

spfile.create <- function(file, con, directory, site, site_collection, text = "") {

  # create service
  service <- sprintf("GetFolderByServerRelativeUrl('%s')/Files/add(url='%s',overwrite=true)",
                     directory, file)
  uri <- paste0(site_collection, site, "/_api/web/", utils::URLencode(service))

  # build POST body (i.e. the file contents)
  if (missing(con)) {
    body <- text
  } else {
    body <- paste(readLines(con), collapse = "\n")
  }

  sppost(uri,
         body = body,
         httr::add_headers("X-RequestDigest" = SP_fdv(site, site_collection)))

}


#' @export
#' @rdname filecreate

spfile.delete <- function(file, directory, site, site_collection) {

  # create service
  service <- sprintf("GetFileByServerRelativeUrl('%s/%s/%s')",
                     site, directory, file)
  uri <- paste0(site_collection, site, "/_api/web/", utils::URLencode(service))

  # call the service
  sppost(uri,
         httr::add_headers("X-RequestDigest" = SP_fdv(site, site_collection),
                           "X-HTTP-Method" = "DELETE"))
}


spfile.update <- function(file, con, directory, site, site_collection, text = "") {

  # Check out the file first to prevent other users from changing it.
  # Then, check it back in after you've made your changes.
  # See the CheckOut method and the CheckIn method.

  # create service
  service <- sprintf("GetFileByServerRelativeUrl('%s/%s/%s')/$value",
                     site, directory, file)
  uri <- paste0(site_collection, site, "/_api/web/", utils::URLencode(service))

  # build POST body (i.e. the file contents)
  if (missing(con)) {
    body <- text
  } else {
    body <- paste(readLines(con), collapse = "\n")
  }

  # call the service
  sppost(uri,
         body = body,
         httr::add_headers("X-RequestDigest" = SP_fdv(),
                           "X-HTTP-Method" = "PUT"))
}
