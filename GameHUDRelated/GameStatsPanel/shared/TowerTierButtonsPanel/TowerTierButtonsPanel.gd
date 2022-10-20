extends MarginContainer


signal tiers_selected_changed(arg_selected_tiers_arr)

onready var tier_button_01 = $MarginContainer/HBoxContainer/TowerTierButton01
onready var tier_button_02 = $MarginContainer/HBoxContainer/TowerTierButton02
onready var tier_button_03 = $MarginContainer/HBoxContainer/TowerTierButton03
onready var tier_button_04 = $MarginContainer/HBoxContainer/TowerTierButton04
onready var tier_button_05 = $MarginContainer/HBoxContainer/TowerTierButton05
onready var tier_button_06 = $MarginContainer/HBoxContainer/TowerTierButton06

#

var all_tier_buttons : Array = []
var selected_tiers : Array = []

#

func _ready():
	all_tier_buttons.append(tier_button_01)
	all_tier_buttons.append(tier_button_02)
	all_tier_buttons.append(tier_button_03)
	all_tier_buttons.append(tier_button_04)
	all_tier_buttons.append(tier_button_05)
	all_tier_buttons.append(tier_button_06)
	
	for i in 6:
		all_tier_buttons[i].tier = i + 1

#

func _on_TowerTierButton01_on_clicked():
	tier_button_01.selected = !tier_button_01.selected
	_update_and_emit_selected_tiers()


func _on_TowerTierButton02_on_clicked():
	tier_button_02.selected = !tier_button_02.selected
	_update_and_emit_selected_tiers()


func _on_TowerTierButton03_on_clicked():
	tier_button_03.selected = !tier_button_03.selected
	_update_and_emit_selected_tiers()


func _on_TowerTierButton04_on_clicked():
	tier_button_04.selected = !tier_button_04.selected
	_update_and_emit_selected_tiers()


func _on_TowerTierButton05_on_clicked():
	tier_button_05.selected = !tier_button_05.selected
	_update_and_emit_selected_tiers()


func _on_TowerTierButton06_on_clicked():
	tier_button_06.selected = !tier_button_06.selected
	_update_and_emit_selected_tiers()

#

func _update_and_emit_selected_tiers():
	_update_selected_tiers()
	_emit_selected_tiers_signal()

func _update_selected_tiers():
	for button in all_tier_buttons:
		if button.selected:
			if !selected_tiers.has(button.tier):
				selected_tiers.append(button.tier)
		else:
			selected_tiers.erase(button.tier)

func _emit_selected_tiers_signal():
	emit_signal("tiers_selected_changed", selected_tiers.duplicate())

#

func select_all_tier_buttons():
	for button in all_tier_buttons:
		button.selected = true
	
	_update_and_emit_selected_tiers()


