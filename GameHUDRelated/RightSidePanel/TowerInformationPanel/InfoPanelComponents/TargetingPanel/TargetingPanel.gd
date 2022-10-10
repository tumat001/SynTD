extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const Targeting = preload("res://GameInfoRelated/Targeting.gd")

var tower : AbstractTower

onready var button_left = $HBoxContainer/ButtonLeftMarginer/ButtonLeft
onready var button_right = $HBoxContainer/ButtonRightMarginer/ButtonRight
onready var targeting_label = $HBoxContainer/TargetPanelMarginer/Marginer/TargetingLabel

var _is_button_hiding : bool

func update_display():
	if is_instance_valid(tower) and is_instance_valid(tower.range_module):
		var targetings = tower.range_module.all_distinct_targeting_options
		var current_targeting = tower.range_module.get_current_targeting_option()
		
		if targetings.size() > 1:
			_show_buttons()
		else:
			_hide_buttons()
		
		if current_targeting != -1:
			targeting_label.text = Targeting.get_name_as_string(current_targeting)
		else:
			_hide_targeting_label()
		
	else:
		_hide_buttons()
		_hide_targeting_label()


func _hide_buttons():
	button_left.self_modulate.a = 0
	button_right.self_modulate.a = 0
	_is_button_hiding = true

func _show_buttons():
	button_left.self_modulate.a = 1
	button_right.self_modulate.a = 1
	_is_button_hiding = false

func _hide_targeting_label():
	targeting_label.text = ""


# Functions



func _on_ButtonLeft_pressed():
	cycle_targeting_left()

func cycle_targeting_left():
	if visible:
		if !_is_button_hiding and is_instance_valid(tower) and is_instance_valid(tower.range_module):
			tower.range_module.targeting_cycle_left()
			update_display()


func _on_ButtonRight_pressed():
	cycle_targeting_right()

func cycle_targeting_right():
	if visible:
		if !_is_button_hiding and is_instance_valid(tower) and is_instance_valid(tower.range_module):
			tower.range_module.targeting_cycle_right()
			update_display()
