#' stopNull
#'
#' Check caller's args and stop if there are any NULLs. 
#' @param except args' name vector that should not to be checked
#'
#' @export
#' @import stringr
#' @importFrom glue glue
#' @importFrom dplyr filter
#' @examples
#' add = function(a, b, c) {
#' 	stopNull()
#' 	a + b + c
#' }
#' 
#' add(1, 2, 3)
#' 
#' add(1, 2, NULL)
#' 
#' add2 = function(a, b, c) {
#' 	stopNull(except = "c")
#' 	a + b
#' }
#' 
#' add2(1, 2, NULL)
stopNull = function(except = NULL) {

	obj_list = parent.frame(n = 1)

	#print(obj_list)

	is_null_obj = sapply(obj_list, is.null)
	obj_names = names(is_null_obj)

	df = data.frame(obj_names, is_null_obj, stringsAsFactors = F)

	if (!is.null(except)) {
		df = dplyr::filter(df, !(obj_names %in% except))
	}

	df = dplyr::filter(df, is_null_obj)

	if (nrow(df) == 0) { return() }

	caller = tail(as.character(as.list(sys.call(-1))[[1]]), 1)

	null_obj_names = paste(df$obj_names, "= NULL", collapse = ", ")

	error_message = "Null args in function: \r\t{caller}({null_obj_names})"

	stop(glue::glue(error_message), call. = FALSE)

}

