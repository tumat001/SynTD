extends Reference


var descriptions : Array = []
var simple_descriptions : Array = []

var name
var id

var atlased_image
var altased_images_list : Array

var tidbit_tier : int   # similar to tower tiers 1-6, with 6 being the best



func has_simple_description() -> bool:
	return simple_descriptions != null and simple_descriptions.size() != 0

func get_description__for_almanac_use():
	return descriptions

func get_simple_description__for_almanac_use():
	return simple_descriptions

func get_atlased_image_as_list__for_almanac_use():
	if altased_images_list.size() == 0:
		return [atlased_image]
	else:
		return altased_images_list

func get_altasted_image_list_size():
	return altased_images_list.size()

func get_name__for_almanac_use():
	return name

func get_id__for_almanac_use():
	return id
	
