#' @export
spfolders <- function(dir, site = NULL, site_collection = "https://community.ices.dk", full = FALSE) {
  service <- sprintf("getFolderByServerRelativeUrl('%s')/Folders", dir)
  res <- spservice(service, site = site, site_collection = site_collection)

  out <- sapply(res, "[[", "Name")
  if (length(out) == 0) {
    character(0)
  } else {
    if (full) paste0(dir, "/", out) else out
  }
}

#' @export
spfiles <- function(dir, site = NULL, site_collection = "https://community.ices.dk", full = TRUE) {
  service <- sprintf("getFolderByServerRelativeUrl('%s')/Files", dir)
  res <- spservice(service, site = site, site_collection = site_collection)

  out <- sapply(res, "[[", "Name")
  if (length(out) == 0) {
    character(0)
  } else {
    if (full) paste0(dir, "/", out) else out
  }
}


#' @export
spdir <- function(directory, site, recursive = FALSE, full = FALSE) {

  files <- spfiles(directory, site, full = TRUE)
  dirs <- spfolders(directory, site, full = TRUE)

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
