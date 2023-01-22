extends Path2D

const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")
const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")

signal on_enemy_death(enemy)
signal on_enemy_reached_end(enemy)

signal is_used_and_active_changed(arg_val)
signal is_used_for_natural_spawning_changed(arg_val)

signal curve_changed(arg_new_curve, arg_curve_id)
signal before_curve_changed_from_deferred_set(arg_new_curve, arg_curve_id)
signal after_curve_changed_from_deferred_set(arg_new_curve, arg_curve_id)

signal last_calculated_curve_change_defer_changed(arg_val)

enum MarkerIds {
	SKIRMISHER_CLONE_OF_BASE_PATH = 1,
	SKIRMISHER_BASE_PATH_ALREADY_CLONED = 2,
}



var path_length : float
var is_used_and_active : bool = true setget set_is_used_and_active# if true, then this signifies that enemies can/will use this path during the round. Can be true even if "is_used_for_natural_spawning" is false, when spawning enemies in path manually. Set this to false if path should be totally unusable (for the round)
var is_used_for_natural_spawning : bool = true setget set_is_used_for_natural_spawning # if true, then this signifies that enemies found in the Ins can/will spawn here. Make this false if enemies should not be spawned here by EnemyManager.

var marker_id_to_value_map : Dictionary = {}

var path_end_global_pos : Vector2


#

enum CurveChangeDeferClauseIds {
	SKIRMISHER_CALCULATING_CURVE_THROUGH_PLACABLES = 1
}
var curve_change_defer_conditional_clauses : ConditionalClauses
var last_calculated_curve_change_defer : bool

#

enum ShowCurveClauseIds {
	HOVERED_OVER_FLAG = 1
	HOVERED_OVER_CULTIST_CROSS = 2
}
var show_curve_conditional_clauses : ConditionalClauses
var last_calculated_is_showing_curve : bool

var showing_curve_color : Color = Color(183/255.0, 114/255.0, 254/255.0, 0.65)


#
# USED to distinguish between different curves. This is used in cases where computations are made per different curves (and to re-use those computed vals for the same ids/curve)
const default_curve_id : int = 0
var current_curve_id : int

var _deferred_new_curve : Curve2D
var _deferred_new_curve_id : int

#

func _init():
	curve_change_defer_conditional_clauses = ConditionalClauses.new()
	curve_change_defer_conditional_clauses.connect("clause_inserted", self, "_on_curve_change_defer_conditional_clauses_updated", [], CONNECT_PERSIST)
	curve_change_defer_conditional_clauses.connect("clause_removed", self, "_on_curve_change_defer_conditional_clauses_updated", [], CONNECT_PERSIST)
	_update_curve_change_defer_state()
	
	show_curve_conditional_clauses = ConditionalClauses.new()
	show_curve_conditional_clauses.connect("clause_inserted", self, "_on_show_curve_conditional_clauses_updated", [], CONNECT_PERSIST)
	show_curve_conditional_clauses.connect("clause_removed", self, "_on_show_curve_conditional_clauses_updated", [], CONNECT_PERSIST)
	_update_show_curve_state()
	
	

#
func _ready():
	#path_length = curve.get_baked_length()
	if curve != null:
		set_curve_and_id(curve, default_curve_id)
	

func add_child(node : Node, legible_unique_name : bool = false):
	.add_child(node, legible_unique_name)
	
	if node is AbstractEnemy:
		node.distance_to_exit = path_length - node.offset
		node.unit_distance_to_exit = 1
		node.current_path_length = path_length
		node.current_path = self
		
		node.connect("on_death_by_any_cause", self, "_emit_enemy_on_death", [node])
		node.connect("reached_end_of_path", self, "_emit_enemy_reached_end")

func _emit_enemy_on_death(enemy):
	emit_signal("on_enemy_death", enemy)

func _emit_enemy_reached_end(enemy):
	emit_signal("on_enemy_reached_end", enemy)


#

func get_copy_of_path(reversed : bool):
	var copy = self.duplicate()
	
	copy.curve = get_copy_of_curve(reversed)
	
	
	#
	
	copy.marker_id_to_value_map = marker_id_to_value_map.duplicate(true)
	
	copy.is_used_and_active = is_used_and_active
	copy.is_used_for_natural_spawning = is_used_for_natural_spawning
	
	return copy


