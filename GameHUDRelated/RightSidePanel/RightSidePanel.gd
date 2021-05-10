extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")

enum Panels {
	ROUND,
	TOWER_INFO,
}

var panel_showing : int
var current_tower_showing : AbstractTower


func _ready():
	show_round_panel()


func show_round_panel():
	$TowerInfoPanel.visible = false
	
	panel_showing = Panels.ROUND
	
	if current_tower_showing != null:
		if current_tower_showing.is_showing_ranges:
			current_tower_showing.toggle_module_ranges()
	current_tower_showing = null
	

func show_tower_info_panel(tower : AbstractTower = null):
	$TowerInfoPanel.visible = true
	$TowerInfoPanel.tower = tower
	$TowerInfoPanel.update_display()
	current_tower_showing = tower
	if !tower.is_showing_ranges:
		tower.toggle_module_ranges()
	
	panel_showing = Panels.TOWER_INFO
