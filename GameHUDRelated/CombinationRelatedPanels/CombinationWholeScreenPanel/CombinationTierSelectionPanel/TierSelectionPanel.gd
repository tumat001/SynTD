extends MarginContainer

const TowerTierButton = preload("res://GameHUDRelated/CombinationRelatedPanels/CombinationWholeScreenPanel/CombinationTowerTierButton/TowerTierButton.gd")
const TowerTierButton_Scene = preload("res://GameHUDRelated/CombinationRelatedPanels/CombinationWholeScreenPanel/CombinationTowerTierButton/TowerTierButton.tscn")


signal on_tier_selected(arg_tier)

onready var container = $BoxContainer

var selected_tier : int
var all_buttons : Array

func _ready():
	for i in 6:
		var tier = i + 1
		var button = TowerTierButton_Scene.instance()
		
		container.add_child(button)
		
		button.tier = tier
		button.selected = false
		button.connect("on_clicked", self, "_button_clicked", [button], CONNECT_PERSIST)
		
		all_buttons.append(button)
	
	_button_clicked(all_buttons[0])



func _button_clicked(arg_button):
	selected_tier = arg_button.tier
	
	for button in all_buttons:
		if arg_button != button:
			button.set_selected(false)
		else:
			button.set_selected(true)
	
	emit_signal("on_tier_selected", selected_tier)


