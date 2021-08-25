extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")


var _tower : AbstractTower setget set_tower

var in_round_total_dmg : float = 0

onready var damage_label = $HBoxContainer/VBoxContainer/DamageLabel
onready var damage_bar = $HBoxContainer/VBoxContainer/DamageBar
onready var tower_icon_panel = $HBoxContainer/TowerIconPanel

#

func _ready():
	if _tower != null:
		tower_icon_panel.tower_type_info = _tower.tower_type_info


#

func set_tower(arg_tower : AbstractTower):
	if _tower != null:
		_tower.disconnect("on_per_round_total_damage_changed", self, "_on_tower_in_round_total_damage_changed")
	
	_tower = arg_tower
	
	if _tower != null:
		_tower.connect("on_per_round_total_damage_changed", self, "_on_tower_in_round_total_damage_changed", [], CONNECT_PERSIST | CONNECT_DEFERRED)
		
		if tower_icon_panel != null:
			tower_icon_panel.tower = _tower

#

func _on_tower_in_round_total_damage_changed(new_total):
	in_round_total_dmg = new_total


# called update

func update_display(new_max_value : float):
	damage_bar.max_value = new_max_value
	damage_bar.current_value = in_round_total_dmg
	
	damage_label.text = str(stepify(in_round_total_dmg, 0.001))


#

