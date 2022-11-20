extends MarginContainer


var id_status_texture_rect_map : Dictionary = {}
export var icons_per_row : int = 4 setget set_icons_per_row


onready var grid_container : GridContainer = $GridContainer


func _ready():
	grid_container.columns = icons_per_row


# setting

func set_icons_per_row(value : int):
	icons_per_row = value
	
	if is_instance_valid(grid_container):
		grid_container.columns = icons_per_row


# Status icon adding/removing

func add_status_icon(identifier, status_icon : Texture):
	if !has_status_icon(identifier):
		var textureRect = _construct_status_texture_rect(status_icon)
		
		id_status_texture_rect_map[identifier] = textureRect
		grid_container.add_child(textureRect)
		
	else:
		replace_status_icon(identifier, status_icon)

func has_status_icon(identifier):
	return id_status_texture_rect_map.has(identifier)

func _construct_status_texture_rect(status_icon) -> TextureRect:
	var textureRect := TextureRect.new()
	
	textureRect.texture = status_icon
	return textureRect


func remove_status_icon(identifier):
	if has_status_icon(identifier):
		var textureRect = id_status_texture_rect_map[identifier]
		
		grid_container.remove_child(textureRect)
		id_status_texture_rect_map.erase(identifier)
		
		textureRect.queue_free()


func clear_all_status_icons():
	for textureRect in id_status_texture_rect_map.values():
		grid_container.remove_child(textureRect)
		textureRect.queue_free()
	
	id_status_texture_rect_map.clear()


func replace_status_icon(identifier, status_icon : Texture):
	if id_status_texture_rect_map.has(identifier):
		id_status_texture_rect_map[identifier].texture = status_icon
