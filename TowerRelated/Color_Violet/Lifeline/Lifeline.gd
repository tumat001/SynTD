extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const TowerDetectingRangeModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.tscn")
const TowerDetectingRangeModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.gd")

#

const base_dmg_ratio_of_self_min : float = 0.25
const base_dmg_ratio_of_self_max : float = 1.0

const base_dmg_ratio_max__health_threshold_for_max : float = -0.8 + 1   #the -x is the missing health component


#

var tower_detecting_range_module : TowerDetectingRangeModule

var basis_attk_module : InstantDamageAttackModule

var _all_affected_towers : Array = []

var current_base_dmg_amount : float

#

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.BEACON_DISH)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	
	tower_detecting_range_module = TowerDetectingRangeModule_Scene.instance()
	tower_detecting_range_module.can_display_range = false
	tower_detecting_range_module.detection_range = info.base_range
	tower_detecting_range_module.connect("on_tower_entered_range_while_in_map_or_entered_map_while_in_range", self, "_on_tower_entered_range_while_in_map_or_entered_map_while_in_range_l", [], CONNECT_PERSIST)
	tower_detecting_range_module.connect("on_tower_exited_range_or_exited_map_while_in_range", self, "_on_tower_exited_range_or_exited_map_while_in_range_l", [], CONNECT_PERSIST)
	
	add_child(tower_detecting_range_module)
	
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	range_module.clear_all_targeting()
	
	var attack_module = InstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.can_be_commanded_by_tower = false
	
	attack_module.is_displayed_in_tracker = false
	
	basis_attk_module = attack_module
	
	add_attack_module(attack_module)
	
	#
	
	connect("final_ability_potency_changed", self, "_update_buff_effects", [], CONNECT_PERSIST)
	connect("final_base_damage_changed", self, "_update_buff_effects", [], CONNECT_PERSIST)
	connect("on_tower_transfered_in_map_from_bench", self, "_on_tower_transfered_in_map_from_bench_l", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	connect("on_tower_transfered_on_bench_from_in_map", self, "_on_tower_transfered_on_bench_from_in_map_l", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	
	tower_detecting_range_module.mirror_tower_range_module_range_changes(self)
	
	_post_inherit_ready()

#

func _on_tower_transfered_in_map_from_bench_l(arg_self, arg_map_placable, arg_bench_placable):
	var all_towers = tower_detecting_range_module.get_all_in_map_towers_in_range()
	
	for tower in all_towers:
		_add_affected_tower_and_apply_buffs(tower)

func on_tower_transfered_on_bench_from_in_map(arg_self, arg_bench, arg_map):
	for tower in _all_affected_towers:
		pass
		
	
	_all_affected_towers.clear()

#

func _on_tower_entered_range_while_in_map_or_entered_map_while_in_range_l(arg_tower):
	pass
	

func _on_tower_exited_range_or_exited_map_while_in_range_l(arg_tower):
	pass
	


#

func _add_affected_tower_and_apply_buffs(arg_tower):
	_all_affected_towers.append(arg_tower)
	
	

func _construct_base_dmg_effect():
	var base_damage_buff_mod = FlatModifier.new(StoreOfTowerEffectsUUID.LIFELINE_BASE_DMG_EFFECT)
	base_damage_buff_mod.flat_modifier = current_base_dmg_amount
	
	var base_damage_buff_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS, base_damage_buff_mod, StoreOfTowerEffectsUUID.LIFELINE_BASE_DMG_EFFECT)
	base_damage_buff_effect.is_timebound = false
	#todo
	#base_damage_buff_effect.status_bar_icon = Douser_BuffIcon
	
	return base_damage_buff_effect

func _calc_and_update_current_base_dmg_val():
	var current_health_ratio = current_health / last_calculated_max_health
	var health_based_multiplier = min()
	
	current_base_dmg_amount = 
	


func _update_buff_effects():
	_calc_and_update_current_base_dmg_val()
	

