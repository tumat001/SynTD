extends Area2D

const Targeting = preload("res://GameInfoRelated/Targeting.gd")
const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")

var benefits_from_bonus_range : bool = true

var base_range_radius : float
var flat_range_effects : Dictionary = {}
var percent_range_effects : Dictionary = {}

var displaying_range : bool = false

var enemies_in_range : Array = []

var current_targeting_option : int
var last_used_targeting_option : int
var all_targeting_options = {}

func _ready():
	all_targeting_options["First"] = Targeting.FIRST
	current_targeting_option = Targeting.FIRST
	last_used_targeting_option = Targeting.FIRST


func time_passed(delta):
	decrease_time_of_timebounded(delta)


func decrease_time_of_timebounded(delta):
	var bucket = []
	
	#For percent range mods
	for effect_uuid in percent_range_effects.keys():
		if percent_range_effects[effect_uuid].is_timebound:
			percent_range_effects[effect_uuid].time_in_seconds -= delta
			var time_left = percent_range_effects[effect_uuid].time_in_seconds
			if time_left <= 0:
				bucket.append(effect_uuid)
	
	for key_to_delete in bucket:
		percent_range_effects.erase(key_to_delete)
	
	if bucket.size() > 0:
		update_range()
	
	bucket.clear()
	
	#For flat range mods
	for effect_uuid in flat_range_effects.keys():
		if flat_range_effects[effect_uuid].is_timebound:
			flat_range_effects[effect_uuid].time_in_seconds -= delta
			var time_left = flat_range_effects[effect_uuid].time_in_seconds
			if time_left <= 0:
				bucket.append(effect_uuid)
	
	for key_to_delete in bucket:
		flat_range_effects.erase(key_to_delete)
	
	if bucket.size() > 0:
		update_range()
	
	bucket.clear()


# Range Related

func set_range_shape(shape : CircleShape2D):
	$RangeShape.shape = shape

func toggle_show_range():
	displaying_range = !displaying_range
	update() #calls _draw()

func _draw():
	
	if displaying_range:
		
		var final_range = calculate_final_range_radius()
		var color : Color = Color.gray
		color.a = 0.1
		draw_circle(Vector2(0, 0), final_range, color)


func update_range():
	var final_range = calculate_final_range_radius()
	
	$RangeShape.shape.set_deferred("radius", final_range)
	update()


func _on_Range_area_shape_entered(area_id, area, area_shape, self_shape):
	if area != null:
		if area.get_parent() is AbstractEnemy:
			_on_enemy_enter_range(area.get_parent())

func _on_Range_area_shape_exited(area_id, area, area_shape, self_shape):
	if area != null:
		if area.get_parent() is AbstractEnemy:
			_on_enemy_leave_range(area.get_parent())

#Enemy Detection Related
func _on_enemy_enter_range(enemy : AbstractEnemy):
	enemies_in_range.append(enemy)

func _on_enemy_leave_range(enemy : AbstractEnemy):
	enemies_in_range.erase(enemy)


func is_an_enemy_in_range():
	var to_remove = []
	for target in enemies_in_range:
		if target == null:
			to_remove.append(target)
	
	for removal in to_remove:
		enemies_in_range.erase(removal)
	
	return enemies_in_range.size() > 0


func calculate_final_range_radius() -> float:
	#All percent modifiers here are to BASE range only
	var final_range = base_range_radius
	for effect in percent_range_effects.values():
		final_range += effect.attribute_as_modifiers.get_modification_to_value(base_range_radius)
	
	for effect in flat_range_effects.values():
		final_range += effect.attribute_as_modifiers.get_modification_to_value(base_range_radius)
	
	return final_range


func get_target() -> AbstractEnemy:
	return Targeting.enemy_to_target(enemies_in_range, current_targeting_option)

func get_targets(num : int) -> Array:
	return Targeting.enemies_to_target(enemies_in_range, current_targeting_option, num)

