#' Get Current User Information
#'
#' Get a json list of information about the currently logged in user.
#'
#' @param site a SharePoint site name, e.g. '/ExpertGroups/WGNSSK'.
#' @param site_collection a SharePoint site collection, will almost exclusively
#'             be 'https://community.ices.dk', so these functions should work for other
#'             SharePoint sites outside ICES.
#'
#' @return
#' The path of the downloaded file
#'
#'
#' @export

spgetuser <- function(site, site_collection) {
  if (missing(site_collection)) {
    site_collection <- getOption("icesSharePoint.site_collection")
  }

  if (missing(site)) {
    site <- getOption("icesSharePoint.site")
  }

  out <- spget(sprintf("%s%s/_api/SP.UserProfiles.PeopleManager/GetMyProperties", site_collection, site))

  out$d
}
