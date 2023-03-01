extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const TowerDetectingRangeModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.tscn")
const TowerDetectingRangeModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.gd")


const Lifeline_StatusBarIcon = preload("res://TowerRelated/Color_Violet/Lifeline/Assets/StatusBarIcon/Lifeline_StatusBarIcon.png")

const Lifeline_MiddleProgBar_01 = preload("res://TowerRelated/Color_Violet/Lifeline/Assets/ProgBar/Lifeline_MiddleBar_01.png")
const Lifeline_MiddleProgBar_02 = preload("res://TowerRelated/Color_Violet/Lifeline/Assets/ProgBar/Lifeline_MiddleBar_02.png")
const Lifeline_MiddleProgBar_03 = preload("res://TowerRelated/Color_Violet/Lifeline/Assets/ProgBar/Lifeline_MiddleBar_03.png")
const Lifeline_MiddleProgBar_04 = preload("res://TowerRelated/Color_Violet/Lifeline/Assets/ProgBar/Lifeline_MiddleBar_04.png")
const Lifeline_MiddleProgBar_05 = preload("res://TowerRelated/Color_Violet/Lifeline/Assets/ProgBar/Lifeline_MiddleBar_05.png")


signal base_dmg_lifeline_effect_changed()

#

const base_dmg_ratio_of_self_min : float = 0.25
const base_dmg_ratio_of_self_max : float = 1.0

const base_dmg_ratio_max__health_threshold_for_max : float = -0.8 + 1   #the -x is the missing health component


const player_heal_on_death : int = 2

#

var tower_detecting_range_module : TowerDetectingRangeModule

var basis_attk_module : InstantDamageAttackModule

var _all_affected_towers_to_effect_map : Dictionary = {}

var current_base_dmg_amount : float
var current_base_dmg_ratio : float

var given_health_in_round : bool

var _is_lifeline_in_map : bool

#

var sample_base_dmg_effect_for_info_panel : TowerBaseEffect

#


const prog_bar_texture_arr_ascending = [
	Lifeline_MiddleProgBar_01,
	Lifeline_MiddleProgBar_02,
	Lifeline_MiddleProgBar_03,
	Lifeline_MiddleProgBar_04,
	Lifeline_MiddleProgBar_05,
	
]

const dmg_ratio_percent_to_prog_bar_texture_map : Dictionary = {
#	0.8 : Lifeline_MiddleProgBar_01,
#	0.6 : Lifeline_MiddleProgBar_02,
#	0.4 : Lifeline_MiddleProgBar_03,
#	0.2 : Lifeline_MiddleProgBar_04,
#	0 : Lifeline_MiddleProgBar_05,
}
const dmg_ratio_percent_breakpoint_for_bar_texture_change := [
#	0.8,
#	0.6,
#	0.4,
#	0.2,
#	0
]

#

onready var lifeline_progress_bar = $TowerBase/KnockUpLayer/LifelineProgressBar
onready var body_cracks = $TowerBase/KnockUpLayer/BodyCracks

#

