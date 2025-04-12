#' Download Files from SharePoint using JWT authentication
#'
#' Download file from SharePoint and return file location.
#'
#' @param file a name of a file on SharePoint.
#' @param site a SharePoint site name, e.g. '/ExpertGroups/WGNSSK'.
#' @param site_collection a SharePoint site collection, will almost exclusively
#'             be 'https://community.ices.dk'.
#' @param destdir a relative path of the directory to download the file to.
#'
#' @return
#' The path of the downloaded file
#'
#' @examples
#' \dontrun{
#' set_jwt_auth(jwt_file = "jwt.txt")
#' spgetfile("SEAwise Documents/habitat_data.zip", 
#'           site = "/ExpertGroups/WGNSSK",
#'           destdir = "data")
#' }
#'
#' @export
spgetfile <- function(file, site, site_collection, destdir = dirname(file)) {
  if (missing(site_collection)) {
    site_collection <- getOption("icesSharePoint.site_collection")
  }
  
  if (missing(site)) {
    site <- getOption("icesSharePoint.site")
  }
  
  # Get JWT token
  jwt <- getOption("icesConnect.jwt")
  if (is.null(jwt)) {
    stop("JWT token not set. Use set_jwt_auth() to set a JWT token.")
  }
  
  # Method 1: Use standard SharePoint API approach
  # Create the service path
  infname <- utils::URLencode(paste0(site, "/", file))
  service <- sprintf("/getfilebyserverrelativeurl('%s')/$value", infname)
  
  # Prepare destination directory
  outfname <- paste0(destdir, "/", basename(file))
  if (!dir.exists(destdir)) dir.create(destdir, recursive = TRUE)
  
  # Try direct download with httr
  url <- paste0(site_collection, "/_api/web", service)
  response <- httr::GET(
    url,
    httr::add_headers(Authorization = paste("Bearer", jwt)),
    httr::write_disk(outfname, overwrite = TRUE)
  )
  
  # Check for errors
  if (httr::http_error(response)) {
    # If direct download fails, fall back to the content approach
    ret <- spservice(service, site = site, site_collection = site_collection)
    writeBin(ret, outfname)
  }
  
  invisible(outfname)
}

#' Download Large Files from SharePoint
#'
#' A specialized function for downloading large files from SharePoint using JWT authentication.
#' This function is optimized for larger files and streams the download to disk.
#'
#' @param file a name of a file on SharePoint.
#' @param site a SharePoint site name, e.g. '/ExpertGroups/WGNSSK'.
#' @param site_collection a SharePoint site collection.
#' @param destdir a relative path of the directory to download the file to.
#' @param progress logical; whether to display a progress bar.
#'
#' @return
#' The path of the downloaded file
#'
#' @examples
#' \dontrun{
#' set_jwt_auth(jwt_file = "jwt.txt")
#' spgetfile_large("SEAwise Documents/large_dataset.zip", 
#'                 site = "/ExpertGroups/WGNSSK",
#'                 destdir = "data")
#' }
#'
#' @export
spgetfile_large <- function(file, site, site_collection, destdir = dirname(file), progress = TRUE) {
  if (missing(site_collection)) {
    site_collection <- getOption("icesSharePoint.site_collection")
  }
  
  if (missing(site)) {
    site <- getOption("icesSharePoint.site")
  }
  
  # Get JWT token
  jwt <- getOption("icesConnect.jwt")
  if (is.null(jwt)) {
    stop("JWT token not set. Use set_jwt_auth() to set a JWT token.")
  }
  
  # Prepare URL
  infname <- utils::URLencode(paste0(site, "/", file))
  url <- paste0(site_collection, "/_api/web/getfilebyserverrelativeurl('", infname, "')/$value")
  
  # Prepare destination
  outfname <- paste0(destdir, "/", basename(file))
  if (!dir.exists(destdir)) dir.create(destdir, recursive = TRUE)
  
  # Configure download options
  config <- list(
    httr::add_headers(Authorization = paste("Bearer", jwt))
  )
  
  # Add progress bar if requested
  if (progress) {
    config <- c(config, list(httr::progress()))
  }
  
  # Download file with streaming to disk
  response <- do.call(httr::GET, c(list(url = url, httr::write_disk(outfname, overwrite = TRUE)), config))
  
  # Check for errors
  if (httr::http_error(response)) {
    stop("Error downloading file: ", httr::http_status(response)$message)
  }
  
  # Return the file path
  invisible(outfname)
}