# icesSharePoint 2.0.0

## Major changes
* Completely replaced username/password authentication with JWT (JSON Web Token) authentication
* Removed all dependencies on keyring and NTLM authentication
* Added new JWT authentication management functions
* Updated all core functions to use JWT authentication
* Added specialized functions for large file downloads

## New features
* `set_jwt_auth()`: Set JWT token from string or file
* `get_jwt_auth()`: Get the current JWT token
* `clear_jwt_auth()`: Clear the current JWT token
* `is_valid_jwt()`: Validate JWT token format and expiration
* `get_jwt_info()`: Extract and decode information from JWT token
* `spgetfile_large()`: Specialized function for large file downloads with progress reporting

## Other improvements
* Added detailed error messages specific to JWT authentication issues
* Improved documentation with examples using JWT authentication
* Updated package metadata and dependencies
* Added automatic JWT token loading from environment variables at startup

# icesSharePoint 1.0.0.9000

* use keyring package to store user passwords, to allow all share point
  users utilise the pacakge

# icesSharePoint 1.0

* initial version for internal ICES secretariate use only