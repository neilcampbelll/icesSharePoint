.onLoad <- function(libname, pkgname) {
  # Default package options
  opts <- c(
    "icesSharePoint.messages" = "FALSE",
    "icesSharePoint.site_collection" = "'https://community.ices.dk'",
    "icesSharePoint.site" = "''",
    "icesSharePoint.wd" = "''"
  )
  
  # Set only those not previously set
  for (i in setdiff(names(opts), names(options()))) {
    eval(parse(text = paste0("options(", i, "=", opts[i], ")")))
  }
  
  # Check for JWT token in the environment
  jwt_env_var <- Sys.getenv("ICES_JWT")
  if (jwt_env_var != "" && is.null(getOption("icesConnect.jwt"))) {
    options(icesConnect.jwt = jwt_env_var)
    message("JWT token loaded from environment variable 'ICES_JWT'")
  }
  
  # Check for JWT token in a standard location
  jwt_files <- c("~/.ices/jwt.txt", "jwt.txt")
  for (jwt_file in jwt_files) {
    if (file.exists(jwt_file) && is.null(getOption("icesConnect.jwt"))) {
      jwt_token <- tryCatch({
        token <- readLines(jwt_file, warn = FALSE)
        if (length(token) > 1) {
          paste(token, collapse = "")
        } else {
          token
        }
      }, error = function(e) NULL)
      
      if (!is.null(jwt_token) && nchar(jwt_token) > 0) {
        options(icesConnect.jwt = jwt_token)
        message("JWT token loaded from ", jwt_file)
        break
      }
    }
  }
  
  invisible()
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage("icesSharePoint: ICES SharePoint Access")
  packageStartupMessage("Authentication: JWT token required")
  
  # Provide information about JWT token status
  jwt <- getOption("icesConnect.jwt")
  if (is.null(jwt)) {
    packageStartupMessage("No JWT token found. Use set_jwt_auth() to set a token before using the package.")
  } else {
    packageStartupMessage("JWT token loaded. Use is_valid_jwt() to verify token validity.")
  }
}