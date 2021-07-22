extends MarginContainer

const ScreenTintEffect = preload("res://MiscRelated/ScreenEffectsRelated/ScreenTintEffect.gd")

var game_elements
var screen_effect_manager

var current_showing_control : Control


func _ready():
	visible = false


func show_control(control : Control, make_background_dark : bool = true):
	if current_showing_control != null:
		hide_control(current_showing_control, false)
	
	#
	if !has_control(control):
		add_child(control)
	
	current_showing_control = control
	control.visible = true
	visible = true
	
	if make_background_dark:
		var screen_effect = ScreenTintEffect.new()
		screen_effect.is_timebounded = false
		screen_effect.fade_in_duration = 0.05
		screen_effect.fade_out_duration = 0.05
		screen_effect.tint_color = Color(0, 0, 0, 0.925)
		screen_effect.ins_uuid = StoreOfScreenEffectsUUID.WHOLE_SCREEN_GUI
		screen_effect.custom_z_index = ZIndexStore.SCREEN_EFFECTS_ABOVE_ALL
		screen_effect_manager.add_screen_tint_effect(screen_effect)

func hide_control(control : Control, update_vis : bool = true):
	control.visible = false
	screen_effect_manager.destroy_screen_tint_effect(StoreOfScreenEffectsUUID.WHOLE_SCREEN_GUI)
	current_showing_control = null
	
	visible = false


func has_control(control : Control) -> bool:
	return get_children().has(control)

func has_control_with_script(script : Reference) -> bool:
	for child in get_children():
		if child.get_script() == script:
			return true
	
	return false

func get_control_with_script(script : Reference) -> Control:
	for child in get_children():
		if child.get_script() == script:
			return child
	
	return null



#func _update_visibility_based_on_children():
#	var to_be_vis := false
#
#	for child in get_children():
#		if child.visible == true:
#			to_be_vis = true
#			break
#
#	return to_be_vis
