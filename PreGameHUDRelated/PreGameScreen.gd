extends Control

const StartingScreen = preload("res://PreGameHUDRelated/StartingScreen/StartingScreen.gd")
const StartingScreen_Scene = preload("res://PreGameHUDRelated/StartingScreen/StartingScreen.tscn")


var node_tree_of_screen : Array = []
var starting_screen : StartingScreen
var current_visible_control : Control

#

func _ready():
	starting_screen = StartingScreen_Scene.instance()
	show_control(starting_screen)
	
	visible = true
	starting_screen.pre_game_screen = self


#

func show_control(control : Control):
	if !node_tree_of_screen.has(control):
		node_tree_of_screen.append(control)
	
	if !has_control(control):
		add_child(control)
	
	if current_visible_control != null:
		current_visible_control.visible = false
	
	current_visible_control = control
	control.visible = true
	
	visible = true


func hide_control(control : Control):
	control.visible = false
	
	if node_tree_of_screen.has(control):
		node_tree_of_screen.erase(control)
	
	if node_tree_of_screen.size() > 0:
		var node = node_tree_of_screen[node_tree_of_screen.size() - 1]
		if node != null:
			node.visible = true
			current_visible_control = node


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


func remove_control(arg_control : Control):
	if !arg_control.is_queued_for_deletion():
		arg_control.queue_free()
	
	hide_control(arg_control)


#

func hide_or_remove_latest_from_node_tree__except_for_starting_screen():
	if node_tree_of_screen.size() > 0:
		var node = node_tree_of_screen[node_tree_of_screen.size() - 1]
		
		if node != starting_screen:
			# remove control if this var/property is not defined or set to false
			if !node.get("REMOVE_WHEN_ESCAPED_BY_PRE_GAME_SCREEN"):
				hide_control(node)
			else:
				remove_control(node)


#

func _unhandled_key_input(event : InputEventKey):
	if !event.echo and event.pressed:
		if event.is_action_pressed("ui_cancel"):
			hide_or_remove_latest_from_node_tree__except_for_starting_screen()
	
	accept_event()
