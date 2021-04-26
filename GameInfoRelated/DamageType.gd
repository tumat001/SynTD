
enum {
	PHYSICAL,
	ELEMENTAL,
	PURE,
	}

static func get_name_of_damage_type(type : int) -> String:
	if type == PHYSICAL:
		return "Physical"
	elif type == ELEMENTAL:
		return "Elemental"
	elif type == PURE:
		return "Pure"
	
	return "Err"
