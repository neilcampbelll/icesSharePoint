#' Get Current User Information
#'
#' Download file from sharepoint and return file location.
#'
#' @param site a SharePoint site name, e.g. '/ExpertGroups/WGNSSK'.
#' @param site_collection a SharePoint site collection, will almost exclusively
#'             be 'https://community.ices.dk', so these functions should work for other
#'             SharePoint sites outside ICES.
#' @param dir a relative path of the directory to download the file to.
#'
#' @return
#' The path of the downloaded file
#'
#'
#' @export

spgetuser <- function(site, site_collection) {
 out <- spget(sprintf("%s%s/_api/SP.UserProfiles.PeopleManager/GetMyProperties", site_collection, site))

 out$d
}

