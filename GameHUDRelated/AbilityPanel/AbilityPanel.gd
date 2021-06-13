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

