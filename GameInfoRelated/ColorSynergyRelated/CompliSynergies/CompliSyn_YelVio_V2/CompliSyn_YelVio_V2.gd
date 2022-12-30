extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const MapManager = preload("res://GameElementsRelated/MapManager.gd")

#

signal yel_side_fire_shell(arg_enemy, arg_shell_fire_id, arg_is_refire)
signal on_round_end()


const vio_side_ing_upgrade_amount__tier_4 : float = 0.15
const vio_side_ing_upgrade_amount__tier_3 : float = 0.20
const vio_side_ing_upgrade_amount__tier_2 : float = 0.50
const vio_side_ing_upgrade_amount__tier_1 : float = 0.65
var current_vio_side_ing_upgrade_amount : float

const yel_side_shell_cooldown : float = 15.0
var yel_side_shell_cd_timer : Timer

const yel_side_shell_damage__tier_4 : float = 3.0
const yel_side_shell_damage__tier_3 : float = 4.0
const yel_side_shell_damage__tier_2 : float = 6.0
const yel_side_shell_damage__tier_1 : float = 8.0
var current_yel_side_explosion_damage : float

# used when refiring from hitting only one enemy
var _current_yel_side_shell_id : int
var _current_yel_side_targeted_enemy_from_refire

#

var game_elements : GameElements
var rift_axis_tower

var curr_tier : int

#

func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements == null:
		game_elements = arg_game_elements
	
	curr_tier = tier
	
	_update_yelside_explosion_dmg_and_vioside_scale_based_on_tier()
	
	#
	
	if !is_instance_valid(rift_axis_tower) or rift_axis_tower.is_queued_for_deletion():
		_attempt_summon_rift_axis_tower()
	else:
		rift_axis_tower.activate_rift_axis()
	
	if !is_instance_valid(yel_side_shell_cd_timer):
		_initialize_yel_shell_timer()
	
	._apply_syn_to_game_elements(arg_game_elements, tier)

func _attempt_summon_rift_axis_tower() -> bool:
	var nearest_to_center_pos = game_elements.get_middle_coordinates_of_playable_map()
	
	var candidate_placables = game_elements.map_manager.get_all_placables_based_on_targeting_params(nearest_to_center_pos, 1000, MapManager.PlacableState.UNOCCUPIED, MapManager.SortOrder.CLOSEST, MapManager.RangeState.ANY)
	if candidate_placables.size() > 0:
		var placable = candidate_placables[0]
		rift_axis_tower = game_elements.tower_inventory_bench.create_tower_and_add_to_scene(Towers.YELVIO_RIFT_AXIS, placable)
		rift_axis_tower.yel_vio_syn = self
		return true
	else:
		_listen_for_new_space_for_rift_axis()
		return false

func _listen_for_new_space_for_rift_axis():
	if !game_elements.tower_manager.is_connected("tower_in_queue_free", self, "_tower_in_queue_free"):
		game_elements.tower_manager.connect("tower_in_queue_free", self, "_tower_in_queue_free", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_transfered_to_placable", self, "_tower_transfered_to_placable", [], CONNECT_PERSIST)

func _tower_in_queue_free(arg_tower):
	_attempt_summon_rift_axis_and_disconnected_listen_if_successful()

func _tower_transfered_to_placable(arg_tower, arg_placable):
	_attempt_summon_rift_axis_and_disconnected_listen_if_successful()


func _attempt_summon_rift_axis_and_disconnected_listen_if_successful():
	var success = _attempt_summon_rift_axis_tower()
	if success:
		if game_elements.tower_manager.is_connected("tower_in_queue_free", self, "_tower_in_queue_free"):
			game_elements.tower_manager.disconnect("tower_in_queue_free", self, "_tower_in_queue_free")
			game_elements.tower_manager.disconnect("tower_transfered_to_placable", self, "_tower_transfered_to_placable")

##

func _initialize_yel_shell_timer():
	yel_side_shell_cd_timer = Timer.new()
	yel_side_shell_cd_timer.one_shot = false
	yel_side_shell_cd_timer.connect("timeout", self, "_on_yel_shell_cd_timer_timeout", [], CONNECT_PERSIST)
	game_elements.add_child(yel_side_shell_cd_timer)
	
	game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
	game_elements.stage_round_manager.connect("round_started", self, "_on_round_start", [], CONNECT_PERSIST)
	
	_pause_or_resume_timer_based_on_round_status()
	
	yel_side_shell_cd_timer.start(yel_side_shell_cooldown)

func _pause_or_resume_timer_based_on_round_status():
	if game_elements.stage_round_manager.round_started:
		_on_round_start(null)
	else:
		_on_round_end(null)


func _on_yel_shell_cd_timer_timeout():
	var target = _get_candidate_target()
	
	if is_instance_valid(target):
		_emit_yel_side_fire_shell_signal(target, false, false)

func _get_candidate_target():
	var all_targetable_enemies = game_elements.enemy_manager.get_all_targetable_enemies()
	var candidates = Targeting.enemies_to_target(all_targetable_enemies, Targeting.FIRST, 1, Vector2(0, 0))
	
	if candidates.size() > 0:
		return candidates[0]

func request_refire_of_shell(arg_curr_id):
	if !is_instance_valid(_current_yel_side_targeted_enemy_from_refire):
		_current_yel_side_targeted_enemy_from_refire = _get_candidate_target()
		
		if is_instance_valid(_current_yel_side_targeted_enemy_from_refire):
			call_deferred("_emit_yel_side_fire_shell_signal", _current_yel_side_targeted_enemy_from_refire, true, true)

func _emit_yel_side_fire_shell_signal(arg_enemy_to_target, arg_set_curr_to_null, arg_is_refire):
	_current_yel_side_shell_id += 1
	emit_signal("yel_side_fire_shell", arg_enemy_to_target, _current_yel_side_shell_id, arg_is_refire)
	
	if arg_set_curr_to_null:
		_current_yel_side_targeted_enemy_from_refire = null


func _on_round_end(_arg_stageround):
	if is_instance_valid(yel_side_shell_cd_timer):
		yel_side_shell_cd_timer.paused = true
		
		emit_signal("on_round_end")

func _on_round_start(_arg_stageround):
	if is_instance_valid(yel_side_shell_cd_timer):
		yel_side_shell_cd_timer.paused = false
		
		yel_side_shell_cd_timer.start(yel_side_shell_cooldown)


#

func _update_yelside_explosion_dmg_and_vioside_scale_based_on_tier():
	if curr_tier == 4:
		current_yel_side_explosion_damage = yel_side_shell_damage__tier_4
		current_vio_side_ing_upgrade_amount = vio_side_ing_upgrade_amount__tier_4
	elif curr_tier == 3:
		current_yel_side_explosion_damage = yel_side_shell_damage__tier_3
		current_vio_side_ing_upgrade_amount = vio_side_ing_upgrade_amount__tier_3
	elif curr_tier == 2:
		current_yel_side_explosion_damage = yel_side_shell_damage__tier_2
		current_vio_side_ing_upgrade_amount = vio_side_ing_upgrade_amount__tier_2
	elif curr_tier == 1:
		current_yel_side_explosion_damage = yel_side_shell_damage__tier_1
		current_vio_side_ing_upgrade_amount = vio_side_ing_upgrade_amount__tier_1

##

func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	if is_instance_valid(rift_axis_tower):
		rift_axis_tower.deactivate_rift_axis()
	
	curr_tier = -1
	
	_on_round_end(null) # pause yel side timer
	
	._remove_syn_from_game_elements(arg_game_elements, tier)


