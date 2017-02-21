#' Working Directory and Site
#'
#' Set and get SharePoint working directory and site.
#'
#' @param directory a directory name.
#' @param site a SharePoint site name, e.g. '/ExpertGroups/WGNSSK'.
#'
#' @return
#' getspwd returns an absolute filepath representing the current SharePoint working directory
#' within the current site; setspwd(directory) is used to set the working directory to directory.
#'
#' @export
#' @rdname setget
setspwd <- function(directory) {

  # if dir starts with ~/ the reset to root dir.
  if (substring(directory, 1, 2) == "~/") {
    directory <- substring(directory, 3)
    options(icesSharePoint.wd = "")
    setspwd(directory)
  }

  # otherwise work relative to current dir
  wd <- getOption("icesSharePoint.wd")

  # check directory is a folder
  if (directory %in% spfolders(wd)) {
    newwd <- if(wd != "") paste0(wd, "/", directory) else directory
    options(icesSharePoint.wd = newwd)
  } else {
    stop('cannot change working directory')
  }
}

#' @rdname setget
#' @export
getspwd <- function() {
  getOption("icesSharePoint.wd")
}

#' @rdname setget
#' @export
setspsite <- function(site) {
  options(icesSharePoint.site = site)
}

#' @rdname setget
#' @export
getspsite <- function() {
  getOption("icesSharePoint.site")
}
