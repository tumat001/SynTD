extends MarginContainer


const BaseAbility = preload("res://GameInfoRelated/AbilityRelated/BaseAbility.gd")
const AbilityButton = preload("res://GameHUDRelated/AbilityPanel/AbilityButton.gd")
const AbilityButtonScene = preload("res://GameHUDRelated/AbilityPanel/AbilityButton.tscn")

onready var ability_container : Control = $ScrollContainer/AbilityContainer
var game_settings_manager

func add_ability(ability : BaseAbility):
	if !has_ability(ability):
		var ability_button = AbilityButtonScene.instance()
		
		ability_container.add_child(ability_button)
		ability_button.ability = ability
		ability_button._ability_panel = self
		ability_button.is_drag_and_droppable = true
		ability_button.game_settings_manager = game_settings_manager
		
		ability_button.connect("visibility_changed", self, "_ability_button_visibility_changed", [], CONNECT_PERSIST)
		ability_button.connect("button_destroying_self", self, "_ability_button_destroying_self", [], CONNECT_PERSIST)
		_update_all_buttons_hotkey_num()


func has_ability(ability : BaseAbility):
	for ability_button in ability_container.get_children():
		if ability_button.ability == ability:
			return true
	
	return false


#func remove_ability(ability : BaseAbility):
#	if has_ability(ability):
#		var ability_button = get_ability_button_with_ability(ability)
#		ability_button.destroy_self()
#
#		_update_all_buttons_hotkey_num()



#

func activate_ability_at_index(i : int):
	#var ability_buttons : Array = ability_container.get_children()
	
	var ability_button_to_activate = get_ability_button_with_hotkey(i + 1)
	if is_instance_valid(ability_button_to_activate):
		ability_button_to_activate._ability_button_left_pressed()
	
	#for button in ability_buttons:
	#	if button.hotkey_num == i + 1:
	#		button._ability_button_left_pressed()
#	var displayed_buttons : Array = []
#
#	for button in ability_buttons:
#		if button.visible:
#			displayed_buttons.append(button)
#
#	if displayed_buttons.size() > i:
#		var button_selected : AbilityButton = displayed_buttons[i]
#		button_selected._ability_button_left_pressed()

func get_ability_button_with_hotkey(hotkey : int) -> AbilityButton:
	var ability_buttons : Array = ability_container.get_children()
	
	for button in ability_buttons:
		if button.hotkey == str(hotkey):
			return button
	
	return null

func get_ability_button_with_ability(ability : BaseAbility) -> AbilityButton:
	var ability_buttons : Array = ability_container.get_children()
	
	for button in ability_buttons:
		if button.ability == ability:
			return button
	
	return null


#

func _ability_button_visibility_changed():
	_update_all_buttons_hotkey_num()

func _ability_button_destroying_self():
	_update_all_buttons_hotkey_num()


func _update_all_buttons_hotkey_num():
	var ability_buttons : Array = ability_container.get_children()
	var displayed_buttons : Array = []
	var not_displayed_buttons : Array = []
	
	for button in ability_buttons:
		if button.visible and !button.is_queued_for_deletion():
			displayed_buttons.append(button)
		else:
			not_displayed_buttons.append(button)
	
	for button in not_displayed_buttons:
		button.hotkey = AbilityButton.NO_HOTKEY
	
	for i in displayed_buttons.size():
		displayed_buttons[i].hotkey = str(i + 1)


#

func get_all_ability_buttons() -> Array:
	return ability_container.get_children()

func get_current_hovered_ability_button() -> AbilityButton:
	for button in get_all_ability_buttons():
		if button.is_mouse_inside_button:
			return button
	
	return null


#

func swap_buttons_with_hotkeys(hotkey01 : int, hotkey02 : int):
	var button_with_hotkey01 = get_ability_button_with_hotkey(hotkey01)
	var button_with_hotkey02 = get_ability_button_with_hotkey(hotkey02)
	var all_ability_buttons = get_all_ability_buttons()
	
	if is_instance_valid(button_with_hotkey01) and is_instance_valid(button_with_hotkey02):
		var button_01_index : int = get_all_ability_buttons().find(button_with_hotkey01)
		var button_02_index : int = get_all_ability_buttons().find(button_with_hotkey02)
		
		ability_container.move_child(button_with_hotkey01, button_02_index)
		ability_container.move_child(button_with_hotkey02, button_01_index)
		
		button_with_hotkey01.hotkey = str(hotkey02)
		button_with_hotkey02.hotkey = str(hotkey01)
		

