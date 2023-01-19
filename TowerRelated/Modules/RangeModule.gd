extends Area2D

const Targeting = preload("res://GameInfoRelated/Targeting.gd")
const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")
const TowerPriorityTargetEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerPriorityTargetEffect.gd")
const TerrainFuncs = preload("res://GameInfoRelated/TerrainRelated/TerrainFuncs.gd")
const NullErasingArray = preload("res://MiscRelated/DataCollectionRelated/NullErasingArray.gd")
const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")

signal final_range_changed
signal enemy_entered_range(enemy)
signal enemy_left_range(enemy)
signal current_enemy_left_range(enemy)
signal current_enemies_acquired()

signal targeting_changed
signal targeting_options_modified

signal after_ready()


var benefits_from_bonus_range : bool = true

var base_range_radius : float
var flat_range_effects : Dictionary = {}
var percent_range_effects : Dictionary = {}

var priority_targets_effects : Dictionary = {}


var displaying_range : bool = false
var can_display_range : bool = true
const circle_range_color : Color = Color(0.2, 0.2, 0.2, 0.125)

var can_display_circle_arc : bool = false
const circle_arc_color : Color = Color(0.15, 0.15, 0.15, 0.3)


var enemies_in_range : Array = []
var _non_unique_enemies_in_range : Array = []
var _current_enemies : Array = []
var priority_enemies_within_range : Array = []
var priority_enemies_regardless_of_range : Array = []

var _current_targeting_option_index : int
var _last_used_targeting_option_index : int
var all_distinct_targeting_options : Array = []
var _all_targeting_options : Array = []

# last calc stuffs

var last_calculated_final_range : float

# tracker

var attack_modules_using_this : Array = []
#var is_deferred_add_child_by_attack_module : bool

# managers and relateds

var enemy_manager # needed for getting enemies out of range
var fov_node

#

var parent_tower setget set_parent_tower

#

var terrain_in_range : Array = []
var range_polygon_poly_points : PoolVector2Array

var layer_on_terrain : int 

#

enum PhysicsProcessEnableClauseIds {
	UPDATE_RANGE_POLYGON = 0
	
	#PROCESS_ENEMY_ENTER_EXIT_STATES_DURING_UPDATE = 1
	#CONNECT_AREA_2D_SIGNALS = 2
}
var physics_process_enable_cond_clause : ConditionalClauses
var last_calc_physics_process_enable : bool

#

var _range_shape_set_before_in_tree #shape
var _terrain_shape_set_before_in_tree #shape

var _update_range_polgyon_requested : bool = false
var _changing_terrain_scan_shape : bool = false
var _wait_one_physics_step : bool = false

var _poly_calculating_thread : Thread # note: threads are single use
var _wait_for_finish_called_from_thread : bool


#var _is_updating_range__prevent_area_signals : bool
#var _enemies_attempting_exit_during_update_range : NullErasingArray
#var _enemies_attempting_enter_during_update_range : NullErasingArray
#
#var _process_enemies_attempting_escape_during_update_range__phy_process : bool
#
#var _connect_area_2d_signals_on_phy_process : bool

###

onready var range_shape = $RangeShape
onready var range_polygon = $RangePolygon

onready var terrain_scan_area_2d = $TerrainScanArea2D
onready var terrain_scan_shape = $TerrainScanArea2D/TerrainScanShape

#

func _on_physics_process_enable_cond_clause_updated(_arg_clause_id):
	_updated_physics_process_enable_cond_clause()

func _updated_physics_process_enable_cond_clause():
	last_calc_physics_process_enable = !physics_process_enable_cond_clause.is_passed
	set_physics_process(last_calc_physics_process_enable)


#

func _ready():
	_updated_physics_process_enable_cond_clause()
	
	_connect_area_shape_entered_and_exit_signals()
	
	if _terrain_shape_set_before_in_tree != null:
		set_terrain_scan_shape(_terrain_shape_set_before_in_tree)
	
	if _range_shape_set_before_in_tree != null:
		set_range_shape(_range_shape_set_before_in_tree)
	
	emit_signal("after_ready")
	
	#_terrain_shape_owner_id - terrain_scan_area_2d.shape_owner
	
	#connect("area_shape_entered", self, "_on_Range_area_shape_entered", [], CONNECT_ONESHOT | CONNECT_DEFERRED | CONNECT_PERSIST)
	#connect("area_shape_exited" , self, "_on_Range_area_shape_exited", [], CONNECT_ONESHOT | CONNECT_DEFERRED | CONNECT_PERSIST)
