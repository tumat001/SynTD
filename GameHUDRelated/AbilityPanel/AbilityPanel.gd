extends MarginContainer


const BaseAbility = preload("res://GameInfoRelated/AbilityRelated/BaseAbility.gd")
const AbilityButton = preload("res://GameHUDRelated/AbilityPanel/AbilityButton.gd")
const AbilityButtonScene = preload("res://GameHUDRelated/AbilityPanel/AbilityButton.tscn")

onready var ability_container : Control = $ScrollContainer/AbilityContainer


func add_ability(ability : BaseAbility):
	if !has_ability(ability):
		var ability_button = AbilityButtonScene.instance()
		
		ability_container.add_child(ability_button)
		ability_button.ability = ability
		
		ability_button.connect("visibility_changed", self, "_ability_button_visibility_changed", [], CONNECT_PERSIST)
		_update_all_buttons_hotkey_num()


func has_ability(ability : BaseAbility):
	for ability_button in ability_container.get_children():
		if ability_button.ability == ability:
			return true
	
	return false


#

func activate_ability_at_index(i : int):
	var ability_buttons : Array = ability_container.get_children()
	
	for button in ability_buttons:
		if button.hotkey_num == i + 1:
			button._ability_button_left_pressed()
#	var displayed_buttons : Array = []
#
#	for button in ability_buttons:
#		if button.visible:
#			displayed_buttons.append(button)
#
#	if displayed_buttons.size() > i:
#		var button_selected : AbilityButton = displayed_buttons[i]
#		button_selected._ability_button_left_pressed()

#

func _ability_button_visibility_changed():
	_update_all_buttons_hotkey_num()

func _update_all_buttons_hotkey_num():
	var ability_buttons : Array = ability_container.get_children()
	var displayed_buttons : Array = []
	var not_displayed_buttons : Array = []
	
	for button in ability_buttons:
		if button.visible:
			displayed_buttons.append(button)
		else:
			not_displayed_buttons.append(button)
	
	for button in not_displayed_buttons:
		button.hotkey_num = AbilityButton.NO_HOTKEY_NUM
	
	for i in displayed_buttons.size():
		displayed_buttons[i].hotkey_num = i + 1

