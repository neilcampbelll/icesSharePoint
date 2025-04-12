#' JWT Authentication Management
#'
#' Functions to manage JWT authentication for ICES SharePoint and related services.
#'
#' @param jwt_token A character string containing the JWT token.
#' @param jwt_file Path to a file containing the JWT token.
#'
#' @return
#' For set_jwt_auth, the function invisibly returns TRUE if successful.
#' For get_jwt_auth, returns the JWT token if set, or NULL if not set.
#'
#' @examples
#' \dontrun{
#' set_jwt_auth("jwt_token_string")
#' # or
#' set_jwt_auth(jwt_file = "jwt.txt")
#' 
#' # Check if JWT token is set
#' get_jwt_auth()
#' }
#'
#' @export
set_jwt_auth <- function(jwt_token = NULL, jwt_file = NULL) {
  if(!is.null(jwt_file) && file.exists(jwt_file)) {
    jwt_token <- readLines(jwt_file, warn = FALSE)
    if(length(jwt_token) > 1) {
      jwt_token <- paste(jwt_token, collapse = "")
    }
  }
  
  if(is.null(jwt_token) || nchar(jwt_token) == 0) {
    stop("JWT token is empty or NULL. Please provide a valid JWT token.")
  }
  
  # Basic token format validation
  if(!grepl("^[A-Za-z0-9-_]+\\.[A-Za-z0-9-_]+\\.[A-Za-z0-9-_]*$", jwt_token)) {
    warning("The JWT token does not appear to be in the standard format (header.payload.signature).")
  }
  
  options(icesConnect.jwt = jwt_token)
  invisible(TRUE)
}

#' @export
#' @rdname set_jwt_auth
get_jwt_auth <- function() {
  getOption("icesConnect.jwt")
}

#' @export
#' @rdname set_jwt_auth
clear_jwt_auth <- function() {
  options(icesConnect.jwt = NULL)
  invisible(TRUE)
}

#' Validate JWT Token
#'
#' Performs basic validation on a JWT token to check its structure and expiration.
#'
#' @param token The JWT token to validate. If NULL, uses the token set via set_jwt_auth().
#'
#' @return A logical value: TRUE if the token appears valid, FALSE otherwise.
#'
#' @examples
#' \dontrun{
#' set_jwt_auth(jwt_file = "jwt.txt")
#' is_valid_jwt()
#' }
#'
#' @export
is_valid_jwt <- function(token = NULL) {
  if(is.null(token)) {
    token <- getOption("icesConnect.jwt")
  }
  
  if(is.null(token)) {
    warning("No JWT token provided or set.")
    return(FALSE)
  }
  
  # Basic structure check
  parts <- strsplit(token, "\\.")[[1]]
  if(length(parts) != 3) {
    warning("JWT token does not have the expected format (header.payload.signature)")
    return(FALSE)
  }
  
  # Try to decode the payload
  tryCatch({
    # Add padding if needed
    payload_encoded <- parts[2]
    padding_needed <- (4 - nchar(payload_encoded) %% 4) %% 4
    if(padding_needed > 0) {
      payload_encoded <- paste0(payload_encoded, strrep("=", padding_needed))
    }
    
    # Decode base64
    payload_raw <- base64enc::base64decode(payload_encoded)
    payload_text <- rawToChar(payload_raw)
    payload <- jsonlite::fromJSON(payload_text)
    
    # Check expiration if present
    if("exp" %in% names(payload)) {
      exp_time <- as.POSIXct(payload$exp, origin="1970-01-01")
      current_time <- Sys.time()
      if(current_time > exp_time) {
        warning("JWT token has expired. Please obtain a new token.")
        return(FALSE)
      }
    }
    
    return(TRUE)
  }, error = function(e) {
    warning("Failed to validate JWT token: ", e$message)
    return(FALSE)
  })
}