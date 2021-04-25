extends MarginContainer


func _ready():
	pass


func _process(delta):
	var new_position : Vector2 = get_global_mouse_position()
	new_position.x += 20
	
	var tooltip_height : float = rect_size.y
	if new_position.y + tooltip_height + 20 > get_viewport().get_visible_rect().size.y:
		new_position.y -= tooltip_height
	
	var tooltip_width : float = rect_size.x
	if new_position.x + tooltip_width + 20 > get_viewport().get_visible_rect().size.x:
		new_position.x -= tooltip_width + 20
	
	set_position(new_position, true)
