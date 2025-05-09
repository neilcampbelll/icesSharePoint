% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download_files.R
\name{spgetfile}
\alias{spgetfile}
\alias{spgetfile_large}
\title{Download Files from SharePoint using JWT authentication}
\usage{
spgetfile(file, site, site_collection, destdir = dirname(file))

spgetfile_large(file, site, site_collection, destdir = dirname(file), progress = TRUE)
}
\arguments{
\item{file}{a name of a file on SharePoint.}

\item{site}{a SharePoint site name, e.g. '/ExpertGroups/WGNSSK'.}

\item{site_collection}{a SharePoint site collection, will almost exclusively
be 'https://community.ices.dk'.}

\item{destdir}{a relative path of the directory to download the file to.}

\item{progress}{logical; whether to display a progress bar.}
}
\value{
The path of the downloaded file
}
\description{
Download file from SharePoint and return file location.

A specialized function for downloading large files from SharePoint using JWT authentication.
This function is optimized for larger files and streams the download to disk.
}
\examples{
\dontrun{
# Set JWT token first
set_jwt_auth(jwt_file = "jwt.txt")

# Download a file
spgetfile("SEAwise Documents/habitat_data.zip", 
          site = "/ExpertGroups/WGNSSK",
          destdir = "data")

# Download a large file with progress reporting
spgetfile_large("SEAwise Documents/large_dataset.zip", 
                site = "/ExpertGroups/WGNSSK",
                destdir = "data")
}
}