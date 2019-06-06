
foo = function(x,...) {
  stopNull()
  x
}

foo("1")
foo(x = 1, b = 1)
foo(x = 1, b = NULL)