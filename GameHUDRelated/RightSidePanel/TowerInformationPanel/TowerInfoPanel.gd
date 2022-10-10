extends MarginContainer

const GameSettingsManager = preload("res://GameElementsRelated/GameSettingsManager.gd")

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
const Tesla_InfoPanel = preload("res://TowerRelated/Color_Violet/Tesla/GUI/Tesla_InfoPanel.gd")
const Tesla_InfoPanel_Scene = preload("res://TowerRelated/Color_Violet/Tesla/GUI/Tesla_InfoPanel.tscn")
const Variance_InfoPanel = preload("res://TowerRelated/Color_Violet/Variance/Panel/Variance_InfoPanel.gd")
const Variance_InfoPanel_Scene = preload("res://TowerRelated/Color_Violet/Variance/Panel/Variance_InfoPanel.tscn")
const RiftAxis_InfoPanel = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/YelVio_RiftAxis/GUI/RiftAxis_InfoPanel.gd")
const RiftAxis_InfoPanel_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/YelVio_RiftAxis/GUI/RiftAxis_InfoPanel.tscn")
const Amalgamator_InfoPanel = preload("res://TowerRelated/Color_Black/Amalgamator/InfoPanel/Amalgamator_InfoPanel.gd")
const Amalgamator_InfoPanel_Scene = preload("res://TowerRelated/Color_Black/Amalgamator/InfoPanel/Amalgamator_InfoPanel.tscn")

signal on_extra_info_panel_shown(arg_info_panel, arg_tower)
signal on_tower_panel_ability_01_activate()
signal on_tower_panel_ability_02_activate()
signal on_tower_panel_ability_03_activate()

var game_settings_manager : GameSettingsManager
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
var tesla_info_panel : Tesla_InfoPanel
var variance_info_panel : Variance_InfoPanel
var rift_axis_info_panel : RiftAxis_InfoPanel
var amalgamator_info_panel : Amalgamator_InfoPanel

var current_active_info_panel


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
	
	if value and game_settings_manager.auto_show_extra_tower_info_mode:
		call_deferred("_create_extra_info_panel")



# Extra info panel related (description and self ingredient)

func _on_TowerNameAndPicPanel_show_extra_tower_info():
	_toggle_extra_tower_info_show()

func _toggle_extra_tower_info_show():
	if !is_instance_valid(extra_info_panel):
		_create_extra_info_panel()
	else:
		_destroy_extra_info_panel()



func _create_extra_info_panel():
	if !is_instance_valid(extra_info_panel):
		extra_info_panel = ExtraInfoPanel_Scene.instance()
		
		extra_info_panel.tower = tower
		extra_info_panel.game_settings_manager = game_settings_manager
		
		var topleft_pos = get_global_rect().position
		var size_x_of_extra_info_panel = extra_info_panel.rect_size.x
		var pos_of_info_panel = Vector2(topleft_pos.x - size_x_of_extra_info_panel, topleft_pos.y)
		
		extra_info_panel.rect_global_position = pos_of_info_panel
		
		CommsForBetweenScenes.ge_add_child_to_below_screen_effects_node_hoster(extra_info_panel)
		extra_info_panel._update_display()
		
		emit_signal("on_extra_info_panel_shown", extra_info_panel, tower)


func _destroy_extra_info_panel():
	if is_instance_valid(extra_info_panel):
		extra_info_panel.queue_free()
		extra_info_panel = null

func destroy_extra_info_panel__called_from_outside():
	_destroy_extra_info_panel()


# ENERGY MODULE PANEL DISPLAY RELATED --------------

func update_display_of_energy_module():
	if tower.energy_module != null:
		if !is_instance_valid(energy_module_panel):
			energy_module_panel = EnergyModulePanel_Scene.instance()
			energy_module_extra_slot.add_child(energy_module_panel)
		
		energy_module_panel.energy_module = tower.energy_module
		energy_module_panel.visible = true
		energy_module_panel.update_display()
		energy_module_extra_slot.update_visibility_based_on_children()
		
	else:
		if is_instance_valid(energy_module_panel):
			energy_module_panel.visible = false
			energy_module_extra_slot.update_visibility_based_on_children()


# HEAT MODULE PANEL DISPLAY RELATED -----------------

func update_display_of_heat_module_panel():
	if tower.heat_module != null and tower.heat_module.should_be_shown_in_info_panel:
		if !is_instance_valid(heat_module_panel):
			heat_module_panel = HeatModulePanel_Scene.instance()
			heat_module_extra_slot.add_child(heat_module_panel)
		
		heat_module_panel.heat_module = tower.heat_module
		heat_module_panel.visible = true
		heat_module_panel.update_display()
		heat_module_extra_slot.update_visibility_based_on_children()
		
	else:
		if is_instance_valid(heat_module_panel):
			heat_module_panel.visible = false
			heat_module_extra_slot.update_visibility_based_on_children()


# TOWER SPECIFIC INFO PANEL -----------------

