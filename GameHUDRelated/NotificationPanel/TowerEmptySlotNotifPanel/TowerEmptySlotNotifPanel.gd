extends MarginContainer

const TowerManager = preload("res://GameElementsRelated/TowerManager.gd")

const tower_being_dragged_mod : Color = Color(1, 1, 1, 0.1)
const tower_dropped_from_dragged_mod : Color = Color(1, 1, 1, 0.35)

var tower_manager : TowerManager setget set_tower_manager

onready var tower_limit_label = $NotifContainer/VBoxContainer/ContentPanel/LabelMarginer/VBoxContainer/TowerLimitLabel

func _ready():
	modulate = tower_dropped_from_dragged_mod

func set_tower_manager(arg_manager : TowerManager):
	tower_manager = arg_manager
	
	arg_manager.connect("tower_current_limit_taken_changed", self, "_tower_curr_slot_taken_changed", [], CONNECT_PERSIST)
	arg_manager.connect("tower_max_limit_changed", self, "_tower_max_limit_changed", [], CONNECT_PERSIST)
	
	arg_manager.connect("tower_being_dragged", self, "_tower_being_dragged", [], CONNECT_PERSIST)
	arg_manager.connect("tower_dropped_from_dragged", self, "_tower_released", [], CONNECT_PERSIST)
	
	_update_display()

#

func _tower_curr_slot_taken_changed(slots_taken):
	_update_display()

func _tower_max_limit_changed(new_limit):
	_update_display()


func _update_display():
	var max_limit = tower_manager.last_calculated_tower_limit
	var curr_slots_taken = tower_manager.current_tower_limit_taken
	
	if max_limit == curr_slots_taken:
		visible = false
	else:
		visible = true
		tower_limit_label.text = _get_display_string(curr_slots_taken, max_limit)

func _get_display_string(curr_slots : int, max_limit : int) -> String:
	return "%s / %s" % [str(curr_slots), str(max_limit)]

#

func _tower_being_dragged(tower):
	modulate = tower_being_dragged_mod

func _tower_released(tower):
	modulate = tower_dropped_from_dragged_mod
