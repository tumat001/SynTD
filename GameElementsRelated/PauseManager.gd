extends MarginContainer

const MainPauseScreenPanel = preload("res://GameHUDRelated/PauseScreenPanel/MainPauseScreenPanel/MainPauseScreenPanel.gd")
const MainPauseScreenPanel_Scene = preload("res://GameHUDRelated/PauseScreenPanel/MainPauseScreenPanel/MainPauseScreenPanel.tscn")
const HubPausePanel = preload("res://GameHUDRelated/PauseScreenPanel/HubPausePanel/HubPausePanel.gd")
const HubPausePanel_Scene = preload("res://GameHUDRelated/PauseScreenPanel/HubPausePanel/HubPausePanel.tscn")

const ScreenTintEffect = preload("res://MiscRelated/ScreenEffectsRelated/ScreenTintEffect.gd")


const background_color : Color = Color(0, 0, 0, 0.8)

var game_elements
var screen_effect_manager

var main_pause_screen_panel : MainPauseScreenPanel
var hub_pause_panel : HubPausePanel

var is_paused : bool = false

var node_tree_of_pause : Array = []


#

func _ready():
	visible = false
	set_process_unhandled_key_input(false)


func show_control(control : Control):
	if !node_tree_of_pause.has(control):
		node_tree_of_pause.append(control)
	#print(str(control) + ": " + str(node_tree_of_pause.has(control)))
	
	var initially_has_visible_control : bool = has_any_visible_control()
	
	if !has_control(control):
		add_child(control)
	
	control.visible = true
	visible = true
	
	if !initially_has_visible_control:
		var screen_effect = ScreenTintEffect.new()
		screen_effect.is_timebounded = false
		screen_effect.tint_color = background_color
		screen_effect.ins_uuid = StoreOfScreenEffectsUUID.PAUSE_GUI
		screen_effect.custom_z_index = ZIndexStore.SCREEN_EFFECTS_ABOVE_ALL
		screen_effect_manager.add_screen_tint_effect(screen_effect)
		
		_pause_game()

func hide_control(control : Control):
	control.visible = false
	
	if node_tree_of_pause.has(control):
		node_tree_of_pause.erase(control)
	#print(str(control) + ": " + str(node_tree_of_pause.has(control)))
	
	if !has_any_visible_control():
		screen_effect_manager.destroy_screen_tint_effect(StoreOfScreenEffectsUUID.PAUSE_GUI)
		visible = false
		_unpause_game()


func has_any_visible_control() -> bool:
	for child in get_children():
		if child.visible:
			return true
	
	return false

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


#

#func _on_control_tree_exiting(arg_control : Control):
#	remove_control(arg_control)

func remove_control(arg_control : Control):
	if !arg_control.is_queued_for_deletion():
		arg_control.queue_free()
	
	hide_control(arg_control)

#

func _pause_game():
	get_tree().paused = true
	is_paused = true
	
	set_process_unhandled_key_input(true)

func _unpause_game():
	get_tree().paused = false
	is_paused = false
	
	set_process_unhandled_key_input(false)

func unpause_game__accessed_for_scene_change():
	_unpause_game()



#######

func pause_game__and_show_hub_pause_panel():
	if main_pause_screen_panel == null:
		_create_main_pause_screen_panel()
	
	show_control(main_pause_screen_panel)
	
	if hub_pause_panel == null:
		_create_hub_pause_panel()
	
	main_pause_screen_panel.show_control_at_content_panel(hub_pause_panel)


func _create_main_pause_screen_panel():
	main_pause_screen_panel = MainPauseScreenPanel_Scene.instance()

func _create_hub_pause_panel():
	hub_pause_panel = HubPausePanel_Scene.instance()
	hub_pause_panel.pause_manager = self
	hub_pause_panel.main_pause_screen_panel = main_pause_screen_panel
	hub_pause_panel.game_elements = game_elements


#

func hide_or_remove_latest_from_pause_tree__and_unpause_if_empty():
	if node_tree_of_pause.size() > 0:
		var node = node_tree_of_pause[node_tree_of_pause.size() - 1]
		
		if !node.get("REMOVE_WHEN_ESCAPED_BY_PAUSE_MANAGER"):
			hide_control(node)
		else:
			remove_control(node)


#


func _unhandled_key_input(event : InputEventKey):
	if !event.echo and event.pressed:
		if event.is_action_pressed("ui_cancel"):
			
			hide_or_remove_latest_from_pause_tree__and_unpause_if_empty()
			
	
	accept_event()