func get_copy_of_curve(reversed : bool):
	var curve_copy = curve.duplicate()
	
	curve_copy.clear_points()
	
	var pos_index = -1
	if reversed:
		pos_index = 0
	
	for point in curve.get_baked_points():
		curve_copy.add_point(point, Vector2(0, 0), Vector2(0, 0), pos_index)
	
	return curve_copy


##

func set_is_used_and_active(arg_val):
	is_used_and_active = arg_val
	emit_signal("is_used_and_active_changed", is_used_and_active)

func set_is_used_for_natural_spawning(arg_val):
	is_used_for_natural_spawning = arg_val
	emit_signal("is_used_for_natural_spawning_changed", is_used_for_natural_spawning)


#################

class ClosestOffsetAdvParams:
	var obj_func_source : Object
	var func_predicate : String
	
	var metadata : Dictionary
	
	func test(arg_test_pos, arg_source_pos, arg_max_distance, arg_closest_pos, distance_of_closest_to_source) -> bool:
		return obj_func_source.call(func_predicate, arg_test_pos, arg_source_pos, arg_max_distance, arg_closest_pos, distance_of_closest_to_source, metadata)


# final offset's distance will never exceed arg_line_search_length distance from source_pos
func get_closest_offset_and_pos_in_a_line__global_source_pos(arg_max_distance_to_candidate_offset : float, arg_line_search_length : float, arg_angle : float, arg_source_global_pos : Vector2, arg_closest_offset_adv_params : ClosestOffsetAdvParams = null):
	return get_closest_offset_and_pos_in_a_line__local_source_pos(arg_max_distance_to_candidate_offset, arg_line_search_length, arg_angle, arg_source_global_pos - global_position, arg_closest_offset_adv_params)

# final offset's distance will never exceed arg_line_search_length distance from source_pos
func get_closest_offset_and_pos_in_a_line__local_source_pos(arg_max_distance_to_candidate_offset : float, arg_line_search_length : float, arg_angle : float, arg_source_local_pos : Vector2, arg_closest_offset_adv_params : ClosestOffsetAdvParams = null):
	#var end_of_search_line_pos : Vector2 = arg_source_pos.move_toward((arg_source_local_pos + Vector2.LEFT).rotated(arg_angle), arg_line_search_length)
	#var end_of_search_line_pos : Vector2 = Vector2(-arg_line_search_length, 0).rotated(arg_angle)# + arg_source_local_pos
	
	var skipping_dist : float = 0.0   # Used to "skip over" distance tests that most likely would not yield a valid offset. Triggered if distance of test pos to nearest offset is very "far"
	var skipping_dist_threshold : float = arg_max_distance_to_candidate_offset * 2
	
	for curr_interval_dist in range(0, arg_line_search_length, arg_max_distance_to_candidate_offset):
		var test_pos : Vector2 = arg_source_local_pos + Vector2(-(curr_interval_dist + skipping_dist), 0).rotated(arg_angle)
		var test_pos_to_source_pos_distance = arg_source_local_pos.distance_to(test_pos)
		
		
		#poses.append(test_pos)   # USED FOR DEBUG DRAW
		
		var valid_offset_and_pos = _get_offset_and_pos_within_distance_of_path(test_pos, arg_source_local_pos, arg_max_distance_to_candidate_offset, arg_line_search_length, arg_closest_offset_adv_params)
		
		if valid_offset_and_pos != null:
			return valid_offset_and_pos
		else:
			if test_pos_to_source_pos_distance > skipping_dist_threshold:
				skipping_dist += 0#skipping_dist_threshold
		
#		if curr_interval_dist + skipping_dist > arg_line_search_length:
#			break
	
	#update()  # dor debug draw
	
	return null

#DEBUG DRAW START
#var poses : Array
#var closest_poses : Array
#var closest_pos_finals : Array
#
#func _draw():
#	for pos in poses:
#		draw_circle(pos, 3, Color(1, 0, 0))
#
#	for pos in closest_poses:
#		draw_circle(pos, 2, Color(0, 0, 1))
#
#	for pos in closest_pos_finals:
#		draw_circle(pos, 3, Color(1, 1, 0))
#DEBUG DRAW END


