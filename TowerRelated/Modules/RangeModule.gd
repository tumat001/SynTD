extends Area2D

const Targeting = preload("res://GameInfoRelated/Targeting.gd")
const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")


signal final_range_changed
signal enemy_entered_range(enemy)
signal enemy_left_range(enemy)
signal current_enemy_left_range(enemy)

signal targeting_changed
signal targeting_options_modified

var benefits_from_bonus_range : bool = true

var base_range_radius : float
var flat_range_effects : Dictionary = {}
var percent_range_effects : Dictionary = {}

var displaying_range : bool = false
var can_display_range : bool = true

var enemies_in_range : Array = []
var _current_enemies : Array = []
var priority_enemies : Array = []

var _current_targeting_option_index : int
var _last_used_targeting_option_index : int
var all_distinct_targeting_options : Array = []
var _all_targeting_options : Array = []

# last calc stuffs

var last_calculated_final_range : float


# tracker

var attack_modules_using_this : Array = []


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

func set_range_shape(shape : CircleShape2D):
	$RangeShape.shape = shape

func toggle_show_range():
	displaying_range = !displaying_range
	update() #calls _draw()

func _draw():
	
	if displaying_range:
		if can_display_range:
			var final_range = calculate_final_range_radius()
			var color : Color = Color.gray
			color.a = 0.1
			draw_circle(Vector2(0, 0), final_range, color)


func update_range():
	var final_range = calculate_final_range_radius()
	call_deferred("emit_signal", "final_range_changed")
	
	$RangeShape.shape.set_deferred("radius", final_range)
	update()


#Enemy Detection Related

func _on_Range_area_shape_entered(area_id, area, area_shape, self_shape):
	if area != null:
		if area.get_parent() is AbstractEnemy:
			_on_enemy_enter_range(area.get_parent())

func _on_Range_area_shape_exited(area_id, area, area_shape, self_shape):
	if area != null:
		if area.get_parent() is AbstractEnemy:
			_on_enemy_leave_range(area.get_parent())


func _on_enemy_enter_range(enemy : AbstractEnemy):
	enemies_in_range.append(enemy)
	emit_signal("enemy_entered_range", enemy)

func _on_enemy_leave_range(enemy : AbstractEnemy):
	enemies_in_range.erase(enemy)
	emit_signal("enemy_left_range", enemy)
	
	if _current_enemies.has(enemy):
		emit_signal("current_enemy_left_range", enemy)
	_current_enemies.erase(enemy)


func is_an_enemy_in_range():
	var to_remove = []
	for target in enemies_in_range:
		if target == null:
			to_remove.append(target)
	
	for removal in to_remove:
		enemies_in_range.erase(removal)
	
	return enemies_in_range.size() > 0


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

func get_targets(num : int, targeting : int = get_current_targeting_option()) -> Array:
	_current_enemies = Targeting.enemies_to_target(enemies_in_range, targeting, num, global_position)
	while _current_enemies.has(null):
		_current_enemies.erase(null)
	
	while priority_enemies.has(null):
		priority_enemies.erase(null)
	
	for i in range(priority_enemies.size() - 1, 0, -1):
		_current_enemies.push_front(priority_enemies[i])
	
	return _current_enemies

func get_all_targets(targeting : int = get_current_targeting_option()) -> Array:
	return get_targets(_current_enemies.size(), targeting)
