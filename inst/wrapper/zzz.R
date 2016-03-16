
.onAttach = 
function(libname, pkgname)
{
    packageStartupMessage(
    pkgname, " is a wrapper package. To make its inner package available for use please run\n\n", 
    "    packagewrapper::load.package('", pkgname, "')\n")
                          
    if (system.file(package = "packagewrapper") == "")
    {
        packageStartupMessage(
        "To install the packagewrapper package please run\n\n",
        "    devtools::install_github('ning-yan/packagewrapper')\n")
    }
}




