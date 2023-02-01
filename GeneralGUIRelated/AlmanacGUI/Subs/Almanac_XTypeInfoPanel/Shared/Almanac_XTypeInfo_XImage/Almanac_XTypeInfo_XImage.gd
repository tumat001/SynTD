extends MarginContainer


onready var image_texture_rect = $MarginContainer/Image


var almanac_item_list_entry_data

func update_display():
	if almanac_item_list_entry_data != null:
		image_texture_rect.texture = almanac_item_list_entry_data.get_texture_to_use_based_on_properties()
