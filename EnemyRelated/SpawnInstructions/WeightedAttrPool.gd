

var weight_attribute_dictionary = {}
var rng : RandomNumberGenerator

func _init(arg_rng : RandomNumberGenerator):
	rng = arg_rng

func random_get_attribute():
	var randI = rng.randi_range(1, get_total_weight())
	var counter = 0
	
	for key in weight_attribute_dictionary.keys():
		counter += weight_attribute_dictionary[key]
		if randI <= counter:
			return key
	
	return null

func get_total_weight() -> float:
	var total : float = 0
	for weight in weight_attribute_dictionary.values():
		total += weight
	
	return total
