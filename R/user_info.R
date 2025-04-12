#' Get Current User Information
#'
#' Get a JSON list of information about the currently authenticated user using JWT.
#'
#' @param site a SharePoint site name, e.g. '/ExpertGroups/WGNSSK'.
#' @param site_collection a SharePoint site collection, will almost exclusively
#'             be 'https://community.ices.dk'.
#'
#' @return
#' User information as returned by the SharePoint API
#'
#' @examples
#' \dontrun{
#' # Set JWT token first
#' set_jwt_auth(jwt_file = "jwt.txt")
#' 
#' # Get user information
#' user_info <- spgetuser()
#' }
#'
#' @export
spgetuser <- function(site, site_collection) {
  if (missing(site_collection)) {
    site_collection <- getOption("icesSharePoint.site_collection")
  }
  
  if (missing(site)) {
    site <- getOption("icesSharePoint.site")
  }
  
  # Check if JWT token is set
  jwt <- getOption("icesConnect.jwt")
  if(is.null(jwt)) {
    stop("JWT token not set. Use set_jwt_auth() to set a JWT token.")
  }
  
  out <- spget(sprintf("%s%s/_api/SP.UserProfiles.PeopleManager/GetMyProperties", site_collection, site))
  
  out$d
}

#' Get JWT Token Information
#'
#' Decodes and returns information from the JWT token currently in use.
#' This can be useful for debugging and understanding the permissions
#' associated with the current token.
#'
#' @return
#' A list containing the decoded header and payload from the JWT token
#'
#' @examples
#' \dontrun{
#' # Set JWT token first
#' set_jwt_auth(jwt_file = "jwt.txt")
#' 
#' # Get token information
#' token_info <- get_jwt_info()
#' }
#'
#' @export
get_jwt_info <- function() {
  jwt <- getOption("icesConnect.jwt")
  if(is.null(jwt)) {
    stop("JWT token not set. Use set_jwt_auth() to set a JWT token.")
  }
  
  # Split the token into its parts
  parts <- strsplit(jwt, "\\.")[[1]]
  if(length(parts) != 3) {
    stop("JWT token does not have the expected format (header.payload.signature)")
  }
  
  # Function to decode a base64 JWT part
  decode_part <- function(part) {
    # Add padding if needed
    padding_needed <- (4 - nchar(part) %% 4) %% 4
    if(padding_needed > 0) {
      part <- paste0(part, strrep("=", padding_needed))
    }
    
    # Decode base64
    tryCatch({
      payload_raw <- base64enc::base64decode(part)
      payload_text <- rawToChar(payload_raw)
      jsonlite::fromJSON(payload_text)
    }, error = function(e) {
      list(error = paste("Failed to decode:", e$message))
    })
  }
  
  # Return decoded header and payload
  list(
    header = decode_part(parts[1]),
    payload = decode_part(parts[2])
  )
}