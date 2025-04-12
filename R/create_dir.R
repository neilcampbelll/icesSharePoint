#' Create and delete folders
#'
#' Create and delete folders on the SharePoint system using JWT authentication.
#'
#' @param folder a name of a folder on SharePoint.
#' @param directory a directory name.
#' @param site a SharePoint site name, e.g. '/ExpertGroups/WGNSSK'.
#' @param site_collection a SharePoint site collection, will almost exclusively
#'             be 'https://community.ices.dk'.
#'
#' @return
#' invisibly returns the response from the SharePoint server
#'
#' @seealso
#' \code{\link{spfile.create}, \link{spfile.delete}} To upload a file and delete files.
#'
#' @export
#' @rdname dircreate

spdir.create <- function(folder, directory, site, site_collection) {
  if (missing(site_collection))
    site_collection <- getOption("icesSharePoint.site_collection")
  
  if (missing(site))
    site <- getOption("icesSharePoint.site")
  
  # create service
  uri <- paste0(site_collection, site, "/_api/web/folders")
  
  # build POST body (i.e. the folder metadata)
  body <- sprintf("{ '__metadata': { 'type': 'SP.Folder' }, 'ServerRelativeUrl': '%s/%s'}",
                  directory, folder)
  
  # send request
  sppost(uri,
         body = body,
         httr::accept("application/json;odata=verbose"),
         httr::content_type("application/json;odata=verbose"),
         httr::add_headers("X-RequestDigest" = SP_fdv(site, site_collection)))
}

#' @export
#' @rdname dircreate
spdir.delete <- function(folder, directory, site, site_collection) {
  if (missing(site_collection))
    site_collection <- getOption("icesSharePoint.site_collection")
  
  if (missing(site))
    site <- getOption("icesSharePoint.site")
  
  # create service
  service <- sprintf("GetFolderByServerRelativeUrl('%s/%s')", directory, folder)
  uri <- paste0(site_collection, site, "/_api/web/", utils::URLencode(service))
  
  # send request
  sppost(uri,
         httr::add_headers("X-RequestDigest" = SP_fdv(site, site_collection),
                           "X-HTTP-Method" = "DELETE"))
}