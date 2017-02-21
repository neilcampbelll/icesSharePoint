#' @export
spfolders <- function(directory = "", site, site_collection, full = FALSE) {

  wd <- getspwd()
  if (wd != "" && directory != "") {
    directory <- paste0(wd, "/", directory)
  } else if (wd != "") {
    directory <- wd
  }

  service <- sprintf("getFolderByServerRelativeUrl('%s')/Folders", directory)
  res <- spservice(service, site = site, site_collection = site_collection)

  out <- sapply(res, "[[", "Name")
  if (length(out) == 0) {
    character(0)
  } else {
    if (full && directory != "") paste0(directory, "/", out) else out
  }
}

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

  out <- sapply(res, "[[", "Name")
  if (length(out) == 0) {
    character(0)
  } else {
    if (full && directory != "") paste0(directory, "/", out) else out
  }
}


#' @export
spdir <- function(directory = "", site, site_collection, recursive = FALSE, full = FALSE) {

  files <- spfiles(directory, site)
  dirs <- spfolders(directory, site)

  if (recursive) {
    while (length(dirs) != 0) {
      # grow file list
      files <- c(files, spfiles(dirs[1], site, full = TRUE))
      # grow directory list
      dirs <- c(dirs, spfolders(dirs[1], site, full = TRUE))
      # chop off just inspected directory
      dirs <- dirs[-1]
    }
  } else {
    files <- c(files, dirs)
  }

  files <- sort(files)
  if (full) files else sub(paste0("^", directory, "/"), "", files)
}


#' @export
setspwd <- function(directory) {

  # if dir starts with ~/ the reset to root dir.
  if (substring(directory, 1, 2) = "~/") {
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

#' @export
getspwd <- function() {
  getOption("icesSharePoint.wd")
}

#' @export
setspsite <- function(site) {
  options(icesSharePoint.site = site)
}

#' @export
getspsite <- function() {
  getOption("icesSharePoint.site")
}
