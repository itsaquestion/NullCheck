add = function(a, b, c) {
	checkNull()
	a + b + c
}

add(1, 2, 3)

add(1, NULL, 2)

add2 = function(a, b, c) {
	checkNull(except = c("c","d"))
	a + b
}

add2(1, 2, NULL)


