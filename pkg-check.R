pkgCheck <- function(pkg_list) {
  options(warn = -1)
  for (i in 1:length(pkg_list)) {
    if (!require(pkg_list[i],character.only = TRUE))
    {
      install.packages(pkg_list[i],dep=TRUE)
      if(!require(x,character.only = TRUE)) stop("Package not found")
    }
  }
  options(warn = 0)
}