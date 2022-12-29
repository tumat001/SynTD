extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")

signal on_left_clicked(tower, me)


var _tower : AbstractTower setget set_tower

var in_round_total_dmg : float = 0
var in_round_phy_dmg : float = 0
var in_round_ele_dmg : float = 0
var in_round_pure_dmg : float = 0

onready var damage_label = $HBoxContainer/VBoxContainer/DamageLabel
#onready var damage_bar = $HBoxContainer/VBoxContainer/DamageBar
onready var damage_bar = $HBoxContainer/VBoxContainer/AdvancedDamageSummaryBar
onready var tower_icon_panel = $HBoxContainer/TowerIconPanel

#

func _ready():
	if is_instance_valid(_tower):
		tower_icon_panel.tower_type_info = _tower.tower_type_info
	
	tower_icon_panel.set_button_interactable(false)


#

func set_tower(arg_tower : AbstractTower):
	if is_instance_valid(_tower):
		_tower.disconnect("on_per_round_total_damage_changed", self, "_on_tower_in_round_total_damage_changed")
		_tower.disconnect("displayable_in_damage_stats_panel_changed", self, "_on_tower_displayable_in_damage_stats_panel_changed")
	
	_tower = arg_tower
	
	if is_instance_valid(_tower):
		_tower.connect("on_per_round_total_damage_changed", self, "_on_tower_in_round_total_damage_changed", [], CONNECT_PERSIST | CONNECT_DEFERRED)
		_tower.connect("displayable_in_damage_stats_panel_changed", self, "_on_tower_displayable_in_damage_stats_panel_changed", [], CONNECT_PERSIST)
		
		if is_instance_valid(tower_icon_panel):
			tower_icon_panel.tower_type_info = _tower.tower_type_info
		
		_update_visibility_based_on_factors()


#

func _on_tower_in_round_total_damage_changed(new_total):
	in_round_total_dmg = new_total
	_on_tower_in_round_phy_damage_changed(_tower.in_round_physical_damage_dealt)
	_on_tower_in_round_ele_damage_changed(_tower.in_round_elemental_damage_dealt)
	_on_tower_in_round_pure_damage_changed(_tower.in_round_pure_damage_dealt)

func _on_tower_in_round_phy_damage_changed(new_val):
	in_round_phy_dmg = new_val

func _on_tower_in_round_ele_damage_changed(new_val):
	in_round_ele_dmg = new_val

func _on_tower_in_round_pure_damage_changed(new_val):
	in_round_pure_dmg = new_val

# called update

func update_display(new_max_value : float, new_curr_value : float = in_round_total_dmg):
	#damage_bar.max_value = new_max_value
	#damage_bar.current_value = new_curr_value
	
	damage_bar.max_value = new_max_value
	damage_bar.set_total_damage_val(new_max_value)
	damage_bar.set_physical_damage_val(in_round_phy_dmg)
	damage_bar.set_elemental_damage_val(in_round_ele_dmg)
	damage_bar.set_pure_damage_val(in_round_pure_dmg)
	#damage_bar.update_each_bar_position_based_on_each_other()
	
	damage_label.text = str(stepify(in_round_total_dmg, 0.001))


#

func _on_SingleTowerRoundDamageStatsPanel_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			emit_signal("on_left_clicked", _tower, self)

#

func _on_tower_displayable_in_damage_stats_panel_changed(arg_val):
	_update_visibility_based_on_factors()

func _update_visibility_based_on_factors():
	visible = _tower.displayable_in_damage_stats_panel

