#' Download Files from SharePoint
#'
#' Download file from sharepoint and return file location.
#'
#' @param file a name of a file on sharepoint.
#' @param site a SharePoint site name, e.g. '/ExpertGroups/WGNSSK'.
#' @param site_collection a SharePoint site collection, will almost exclusively
#'             be 'https://community.ices.dk', so these functions should work for other
#'             SharePoint sites outside ICES.
#' @param destdir a relative path of the directory to download the file to.
#'
#' @return
#' The path of the downloaded file
#'
#'
#' @export

spgetfile <- function(file, site, site_collection, destdir = dirname(file)) {
  if (missing(site_collection)) {
    site_collection <- getOption("icesSharePoint.site_collection")
  }

  if (missing(site)) {
    site <- getOption("icesSharePoint.site")
  }

  infname <- utils::URLencode(paste0(site, "/", file))
  service <- sprintf("/getfilebyserverrelativeurl('%s')/$value", infname)
  ret <- spservice(service, site = site, site_collection = site_collection)

  outfname <- paste0(destdir, "/", basename(file))
  if (!dir.exists(destdir)) dir.create(destdir, recursive = TRUE)

  writeBin(ret, outfname)
  invisible(outfname)
}
