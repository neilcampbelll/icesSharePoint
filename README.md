[![Build Status](https://github.com/ices-tools-prod/icesSharePoint/actions/workflows/check-standard.yaml/badge.svg)](https://github.com/ices-tools-prod/icesSharePoint/actions)

[<img align="right" alt="ICES Logo" width="17%" height="17%" src="http://www.ices.dk/_layouts/15/1033/images/icesimg/iceslogo.png">](http://www.ices.dk/Pages/default.aspx)

# icesSharePoint

icesSharePoint provides helper functions to access the SharePoint site used by [ICES](http://www.ices.dk/Pages/default.aspx).

## Authentication

This version uses JWT (JSON Web Token) authentication which replaces the previous username/password approach. Before you can access the SharePoint via R, you must have a valid JWT token from ICES. You can obtain this token from the ICES website or through your ICES administrator.

## Installation

icesSharePoint can be installed from GitHub using the `install_github` command from the `devtools` package:

```r
library(devtools)
install_github("ices-tools-prod/icesSharePoint")
```

## Usage

For a summary of the package:

```r
library(icesSharePoint)
?icesSharePoint
```

## Basic example

First, you need to set your JWT token. This can be done in a few ways:

```r
# Option 1: From a file
set_jwt_auth(jwt_file = "jwt.txt")

# Option 2: Directly with the token
jwt_token <- "your.jwt.token.string"
set_jwt_auth(jwt_token)

# Option 3: Environment variable (set before starting R)
# Sys.setenv(ICES_JWT = "your.jwt.token.string")
# The package will automatically load this on startup
```

You can validate that your token is properly formatted and not expired:

```r
if (!is_valid_jwt()) {
  stop("JWT token is invalid or expired. Please obtain a new token.")
}
```

Next, set the SharePoint site you want to access to avoid specifying it in all function calls:

```r
options(icesSharePoint.site = "/ExpertGroups/WGMIXFISH-ADVICE")
```

Now find the directory you want to access:

```r
# This prints the directory contents, useful for navigation
spdir()
spdir("2023 Meeting Documents")
spdir("2023 Meeting Documents/06. Data")
```

Once you know the directory you want to access, you can list and download files:

```r
# List files in a directory
files <- spfiles("2023 Meeting Documents/06. Data", full = TRUE)

# Download individual files
for (file in files) {
  spgetfile(file, destdir = "data")
}

# Or download a specific file
spgetfile(
  "2023 Meeting Documents/06. Data/important_data.xlsx",
  destdir = "data"
)

# For large files, use the specialized function with progress reporting
spgetfile_large(
  "2023 Meeting Documents/06. Data/large_dataset.zip",
  destdir = "data",
  progress = TRUE
)
```

You can also create, update, and delete files and folders:

```r
# Create a folder
spdir.create("NewFolder", "2023 Meeting Documents", 
           site = "/ExpertGroups/WGMIXFISH-ADVICE")

# Upload a file
spfile.create("data.csv", con = "local_data.csv", 
              directory = "2023 Meeting Documents/NewFolder",
              site = "/ExpertGroups/WGMIXFISH-ADVICE")

# Update a file
spfile.update("data.csv", con = "updated_data.csv",
              directory = "2023 Meeting Documents/NewFolder",
              site = "/ExpertGroups/WGMIXFISH-ADVICE")

# Delete a file
spfile.delete("data.csv", directory = "2023 Meeting Documents/NewFolder",
              site = "/ExpertGroups/WGMIXFISH-ADVICE")

# Delete a folder
spdir.delete("NewFolder", "2023 Meeting Documents",
             site = "/ExpertGroups/WGMIXFISH-ADVICE")
```

When you're done with your session, you can clear the JWT token (optional):

```r
clear_jwt_auth()
```

## JWT Token Management

The package provides several functions to help manage your JWT tokens:

```r
# Set your JWT token
set_jwt_auth(jwt_file = "jwt.txt")

# Get the currently set JWT token
token <- get_jwt_auth()

# Check if the token is valid
is_valid <- is_valid_jwt()

# Get information from the token (useful for debugging)
token_info <- get_jwt_info()
print(token_info$payload$exp)  # Expiration timestamp
```

## References

ICES Community SharePoint site:

<https://community.ices.dk/SitePages/Home.aspx>

Microsoft SharePoint REST interface reference:

<https://learn.microsoft.com/en-us/sharepoint/dev/sp-add-ins/get-to-know-the-sharepoint-rest-service>

## Development

icesSharePoint is developed openly on [GitHub](https://github.com/ices-tools-prod/icesSharePoint).

Feel free to open an [issue](https://github.com/ices-tools-prod/icesSharePoint/issues) there if you encounter problems or have suggestions for future versions.