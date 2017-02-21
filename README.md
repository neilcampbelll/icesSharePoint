[![Build
Status](https://travis-ci.org/ices-tools-prod/icesSharePoint.svg?branch=master)](https://travis-ci.org/ices-tools-prod/icesSharePoint)

[<img align="right" alt="ICES Logo" width="17%" height="17%" src="http://www.ices.dk/_layouts/15/1033/images/icesimg/iceslogo.png">](http://www.ices.dk/Pages/default.aspx)

icesSharePoint
==============

icesSharePoint provides helper functions to access the SharePoint site
used by [ICES](http://www.ices.dk/Pages/default.aspx).

<!-- icesSharePoint is implemented as an [R](https://www.r-project.org) package and
available on [CRAN](https://cran.r-project.org/package=icesSharePoint). -->
Before you can access the SharePoint via R, you must have a valid user
name and password given to you by the ICES Secretariate. icesSharePoint
requires your ICES username and password to be saved in environment
variables, see for example, Appendix: Storing API Authentication
Keys/Tokens in the [httr package
vignette](https://cran.r-project.org/web/packages/httr/vignettes/api-packages.html).
The first time you use the API, the package will create an appropriate
file ('~/.Renviron\_SP') to contain your username and password. It is
important that this file is in a private location in your computer, such
as your home drive '~'. Your password is never sent to the API, but is
used to authenticate via
[ntlm](http://davenport.sourceforge.net/ntlm.html).

Installation
------------

icesSharePoint can be installed from GitHub using the `install_github`
command from the `devtools` package:

    library(devtools)
    install_github("ices-tools-prod/icesSharePoint")

Usage
-----

For a summary of the package:

    library(icesSharePoint)
    ?icesSharePoint

References
----------

ICES Community SharePoint site:

<https://community.ices.dk/SitePages/Home.aspx>

Microsoft SharePoint 2013 REST interface reference

<https://msdn.microsoft.com/en-us/library/office/jj860569.aspx>

Development
-----------

icesSharePoint is developed openly on
[GitHub](https://github.com/ices-tools-prod/icesSharePoint).

Feel free to open an
[issue](https://github.com/ices-tools-prod/icesSharePoint/issues) there
if you encounter problems or have suggestions for future versions.

<!--
The current development version can be installed using:

```R
library(devtools)
install_github("ices-tools-prod/icesSharePoint")
```
-->
<!-- Poke Travis -->
