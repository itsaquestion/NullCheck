
foo = function(x,...) {
  stopNull()
  x
}

foo("1")
foo(x = 1, b = 1)
foo(x = 1, b = NULL)
foo(x = list(a = 1))
foo(x = NA)

foo2 = function(x, .f, y = NULL, ...) {
  stopNull(except = "y")
  .f(x)
}

foo2(2,function(x)x^2,1)