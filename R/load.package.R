#' load an R package.
#'
#' If the input is the name of an installed package, then that package is either
#' unwrapped or simply reloaded, depending on whether an inner package is found. 
#' If the input is not the name of an installed package but instead the path to 
#' a source package, then that package is first installed, then the newly installed
#' package is either unwrapped or reloaded.
#' 
#' Use load.package("./foo") if the source package foo is in the current directory,
#' and the intention is to install from this source package. Use load.package("foo") 
#' if the intention is to load the currently installed version of foo.
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








