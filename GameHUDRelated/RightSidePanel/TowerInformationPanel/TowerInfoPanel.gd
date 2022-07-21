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
const Orb_InfoPanel = preload("res://TowerRelated/Color_Blue/Orb/Orb_InfoPanel/Orb_InfoPanel.gd")
const Orb_InfoPanel_Scene = preload("res://TowerRelated/Color_Blue/Orb/Orb_InfoPanel/Orb_InfoPanel.tscn")
const Wave_InfoPanel = preload("res://TowerRelated/Color_Blue/Wave/Ability/WaveInfoPanel.gd")
const Wave_InfoPanel_Scene = preload("res://TowerRelated/Color_Blue/Wave/Ability/WaveInfoPanel.tscn")
const Hero_InfoPanel = preload("res://TowerRelated/Color_White/Hero/HeroInfoPanel_Related/HeroInfoPanel.gd")
const Hero_InfoPanel_Scene = preload("res://TowerRelated/Color_White/Hero/HeroInfoPanel_Related/HeroInfoPanel.tscn")
const Blossom_InfoPanel = preload("res://TowerRelated/Color_Green/Blossom/AbilityPanel/Blossom_InfoPanel.gd")
const Blossom_InfoPanel_Scene = preload("res://TowerRelated/Color_Green/Blossom/AbilityPanel/Blossom_InfoPanel.tscn")
const Brewd_InfoPanel = preload("res://TowerRelated/Color_Green/Brewd/Panels/Brewd_InfoPanel.gd")
const Brewd_InfoPanel_Scene = preload("res://TowerRelated/Color_Green/Brewd/Panels/Brewd_InfoPanel.tscn")
const BeaconDish_EffectPanel = preload("res://TowerRelated/Color_Yellow/BeaconDish/BeaconDish_Panel/BeaconDish_EffectPanel.gd")
const BeaconDish_EffectPanel_Scene = preload("res://TowerRelated/Color_Yellow/BeaconDish/BeaconDish_Panel/BeaconDish_EffectPanel.tscn")
const SePropager_InfoPanel = preload("res://TowerRelated/Color_Green/SePropager/GUI/SePropagerInfoPanel.gd")
const SePropager_InfoPanel_Scene = preload("res://TowerRelated/Color_Green/SePropager/GUI/SePropagerInfoPanel.tscn")
const LAssaut_InfoPanel = preload("res://TowerRelated/Color_Green/L'Assaut/GUI/LAssaut_InfoPanel.gd")
const LAssaut_InfoPanel_Scene = preload("res://TowerRelated/Color_Green/L'Assaut/GUI/LAssaut_InfoPanel.tscn")
const LaChasseur_InfoPanel = preload("res://TowerRelated/Color_Green/La_Chasseur/GUI/LaChasseur_InfoPanel.gd")
const LaChasseur_InfoPanel_Scene = preload("res://TowerRelated/Color_Green/La_Chasseur/GUI/LaChasseur_InfoPanel.tscn")



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
var orb_info_panel : Orb_InfoPanel
var wave_info_panel : Wave_InfoPanel
var hero_info_panel : Hero_InfoPanel
var blossom_info_panel : Blossom_InfoPanel
var brewd_info_panel : Brewd_InfoPanel
var beacon_dish_effect_panel : BeaconDish_EffectPanel
var se_propager_info_panel : SePropager_InfoPanel
var lassaut_info_panel : LAssaut_InfoPanel
var la_chasseur_info_panel : LaChasseur_InfoPanel


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
	var size_x_of_extra_info_panel = extra_info_panel.rect_size.x
	var pos_of_info_panel = Vector2(topleft_pos.x - size_x_of_extra_info_panel, topleft_pos.y)
	
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
	
	
	# Orb
	if Orb_InfoPanel.should_display_self_for(tower):
		if orb_info_panel == null:
			orb_info_panel = Orb_InfoPanel_Scene.instance()
			tower_specific_slot.add_child(orb_info_panel)
		
		orb_info_panel.visible = true
		orb_info_panel.set_orb_tower(tower)
	else:
		if orb_info_panel != null:
			orb_info_panel.visible = false
			orb_info_panel.set_orb_tower(null)
	
	
	# Wave
	if Wave_InfoPanel.should_display_self_for(tower):
		if wave_info_panel == null:
			wave_info_panel = Wave_InfoPanel_Scene.instance()
			tower_specific_slot.add_child(wave_info_panel)
		
		wave_info_panel.visible = true
		wave_info_panel.set_wave_tower(tower)
	else:
		if wave_info_panel != null:
			wave_info_panel.visible = false
			wave_info_panel.set_wave_tower(null)
	
	
	# Hero
	if Hero_InfoPanel.should_display_self_for(tower):
		if hero_info_panel == null:
			hero_info_panel = Hero_InfoPanel_Scene.instance()
			tower_specific_slot.add_child(hero_info_panel)
		
		hero_info_panel.visible = true
		hero_info_panel.set_hero(tower)
	else:
		if hero_info_panel != null:
			hero_info_panel.visible = false
			hero_info_panel.set_hero(null)
	
	
	# Blossom
	if Blossom_InfoPanel.should_display_self_for(tower):
		if blossom_info_panel == null:
			blossom_info_panel = Blossom_InfoPanel_Scene.instance()
			tower_specific_slot.add_child(blossom_info_panel)
		
		blossom_info_panel.visible = true
		blossom_info_panel.set_blossom(tower)
	else:
		if blossom_info_panel != null:
			blossom_info_panel.visible = false
			blossom_info_panel.set_blossom(null)
	
	
	# Brewd
	if Brewd_InfoPanel.should_display_self_for(tower):
		if brewd_info_panel == null:
			brewd_info_panel = Brewd_InfoPanel_Scene.instance()
			tower_specific_slot.add_child(brewd_info_panel)
		
		brewd_info_panel.visible = true
		brewd_info_panel.set_brewd_tower(tower)
	else:
		if brewd_info_panel != null:
			brewd_info_panel.visible = false
			brewd_info_panel.set_brewd_tower(null)
	
	
	# BeaconDish
	if BeaconDish_EffectPanel.should_display_self_for(tower):
		if beacon_dish_effect_panel == null:
			beacon_dish_effect_panel = BeaconDish_EffectPanel_Scene.instance()
			tower_specific_slot.add_child(beacon_dish_effect_panel)
		
		beacon_dish_effect_panel.visible = true
		beacon_dish_effect_panel.set_beacon_dish(tower)
	else:
		if beacon_dish_effect_panel != null:
			beacon_dish_effect_panel.visible = false
			beacon_dish_effect_panel.set_beacon_dish(null)
	
	
	# Se Propager
	if SePropager_InfoPanel.should_display_self_for(tower):
		if se_propager_info_panel == null:
			se_propager_info_panel = SePropager_InfoPanel_Scene.instance()
			tower_specific_slot.add_child(se_propager_info_panel)
		
		se_propager_info_panel.visible = true
		se_propager_info_panel.set_se_propager(tower)
	else:
		if se_propager_info_panel != null:
			se_propager_info_panel.visible = false
			se_propager_info_panel.set_se_propager(null)
	
	# L_Assaut
	if LAssaut_InfoPanel.should_display_self_for(tower):
		if lassaut_info_panel == null:
			lassaut_info_panel = LAssaut_InfoPanel_Scene.instance()
			tower_specific_slot.add_child(lassaut_info_panel)
		
		lassaut_info_panel.visible = true
		lassaut_info_panel.set_lassaut(tower)
	else:
		if lassaut_info_panel != null:
			lassaut_info_panel.visible = false
			lassaut_info_panel.set_lassaut(null)
	
	# La_Chasseur
	if LaChasseur_InfoPanel.should_display_self_for(tower):
		if la_chasseur_info_panel == null:
			la_chasseur_info_panel = LaChasseur_InfoPanel_Scene.instance()
			tower_specific_slot.add_child(la_chasseur_info_panel)
		
		la_chasseur_info_panel.visible = true
		la_chasseur_info_panel.set_la_chasseur(tower)
	else:
		if la_chasseur_info_panel != null:
			la_chasseur_info_panel.visible = false
			la_chasseur_info_panel.set_la_chasseur(null)
	
	
	# KEEP THIS AT THE BOTTOM
	tower_specific_slot.update_visibility_based_on_children()


# queue free

func queue_free():
	if energy_module_panel != null:
		energy_module_panel.queue_free()
	
	.queue_free()
