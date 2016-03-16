#' Unwrap an installed wrapper package
#'
#' Install the inner package inside an installed wrapper package. Note that 
#' this will overwrite the wrapper package if the package name used in the
#' DESCRIPTION file of the wrapper package is the same as the package name
#' used in the DESCRIPTION file of the inner package. This would indeed be
#' the case if the wrapper package was created by the wrap.package function.
#' This is the recommended way of using a wrapper package, since the wrapper
#' package is only a container for its inner package, it is no longer needed
#' once it is unwrapped and the inner package becomes available for use. 
#'
#' @param package
#' Name of the installed wrapper package to be unwrapped, given as a character
#' string.
#'
#' @export



unwrap.package =
function (package)
{
    inner.path = system.file("package", package = package)

    if (!file.exists(file.path(inner.path, "DESCRIPTION")))
    {
        message("No inner package found inside ", package)

        return(invisible(FALSE))
    }

    # flatten the file hierarchy inside the R folder

    R.path = file.path(inner.path, "R")

    R.files = list.files(R.path, full.names = TRUE, recursive = TRUE)

    file.rename(R.files, file.path(R.path, basename(R.files)))

    # install the inner package

    message("Installing the inner package inside ", package)

    suppressWarnings(devtools::document(inner.path))    
    suppressWarnings(devtools::install(inner.path))

    return(invisible(TRUE)) 
}






