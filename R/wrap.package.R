#' Convert a regular source package into a wrapper package. 
#'
#' @param package 
#' Path to the source package to be converted into a wrapper package. 
#'
#' @export



wrap.package =
function (package)
{    
    if (!file.exists(file.path(package, "DESCRIPTION")))
    {
        stop("No package infrastructure found in ", package)
    }

    # move into the outer package folder

    wd = setwd(package)

    on.exit(setwd(wd))

    # set up the inner package folder

    inner.path = file.path("inst", "package")

    if (file.exists(inner.path))
    {
        stop(package, " is already a wrapper package")
    }

    dir.create(inner.path, recursive = TRUE)

    # move all outer package content except the inst folder into inner package

    outer.files = setdiff(list.files(), "inst")

    inner.files = file.path(inner.path, outer.files)

    file.rename(outer.files, inner.files) 

    # add a copy of the DESCRIPTION file
  
    file.copy(file.path(inner.path, "DESCRIPTION"), ".") 

    # add a copy of the standard zzz.R file for wrapper packages

    dir.create("R")

    file.copy(system.file("wrapper/zzz.R", package = "packagewrapper"), "R")

    # move into the inst folder

    setwd("inst")

    # set up inst folder in the inner package

    inner.path = file.path("package", "inst")

    dir.create(inner.path)

    # move all content of inst except the package folder into inner package 

    outer.files = setdiff(list.files(), "package")  

    inner.files = file.path(inner.path, outer.files)

    file.rename(outer.files, inner.files)

    return(invisible(TRUE))
}







