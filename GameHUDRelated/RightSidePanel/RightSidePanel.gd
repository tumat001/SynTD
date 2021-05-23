extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const TowerInfoPanel = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerInfoPanel.gd")
const RoundStatusPanel = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundStatusPanel.gd")

enum Panels {
	ROUND,
	TOWER_INFO,
}

var panel_showing : int
var current_tower_showing : AbstractTower

onready var tower_info_panel : TowerInfoPanel = $TowerInfoPanel
onready var round_status_panel : RoundStatusPanel = $RoundStatusPanel


func _ready():
	show_round_panel()


func show_round_panel():
	
	# Tower Info
	tower_info_panel.set_visible(false)
	
	if current_tower_showing != null:
		if current_tower_showing.is_showing_ranges:
			current_tower_showing.toggle_module_ranges()
	current_tower_showing = null
	
	# Round
	round_status_panel.visible = true
	
	panel_showing = Panels.ROUND

func show_tower_info_panel(tower : AbstractTower = null):
	
	# Round
	round_status_panel.visible = false
	
	# Tower Info
	tower_info_panel.set_visible(true)
	tower_info_panel.tower = tower
	tower_info_panel.update_display()
	current_tower_showing = tower
	if !tower.is_showing_ranges:
		tower.toggle_module_ranges()
	
	panel_showing = Panels.TOWER_INFO