func _update_tower_specific_info_panel():
	if is_instance_valid(current_active_info_panel):
		if current_active_info_panel.has_method("UNLISTEN_TO_INFO_PANEL_SIGNALS"):
			current_active_info_panel.call("UNLISTEN_TO_INFO_PANEL_SIGNALS", self)
	
	current_active_info_panel = null
	
	
	# 704
	if _704_InfoPanel.should_display_self_for(tower):
		if !is_instance_valid(_704_info_panel):
			_704_info_panel = _704_InfoPanel_Scene.instance()
			tower_specific_slot.add_child(_704_info_panel)
		
		_704_info_panel.visible = true
		_704_info_panel.tower_704 = tower
		_704_info_panel.update_display()
		current_active_info_panel = _704_info_panel
		
	else:
		if is_instance_valid(_704_info_panel):
			_704_info_panel.visible = false
			_704_info_panel.tower_704 = null
	
	
	# Leader
	if Leader_SelectionPanel.should_display_self_for(tower):
		if !is_instance_valid(leader_selection_panel):
			leader_selection_panel = Leader_SelectionPanel_Scene.instance()
			tower_specific_slot.add_child(leader_selection_panel)
		
		leader_selection_panel.visible = true
		leader_selection_panel.set_leader(tower)
		current_active_info_panel = leader_selection_panel
		
	else:
		if is_instance_valid(leader_selection_panel):
			leader_selection_panel.visible = false
			leader_selection_panel.set_leader(null)
	
	
	# Orb
	if Orb_InfoPanel.should_display_self_for(tower):
		if !is_instance_valid(orb_info_panel):
			orb_info_panel = Orb_InfoPanel_Scene.instance()
			orb_info_panel.game_settings_manager = game_settings_manager
			tower_specific_slot.add_child(orb_info_panel)
		
		orb_info_panel.visible = true
		orb_info_panel.set_orb_tower(tower)
		current_active_info_panel = orb_info_panel
	else:
		if is_instance_valid(orb_info_panel):
			orb_info_panel.visible = false
			orb_info_panel.set_orb_tower(null)
	
	
	# Wave
	if Wave_InfoPanel.should_display_self_for(tower):
		if !is_instance_valid(wave_info_panel):
			wave_info_panel = Wave_InfoPanel_Scene.instance()
			tower_specific_slot.add_child(wave_info_panel)
		
		wave_info_panel.visible = true
		wave_info_panel.set_wave_tower(tower)
		current_active_info_panel = wave_info_panel
	else:
		if is_instance_valid(wave_info_panel):
			wave_info_panel.visible = false
			wave_info_panel.set_wave_tower(null)
	
	
	# Hero
	if Hero_InfoPanel.should_display_self_for(tower):
		if !is_instance_valid(hero_info_panel):
			hero_info_panel = Hero_InfoPanel_Scene.instance()
			tower_specific_slot.add_child(hero_info_panel)
		
		hero_info_panel.visible = true
		hero_info_panel.set_hero(tower)
		current_active_info_panel = hero_info_panel
	else:
		if is_instance_valid(hero_info_panel):
			hero_info_panel.visible = false
			hero_info_panel.set_hero(null)
	
	
	# Blossom
	if Blossom_InfoPanel.should_display_self_for(tower):
		if !is_instance_valid(blossom_info_panel):
			blossom_info_panel = Blossom_InfoPanel_Scene.instance()
			tower_specific_slot.add_child(blossom_info_panel)
		
		blossom_info_panel.visible = true
		blossom_info_panel.set_blossom(tower)
		current_active_info_panel = blossom_info_panel
	else:
		if is_instance_valid(blossom_info_panel):
			blossom_info_panel.visible = false
			blossom_info_panel.set_blossom(null)
	
	
	# Brewd
	if Brewd_InfoPanel.should_display_self_for(tower):
		if !is_instance_valid(brewd_info_panel):
			brewd_info_panel = Brewd_InfoPanel_Scene.instance()
			tower_specific_slot.add_child(brewd_info_panel)
		
		brewd_info_panel.visible = true
		brewd_info_panel.set_brewd_tower(tower)
		current_active_info_panel = brewd_info_panel
	else:
		if is_instance_valid(brewd_info_panel):
			brewd_info_panel.visible = false
			brewd_info_panel.set_brewd_tower(null)
	
	
	# BeaconDish
	if BeaconDish_EffectPanel.should_display_self_for(tower):
		if !is_instance_valid(beacon_dish_effect_panel):
			beacon_dish_effect_panel = BeaconDish_EffectPanel_Scene.instance()
			tower_specific_slot.add_child(beacon_dish_effect_panel)
		
		beacon_dish_effect_panel.visible = true
		beacon_dish_effect_panel.set_beacon_dish(tower)
		current_active_info_panel = beacon_dish_effect_panel
	else:
		if is_instance_valid(beacon_dish_effect_panel):
			beacon_dish_effect_panel.visible = false
			beacon_dish_effect_panel.set_beacon_dish(null)
	
	
	# Se Propager
	if SePropager_InfoPanel.should_display_self_for(tower):
		if !is_instance_valid(se_propager_info_panel):
			se_propager_info_panel = SePropager_InfoPanel_Scene.instance()
			tower_specific_slot.add_child(se_propager_info_panel)
		
		se_propager_info_panel.visible = true
		se_propager_info_panel.set_se_propager(tower)
		current_active_info_panel = se_propager_info_panel
	else:
		if is_instance_valid(se_propager_info_panel):
			se_propager_info_panel.visible = false
			se_propager_info_panel.set_se_propager(null)
	
	# L_Assaut
	if LAssaut_InfoPanel.should_display_self_for(tower):
		if !is_instance_valid(lassaut_info_panel):
			lassaut_info_panel = LAssaut_InfoPanel_Scene.instance()
			tower_specific_slot.add_child(lassaut_info_panel)
		
		lassaut_info_panel.visible = true
		lassaut_info_panel.set_lassaut(tower)
		current_active_info_panel = lassaut_info_panel
	else:
		if is_instance_valid(lassaut_info_panel):
			lassaut_info_panel.visible = false
			lassaut_info_panel.set_lassaut(null)
	
	# La_Chasseur
	if LaChasseur_InfoPanel.should_display_self_for(tower):
		if !is_instance_valid(la_chasseur_info_panel):
			la_chasseur_info_panel = LaChasseur_InfoPanel_Scene.instance()
			tower_specific_slot.add_child(la_chasseur_info_panel)
		
		la_chasseur_info_panel.visible = true
		la_chasseur_info_panel.set_la_chasseur(tower)
		current_active_info_panel = la_chasseur_info_panel
	else:
		if is_instance_valid(la_chasseur_info_panel):
			la_chasseur_info_panel.visible = false
			la_chasseur_info_panel.set_la_chasseur(null)
	
	# Tesla
	if Tesla_InfoPanel.should_display_self_for(tower):
		if !is_instance_valid(tesla_info_panel):
			tesla_info_panel = Tesla_InfoPanel_Scene.instance()
			tower_specific_slot.add_child(tesla_info_panel)
		
		tesla_info_panel.visible = true
		tesla_info_panel.set_tesla(tower)
		current_active_info_panel = tesla_info_panel
	else:
		if is_instance_valid(tesla_info_panel):
			tesla_info_panel.visible = false
			tesla_info_panel.set_tesla(null)
	
	# Variance
	if Variance_InfoPanel.should_display_self_for(tower):
		if !is_instance_valid(variance_info_panel):
			variance_info_panel = Variance_InfoPanel_Scene.instance()
			tower_specific_slot.add_child(variance_info_panel)
		
		variance_info_panel.visible = true
		variance_info_panel.set_variance(tower)
		current_active_info_panel = variance_info_panel
	else:
		if is_instance_valid(variance_info_panel):
			variance_info_panel.visible = false
			variance_info_panel.set_variance(null)
	
	
	# Rift Axis
	if RiftAxis_InfoPanel.should_display_self_for(tower):
		if !is_instance_valid(rift_axis_info_panel):
			rift_axis_info_panel = RiftAxis_InfoPanel_Scene.instance()
			tower_specific_slot.add_child(rift_axis_info_panel)
		
		rift_axis_info_panel.visible = true
		rift_axis_info_panel.set_rift_axis(tower)
		current_active_info_panel = rift_axis_info_panel
	else:
		if is_instance_valid(rift_axis_info_panel):
			rift_axis_info_panel.visible = false
			rift_axis_info_panel.set_rift_axis(null)
	
	# Amalgamator
	if Amalgamator_InfoPanel.should_display_self_for(tower):
		if !is_instance_valid(amalgamator_info_panel):
			amalgamator_info_panel = Amalgamator_InfoPanel_Scene.instance()
			tower_specific_slot.add_child(amalgamator_info_panel)
		
		amalgamator_info_panel.visible = true
		amalgamator_info_panel.set_amalgamator(tower)
		current_active_info_panel = amalgamator_info_panel
	else:
		if is_instance_valid(amalgamator_info_panel):
			amalgamator_info_panel.visible = false
			amalgamator_info_panel.set_amalgamator(null)
	
	
	
	# KEEP THIS AT THE BOTTOM
	if is_instance_valid(current_active_info_panel):
		if current_active_info_panel.has_method("LISTEN_TO_INFO_PANEL_SIGNALS"):
			current_active_info_panel.call("LISTEN_TO_INFO_PANEL_SIGNALS", self)
	
	tower_specific_slot.update_visibility_based_on_children()

#

func activate_tower_panel_ability_01():
	emit_signal("on_tower_panel_ability_01_activate")

func activate_tower_panel_ability_02():
	emit_signal("on_tower_panel_ability_02_activate")

func activate_tower_panel_ability_03():
	emit_signal("on_tower_panel_ability_03_activate")



# queue free

func queue_free():
	if is_instance_valid(energy_module_panel):
		energy_module_panel.queue_free()
	
	.queue_free()
