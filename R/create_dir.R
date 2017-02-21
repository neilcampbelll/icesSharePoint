

# create dir
#' @export
spdir.create <- function(folder, dir, site, site_collection) {

  # create new folder
  uri <- paste0(site_collection, site, "/_api/web/folders")
  body <- sprintf("{ '__metadata': { 'type': 'SP.Folder' }, 'ServerRelativeUrl': '%s/%s'}", dir, folder)
  x <- httr::POST(uri,
                  SP_cred(),
                  body = body,
                  httr::accept("application/json;odata=verbose"),
                  httr::content_type("application/json;odata=verbose"),
                  httr::add_headers("X-RequestDigest" = SP_fdv(site, site_collection)))
  message(httr::http_status(x)$message)

  invisible(httr::content(x))
}

#' @export
spdir.delete <- function(folder, dir, site, site_collection) {

  # create new folder
  service <- sprintf("GetFolderByServerRelativeUrl('%s/%s')", dir, folder)
  uri <- paste0(site_collection, site, "/_api/web/", utils::URLencode(service))
  x <- httr::POST(uri,
                  SP_cred(),
                  httr::add_headers("X-RequestDigest" = SP_fdv(site, site_collection),
                                    "X-HTTP-Method" = "DELETE"))
  message(httr::http_status(x)$message)

  invisible(httr::content(x))
}
