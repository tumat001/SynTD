

enum {
	MAX,
	BASE,
	CURRENT,
	MISSING
}

static func get_description_of(type : int) -> String:
	if type == MAX:
		return "total"
	elif type == BASE:
		return "base"
	elif type == CURRENT:
		return "current"
	elif type == MISSING:
		return "missing"
	
	return "Err"
