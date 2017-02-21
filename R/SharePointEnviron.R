
SP_cred <- function() {
  # get value of environment variable SP_User
  SP_User <- Sys.getenv("SP_User")
  SP_password <- Sys.getenv("SP_Password")
  if (any(identical(SP_User, ""), identical(SP_password, ""))) {
    # SAG_PAT environment variable is not set
    set_SP_cred()
    cred <- SP_cred()
  } else {
    cred <- httr::authenticate(SP_User, SP_password, type = "ntlm")
  }

  cred
}

.SP_eviron_file <- "~/.Renviron_SP"

set_SP_cred <- function() {
  # permanently set the SP_User and SP_password environment variable

  if (!file.exists(.SP_eviron_file)) {
    message("Creating .Renviron_SP file:\n\t",
            path.expand(.SP_eviron_file))
    file.create(.SP_eviron_file)
    # add SAG_PAT to .Renviron_SAG
    cat("# ICES Sharepoint username\n",
      "SP_User=\n",
      "# ICES Sharepoint password\n",
      "SP_Password=\n",
      file = .SP_eviron_file, sep = "")
  }

  ans <- readline(paste("Please edit:\n\t", path.expand(.SP_eviron_file), "\nand press enter when finished"))

  # read environment file
  readRenviron(.SP_eviron_file)
}