#	connect("area_shape_entered", self, "_on_Range_area_shape_entered", [], CONNECT_PERSIST)
#	connect("area_shape_exited" , self, "_on_Range_area_shape_exited", [], CONNECT_PERSIST)


# Range effect

func flat_range_effect_has_same_stats_to_current_except_time(arg_flat_range_effect):
	if flat_range_effects.has(arg_flat_range_effect.effect_uuid):
		var current = flat_range_effects[arg_flat_range_effect.effect_uuid]
		
		return current.has_same_stats_to_effect_except_for_time(arg_flat_range_effect)
		
	else:
		return false

func percent_range_effect_has_same_stats_to_current_except_time(arg_range_effect):
	if percent_range_effects.has(arg_range_effect.effect_uuid):
		var current = percent_range_effects[arg_range_effect.effect_uuid]
		
		return current.has_same_stats_to_effect_except_for_time(arg_range_effect)
		
	else:
		return false


#

func _init():
	#_enemies_attempting_enter_during_update_range = NullErasingArray.new()
	#_enemies_attempting_exit_during_update_range = NullErasingArray.new()
	
	_all_targeting_options = [Targeting.FIRST, Targeting.LAST]
	all_distinct_targeting_options = [Targeting.FIRST, Targeting.LAST]
	
	_current_targeting_option_index = 0
	_last_used_targeting_option_index = 0
	
	#
	
	physics_process_enable_cond_clause = ConditionalClauses.new()
	physics_process_enable_cond_clause.connect("clause_inserted", self, "_on_physics_process_enable_cond_clause_updated", [], CONNECT_PERSIST)
	physics_process_enable_cond_clause.connect("clause_removed", self, "_on_physics_process_enable_cond_clause_updated", [], CONNECT_PERSIST)


func targeting_cycle_left():
	var to_be : int = _current_targeting_option_index - 1
	if to_be < 0:
		to_be = all_distinct_targeting_options.size() - 1
	
	_last_used_targeting_option_index = _current_targeting_option_index
	_current_targeting_option_index = to_be
	call_deferred("emit_signal", "targeting_changed")

func targeting_cycle_right():
	var to_be : int = _current_targeting_option_index + 1
	if to_be >= all_distinct_targeting_options.size():
		to_be = 0
	
	_last_used_targeting_option_index = _current_targeting_option_index
	_current_targeting_option_index = to_be
	call_deferred("emit_signal", "targeting_changed")


func add_targeting_option(targeting : int):
	_all_targeting_options.append(targeting)
	_update_all_distinct_targeting_options()
	
	call_deferred("emit_signal", "targeting_options_modified")


func add_targeting_options(targetings : Array):
	for targ in targetings:
		_all_targeting_options.append(targ)
	
	_update_all_distinct_targeting_options()
	call_deferred("emit_signal", "targeting_options_modified")



func _update_all_distinct_targeting_options():
	all_distinct_targeting_options.clear()
	
	for targeting in _all_targeting_options:
		if !all_distinct_targeting_options.has(targeting):
			all_distinct_targeting_options.append(targeting)


func remove_targeting_option(targeting : int):
	var switch : bool = false
	
	if all_distinct_targeting_options[_current_targeting_option_index] == targeting:
		switch = true
	
	_last_used_targeting_option_index = 0
	
	_all_targeting_options.erase(targeting)
	_update_all_distinct_targeting_options()
	
	if switch:
		targeting_cycle_right()
	
	call_deferred("emit_signal", "targeting_options_modified")


func remove_targeting_options(targetings : Array):
	var switch : bool = false
	var affected_index : Array = []
	var curr_index_shift : int = 0
	
	if targetings.has(all_distinct_targeting_options[_current_targeting_option_index]):
		switch = true
	
	for targeting in targetings:
		var index = all_distinct_targeting_options.find(targeting)
		if index != -1:
			affected_index.append(index)
	
	_last_used_targeting_option_index = 0
	for aff_i in affected_index:
		if aff_i < _current_targeting_option_index:
			curr_index_shift -= 1
	_current_targeting_option_index += curr_index_shift
	
	for targ in targetings:
		_all_targeting_options.erase(targ)
	_update_all_distinct_targeting_options()
	
	if switch:
		targeting_cycle_right()
	
	
	call_deferred("emit_signal", "targeting_options_modified")


func clear_all_targeting():
	_current_targeting_option_index = 0
	_last_used_targeting_option_index = 0
	
	all_distinct_targeting_options.clear()
	_all_targeting_options.clear()
	call_deferred("emit_signal", "targeting_options_modified")


