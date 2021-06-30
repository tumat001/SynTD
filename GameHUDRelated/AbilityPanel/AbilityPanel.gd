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


func has_ability(ability : BaseAbility):
	for ability_button in ability_container.get_children():
		if ability_button.ability == ability:
			return true
	
	return false


func activate_ability_at_index(i : int):
	if ability_container.get_child_count() > i:
		var button_selected : AbilityButton = ability_container.get_children()[i]
		button_selected._ability_button_left_pressed()

