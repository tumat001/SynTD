extends MarginContainer

const IngredientEffect = preload("res://GameInfoRelated/TowerIngredientRelated/IngredientEffect.gd")
const SingleIngredientPanel_Scene = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/SingleIngredientPanel.tscn")
const SingleIngredientPanel = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/SingleIngredientPanel.gd")

var ingredient_effects : Array = []
var ingredient_effect_limit : int
var single_ingredient_panels : Array = []
var single_ingredient_list : VBoxContainer


func _ready():
	single_ingredient_list = $VBoxContainer/ListMargin/Marginer/ScrollContainer/SingleIngredientPanelList
	
	update_display()


func update_display():
	_allocate_single_ingredient_panels()
	_set_ingredient_of_single_panels()
	_set_panels_to_be_children()


func _allocate_single_ingredient_panels():
	var difference = ingredient_effects.size() - single_ingredient_panels.size()
	if difference > 0:
		for i in difference:
			var single_panel = SingleIngredientPanel_Scene.instance()
			single_ingredient_panels.append(single_panel)

func _set_ingredient_of_single_panels():
	for i in ingredient_effects.size():
		single_ingredient_panels[i].ingredient_effect = ingredient_effects[i]
		
		if i < ingredient_effect_limit:
			var panel : SingleIngredientPanel = single_ingredient_panels[i]
			panel.modulate = Color(0.4, 0.4, 0.4, 1)
			
		else:
			var panel : SingleIngredientPanel = single_ingredient_panels[i]
			panel.modulate = Color(1, 1, 1, 1)
		
		single_ingredient_panels[i].update_display()

func _set_panels_to_be_children():
	var difference = ingredient_effects.size() - single_ingredient_list.get_children().size()
	
	if difference > 0:
		for i in difference:
			var index = i + difference - 1
			single_ingredient_list.add_child(single_ingredient_panels[index])
	if difference < 0:
		for i in -difference:
			single_ingredient_list.remove_child(single_ingredient_panels[single_ingredient_panels.size() - (i + 1)])


# Overriding

func queue_free():
	for panel in single_ingredient_panels:
		panel.queue_free()
	
	.queue_free()