func set_current_targeting(targeting : int):
	var index_of_targeting = all_distinct_targeting_options.find(targeting)
	
	if index_of_targeting != -1:
		_last_used_targeting_option_index = _current_targeting_option_index
		_current_targeting_option_index = index_of_targeting
		call_deferred("emit_signal", "targeting_changed")


# Range Related

func set_range_shape(shape):
	#$RangeShape.shape = shape
	if !is_inside_tree():
		_range_shape_set_before_in_tree = shape
	else:
		range_shape.shape = shape

func get_range_shape():
	#return $RangeShape.shape
	return range_shape.shape

###

func toggle_show_range():
	displaying_range = !displaying_range
	update() #calls _draw()

func _draw():
	if displaying_range:
		var final_range = last_calculated_final_range
		
		if can_display_range:
			if terrain_scan_shape.shape == null:
				draw_circle(Vector2(0, 0), final_range, circle_range_color)
				
			elif range_polygon_poly_points != null:
				draw_polygon(range_polygon_poly_points, PoolColorArray([circle_range_color]))
		
		if can_display_circle_arc:
			draw_circle_arc(Vector2(0, 0), final_range, 0, 360, circle_arc_color)



func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	
	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color, 2)


########

func update_range():
	if is_inside_tree():
		var final_range = calculate_final_range_radius()
		call_deferred("emit_signal", "final_range_changed")
		
		_change_range(final_range)
		#call_deferred("_change_range", final_range)
		
	else:
		if !is_connected("after_ready", self, "_on_self_after_ready__update_range"):
			connect("after_ready", self, "_on_self_after_ready__update_range", [], CONNECT_ONESHOT)


func _on_self_after_ready__update_range():
	update_range()


func _change_range(final_range):
	_disconnect_area_shape_entered_and_exit_signals()
	
	var has_terrain_shape = terrain_scan_shape != null and terrain_scan_shape.shape != null
	
	if range_shape != null and range_shape.shape != null:
		range_shape.shape.set_deferred("radius", final_range)
		update()
		
		#if *2 is enabled, remove this
		if !has_terrain_shape:
			_connect_area_shape_entered_and_exit_signals()
	
	if has_terrain_shape:
		_change_terrain_scan_shape__and_update_range_polygon(final_range)
	
	_connect_area_shape_entered_and_exit_signals()
	
	
	#call_deferred("_connect_area_shape_entered_and_exit_signals")

func _disconnect_area_shape_entered_and_exit_signals():
	if is_connected("area_shape_entered", self, "_on_Range_area_shape_entered"):
		disconnect("area_shape_entered", self, "_on_Range_area_shape_entered")
	
	if is_connected("area_shape_exited", self, "_on_Range_area_shape_exited"):
		disconnect("area_shape_exited", self, "_on_Range_area_shape_exited")
	
	#_is_updating_range__prevent_area_signals = true
	#_connect_area_2d_signals_on_phy_process = true
	
	#physics_process_enable_cond_clause.attempt_insert_clause(PhysicsProcessEnableClauseIds.CONNECT_AREA_2D_SIGNALS)


