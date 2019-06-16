#' stopNull
#'
#' Check caller's args and stop if there are any NULL, all(NA) or zero-length vector.
#' @param except args' name vector that should not to be checked
#' @export
#' @import stringr
#' @importFrom glue glue
#' @importFrom dplyr filter
#' @importFrom magrittr %>%
#' @examples
#' add = function(a, b, c) {
#' 	stopNull()
#' 	a + b + c
#' }
#'
#' # add(1, 2, 3)
#'
#' # add(1, 2, NULL)
#'
#' add2 = function(a, b, c) {
#' 	stopNull(except = "c")
#' 	a + b
#' }
#'
#' # add2(1, 2, NULL)
stopNull = function(except = NULL) {

  # obj_list = list(a=1,b=NA,c=NULL,d=vector(),e=list(a=1,b=2),f=mean)
	obj_list = parent.frame(n = 1)

	#print(obj_list)

  is_null_obj = checkNull(obj_list)

  #is_na_obj = checkNA(obj_list)

  is_len_0 = checkZeroLen(obj_list)

  obj_names = names(is_null_obj)

  is_list = checkIsList(obj_list)

  suppressWarnings({
    df = data.frame(obj_names, is_null_obj, is_len_0, is_list,
      stringsAsFactors = F)
  })


  # no check list
  df = dplyr::filter(df,!is_list)

  if (nrow(df) == 0) {return() }

  # no check except
	if (!is.null(except)) {
    df = dplyr::filter(df, !(obj_names %in% except))
  }

  #if (!check_na) {
    #df = dplyr::filter(df, !is_na_obj)
  #}

  # all ok, return
  if (all(!df[, -1])) { return() }


  df_null = dplyr::filter(df, is_null_obj)
  df_na = dplyr::filter(df, is_na_obj)
  df_len0 = dplyr::filter(df, is_len_0)

	caller = tail(as.character(as.list(sys.call(-1))[[1]]), 1)


  null_obj_names = ""
  if (nrow(df_null) > 0) {
    null_obj_names = paste0(paste(df_null$obj_names, "= NULL", collapse = ", "),", ")
  }

  na_obj_names = ""
  if (nrow(df_na) > 0) {
    na_obj_names = paste0(paste(df_na$obj_names, "= NA", collapse = ", "), ", ")
  }

  len0_obj_names = ""
  if (nrow(df_len0) > 0) {
    len0_obj_names = paste(df_len0$obj_names, "= Len0", collapse = ", ")
  }

	error_message_0 = "Null args in function: \n\t{caller}({null_obj_names}{na_obj_names}{len0_obj_names})"

  error_message = glue::glue(error_message_0) %>%
    stringr::str_replace(", \\)", "\\)")

  stop(error_message, call. = FALSE)

}

checkNull = function(x) {
  sapply(x, is.null)
}

checkNA = function(x) {
  sapply(x, function(y) {
    if (!is.null(y) & length(y)>0) {
      return(all(is.na(y)))
    }
    else {
      return(F)
    }
    })
}

checkZeroLen = function(x) {
  sapply(x, function(y) {
    if (!is.null(y)) {
      return(length(y)==0)
    }
    else {
      return(F)
    }
  })
}

checkIsList = function(x){
  sapply(x, function(y) {
    if (!is.null(y)) {
      return(is.list(y))
    }
    else {
      return(F)
    }
  })
}



