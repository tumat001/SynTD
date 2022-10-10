extends MarginContainer

const Wave_SlotIndicator = preload("res://TowerRelated/Color_Blue/Wave/Ability/Wave_SlotIndicator.gd")
const Wave_SlotIndicator_Scene = preload("res://TowerRelated/Color_Blue/Wave/Ability/Wave_SlotIndicator.tscn")


var wave_tower setget set_wave_tower
var _slots_castable : int

var _uninitialized : bool = true

onready var slot_indicator_container = $SlotIndicatorContainer

#

func _ready():
	size_flags_horizontal = SIZE_EXPAND | SIZE_SHRINK_CENTER

#

func set_wave_tower(arg_tower):
	wave_tower = arg_tower
	
	if is_instance_valid(wave_tower):
		wave_tower.connect("effect_modifier_changed", self, "_effect_modi_changed", [], CONNECT_PERSIST)
		_slots_castable = wave_tower.base_damage_amount_modifier / wave_tower.debuff_damage_amount_per_cast
		
		if _uninitialized:
			_initialize_slots_indicators()
			_uninitialized = false
		
		_effect_modi_changed(wave_tower._get_final_damage_mod())


func _initialize_slots_indicators():
	for i in _slots_castable:
		var slot_indicator = Wave_SlotIndicator_Scene.instance()
		slot_indicator.mouse_filter = MOUSE_FILTER_IGNORE
		
		slot_indicator_container.add_child(slot_indicator)


#

func _effect_modi_changed(amount):
	var wave_shots_charged : int = amount / wave_tower.debuff_damage_amount_per_cast
	
	var slot_indicators : Array = slot_indicator_container.get_children()
	for i in slot_indicator_container.get_child_count():
		if i < wave_shots_charged:
			slot_indicators[i].set_slot_active()
		else:
			slot_indicators[i].set_slot_empty()