# OLD CODE HERE For failed binary style. This type is just not compatible to requirements.
#	# USE AVERAGE/BINARY STYLE Kind of search
#	var higher_bound_ratio : float = 2.0
#	var lower_bound_ratio : float = 0.0
#	var current_ratio : float = 0.0
#
#	var max_attempts : int = 100
#
#	for i in max_attempts:
#		var test_pos : Vector2 = _get_sum_of_vectors(arg_source_local_pos, end_of_search_line_pos * current_ratio)
#		var test_pos_to_source_pos_distance = arg_source_local_pos.distance_to(test_pos)
#
#		var valid_offset = _get_offset_within_distance_of_path(test_pos, arg_source_local_pos, test_pos_to_source_pos_distance, arg_max_distance_to_candidate_offset, arg_closest_offset_adv_params)
#
#		if valid_offset != null:
#			return valid_offset
#		else:
#			pass
#
#func _get_sum_of_vectors(arg_vec_01 : Vector2, arg_vec_02 : Vector2):
#	return (arg_vec_01 + arg_vec_02)


func _get_offset_and_pos_within_distance_of_path(arg_test_pos, arg_source_pos : Vector2, arg_max_distance_to_test_offset : float, arg_line_search_length : float, arg_closest_offset_adv_params : ClosestOffsetAdvParams = null):
	var closest_pos : Vector2 = curve.get_closest_point(arg_test_pos)
	var distance_of_closest_to_test = closest_pos.distance_to(arg_test_pos)
	var distance_of_closest_to_source = closest_pos.distance_to(arg_source_pos)
	
	#closest_poses.append(closest_pos)  #used to debug draw
	
	#if distance_of_closest_to_test <= arg_max_distance_to_test_offset and arg_line_search_length < distance_of_closest_to_source:
	if distance_of_closest_to_test <= arg_max_distance_to_test_offset:
		var passed : bool = true
		
		if arg_closest_offset_adv_params != null:
			passed = arg_closest_offset_adv_params.test(arg_test_pos, arg_source_pos, arg_max_distance_to_test_offset, closest_pos, distance_of_closest_to_source)
		
		if passed:
			#closest_pos_finals.append(closest_pos)  # used for debug draw
			return [curve.get_closest_offset(closest_pos), closest_pos]
	
	return null

#########

func set_curve_and_id(arg_curve_2d : Curve2D, arg_curve_id : int):
	if !last_calculated_curve_change_defer:
		_deferred_new_curve = null
		_deferred_new_curve_id = 0
		
		curve = arg_curve_2d
		path_length = curve.get_baked_length()
		current_curve_id = arg_curve_id
		
		path_end_global_pos = curve.get_point_position(curve.get_point_count() - 1) + global_position
		
		update()
		emit_signal("curve_changed", curve, current_curve_id)
	else:
		
		_deferred_new_curve = arg_curve_2d
		_deferred_new_curve_id = arg_curve_id


func _on_curve_change_defer_conditional_clauses_updated(arg_clause_id):
	_update_curve_change_defer_state()

func _update_curve_change_defer_state():
	last_calculated_curve_change_defer = !curve_change_defer_conditional_clauses.is_passed
	
	emit_signal("last_calculated_curve_change_defer_changed", last_calculated_curve_change_defer)
	
	if _deferred_new_curve != null and !last_calculated_curve_change_defer:
		emit_signal("before_curve_changed_from_deferred_set", _deferred_new_curve, _deferred_new_curve_id)
		set_curve_and_id(_deferred_new_curve, _deferred_new_curve_id)
		emit_signal("after_curve_changed_from_deferred_set", _deferred_new_curve, _deferred_new_curve_id)


func set_curve_and_id__using_vector_points(arg_points : Array, arg_curve_id : int):
	set_curve_and_id(_construct_curve_2d_using_points(arg_points), arg_curve_id)
	
	

func _construct_curve_2d_using_points(arg_points : Array) -> Curve2D:
	var curve_2d = Curve2D.new()
	
	for pos in arg_points:
		curve_2d.add_point(pos)
	
	return curve_2d


###


func _on_show_curve_conditional_clauses_updated(arg_clause_id):
	_update_show_curve_state()

func _update_show_curve_state():
	last_calculated_is_showing_curve = !show_curve_conditional_clauses.is_passed
	
	update()

func _draw():
	if last_calculated_is_showing_curve:
		#draw_multiline(curve.get_baked_points(), showing_curve_color, 8, false)
		draw_polyline(curve.get_baked_points(), showing_curve_color, 6)
