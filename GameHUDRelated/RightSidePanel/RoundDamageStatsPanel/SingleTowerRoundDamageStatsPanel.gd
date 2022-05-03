extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")

signal on_left_clicked(tower, me)


var _tower : AbstractTower setget set_tower

var in_round_total_dmg : float = 0

onready var damage_label = $HBoxContainer/VBoxContainer/DamageLabel
onready var damage_bar = $HBoxContainer/VBoxContainer/DamageBar
onready var tower_icon_panel = $HBoxContainer/TowerIconPanel

#

func _ready():
	if _tower != null:
		tower_icon_panel.tower_type_info = _tower.tower_type_info
	
	tower_icon_panel.set_button_interactable(false)


#

func set_tower(arg_tower : AbstractTower):
	if _tower != null:
		_tower.disconnect("on_per_round_total_damage_changed", self, "_on_tower_in_round_total_damage_changed")
	
	_tower = arg_tower
	
	if _tower != null:
		_tower.connect("on_per_round_total_damage_changed", self, "_on_tower_in_round_total_damage_changed", [], CONNECT_PERSIST | CONNECT_DEFERRED)
		
		if tower_icon_panel != null:
			tower_icon_panel.tower_type_info = _tower.tower_type_info



#

func _on_tower_in_round_total_damage_changed(new_total):
	in_round_total_dmg = new_total


# called update

func update_display(new_max_value : float, new_curr_value : float = in_round_total_dmg):
	damage_bar.max_value = new_max_value
	damage_bar.current_value = new_curr_value
	
	damage_label.text = str(stepify(in_round_total_dmg, 0.001))


#

func _on_SingleTowerRoundDamageStatsPanel_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			emit_signal("on_left_clicked", _tower, self)
