

enum {
	MAX,
	BASE,
	CURRENT,
	MISSING
}

static func get_description_of(type : int) -> String:
	if type == MAX:
		return "max"
	elif type == BASE:
		return "base"
	elif type == CURRENT:
		return "current"
	elif type == MISSING:
		return "missing"
	
	return "Err"
