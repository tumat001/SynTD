extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const ExtraInfoPanel = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/ExtraInfoPanelComponents/ExtraInfoPanel.gd")
const ExtraInfoPanel_Scene = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/ExtraInfoPanelComponents/ExtraInfoPanel.tscn")


var tower : AbstractTower

onready var active_ing_panel = $VBoxContainer/ActiveIngredientsPanel
onready var tower_name_and_pic_panel = $VBoxContainer/TowerNameAndPicPanel
onready var targeting_panel = $VBoxContainer/TargetingPanel

onready var tower_colors_panel = $VBoxContainer/TowerColorsPanel
onready var tower_stats_panel = $VBoxContainer/TowerStatsPanel

var extra_info_panel : ExtraInfoPanel


func _ready():
	pass

func update_display():
	
	# Tower name and pic display related
	tower_name_and_pic_panel.tower = tower
	tower_name_and_pic_panel.update_display()
	
	# Targeting panel related
	targeting_panel.tower = tower
	targeting_panel.update_display()
	
	# Colors panel
	tower_colors_panel.tower = tower
	tower_colors_panel.update_display()
	
	# Stats panel
	tower_stats_panel.tower = tower
	tower_stats_panel.update_display()
	
	# Active Ingredients display related
	active_ing_panel.tower = tower
	active_ing_panel.update_display()


# Visibility

func set_visible(value : bool):
	visible = value
	
	if !value:
		_destroy_extra_info_panel()



# Extra info panel related

func _on_TowerNameAndPicPanel_show_extra_tower_info():
	if extra_info_panel == null:
		_create_extra_info_panel()
	else:
		_destroy_extra_info_panel()


func _create_extra_info_panel():
	extra_info_panel = ExtraInfoPanel_Scene.instance()
	
	extra_info_panel.tower = tower
	
	var topleft_pos = get_global_rect().position
	var pos_of_info_panel = Vector2(topleft_pos.x - 150, topleft_pos.y)
	
	extra_info_panel.rect_global_position = pos_of_info_panel
	get_tree().get_root().add_child(extra_info_panel)
	extra_info_panel._update_display()


func _destroy_extra_info_panel():
	if extra_info_panel != null:
		extra_info_panel.queue_free()
		extra_info_panel = null
