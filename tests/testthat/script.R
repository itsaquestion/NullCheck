add = function(a, b, c) {
	stopNull()
	a + b + c
}

add(1, 2, 3)

add(NULL, 2, 2)

add(1, NULL, 2)

add(1, NA, 2)

add(NULL, NA, vector())

add2 = function(a, b, c) {
	stopNull(except = c("c","d"))
	a + b
}

add2(1, 2, NULL)


add2(1, 2, vector())

