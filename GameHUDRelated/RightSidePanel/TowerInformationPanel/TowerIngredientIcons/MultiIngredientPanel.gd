extends MarginContainer

const IngredientEffect = preload("res://GameInfoRelated/TowerIngredientRelated/IngredientEffect.gd")
const SingleIngredientPanel_Scene = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/SingleIngredientPanel.tscn")
const SingleIngredientPanel = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/SingleIngredientPanel.gd")

var ingredient_effects : Array = []
var ingredient_effect_limit : int
var _single_ingredient_panels : Array = []
var _single_ingredient_list : VBoxContainer

export(bool) var collapsed_value_by_default : bool = false

var tower_to_use_for_interpreter


const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")

func _ready():
	_single_ingredient_list = $VBoxContainer/ListMargin/Marginer/ScrollContainer/SingleIngredientPanelList
	
	update_display()


func update_display():
	_allocate_single_ingredient_panels()
	_set_ingredient_of_single_panels()
	_set_panels_to_be_children()
	

func _allocate_single_ingredient_panels():
	var difference = ingredient_effects.size() - _single_ingredient_panels.size()
	if difference > 0:
		for i in difference:
			var single_panel = SingleIngredientPanel_Scene.instance()
			single_panel.collapsed = collapsed_value_by_default
			
			_single_ingredient_panels.append(single_panel)
			_single_ingredient_list.add_child(single_panel)


func _set_ingredient_of_single_panels():
	for i in ingredient_effects.size():
		_single_ingredient_panels[i].ingredient_effect = ingredient_effects[i]
		
		if i >= ingredient_effect_limit:
			var panel : SingleIngredientPanel = _single_ingredient_panels[i]
			panel.modulate = Color(0.4, 0.4, 0.4, 1)
			
		else:
			var panel : SingleIngredientPanel = _single_ingredient_panels[i]
			panel.modulate = Color(1, 1, 1, 1)
		
		_single_ingredient_panels[i].tower_to_use_for_interpreter = tower_to_use_for_interpreter
		_single_ingredient_panels[i].update_display()


func _set_panels_to_be_children():
	for child in _single_ingredient_list.get_children():
		#_single_ingredient_list.remove_child(child)
		child.visible = false
	
	for i in ingredient_effects.size():
		if _single_ingredient_panels.size() > i:
			#_single_ingredient_list.add_child(_single_ingredient_panels[i])
			_single_ingredient_panels[i].visible = true
		else:
			break

#func _set_panels_to_be_children():
#	var difference = ingredient_effects.size() - _single_ingredient_list.get_children().size()
#
#	if difference > 0:
#		for i in difference:
#			var index = _single_ingredient_list.get_child_count() - 1
#			_single_ingredient_list.add_child(_single_ingredient_panels[index])
#
#			print(_single_ingredient_panels[index].ingredient_effect.tower_base_effect.description)
#	if difference < 0:
#		for i in -difference:
#			_single_ingredient_list.remove_child(_single_ingredient_panels[_single_ingredient_panels.size() - (i + 1)])
#

# Overriding

func queue_free():
	for panel in _single_ingredient_panels:
		panel.queue_free()
	
	
	.queue_free()
