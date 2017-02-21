#' Files and Folders
#'
#' List the files and folders in a SharePoint directory.
#'
#' @param directory a directory name.
#' @param site a SharePoint site name, e.g. '/ExpertGroups/WGNSSK'.
#' @param site_collection a SharePoint site collection, will almost exclusively
#'             be 'https://community.ices.dk', so these functions should work for other
#'             SharePoint sites outside ICES.
#' @param full a logical value. If TRUE, the directory path is prepended
#'             to the file names to give a relative file path. If FALSE,
#'             the file names (rather than paths) are returned.
#' @param recursive logical. Should the listing recurse into directories?
#'
#' @return
#' A character vector containing the names of the files in the specified directories,
#' or "" if there were no files. If a path does not exist or is not a directory or is
#' unreadable it is skipped, with a warning..
#'
#' @seealso
#' \code{\link{setspwd}, \link{getspwd}} set and get SharePoint working directory.
#'
#' \code{\link{setspsite}, \link{getspsite}} set and get SharePoint default site.
#'
#' @examples
#' \dontrun{
#' spfolders()
#' spfiles()
#' spdir()
#'
#' spdir(site = "/ExpertGroups/WGNSSK")
#' }
#'
#' @export
#' @rdname spdir

spfolders <- function(directory = "", site, site_collection, full = FALSE) {

  wd <- getspwd()
  if (wd != "" && directory != "") {
    directory <- paste0(wd, "/", directory)
  } else if (wd != "") {
    directory <- wd
  }

  service <- sprintf("getFolderByServerRelativeUrl('%s')/Folders", directory)
  res <- spservice(service, site = site, site_collection = site_collection)

  out <- sapply(res$results, "[[", "Name")
  if (length(out) == 0) {
    character(0)
  } else {
    if (full && directory != "") paste0(directory, "/", out) else out
  }
}

##' @rdname spdir
#' @export
spfiles <- function(directory = "", site, site_collection, full = FALSE) {

  wd <- getspwd()
  if (wd != "" && directory != "") {
    directory <- paste0(wd, "/", directory)
  } else if (wd != "") {
    directory <- wd
  }

  service <- sprintf("getFolderByServerRelativeUrl('%s')/Files", directory)
  res <- spservice(service, site = site, site_collection = site_collection)

  out <- sapply(res$results, "[[", "Name")
  if (length(out) == 0) {
    character(0)
  } else {
    if (full && directory != "") paste0(directory, "/", out) else out
  }
}

##' @rdname spdir
#' @export
spdir <- function(directory = "", site, site_collection, recursive = FALSE, full = FALSE) {

  files <- spfiles(directory, site = site, site_collection = site_collection)
  dirs <- spfolders(directory, site = site, site_collection = site_collection)

  if (recursive) {
    while (length(dirs) != 0) {
      # grow file list
      files <- c(files, spfiles(dirs[1], site = site, site_collection = site_collection, full = TRUE))
      # grow directory list
      dirs <- c(dirs, spfolders(dirs[1], site = site, site_collection = site_collection, full = TRUE))
      # chop off just inspected directory
      dirs <- dirs[-1]
    }
  } else {
    files <- c(files, dirs)
  }

  files <- sort(files)
  if (full) files else sub(paste0("^", directory, "/"), "", files)
}

