# download file from sharepoint and return file location
#' @export
spgetfile <- function(file, site, site_collection, dir = dirname(file), verbose = TRUE) {

  infname <- utils::URLencode(paste0(site, "/", file))
  service <- sprintf("/getfilebyserverrelativeurl('%s')/$value", infname)
  ret <- spservice(service, site = site, site_collection = site_collection)

  outfname <- paste0(dir, "/", basename(file))
  if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)

  writeBin(ret, outfname)
  invisible(outfname)
}

