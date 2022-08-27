extends Area2D

const Targeting = preload("res://GameInfoRelated/Targeting.gd")
const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")
const TowerPriorityTargetEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerPriorityTargetEffect.gd")

signal final_range_changed
signal enemy_entered_range(enemy)
signal enemy_left_range(enemy)
signal current_enemy_left_range(enemy)
signal current_enemies_acquired()

signal targeting_changed
signal targeting_options_modified

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

#
onready var range_shape = $RangeShape

func _ready():
	_connect_area_shape_entered_and_exit_signals()
	#connect("area_shape_entered", self, "_on_Range_area_shape_entered", [], CONNECT_ONESHOT | CONNECT_DEFERRED | CONNECT_PERSIST)
	#connect("area_shape_exited" , self, "_on_Range_area_shape_exited", [], CONNECT_ONESHOT | CONNECT_DEFERRED | CONNECT_PERSIST)
#	connect("area_shape_entered", self, "_on_Range_area_shape_entered", [], CONNECT_PERSIST)
#	connect("area_shape_exited" , self, "_on_Range_area_shape_exited", [], CONNECT_PERSIST)
	

func _init():
	_all_targeting_options = [Targeting.FIRST, Targeting.LAST]
	all_distinct_targeting_options = [Targeting.FIRST, Targeting.LAST]
	
	_current_targeting_option_index = 0
	_last_used_targeting_option_index = 0


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
	
	if targetings.has(all_distinct_targeting_options[_current_targeting_option_index]):
		switch = true
	
	_last_used_targeting_option_index = 0
	
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
	$RangeShape.shape = shape

func get_range_shape():
	return $RangeShape.shape


func toggle_show_range():
	displaying_range = !displaying_range
	update() #calls _draw()

func _draw():
	if displaying_range:
		var final_range = last_calculated_final_range
		
		if can_display_range:
#			var color : Color = Color.gray
#			color.a = 0.1
			draw_circle(Vector2(0, 0), final_range, circle_range_color)
		
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




func update_range():
	var final_range = calculate_final_range_radius()
	call_deferred("emit_signal", "final_range_changed")
	
	_change_range(final_range)
	#call_deferred("_change_range", final_range)



func _change_range(final_range):
	if is_connected("area_shape_entered", self, "_on_Range_area_shape_entered"):
		disconnect("area_shape_entered", self, "_on_Range_area_shape_entered")
	
	if is_connected("area_shape_exited", self, "_on_Range_area_shape_exited"):
		disconnect("area_shape_exited", self, "_on_Range_area_shape_exited")
	
	$RangeShape.shape.set_deferred("radius", final_range)
	#$RangeShape.shape.radius = final_range
	
	_connect_area_shape_entered_and_exit_signals()
	#call_deferred("_connect_area_shape_entered_and_exit_signals")
	
	update()

func _connect_area_shape_entered_and_exit_signals():
	if !is_connected("area_shape_entered", self, "_on_Range_area_shape_entered"):
		connect("area_shape_entered", self, "_on_Range_area_shape_entered", [], CONNECT_DEFERRED | CONNECT_PERSIST)
	
	if !is_connected("area_shape_exited", self, "_on_Range_area_shape_exited"):
		connect("area_shape_exited", self, "_on_Range_area_shape_exited", [], CONNECT_DEFERRED | CONNECT_PERSIST)



#Enemy Detection Related

func _on_Range_area_shape_entered(area_id, area, area_shape, self_shape):
	if area != null:
		if area.get_parent() is AbstractEnemy:
			_on_enemy_enter_range(area.get_parent())
	
	#connect("area_shape_entered", self, "_on_Range_area_shape_entered", [], CONNECT_ONESHOT | CONNECT_DEFERRED | CONNECT_PERSIST)

func _on_Range_area_shape_exited(area_id, area, area_shape, self_shape):
	if area != null:
		if area.get_parent() is AbstractEnemy:
			_on_enemy_leave_range(area.get_parent())
	
	#connect("area_shape_exited", self, "_on_Range_area_shape_exited", [], CONNECT_ONESHOT | CONNECT_DEFERRED | CONNECT_PERSIST)


func _on_enemy_enter_range(enemy : AbstractEnemy):
	#enemies_in_range.append(enemy)
	_add_enemy_to_enemies_in_range(enemy)
	emit_signal("enemy_entered_range", enemy)
	
	#enemy.connect("tree_exiting", self, "_on_enemy_leave_range", [enemy])

# by leaving range or by dying
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
		if target == null:
			to_remove.append(target)
	
	for removal in to_remove:
		enemies_in_range.erase(removal)
	
	return enemies_in_range.size() > 0

func get_enemy_in_range_count() -> int:
	var to_remove = []
	for target in enemies_in_range:
		if target == null:
			to_remove.append(target)
	
	for removal in to_remove:
		enemies_in_range.erase(removal)
	
	return enemies_in_range.size()


func get_enemies_in_range__not_affecting_curr_enemies_in_range() -> Array:
	var bucket = []
	for target in enemies_in_range:
		if target != null and !target.is_queued_for_deletion():
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
	if !priority_targets_effects.has(effect.effect_uuid) and effect.target != null:
		priority_targets_effects[effect.effect_uuid] = effect
		
		if !effect.is_priority_regardless_of_range:
			add_priority_target_within_range(effect.target)
		else:
			add_priority_target_regardless_of_range(effect.target)
		
		effect.set_up_signal_with_target()
		effect.connect("on_target_tree_exiting", self, "_on_target_from_target_effect_tree_exiting", [effect], CONNECT_ONESHOT)

func add_priority_target_within_range(target):
	if target != null:
		priority_enemies_within_range.append(target)
		#_add_enemy_to_enemies_in_range(target)

func add_priority_target_regardless_of_range(target):
	if target != null:
		priority_enemies_regardless_of_range.append(target)

func _on_target_from_target_effect_tree_exiting(target, effect):
	_remove_priority_target_effect_from_tower(effect)


func _remove_priority_target_effect_from_tower(effect : TowerPriorityTargetEffect):
	for am in attack_modules_using_this:
		if am != null and am.parent_tower != null:
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
	if other_module != null:
		other_module.connect("targeting_changed", self, "_mirrored_range_module_targeting_changed", [other_module], CONNECT_PERSIST)
		other_module.connect("targeting_options_modified", self, "_mirrored_range_module_targeting_options_modified", [other_module], CONNECT_PERSIST)


func _mirrored_range_module_targeting_changed(module):
	if module != null:
		set_current_targeting(module.get_current_targeting_option())

func _mirrored_range_module_targeting_options_modified(module):
	if module != null:
		clear_all_targeting()
		add_targeting_options(module.all_distinct_targeting_options)



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


