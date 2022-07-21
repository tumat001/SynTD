extends MarginContainer

signal on_path_selected(path)
signal on_path_hovered(path)


var black_path

onready var black_path_texture_rect = $BlackPathTextureRect

func _ready():
	black_path_texture_rect.texture = black_path.black_path_icon


func set_black_path(arg_path):
	black_path = arg_path
	
	if is_inside_tree():
		black_path_texture_rect.texture = black_path.black_path_icon


func _on_AdvancedButton_pressed_mouse_event(event : InputEventMouseButton):
	if event.button_index == BUTTON_LEFT:
		emit_signal("on_path_selected", black_path)

func _on_AdvancedButton_mouse_entered():
	emit_signal("on_path_hovered", black_path)
