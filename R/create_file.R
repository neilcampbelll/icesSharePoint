#' Create and delete files
#'
#' Create and delete files on the SharePoint system using JWT authentication.
#'
#' @param file a name of a file on SharePoint.
#' @param con a file connection to, or the file name of, the file to upload.
#' @param directory a directory name.
#' @param site a SharePoint site name, e.g. '/ExpertGroups/WGNSSK'.
#' @param site_collection a SharePoint site collection, will almost exclusively
#'             be 'https://community.ices.dk'.
#' @param text if `con` is not supplied, the `text` is assumed to be the contents
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
#' @importFrom httr add_headers
#' @importFrom utils URLencode
spfile.create <- function(file, con, directory, site, site_collection, text = "") {
  if (missing(site_collection))
    site_collection <- getOption("icesSharePoint.site_collection")
  
  if (missing(site))
    site <- getOption("icesSharePoint.site")
  
  # create service
  service <- sprintf("GetFolderByServerRelativeUrl('%s')/Files/add(url='%s',overwrite=true)",
                     directory, file)
  uri <- paste0(site_collection, site, "/_api/web/", utils::URLencode(service))
  
  # build POST body (i.e. the file contents)
  if (missing(con)) {
    body <- text
  } else {
    body <- httr::upload_file(con)
  }
  
  sppost(uri,
         body = body,
         httr::add_headers("X-RequestDigest" = SP_fdv(site, site_collection)))
}


#' @export
#' @rdname filecreate
spfile.delete <- function(file, directory, site, site_collection) {
  if (missing(site_collection))
    site_collection <- getOption("icesSharePoint.site_collection")
  
  if (missing(site))
    site <- getOption("icesSharePoint.site")
  
  # create service
  service <- sprintf("GetFileByServerRelativeUrl('%s/%s/%s')",
                     site, directory, file)
  uri <- paste0(site_collection, site, "/_api/web/", utils::URLencode(service))
  
  # call the service
  sppost(uri,
         httr::add_headers("X-RequestDigest" = SP_fdv(site, site_collection),
                           "X-HTTP-Method" = "DELETE"))
}


#' Update an existing file
#'
#' Update the contents of an existing file on SharePoint.
#'
#' @param file a name of a file on SharePoint.
#' @param con a file connection to, or the file name of, the file to upload.
#' @param directory a directory name.
#' @param site a SharePoint site name, e.g. '/ExpertGroups/WGNSSK'.
#' @param site_collection a SharePoint site collection.
#' @param text if `con` is not supplied, the `text` is assumed to be the contents
#'             of the file, defaulting to "".
#'
#' @return
#' invisibly returns the response from the SharePoint server
#'
#' @export
spfile.update <- function(file, con, directory, site, site_collection, text = "") {
  if (missing(site_collection))
    site_collection <- getOption("icesSharePoint.site_collection")
  
  if (missing(site))
    site <- getOption("icesSharePoint.site")
  
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
         httr::add_headers("X-RequestDigest" = SP_fdv(site, site_collection),
                           "X-HTTP-Method" = "PUT"))
}

#' Upload large files in chunks
#'
#' For large files, these functions allow uploading in chunks.
#'
#' @param file a name of a file on SharePoint.
#' @param body content to upload.
#' @param directory a directory name.
#' @param site a SharePoint site name.
#' @param site_collection a SharePoint site collection.
#' @param guid a unique identifier for the upload session.
#'
#' @return Invisibly returns the response from the SharePoint server
#'
#' @export
spfile.startupload <- function(file, body, directory, site, site_collection, guid) {
  if (missing(site_collection))
    site_collection <- getOption("icesSharePoint.site_collection")
  
  if (missing(site))
    site <- getOption("icesSharePoint.site")
  
  service <- sprintf("GetFileByServerRelativeUrl('%s/%s/%s')/startupload(uploadId=guid'%s')",
                     site, directory, file, guid)
  uri <- paste0(site_collection, site, "/_api/web/", utils::URLencode(service))
  sppost(uri, body = body, httr::add_headers(`X-RequestDigest` = SP_fdv(site, site_collection)))
}

#' @rdname spfile.startupload
#' @export
spfile.continueupload <- function(file, body, directory, site, site_collection, guid) {
  if (missing(site_collection))
    site_collection <- getOption("icesSharePoint.site_collection")
  
  if (missing(site))
    site <- getOption("icesSharePoint.site")
  
  service <- sprintf("GetFileByServerRelativeUrl('%s/%s/%s')/continueupload(uploadId=guid'%s')",
                     site, directory, file, guid)
  uri <- paste0(site_collection, site, "/_api/web/", utils::URLencode(service))
  sppost(uri, body = body, httr::add_headers(`X-RequestDigest` = SP_fdv(site, site_collection)))
}

#' @rdname spfile.startupload
#' @export
spfile.finishupload <- function(file, body, directory, site, site_collection, guid) {
  if (missing(site_collection))
    site_collection <- getOption("icesSharePoint.site_collection")
  
  if (missing(site))
    site <- getOption("icesSharePoint.site")
  
  service <- sprintf("GetFileByServerRelativeUrl('%s/%s/%s')/finishupload(uploadId=guid'%s')",
                     site, directory, file, guid)
  uri <- paste0(site_collection, site, "/_api/web/", utils::URLencode(service))
  sppost(uri, body = body, httr::add_headers(`X-RequestDigest` = SP_fdv(site, site_collection)))
}