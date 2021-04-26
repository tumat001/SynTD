extends Area2D

const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")
const Targeting = preload("res://GameInfoRelated/Targeting.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const BaseAreaTowerPlacable = preload("res://GameElementsRelated/AreaTowerPlacablesRelated/BaseAreaTowerPlacable.gd")
const TowerBenchSlot = preload("res://GameElementsRelated/AreaTowerPlacablesRelated/TowerBenchSlot.gd")

signal tower_being_dragged
signal tower_dropped_from_dragged
signal tower_show_info

export var tower_highlight_sprite : Resource

var hovering_over_placable : BaseAreaTowerPlacable
var current_placable : BaseAreaTowerPlacable

var is_being_dragged : bool = false

#####

var collision_shape
var disabled_from_attacking : bool = false

var base_damage : float
var base_damage_type : int
var flat_base_damage_modifiers = {}
var percent_base_damage_modifiers = {}
var base_on_hit_damage_internal_name

var extra_on_hit_damages = {}

var extra_on_hit_effects = {}

var base_attack_speed : float
var flat_attack_speed_modifiers = {}
var percent_attack_speed_modifiers = {}
var current_attack_speed_wait : float = 0

var base_pierce : float
var flat_pierce_modifiers = {}
var percent_pierce_modifiers = {}

var base_range_radius : float
var flat_range_modifiers = {}
var percent_range_modifiers = {}

var base_proj_speed : float
var flat_proj_speed_modifiers = {}
var percent_proj_speed_modifiers = {}

var current_targeting_option : int
var last_used_targeting_option : int
var all_targeting_options = {}

var current_power_level_used : int

var enemies_in_range : Array = []

var displaying_range : bool = false

var ingredients_absorbed : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	_end_drag()
	
	all_targeting_options["First"] = Targeting.FIRST
	current_targeting_option = Targeting.FIRST
	last_used_targeting_option = Targeting.FIRST

func _post_inherit_ready():
	_update_detection_range()

func _calculate_base_on_hit_damage() -> OnHitDamage:
	var modifier : FlatModifier = FlatModifier.new(base_on_hit_damage_internal_name)
	modifier.flat_modifier = calculate_final_base_damage()

	return OnHitDamage.new(base_on_hit_damage_internal_name, modifier, base_damage_type)

func get_all_on_hit_damages() -> Array:
	var on_hit_damages = {}
	on_hit_damages[base_on_hit_damage_internal_name] = _calculate_base_on_hit_damage()
	for extra_on_hit_key in extra_on_hit_damages.keys():
		on_hit_damages[extra_on_hit_key] = extra_on_hit_damages[extra_on_hit_key]
	
	return on_hit_damages

#Calculation of attributes
func calculate_final_base_damage():
	#All percent modifiers here are to BASE damage only
	var final_base_damage = base_damage
	for modifier in percent_base_damage_modifiers.values():
		final_base_damage += modifier.get_modification_to_value(base_damage)
	
	for flat in flat_base_damage_modifiers.values():
		final_base_damage += flat.get_modification_to_value(base_damage)
	
	return final_base_damage

func calculate_final_attack_speed():
	#All percent modifiers here are to BASE attk speed only
	var final_attack_speed = base_attack_speed
	for modifier in percent_attack_speed_modifiers.values():
		final_attack_speed += modifier.get_modification_to_value(base_attack_speed)
	
	for flat in flat_attack_speed_modifiers.values():
		final_attack_speed += flat.get_modification_to_value(base_attack_speed)
	
	return final_attack_speed

func calculate_final_range_radius():
	#All percent modifiers here are to BASE range only
	var final_range = base_range_radius
	for modifier in percent_range_modifiers.values():
		final_range += modifier.get_modification_to_value(base_range_radius)
	
	for flat in flat_range_modifiers.values():
		final_range += flat.get_modification_to_value(base_range_radius)
	
	return final_range

func calculate_final_pierce():
	#All percent modifiers here are to BASE pierce only
	var final_pierce = base_pierce
	for modifier in percent_pierce_modifiers.values():
		final_pierce += modifier.get_modification_to_value(base_pierce)
	
	for flat in flat_pierce_modifiers.values():
		final_pierce += flat.get_modification_to_value(base_pierce)
	
	return final_pierce

func calculate_final_proj_speed():
	#All percent modifiers here are to BASE proj speed only
	var final_proj_speed = base_proj_speed
	for modifier in percent_proj_speed_modifiers.values():
		final_proj_speed += modifier.get_modification_to_value(base_proj_speed)
	
	for flat in flat_proj_speed_modifiers.values():
		final_proj_speed += flat.get_modification_to_value(base_proj_speed)
	
	return final_proj_speed

func calculate_final_life_distance():
	return calculate_final_range_radius()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Attack speed related
	if calculate_final_attack_speed() > 0 and !disabled_from_attacking:
		if current_attack_speed_wait <= 0:
			
			if _is_an_enemy_in_range():
				_attack_at_position(_get_current_target_position())
				current_attack_speed_wait = 1 / calculate_final_attack_speed()
			
		else:
			current_attack_speed_wait -= delta
	
	#Counting down time-bound modifiers
	_decrement_time_of_modifiers(delta)
	
	#Drag related
	if is_being_dragged:
		var mouse_pos = get_global_mouse_position()
		position.x = mouse_pos.x
		position.y = mouse_pos.y

func _decrement_time_of_modifiers(delta):
	var bucket = []
	
	# For on_hit_damages
	for key in extra_on_hit_damages.keys():
		if extra_on_hit_damages[key].is_timebound:
			extra_on_hit_damages[key].time_in_seconds -= delta
			var time_left = extra_on_hit_damages[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
				
	for key_to_delete in bucket:
		extra_on_hit_damages.erase(key_to_delete)
	
	bucket.clear()
	
	#For percent attk speed mods
	for key in percent_attack_speed_modifiers.keys():
		if percent_attack_speed_modifiers[key].is_timebound:
			percent_attack_speed_modifiers[key].time_in_seconds -= delta
			var time_left = percent_attack_speed_modifiers[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
	
	for key_to_delete in bucket:
		percent_attack_speed_modifiers.erase(key_to_delete)
	
	bucket.clear()
	
	#For flat attk speed mods
	for key in flat_attack_speed_modifiers.keys():
		if flat_attack_speed_modifiers[key].is_timebound:
			flat_attack_speed_modifiers[key].time_in_seconds -= delta
			var time_left = flat_attack_speed_modifiers[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
	
	for key_to_delete in bucket:
		flat_attack_speed_modifiers.erase(key_to_delete)
	
	bucket.clear()
	
	#For percent range mods
	for key in percent_range_modifiers.keys():
		if percent_range_modifiers[key].is_timebound:
			percent_range_modifiers[key].time_in_seconds -= delta
			var time_left = percent_range_modifiers[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
	
	for key_to_delete in bucket:
		percent_range_modifiers.erase(key_to_delete)
	
	if bucket.size() > 0:
		_update_detection_range()
	
	bucket.clear()
	
	#For flat range mods
	for key in flat_range_modifiers.keys():
		if flat_range_modifiers[key].is_timebound:
			flat_range_modifiers[key].time_in_seconds -= delta
			var time_left = flat_range_modifiers[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
	
	for key_to_delete in bucket:
		flat_range_modifiers.erase(key_to_delete)
	
	if bucket.size() > 0:
		_update_detection_range()
	
	bucket.clear()
	
	#For percent pierce mods
	for key in percent_pierce_modifiers.keys():
		if percent_pierce_modifiers[key].is_timebound:
			percent_pierce_modifiers[key].time_in_seconds -= delta
			var time_left = percent_pierce_modifiers[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
	
	for key_to_delete in bucket:
		percent_pierce_modifiers.erase(key_to_delete)
	
	bucket.clear()
	
	#For flat pierce mods
	for key in flat_pierce_modifiers.keys():
		if flat_pierce_modifiers[key].is_timebound:
			flat_pierce_modifiers[key].time_in_seconds -= delta
			var time_left = flat_pierce_modifiers[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
	
	for key_to_delete in bucket:
		flat_pierce_modifiers.erase(key_to_delete)
	
	bucket.clear()
	
	#For percent proj speed mods
	for key in percent_proj_speed_modifiers.keys():
		if percent_proj_speed_modifiers[key].is_timebound:
			percent_proj_speed_modifiers[key].time_in_seconds -= delta
			var time_left = percent_proj_speed_modifiers[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
	
	for key_to_delete in bucket:
		percent_proj_speed_modifiers.erase(key_to_delete)
	
	bucket.clear()
	
	#For flat proj speed mods
	for key in flat_proj_speed_modifiers.keys():
		if flat_proj_speed_modifiers[key].is_timebound:
			flat_proj_speed_modifiers[key].time_in_seconds -= delta
			var time_left = flat_proj_speed_modifiers[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
	
	for key_to_delete in bucket:
		flat_proj_speed_modifiers.erase(key_to_delete)
	
	bucket.clear()
	

func _rotate_barrel_to(position_arg):
	var angle = _get_angle(position_arg.x, position_arg.y)
	
	$TowerBarrel.rotation_degrees = angle

func _attack_at_position(pos):
	_rotate_barrel_to(pos)

func _update_detection_range():
	var final_range = calculate_final_range_radius()
	
	$Range/RangeShape.shape.set_deferred("radius", final_range)
	update()


func _on_Range_area_shape_entered(area_id, area, area_shape, self_shape):
	_on_enemy_enter_range(area.get_parent())


func _on_Range_area_shape_exited(area_id, area, area_shape, self_shape):
	if area != null:
		_on_enemy_leave_range(area.get_parent())

func _get_angle(xPos, yPos):
	var dx = xPos - position.x
	var dy = yPos - position.y
	
	return rad2deg(atan2(dy, dx))

#Enemy Detection Related
func _on_enemy_enter_range(enemy : AbstractEnemy):
	enemies_in_range.append(enemy)

func _on_enemy_leave_range(enemy : AbstractEnemy):
	enemies_in_range.erase(enemy)

func _is_an_enemy_in_range():
	var to_remove = []
	for target in enemies_in_range:
		if target == null:
			to_remove.append(target)
	
	for removal in to_remove:
		enemies_in_range.erase(removal)
	
	return enemies_in_range.size() > 0

func _get_current_target_position():
	var target : AbstractEnemy = Targeting.enemy_to_target(enemies_in_range, current_targeting_option)
	
	return Vector2(target.position.x, target.position.y)

func _on_Mono_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_RIGHT:
			_show_range()
			_show_tower_info()
		elif event.pressed and event.button_index == BUTTON_LEFT:
			_start_drag()
		elif !event.pressed and event.button_index == BUTTON_LEFT:
			_end_drag()

# Show Range and Tower Info

func _show_range():
	displaying_range = !displaying_range
	update() #calls _draw()

func _draw():
	var final_range = calculate_final_range_radius()
	var color : Color = Color.gray
	color.a = 0.1
	
	if displaying_range:
		draw_circle(Vector2(0, 0), final_range, color)

func _show_tower_info():
	emit_signal("tower_show_info")

# Drag and Drop things related

func _start_drag():
	$PlacableDetector/DetectorShape.set_deferred("disabled", false)
	$PlacableDetector.monitoring = true
	is_being_dragged = true
	disabled_from_attacking = true
	
	emit_signal("tower_being_dragged")

func _end_drag():
	transfer_to_placable(hovering_over_placable)
	emit_signal("tower_dropped_from_dragged")


func transfer_to_placable(new_area_placable: BaseAreaTowerPlacable):
	# The "old" one
	if current_placable != null:
		current_placable.tower_occupying = null
	
	if new_area_placable != null and new_area_placable.tower_occupying != null:
		new_area_placable.tower_occupying.transfer_to_placable(current_placable)
	
	# The "new" one
	if new_area_placable != null:
		current_placable = new_area_placable
		current_placable.tower_occupying = self
	
	$PlacableDetector/DetectorShape.set_deferred("disabled", true)
	$PlacableDetector.monitoring = false
	is_being_dragged = false
	
	if current_placable != null:
		var pos = current_placable.get_tower_center_position()
		position.x = pos.x
		position.y = pos.y
		current_attack_speed_wait = 0
		
		if current_placable is TowerBenchSlot:
			disabled_from_attacking = true
		else:
			disabled_from_attacking = false

var hover_window : bool
func _on_PlacableDetector_area_entered(area):
	if area is BaseAreaTowerPlacable:
		hovering_over_placable = area
		hovering_over_placable.set_tower_highlight_sprite(tower_highlight_sprite)

func _on_PlacableDetector_area_exited(area):
	if area is BaseAreaTowerPlacable:
		area.set_tower_highlight_sprite(null)
		if hovering_over_placable == area:
			hovering_over_placable = null
