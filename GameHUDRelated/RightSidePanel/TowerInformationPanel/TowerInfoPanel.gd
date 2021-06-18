extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const ExtraInfoPanel = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/ExtraInfoPanelComponents/ExtraInfoPanel.gd")
const ExtraInfoPanel_Scene = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/ExtraInfoPanelComponents/ExtraInfoPanel.tscn")
const EnergyModulePanel = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/Panels/EnergyModulePanel/EnergyModulePanel.gd")
const EnergyModulePanel_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/Panels/EnergyModulePanel/EnergyModulePanel.tscn")
const HeatModulePanel = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/Panels/HeatModuleMainPanel/HeatModulePanel.gd")
const HeatModulePanel_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/Panels/HeatModuleMainPanel/HeatModulePanel.tscn")

const _704_InfoPanel = preload("res://TowerRelated/Color_Orange/704/704_InfoPanel/704_InfoPanel.gd")
const _704_InfoPanel_Scene = preload("res://TowerRelated/Color_Orange/704/704_InfoPanel/704_InfoPanel.tscn")
const Leader_SelectionPanel = preload("res://TowerRelated/Color_Blue/Leader/Ability/TowerSelectionPanel/Leader_SelectionPanel.gd")
const Leader_SelectionPanel_Scene = preload("res://TowerRelated/Color_Blue/Leader/Ability/TowerSelectionPanel/Leader_SelectionPanel.tscn")

var tower : AbstractTower

onready var active_ing_panel = $VBoxContainer/ActiveIngredientsPanel
onready var tower_name_and_pic_panel = $VBoxContainer/TowerNameAndPicPanel
onready var targeting_panel = $VBoxContainer/TargetingPanel

onready var tower_stats_panel = $VBoxContainer/TowerStatsPanel

onready var energy_module_extra_slot = $VBoxContainer/EnergyModuleExtraSlot
onready var heat_module_extra_slot = $VBoxContainer/HeatModuleExtraSlot
onready var tower_specific_slot = $VBoxContainer/TowerSpecificSlot

var extra_info_panel : ExtraInfoPanel

var energy_module_panel : EnergyModulePanel
var heat_module_panel : HeatModulePanel

var _704_info_panel : _704_InfoPanel
var leader_selection_panel : Leader_SelectionPanel


func _ready():
	energy_module_extra_slot.visible = false
	heat_module_extra_slot.visible = false


func update_display():
	
	# Tower name and pic display related
	tower_name_and_pic_panel.tower = tower
	tower_name_and_pic_panel.update_display()
	
	# Targeting panel related
	targeting_panel.tower = tower
	targeting_panel.update_display()
	
	# Stats panel
	tower_stats_panel.tower = tower
	tower_stats_panel.update_display()
	
	# Active Ingredients display related
	active_ing_panel.tower = tower
	active_ing_panel.update_display()
	
	
	# Energy Module (In Bottom Extra Slot)
	update_display_of_energy_module()
	
	# Heat Module (slot)
	update_display_of_heat_module_panel()
	
	
	# tower specific slot
	_update_tower_specific_info_panel()


# Visibility

func set_visible(value : bool):
	visible = value
	
	if !value:
		_destroy_extra_info_panel()



# Extra info panel related (description and self ingredient)

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


# ENERGY MODULE PANEL DISPLAY RELATED --------------

func update_display_of_energy_module():
	if tower.energy_module != null:
		if energy_module_panel == null:
			energy_module_panel = EnergyModulePanel_Scene.instance()
			energy_module_extra_slot.add_child(energy_module_panel)
		
		energy_module_panel.energy_module = tower.energy_module
		energy_module_panel.visible = true
		energy_module_panel.update_display()
		energy_module_extra_slot.update_visibility_based_on_children()
		
	else:
		if energy_module_panel != null:
			energy_module_panel.visible = false
			energy_module_extra_slot.update_visibility_based_on_children()


# HEAT MODULE PANEL DISPLAY RELATED -----------------

func update_display_of_heat_module_panel():
	if tower.heat_module != null and tower.heat_module.should_be_shown_in_info_panel:
		if heat_module_panel == null:
			heat_module_panel = HeatModulePanel_Scene.instance()
			heat_module_extra_slot.add_child(heat_module_panel)
		
		heat_module_panel.heat_module = tower.heat_module
		heat_module_panel.visible = true
		heat_module_panel.update_display()
		heat_module_extra_slot.update_visibility_based_on_children()
		
	else:
		if heat_module_panel != null:
			heat_module_panel.visible = false
			heat_module_extra_slot.update_visibility_based_on_children()


# TOWER SPECIFIC INFO PANEL -----------------

func _update_tower_specific_info_panel():
	# 704
	if _704_InfoPanel.should_display_self_for(tower):
		if _704_info_panel == null:
			_704_info_panel = _704_InfoPanel_Scene.instance()
			tower_specific_slot.add_child(_704_info_panel)
		
		_704_info_panel.visible = true
		_704_info_panel.tower_704 = tower
		_704_info_panel.update_display()
		
	else:
		if _704_info_panel != null:
			_704_info_panel.visible = false
			_704_info_panel.tower_704 = null
	
	
	# Leader
	if Leader_SelectionPanel.should_display_self_for(tower):
		if leader_selection_panel == null:
			leader_selection_panel = Leader_SelectionPanel_Scene.instance()
			tower_specific_slot.add_child(leader_selection_panel)
		
		leader_selection_panel.visible = true
		leader_selection_panel.set_leader(tower)
		
	else:
		if leader_selection_panel != null:
			leader_selection_panel.visible = false
			leader_selection_panel.set_leader(null)
	
	tower_specific_slot.update_visibility_based_on_children()


# queue free

func queue_free():
	if energy_module_panel != null:
		energy_module_panel.queue_free()
	
	.queue_free()
