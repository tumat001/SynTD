extends MarginContainer

const Border_Tier01 = preload("res://GameHUDRelated/TowerIconPanel/BorderAssets/Border_Tier01.png")
const Border_Tier02 = preload("res://GameHUDRelated/TowerIconPanel/BorderAssets/Border_Tier02.png")
const Border_Tier03 = preload("res://GameHUDRelated/TowerIconPanel/BorderAssets/Border_Tier03.png")
const Border_Tier04 = preload("res://GameHUDRelated/TowerIconPanel/BorderAssets/Border_Tier04.png")
const Border_Tier05 = preload("res://GameHUDRelated/TowerIconPanel/BorderAssets/Border_Tier05.png")
const Border_Tier06 = preload("res://GameHUDRelated/TowerIconPanel/BorderAssets/Border_Tier06.png")


signal on_button_pressed(event)
signal on_mouse_hovered()
signal on_mouse_hover_exited()


#var tower setget set_tower
var tower_type_info setget set_tower_type_info


onready var tower_icon = $TowerIcon
onready var tower_border_pic_button = $TowerBorderPicButton


#func set_tower(arg_tower):
#	tower = arg_tower
#	
#	_update_display()

func set_tower_type_info(arg_type_info):
	tower_type_info = arg_type_info
	
	_update_display()


func set_button_interactable(arg_interactable : bool):
	if arg_interactable:
		tower_border_pic_button.mouse_filter = MOUSE_FILTER_STOP
	else:
		tower_border_pic_button.mouse_filter = MOUSE_FILTER_IGNORE


#

func _ready():
	_update_display()
	
	tower_border_pic_button.connect("mouse_entered", self, "_on_mouse_hovered", [], CONNECT_PERSIST)
	tower_border_pic_button.connect("mouse_exited", self, "_on_mouse_hover_exited", [], CONNECT_PERSIST)

#

func _update_display():
	if is_inside_tree():
		if tower_type_info != null:
			var tower_tier = tower_type_info.tower_tier
			
			tower_border_pic_button.texture_normal = _get_border_to_use(tower_tier)
			tower_icon.texture = tower_type_info.tower_atlased_image


func _get_border_to_use(tower_tier : int) -> Texture:
	if tower_tier == 1:
		return Border_Tier01
	elif tower_tier == 2:
		return Border_Tier02
	elif tower_tier == 3:
		return Border_Tier03
	elif tower_tier == 4:
		return Border_Tier04
	elif tower_tier == 5:
		return Border_Tier05
	elif tower_tier == 6:
		return Border_Tier06
	
	return null


#

func _on_TowerBorderPicButton_pressed_mouse_event(event):
	emit_signal("on_button_pressed", event)

func _on_mouse_hovered():
	emit_signal("on_mouse_hovered")

func _on_mouse_hover_exited():
	emit_signal("on_mouse_hover_exited")
