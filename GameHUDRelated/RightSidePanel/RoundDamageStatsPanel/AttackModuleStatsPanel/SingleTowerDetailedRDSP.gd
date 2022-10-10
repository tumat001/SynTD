extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const AbstractAttackModule = preload("res://TowerRelated/Modules/AbstractAttackModule.gd")
const SingleAttackModuleRoundDamageStatsPanel_Scene = preload("res://GameHUDRelated/RightSidePanel/RoundDamageStatsPanel/AttackModuleStatsPanel/SingleAttackModuleRoundDamageStatsPanel.tscn")
const SingleAttackModuleRoundDamageStatsPanel = preload("res://GameHUDRelated/RightSidePanel/RoundDamageStatsPanel/AttackModuleStatsPanel/SingleAttackModuleRoundDamageStatsPanel.gd")
const SingleTowerRDSP_Scene = preload("res://GameHUDRelated/RightSidePanel/RoundDamageStatsPanel/SingleTowerRoundDamageStatsPanel.tscn")

signal on_tower_queue_free(tower)
signal on_back_button_pressed(tower)


const seconds_per_update : float = 0.2

var update_timer : Timer

var tower : AbstractTower setget set_tower

var stage_round_manager setget set_stage_round_manager

var tower_rdsp

onready var attack_module_rdsp_panel = $VBoxContainer/AttackModuleMarginer/AttackModuleRDSPContainer
onready var tower_rdsp_marginer = $VBoxContainer/TowerInfoMarginer


func _ready():
	update_timer = Timer.new()
	update_timer.connect("timeout", self, "_on_update_timer_expired", [], CONNECT_PERSIST)
	update_timer.one_shot = true
	
	add_child(update_timer)
	
	#
	
	tower_rdsp = SingleTowerRDSP_Scene.instance()
	tower_rdsp_marginer.add_child(tower_rdsp)
	
	#


#

func set_tower(arg_tower : AbstractTower):
	if is_instance_valid(tower):
		tower.disconnect("attack_module_added", self, "_tower_attack_module_added")
		tower.disconnect("attack_module_removed", self, "_tower_attack_module_removed")
		tower.disconnect("tree_exiting", self, "_on_tower_tree_exiting")
		
		for attk_module_panel in attack_module_rdsp_panel.get_children():
			attk_module_panel.queue_free()
	
	
	tower = arg_tower
	
	if tower_rdsp._tower != tower:
		tower_rdsp.set_tower(tower)
	
	if is_instance_valid(tower):
		tower.connect("attack_module_added", self, "_tower_attack_module_added", [], CONNECT_PERSIST)
		tower.connect("attack_module_removed", self, "_tower_attack_module_removed", [], CONNECT_PERSIST)
		tower.connect("tree_exiting", self, "_on_tower_tree_exiting", [], CONNECT_PERSIST)
		
		
		for attk_module in tower.all_attack_modules:
			_create_attk_module_rdsp(attk_module)
		
		#_set_current_am_panels_of_tower()
		
		yield(get_tree(), "idle_frame")
		_update_from_set()

func _update_from_set():
	tower_rdsp.in_round_total_dmg = tower.in_round_total_damage_dealt
	tower_rdsp.in_round_phy_dmg = tower.in_round_physical_damage_dealt
	tower_rdsp.in_round_ele_dmg = tower.in_round_elemental_damage_dealt
	tower_rdsp.in_round_pure_dmg = tower.in_round_pure_damage_dealt
	
	_update_display_of_all_am_panels()


#
#func _set_current_am_panels_of_tower():
#	var displayable_modules : Array = []
#	for attack_module in tower.all_attack_modules:
#		if attack_module.is_displayed_in_tracker:
#			displayable_modules.append(attack_module)
#
#	for i in range(0, attack_module_rdsp_panel.get_child_count() - displayable_modules.size()):
#		attack_module_rdsp_panel.get_children()[i].queue_free()
#
#	yield(get_tree(), "idle_frame")
#
#	for i in range(0, displayable_modules.size()):
#		if attack_module_rdsp_panel.get_child_count() > i:
#			attack_module_rdsp_panel.get_children()[i].set_attack_module(displayable_modules[i])
#		else:
#			_create_attk_module_rdsp(displayable_modules[i])


func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	stage_round_manager.connect("round_started", self, "_on_round_start", [], CONNECT_PERSIST)
	stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)


#

func _tower_attack_module_added(arg_attk_module : AbstractAttackModule):
	_create_attk_module_rdsp(arg_attk_module)


func _create_attk_module_rdsp(arg_attk_module : AbstractAttackModule):
	if arg_attk_module.is_displayed_in_tracker:
		var rdsp = SingleAttackModuleRoundDamageStatsPanel_Scene.instance()
		
		attack_module_rdsp_panel.add_child(rdsp)
		rdsp.set_attack_module(arg_attk_module)
		
		return rdsp




#

func _tower_attack_module_removed(arg_attk_module : AbstractAttackModule):
	for child in attack_module_rdsp_panel.get_children():
		if child.attack_module == arg_attk_module:
			child.queue_free()
			return

#

func _on_tower_tree_exiting():
	emit_signal("on_tower_queue_free", tower)

#


func _on_round_start(curr_stageround):
	for am_panel in attack_module_rdsp_panel.get_children():
		if !is_instance_valid(am_panel.attack_module):
			am_panel.queue_free()
	
	yield(get_tree(), "idle_frame")
	
	update_timer.paused = false
	_update_display_of_all_am_panels()


func _update_display_of_all_am_panels():
	update_timer.start(seconds_per_update)
	
	var stat_panels = attack_module_rdsp_panel.get_children()
	var highest_damage = tower_rdsp.in_round_total_dmg
	if highest_damage < 1:
		highest_damage = 1
	
	#for single_stat_panel in stat_panels:
	#	if single_stat_panel.in_round_total_dmg > highest_damage:
	#		highest_damage = single_stat_panel.in_round_total_dmg
	
	for single_stat_panel in stat_panels:
		single_stat_panel.update_display(highest_damage)
	
	tower_rdsp.update_display(highest_damage)


#

func _on_round_end(curr_stageround):
	update_timer.paused = true
	_update_display_of_all_am_panels()


func _on_update_timer_expired():
	_update_display_of_all_am_panels()


#

func _on_BackButton_pressed_mouse_event(event):
	emit_signal("on_back_button_pressed")
