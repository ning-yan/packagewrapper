#' Load an R package
#' 
#' @param package
#' A character string which can be either the name of an installed package or the
#' path to a source package. The default value is ".", which assumes the current
#' working directory to be the root directory of a source package. If an installed 
#' package with the given name exists, that package will be either unwrapped or
#' simply reloaded, depending on whether an inner package is found. Otherwise the
#' source package at the given path is first installed, then the newly installed
#' package is either unwrapped or reloaded.
#'
#' @export



load.package =
function(package = ".")
{
    package.path = system.file(package = package)

    if (dir.exists(package.path))
    {
        if (file.exists(file.path(package.path, "package", "DESCRIPTION")))
        {
            message("Unwrapping the package ", package)

            suppressMessages(unwrap.package(package)) 
        }
        else
        {
            message("Reloading the package ", package)

            try(devtools::unload(package.path), silent = TRUE)
        }

        require(package, quietly = TRUE, character.only = TRUE)

    }
    else if (dir.exists(package))
    {
        # treat package as source package and install it,
        # then call load.package again

        package = devtools::as.package(package)

        message("Installing from source package ", package$path)

        suppressMessages(devtools::document(package))    
        suppressMessages(devtools::install(package))  

        load.package(package$package)        
    }
    else
    {
        stop("Cannot find the package ", package)
    }

    return(invisible(TRUE))
}