func _connect_area_shape_entered_and_exit_signals(arg_allow_process_enemies_attempt : bool = true):
	if !is_connected("area_shape_entered", self, "_on_Range_area_shape_entered"):
		connect("area_shape_entered", self, "_on_Range_area_shape_entered", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	
	if !is_connected("area_shape_exited", self, "_on_Range_area_shape_exited"):
		connect("area_shape_exited", self, "_on_Range_area_shape_exited", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	
	#_is_updating_range__prevent_area_signals = false
	
	#_connect_area_2d_signals_on_phy_process = false
	#physics_process_enable_cond_clause.remove_clause(PhysicsProcessEnableClauseIds.CONNECT_AREA_2D_SIGNALS)
	
	#if arg_allow_process_enemies_attempt:
	#	#_process_enemies_attempting_escape_during_update_range__phy_process = true
	#	physics_process_enable_cond_clause.attempt_insert_clause(PhysicsProcessEnableClauseIds.PROCESS_ENEMY_ENTER_EXIT_STATES_DURING_UPDATE)

#
#func _process_enemies_attempting_enter_or_exit_during_update_range():
#	var exited_enemies : Array = []
#	var entered_enemies : Array = []
#	var overlapping_areas = get_overlapping_areas()
#
#
#	#print("overlapping areas: %s, tower: %s" % [overlapping_areas, parent_tower])
#
#	for enemy in _enemies_attempting_exit_during_update_range.array_of_nodes:
#		if !overlapping_areas.has(enemy):
#
#			#print("enemy not in overlapping areas -- exited")
#			exited_enemies.append(enemy.get_parent())
#
#	for enemy in _enemies_attempting_enter_during_update_range.array_of_nodes:
#		if overlapping_areas.has(enemy):
#			entered_enemies.append(enemy.get_parent())
#
#	_enemies_attempting_exit_during_update_range.array_of_nodes.clear()
#	_enemies_attempting_enter_during_update_range.array_of_nodes.clear()
#
#	_process_enemies_attempting_escape_during_update_range__phy_process = false
#	physics_process_enable_cond_clause.remove_clause(PhysicsProcessEnableClauseIds.PROCESS_ENEMY_ENTER_EXIT_STATES_DURING_UPDATE)
#
#	#
#
#	#call_deferred("_deferred_call_enter_exit_methods_on_enemies", entered_enemies, exited_enemies)
#	_call_enter_exit_methods_on_enemies(entered_enemies, exited_enemies)
#
#	call_deferred("_connect_area_shape_entered_and_exit_signals", false)

#func _call_enter_exit_methods_on_enemies(arg_entered_enemies : Array, arg_exited_enemies : Array):
#	for enemy in arg_entered_enemies:
#		#if is_instance_valid(enemy):
#			_on_enemy_enter_range(enemy)
#
#	for enemy in arg_exited_enemies:
#		#if is_instance_valid(enemy):
#			_on_enemy_leave_range(enemy)
#
#	_is_updating_range__prevent_area_signals = false
#


#Enemy Detection Related

func _on_Range_area_shape_entered(area_id, area, area_shape, self_shape):
	if is_instance_valid(area):
		if area.get_parent() is AbstractEnemy:
			_on_enemy_enter_range(area.get_parent())
			#if !_is_updating_range__prevent_area_signals:
			#	_on_enemy_enter_range(area.get_parent())
			#else:
			#	if !_enemies_attempting_enter_during_update_range.array_of_nodes.has(area):
			#		_enemies_attempting_enter_during_update_range.append_node_and_listen_for_tree_exiting(area)
	
	#connect("area_shape_entered", self, "_on_Range_area_shape_entered", [], CONNECT_ONESHOT | CONNECT_DEFERRED | CONNECT_PERSIST)

func _on_Range_area_shape_exited(area_id, area, area_shape, self_shape):
	if is_instance_valid(area):
		if area.get_parent() is AbstractEnemy:
			_on_enemy_leave_range(area.get_parent())
#			if !_is_updating_range__prevent_area_signals:
#				#print("enemy leave range. tower: %s" % parent_tower)
#				_on_enemy_leave_range(area.get_parent())
#			else:
#
#				if !_enemies_attempting_exit_during_update_range.array_of_nodes.has(area):
#
#					#print("placed enemy in attempt exit during update. tower: %s" % parent_tower)
#					_enemies_attempting_exit_during_update_range.append_node_and_listen_for_tree_exiting(area)
	
	#connect("area_shape_exited", self, "_on_Range_area_shape_exited", [], CONNECT_ONESHOT | CONNECT_DEFERRED | CONNECT_PERSIST)


func _on_enemy_enter_range(enemy : AbstractEnemy):
	#enemies_in_range.append(enemy)
	_add_enemy_to_enemies_in_range(enemy)
	emit_signal("enemy_entered_range", enemy)
	
	#enemy.connect("tree_exiting", self, "_on_enemy_leave_range", [enemy])

# by leaving range
func _on_enemy_leave_range(enemy : AbstractEnemy):
	#enemies_in_range.erase(enemy)
	_remove_enemy_from_enemies_in_range(enemy)
	
	if _current_enemies.has(enemy):
		_current_enemies.erase(enemy)
		emit_signal("current_enemy_left_range", enemy)
	
	emit_signal("enemy_left_range", enemy)
	
	#if enemy.is_connected("tree_exiting", self, "_on_enemy_leave_range"):
	#	enemy.disconnect("tree_exiting", self, "_on_enemy_leave_range")


func is_an_enemy_in_range() -> bool:
	var to_remove = []
	for target in enemies_in_range:
		if !is_instance_valid(target) or target.is_queued_for_deletion():
			to_remove.append(target)
	
	for removal in to_remove:
		enemies_in_range.erase(removal)
	
	return enemies_in_range.size() > 0

func get_enemy_in_range_count() -> int:
	var to_remove = []
	for target in enemies_in_range:
		if !is_instance_valid(target) or target.is_queued_for_deletion():
			to_remove.append(target)
	
	for removal in to_remove:
		enemies_in_range.erase(removal)
	
	return enemies_in_range.size()


func get_enemies_in_range__not_affecting_curr_enemies_in_range() -> Array:
	var bucket = []
	for target in enemies_in_range:
		if is_instance_valid(target) and !target.is_queued_for_deletion():
			bucket.append(target)
	
	return bucket



func is_a_targetable_enemy_in_range() -> bool:
	var targetable_enemies : Array = get_targets_without_affecting_self_current_targets(1)

	return targetable_enemies.size() > 0


func clear_all_detected_enemies():
	enemies_in_range.clear()
	_non_unique_enemies_in_range.clear()
	priority_enemies_regardless_of_range.clear()
	priority_enemies_within_range.clear()
	_current_enemies.clear()
	
	
	#
	
	var to_remove : Array = []
	for effect in priority_targets_effects.values():
		to_remove.append(effect)
	
	for effect in to_remove:
		remove_priority_target_effect(effect)


func _add_enemy_to_enemies_in_range(enemy):
	_non_unique_enemies_in_range.append(enemy)
	
	if !enemies_in_range.has(enemy):
		enemies_in_range.append(enemy)

func _remove_enemy_from_enemies_in_range(enemy):
	_non_unique_enemies_in_range.erase(enemy)
	
	if !_non_unique_enemies_in_range.has(enemy):
		enemies_in_range.erase(enemy)

# Calculations

func calculate_final_range_radius() -> float:
	#All percent modifiers here are to BASE range only
	var final_range = base_range_radius
	for effect in percent_range_effects.values():
		final_range += effect.attribute_as_modifier.get_modification_to_value(base_range_radius)
	
	for effect in flat_range_effects.values():
		final_range += effect.attribute_as_modifier.get_modification_to_value(base_range_radius)
	
	last_calculated_final_range = final_range
	return final_range


# Priority effects related

func add_priority_target_effect(effect : TowerPriorityTargetEffect):
	if !priority_targets_effects.has(effect.effect_uuid) and is_instance_valid(effect.target):
		priority_targets_effects[effect.effect_uuid] = effect
		
		if !effect.is_priority_regardless_of_range:
			add_priority_target_within_range(effect.target)
		else:
			add_priority_target_regardless_of_range(effect.target)
		
		effect.set_up_signal_with_target()
		effect.connect("on_target_tree_exiting", self, "_on_target_from_target_effect_tree_exiting", [effect], CONNECT_ONESHOT)

func add_priority_target_within_range(target):
	if is_instance_valid(target):
		priority_enemies_within_range.append(target)
		#_add_enemy_to_enemies_in_range(target)

func add_priority_target_regardless_of_range(target):
	if is_instance_valid(target):
		priority_enemies_regardless_of_range.append(target)

func _on_target_from_target_effect_tree_exiting(target, effect):
	_remove_priority_target_effect_from_tower(effect)


func _remove_priority_target_effect_from_tower(effect : TowerPriorityTargetEffect):
	for am in attack_modules_using_this:
		if is_instance_valid(am) and is_instance_valid(am.parent_tower):
			am.parent_tower.remove_tower_effect(effect)


func remove_priority_target_effect(effect : TowerPriorityTargetEffect):
	if priority_targets_effects.has(effect.effect_uuid):
		var effect_to_remove = priority_targets_effects[effect.effect_uuid]
		
		priority_targets_effects.erase(effect.effect_uuid)
		
		if !effect.is_priority_regardless_of_range:
			remove_priority_target_within_range(effect_to_remove.target)
		else:
			remove_priority_target_regardless_of_range(effect_to_remove.target)


func remove_priority_target_within_range(target):
	priority_enemies_within_range.erase(target)

func remove_priority_target_regardless_of_range(target):
	priority_enemies_regardless_of_range.erase(target)

#

func clear_all_target_effects():
	var effects : Array = priority_targets_effects.values()
	
	for effect in effects:
		remove_priority_target_effect(effect)


# Other range module interaction

func mirror_range_module_targeting_changes(other_module):
	if is_instance_valid(other_module):
		other_module.connect("targeting_changed", self, "_mirrored_range_module_targeting_changed", [other_module], CONNECT_PERSIST)
		other_module.connect("targeting_options_modified", self, "_mirrored_range_module_targeting_options_modified", [other_module], CONNECT_PERSIST)


func _mirrored_range_module_targeting_changed(module):
	if is_instance_valid(module):
		set_current_targeting(module.get_current_targeting_option())

func _mirrored_range_module_targeting_options_modified(module):
	if is_instance_valid(module):
		clear_all_targeting()
		add_targeting_options(module.all_distinct_targeting_options)


# Other Tower interaction

func mirror_tower_main_range_module_targeting_changes(arg_tower):
	if is_instance_valid(arg_tower):
		arg_tower.connect("targeting_changed", self, "_mirrored_tower_main_range_module_targeting_changed", [arg_tower], CONNECT_PERSIST)
		arg_tower.connect("targeting_options_modified", self, "_mirrored_tower_main_range_module_targeting_options_modified", [arg_tower], CONNECT_PERSIST)


func _mirrored_tower_main_range_module_targeting_changed(arg_tower):
	if is_instance_valid(arg_tower):
		set_current_targeting(arg_tower.range_module.get_current_targeting_option())

func _mirrored_tower_main_range_module_targeting_options_modified(arg_tower):
	if is_instance_valid(arg_tower):
		clear_all_targeting()
		add_targeting_options(arg_tower.range_module.all_distinct_targeting_options)


# Uses

func get_current_targeting_option() -> int:
	if all_distinct_targeting_options.size() > 0:
		return all_distinct_targeting_options[_current_targeting_option_index]
	else:
		return -1

#func get_target(targeting : int = get_current_targeting_option()) -> AbstractEnemy:
#	_current_enemies.clear()
#	_current_enemies[0] = Targeting.enemy_to_target(enemies_in_range, targeting)
#	return _current_enemies[0]

# Affects current target of tower! If this is not needed, use method below (you'll see the right one)
func get_targets(num : int, targeting : int = get_current_targeting_option(), include_invis_enemies : bool = false) -> Array:
	var targeting_params : Targeting.TargetingParameters
	
	if priority_enemies_within_range.size() > 0 or priority_enemies_regardless_of_range.size() > 0:
		targeting_params = Targeting.TargetingParameters.new()
		targeting_params.priority_enemies_in_range = priority_enemies_within_range
		targeting_params.priority_enemies_regardless_of_range = priority_enemies_regardless_of_range
	
	_current_enemies = Targeting.enemies_to_target(enemies_in_range, targeting, num, global_position, include_invis_enemies, targeting_params)
	while _current_enemies.has(null):
		_current_enemies.erase(null)
	
#	while priority_enemies.has(null):
#		priority_enemies.erase(null)
#
#	#for i in range(priority_enemies.size() - 1, 0, -1):
#	#	_current_enemies.push_front(priority_enemies[i])
#	for enemy in priority_enemies:
#		_current_enemies.push_front(enemy)
#
	
	emit_signal("current_enemies_acquired")
	return _current_enemies

func get_all_targets(targeting : int = get_current_targeting_option(), include_invis_enemies : bool = false) -> Array:
	return get_targets(_current_enemies.size(), targeting, include_invis_enemies)

#

func get_targets_without_affecting_self_current_targets(num : int, targeting : int = get_current_targeting_option(), include_invis_enemies : bool = false) -> Array:
	var targeting_params : Targeting.TargetingParameters
	
	if priority_enemies_within_range.size() > 0 or priority_enemies_regardless_of_range.size() > 0:
		targeting_params = Targeting.TargetingParameters.new()
		targeting_params.priority_enemies_in_range = priority_enemies_within_range
		targeting_params.priority_enemies_regardless_of_range = priority_enemies_regardless_of_range
	
	
	var bucket : Array = Targeting.enemies_to_target(enemies_in_range, targeting, num, global_position, include_invis_enemies, targeting_params)
	
	return bucket

func get_all_targets_without_affecting_self_current_targets(targeting : int = get_current_targeting_option(), include_invis_enemies : bool = false) -> Array:
	return get_targets_without_affecting_self_current_targets(_current_enemies.size(), targeting, include_invis_enemies)


#

func is_enemy_in_range(arg_enemy) -> bool:
	for target in enemies_in_range:
		if target == arg_enemy:
			return true
	
	return false

func get_current_enemies() -> Array:
	return _current_enemies.duplicate()

#

func get_all_targetable_enemies_outside_of_range(arg_targeting : int, arg_count : int = -1, arg_include_invis_enemies : bool = false):
	var all_targetable_enemies = enemy_manager.get_all_enemies()
	all_targetable_enemies = Targeting.enemies_to_target(all_targetable_enemies, arg_targeting, all_targetable_enemies.size(), global_position, arg_include_invis_enemies)
	
	var all_enemies_in_range = get_enemies_in_range__not_affecting_curr_enemies_in_range()
	
	if arg_count == -1:
		arg_count = all_targetable_enemies.size()
	
	var bucket = []
	
	for enemy in all_targetable_enemies:
		if !all_enemies_in_range.has(enemy):
			bucket.append(enemy)
			
			if bucket.size() >= arg_count:
				break
	
	return bucket


########################


## Terrain related

func set_terrain_scan_shape(arg_shape):
	if !is_inside_tree():
		_terrain_shape_set_before_in_tree = arg_shape
	else:
		terrain_scan_shape.shape = arg_shape
		
		if !terrain_scan_area_2d.is_connected("area_exited", self, "_on_area_exited_terrain_scan_area_2d"):
			terrain_scan_area_2d.connect("area_exited", self, "_on_area_exited_terrain_scan_area_2d", [], CONNECT_PERSIST)
		
		
		if !terrain_scan_area_2d.is_connected("area_entered", self, "_on_area_entered_terrain_scan_area_2d"):
			terrain_scan_area_2d.connect("area_entered", self, "_on_area_entered_terrain_scan_area_2d", [], CONNECT_PERSIST)
		
		#_request_update_range_polgyon()

func get_terrain_scan_shape():
	return terrain_scan_shape.shape

func _change_terrain_scan_shape__and_update_range_polygon(arg_range):
	_change_terrain_scan_range(arg_range)

func _change_terrain_scan_range(arg_range : float):
	#_changing_terrain_scan_shape = true
	
	if terrain_scan_area_2d.is_connected("area_entered", self, "_on_area_entered_terrain_scan_area_2d"):
		terrain_scan_area_2d.disconnect("area_entered", self, "_on_area_entered_terrain_scan_area_2d")
	
	if terrain_scan_area_2d.is_connected("area_exited", self, "_on_area_exited_terrain_scan_area_2d"):
		terrain_scan_area_2d.disconnect("area_exited", self, "_on_area_exited_terrain_scan_area_2d")
	
	_wait_one_physics_step = true
	call_deferred("_set_terrain_shape_deferred", arg_range)
	#_set_terrain_shape_deferred(arg_range)

func _set_terrain_shape_deferred(arg_range : float):
	terrain_scan_shape.shape.radius = arg_range
	#terrain_scan_shape.shape.set_deferred("radius", arg_range)
	
	if !terrain_scan_area_2d.is_connected("area_exited", self, "_on_area_exited_terrain_scan_area_2d"):
		terrain_scan_area_2d.connect("area_exited", self, "_on_area_exited_terrain_scan_area_2d", [], CONNECT_PERSIST)
	
	if !terrain_scan_area_2d.is_connected("area_entered", self, "_on_area_entered_terrain_scan_area_2d"):
		terrain_scan_area_2d.connect("area_entered", self, "_on_area_entered_terrain_scan_area_2d", [], CONNECT_PERSIST)
	
	
	_request_update_range_polgyon()
	
	#_changing_terrain_scan_shape = false


func _request_update_range_polgyon():
	_update_range_polgyon_requested = true
	
	#_wait_one_physics_step = true
	#set_physics_process(true)
	physics_process_enable_cond_clause.attempt_insert_clause(PhysicsProcessEnableClauseIds.UPDATE_RANGE_POLYGON)

#

func _physics_process(delta):
	#if _connect_area_2d_signals_on_phy_process:
	#if _connect_area_2d_signals_on_phy_process and !_process_enemies_attempting_escape_during_update_range__phy_process:
	#	#_connect_area_shape_entered_and_exit_signals()
	#	call_deferred("_connect_area_shape_entered_and_exit_signals")
	#	
	
	if _update_range_polgyon_requested:
		if !_wait_one_physics_step:
			_update_range_polgyon()
		else:
			_wait_one_physics_step = false
	
	#if _process_enemies_attempting_escape_during_update_range__phy_process:
	#	#_process_enemies_attempting_enter_or_exit_during_update_range()
	#	call_deferred("_process_enemies_attempting_enter_or_exit_during_update_range")


func _update_range_polgyon():
	if _update_range_polgyon_requested:# and !_changing_terrain_scan_shape:
		_update_range_polgyon_requested = false
		#set_physics_process(false)
		physics_process_enable_cond_clause.remove_clause(PhysicsProcessEnableClauseIds.UPDATE_RANGE_POLYGON)
		
		#_update_polygon__start_thread()
		call_deferred("_update_polygon__start_thread")
		
#		var terrain_polygons = TerrainFuncs.convert_areas_to_polygons(terrain_in_range, global_position, layer_on_terrain)
#		var vision_polygon = TerrainFuncs.get_polygon_resulting_from_vertices__circle(terrain_polygons, last_calculated_final_range, fov_node)
#
#		range_polygon_poly_points = vision_polygon
#		range_polygon.set_deferred("polygon", vision_polygon)
#
#		update()


func _update_polygon__start_thread():
	_wait_for_curr_poly_calc_thread_to_finish()
	
	if _poly_calculating_thread == null or !_poly_calculating_thread.is_active():
		_poly_calculating_thread = Thread.new()
		_poly_calculating_thread.start(self, "_update_polygon__in_thread", null)

func _wait_for_curr_poly_calc_thread_to_finish():
	if _poly_calculating_thread != null and _poly_calculating_thread.is_active():
		_wait_for_finish_called_from_thread = true
		_poly_calculating_thread.wait_to_finish()
		_wait_for_finish_called_from_thread = false

func _update_polygon__in_thread(_data):
	if !_wait_for_finish_called_from_thread:
		#print("----------")
		
		var terrain_polygons = TerrainFuncs.convert_areas_to_polygons(terrain_in_range, global_position, layer_on_terrain)
		var vision_polygon = TerrainFuncs.get_polygon_resulting_from_vertices__circle(terrain_polygons, last_calculated_final_range, fov_node)
		
		range_polygon_poly_points = vision_polygon
		range_polygon.set_deferred("polygon", vision_polygon)
		
		update()

###

func _on_area_entered_terrain_scan_area_2d(area):
	if !terrain_in_range.has(area):
		terrain_in_range.append(area)
	
	if !area.is_connected("global_position_changed", self, "_on_terrain_changed_pos"):
		area.connect("global_position_changed", self, "_on_terrain_changed_pos", [], CONNECT_PERSIST)
	
	if !area.is_connected("terrain_layer_changed", self, "_on_terrain_changed_terrain_layer"):
		area.connect("terrain_layer_changed", self, "_on_terrain_changed_terrain_layer", [], CONNECT_PERSIST)
	
	#_request_update_range_polgyon()

func _on_area_exited_terrain_scan_area_2d(area):
	terrain_in_range.erase(area)
	
	if area.is_connected("global_position_changed", self, "_on_terrain_changed_pos"):
		area.disconnect("global_position_changed", self, "_on_terrain_changed_pos")
	
	if area.is_connected("terrain_layer_changed", self, "_on_terrain_changed_terrain_layer"):
		area.disconnect("terrain_layer_changed", self, "_on_terrain_changed_terrain_layer")
	
	#_request_update_range_polgyon()

func _on_terrain_changed_pos(arg_old, arg_new):
	_request_update_range_polgyon()

func _on_terrain_changed_terrain_layer(arg_old, arg_new):
	_request_update_range_polgyon()

#

func set_parent_tower(arg_tower):
	if is_instance_valid(parent_tower):
		if arg_tower.is_connected("layer_on_terrain_changed", self, "_on_parent_tower_changed_terrain_layer"):
			arg_tower.disconnect("layer_on_terrain_changed", self, "_on_parent_tower_changed_terrain_layer")
		#if arg_tower.is_connected("global_position_changed", self, "_on_parent_tower_changed_global_pos"):
		#	arg_tower.disconnect("global_position_changed", self, "_on_parent_tower_changed_global_pos")
		if arg_tower.is_connected("on_tower_transfered_to_placable", self, "_on_tower_transfered_to_placable"):
			arg_tower.disconnect("on_tower_transfered_to_placable", self, "_on_tower_transfered_to_placable")
	
	parent_tower = arg_tower
	
	if is_instance_valid(arg_tower):
		if !arg_tower.is_connected("layer_on_terrain_changed", self, "_on_parent_tower_changed_terrain_layer"):
			arg_tower.connect("layer_on_terrain_changed", self, "_on_parent_tower_changed_terrain_layer", [], CONNECT_PERSIST)
		#if !arg_tower.is_connected("global_position_changed", self, "_on_parent_tower_changed_global_pos"):
		#	arg_tower.connect("global_position_changed", self, "_on_parent_tower_changed_global_pos", [], CONNECT_PERSIST)
		if !arg_tower.is_connected("on_tower_transfered_to_placable", self, "_on_tower_transfered_to_placable"):
			arg_tower.connect("on_tower_transfered_to_placable", self, "_on_tower_transfered_to_placable", [], CONNECT_PERSIST)
		
		#layer_on_terrain = arg_tower.layer_on_terrain
		layer_on_terrain = arg_tower.last_calculated_layer_on_terrain
		_request_update_range_polgyon()

func _on_parent_tower_changed_terrain_layer(arg_old, arg_new):
	layer_on_terrain = arg_new
	_request_update_range_polgyon()

#func _on_parent_tower_changed_global_pos(arg_old, arg_new):
#	_request_update_range_polgyon()

func _on_tower_transfered_to_placable(arg_tower, arg_placable):
	_request_update_range_polgyon()

######

func _exit_tree():
	_wait_for_curr_poly_calc_thread_to_finish()