func _init():
	var iterations : int = 5
	
	var diff : float = base_dmg_ratio_of_self_max - base_dmg_ratio_of_self_min
	var diff_per_it : float = diff / (iterations - 1)
	
	for i in iterations:
		var breakpoint_in_this_it = base_dmg_ratio_of_self_min + (diff_per_it * i)
		
		dmg_ratio_percent_to_prog_bar_texture_map[breakpoint_in_this_it] = prog_bar_texture_arr_ascending[i]
		dmg_ratio_percent_breakpoint_for_bar_texture_change.insert(0, breakpoint_in_this_it)
	
	#print(dmg_ratio_percent_breakpoint_for_bar_texture_change)

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.LIFELINE)
	
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
	
	connect("final_ability_potency_changed", self, "_stats_changed_l", [], CONNECT_PERSIST)
	connect("final_base_damage_changed", self, "_stats_changed_l", [], CONNECT_PERSIST)
	connect("on_tower_transfered_in_map_from_bench", self, "_on_tower_transfered_in_map_from_bench_l", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	connect("on_tower_transfered_on_bench_from_in_map", self, "_on_tower_transfered_on_bench_from_in_map_l", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	
	connect("on_max_health_changed", self, "_on_tower_max_health_changed_l", [], CONNECT_PERSIST)
	connect("on_current_health_changed", self, "_on_current_health_changed_l", [], CONNECT_PERSIST)
	connect("on_tower_no_health", self, "_on_tower_no_health_l", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_l", [], CONNECT_PERSIST)
	
	connect("changed_anim_from_alive_to_dead", self, "_on_changed_anim_from_alive_to_dead_l", [], CONNECT_PERSIST)
	connect("changed_anim_from_dead_to_alive", self, "_on_changed_anim_from_dead_to_alive_l", [], CONNECT_PERSIST)
	
	tower_detecting_range_module.mirror_tower_range_module_range_changes(self)
	
	#
	
	lifeline_progress_bar.max_value = 1
	
	#
	
	_post_inherit_ready()

func _post_inherit_ready():
	._post_inherit_ready()
	
	sample_base_dmg_effect_for_info_panel = _construct_base_dmg_effect()
	
	_update_buff_effects()
	_update_life_bar()


#

func _on_tower_transfered_in_map_from_bench_l(arg_self, arg_map_placable, arg_bench_placable):
	var all_towers = tower_detecting_range_module.get_all_in_map_towers_in_range()
	
	for tower in all_towers:
		_add_affected_tower_and_apply_buffs(tower)
	
	##
	
	_is_lifeline_in_map = true

func _on_tower_transfered_on_bench_from_in_map_l(arg_self, arg_bench, arg_map):
	for tower in _all_affected_towers_to_effect_map.keys():
		tower.remove_tower_effect(_all_affected_towers_to_effect_map[tower])
		
	
	_all_affected_towers_to_effect_map.clear()
	
	##
	
	_is_lifeline_in_map = false

#

func _on_tower_entered_range_while_in_map_or_entered_map_while_in_range_l(arg_tower):
	if _is_lifeline_in_map:
		_add_affected_tower_and_apply_buffs(arg_tower)
	

func _on_tower_exited_range_or_exited_map_while_in_range_l(arg_tower):
	if _is_lifeline_in_map:
		_remove_affected_tower_and_remove_buffs(arg_tower)
	


#

func _add_affected_tower_and_apply_buffs(arg_tower):
	if arg_tower != self:
		var buff = _construct_base_dmg_effect()
		
		arg_tower.add_tower_effect(buff)
		if buff != null:
			_all_affected_towers_to_effect_map[arg_tower] = buff

func _remove_affected_tower_and_remove_buffs(arg_tower):
	if _all_affected_towers_to_effect_map.has(arg_tower):
		arg_tower.remove_tower_effect(_all_affected_towers_to_effect_map[arg_tower])
		_all_affected_towers_to_effect_map.erase(arg_tower)



func _construct_base_dmg_effect():
	var base_damage_buff_mod = FlatModifier.new(StoreOfTowerEffectsUUID.LIFELINE_BASE_DMG_EFFECT)
	base_damage_buff_mod.flat_modifier = current_base_dmg_amount
	
	var base_damage_buff_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS, base_damage_buff_mod, StoreOfTowerEffectsUUID.LIFELINE_BASE_DMG_EFFECT)
	base_damage_buff_effect.is_timebound = false
	base_damage_buff_effect.status_bar_icon = Lifeline_StatusBarIcon
	
	return base_damage_buff_effect

func _calc_and_update_current_base_dmg_val():
	var current_health_ratio = current_health / last_calculated_max_health
	var diff = (1 + base_dmg_ratio_max__health_threshold_for_max)  # 1 = max curr to max health ratio
	
	var diff_ratio = diff * (1 - current_health_ratio)
	if diff_ratio > 1:
		diff_ratio = 1
	
	var dmg_ratio_diff = (base_dmg_ratio_of_self_max - base_dmg_ratio_of_self_min)
	var dmg_ratio_ratio = (dmg_ratio_diff * diff_ratio) + base_dmg_ratio_of_self_min
	
	#print("dmg ratio ratio: %s. diff_ratio : %s. curr health ratio: %s" % [dmg_ratio_ratio, diff_ratio, current_health_ratio])
	current_base_dmg_ratio = dmg_ratio_ratio #min(base_dmg_ratio_of_self_max, -(current_health_ratio - base_dmg_ratio_max__health_threshold_for_max) + 1)
	
	current_base_dmg_amount = get_last_calculated_base_damage_of_main_attk_module() * current_base_dmg_ratio
	
	#
	


func _stats_changed_l():
	_update_buff_effects()

func _update_buff_effects():
	_calc_and_update_current_base_dmg_val()
	
	for tower in _all_affected_towers_to_effect_map.keys():
		var effect = _all_affected_towers_to_effect_map[tower]
		effect.attribute_as_modifier.flat_modifier = current_base_dmg_amount
		
		tower.recalculate_final_base_damage()
	
	if sample_base_dmg_effect_for_info_panel != null:
		sample_base_dmg_effect_for_info_panel.attribute_as_modifier.flat_modifier = current_base_dmg_amount
	
	emit_signal("base_dmg_lifeline_effect_changed")

#######

func _on_tower_no_health_l():
	if !given_health_in_round:
		given_health_in_round = true
		
		game_elements.health_manager.increase_health_by(player_heal_on_death, game_elements.health_manager.IncreaseHealthSource.TOWER)
	


func _on_round_end_l():
	given_health_in_round = false
	

#

func toggle_module_ranges():
	.toggle_module_ranges()
	
	if is_showing_ranges:
		if current_placable is InMapAreaPlacable:
			_on_tower_show_range()
	else:
		_on_tower_hide_range()


func _on_tower_show_range():
	tower_detecting_range_module.glow_all_towers_in_range()

func _on_tower_hide_range():
	tower_detecting_range_module.unglow_all_towers_in_range()

######

func _on_changed_anim_from_alive_to_dead_l():
	body_cracks.visible = true
	

func _on_changed_anim_from_dead_to_alive_l():
	body_cracks.visible = false
	

###

func _on_tower_max_health_changed_l(arg_val):
	_update_buff_effects()
	_update_life_bar()

func _on_current_health_changed_l(arg_val):
	_update_buff_effects()
	_update_life_bar()

func _update_life_bar():
	for ratio in dmg_ratio_percent_breakpoint_for_bar_texture_change:
		if current_base_dmg_ratio >= ratio:
			lifeline_progress_bar.fill_foreground_pic = dmg_ratio_percent_to_prog_bar_texture_map[ratio]
			break
	
	lifeline_progress_bar.current_value = current_base_dmg_ratio
