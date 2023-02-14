extends MarginContainer

const TowerManager = preload("res://GameElementsRelated/TowerManager.gd")

const tower_being_dragged_mod : Color = Color(1, 1, 1, 0.1)
const tower_dropped_from_dragged_mod : Color = Color(1, 1, 1, 0.35)


const violet_syn_name : String = "Violet"

var tower_manager : TowerManager setget set_tower_manager
var synergy_manager setget set_synergy_manager

onready var tower_limit_label = $NotifContainer/VBoxContainer/ContentPanel/LabelMarginer/VBoxContainer/TowerLimitLabel

#


func _ready():
	modulate = tower_dropped_from_dragged_mod

func set_tower_manager(arg_manager : TowerManager):
	tower_manager = arg_manager
	
	arg_manager.connect("tower_current_limit_taken_changed", self, "_tower_curr_slot_taken_changed", [], CONNECT_PERSIST)
	arg_manager.connect("tower_max_limit_changed", self, "_tower_max_limit_changed", [], CONNECT_PERSIST)
	
	arg_manager.connect("tower_being_dragged", self, "_tower_being_dragged", [], CONNECT_PERSIST)
	arg_manager.connect("tower_dropped_from_dragged", self, "_tower_released", [], CONNECT_PERSIST)

func set_synergy_manager(arg_manager):
	synergy_manager = arg_manager
	
	synergy_manager.connect("synergies_updated", self, "_syns_updated", [], CONNECT_PERSIST)

func all_properties_set():
	_update_display()


#

func _tower_curr_slot_taken_changed(slots_taken):
	_update_display()

func _tower_max_limit_changed(new_limit):
	_update_display()

func _syns_updated():
	_update_display()



func _update_display():
	var max_limit = tower_manager.last_calculated_tower_limit
	var curr_slots_taken = tower_manager.current_tower_limit_taken
	
	#if max_limit == curr_slots_taken or synergy_manager.is_dom_color_synergy_active(TowerDominantColors.synergies[violet_syn_name]):
	if max_limit == curr_slots_taken or synergy_manager.is_dom_color_synergy_active(TowerDominantColors.SynergyID__Violet):
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
