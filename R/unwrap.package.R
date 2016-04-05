#' Unwrap an installed wrapper package
#'
#' @param package
#' A character string which gives the name of an installed wrapper package.
#' The inner package inside this wrapper package will be installed. Note that 
#' the wrapper package will be over-written if it has the same name as its
#  inner package (i.e. the name used in the inner DESCRIPTION file). This would
#' be the case if the wrapper package was created by the wrap.package function.
#' This is the recommended way of using a wrapper package, which is intended to
#' be only a container for its inner package, it is no longer needed once it is
#' unwrapped and the inner package is installed. 
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






