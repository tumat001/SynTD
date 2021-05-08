extends PathFollow2D

const Modifier = preload("res://GameInfoRelated/Modifier.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const OnHitEffect = preload("res://GameInfoRelated/OnHitEffect.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const EnemyBaseEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd")
const BaseBullet = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")

signal on_death
signal on_hit
signal on_current_health_changed(current_health)
signal on_max_health_changed(max_health)


var base_health : float = 1
var _flat_base_health_modifiers = {}
var _percent_base_health_modifiers = {}
var current_health : float = 1

var active_on_hit_effects = {}

var pierce_consumed_per_hit : float = 1

var base_armor : float = 0
var flat_armor_modifiers = {}
var percent_armor_modifiers = {}

var base_toughness : float = 0
var flat_toughness_modifiers = {}
var percent_toughness_modifiers = {}

var base_resistance : float = 0
var flat_resistance_modifiers = {}
var percent_resistance_modifiers = {}

var base_player_damage : float = 1
var flat_player_damage_modifiers = {}
var percent_player_damage_modifiers = {}

var base_movement_speed : float
var flat_movement_speed_modifiers = {}
var percent_movement_speed_modifiers = {}

var distance_to_exit : float

#internals

var _self_size : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	_self_size = _get_current_anim_size()
	
	$Healthbar.position.y -= round((_self_size.y / 2) + 15)
	$Healthbar.position.x -= round($Healthbar.get_size().x / 2)
	
	connect("on_current_health_changed", $Healthbar, "_on_current_health_changed")

func _post_ready():
	$Healthbar.base_health = base_health
	$Healthbar.redraw_chunks()


func _get_current_anim_size() -> Vector2:
	return $AnimatedSprite.frames.get_frame($AnimatedSprite.animation, $AnimatedSprite.frame).get_size()


#func _process(delta):
#	pass


func _physics_process(delta):
	var distance_traveled = delta * calculate_final_movement_speed()
	offset += distance_traveled
	distance_to_exit -= distance_traveled
	



# Health related functions. Different from the norm
# because percentages must be preserved when removing
# flats and percentages. Also must heal when flats
# and percentages are added
func calculate_max_health() -> float:
	#All percent modifiers here are to BASE health only
	var max_health = base_health
	for modifier in _percent_base_health_modifiers.values():
		max_health += modifier.get_modification_to_value(base_health)
	
	for flat in _flat_base_health_modifiers.values():
		max_health += flat.get_modification_to_value(max_health)
	
	return max_health

func heal_without_overhealing(heal_amount):
	var total_amount : float = current_health + heal_amount
	var max_health = calculate_max_health()
	if total_amount > max_health:
		current_health = max_health
	else:
		current_health += heal_amount
	
	emit_signal("on_current_health_changed", current_health)

func heal_with_overhealing(heal_amount):
	current_health += heal_amount
	
	emit_signal("on_current_health_changed", current_health)

func _set_current_health_to(health_amount):
	current_health = health_amount
	
	emit_signal("on_current_health_changed", current_health)

# The only function that should handle taking
# damage and health deduction. Also where
# death is handled
func _take_unmitigated_damage(damage_amount):
	current_health -= damage_amount
	if current_health <= 0:
		_destroy_self()
	else:
		emit_signal("on_current_health_changed", current_health)

func _destroy_self():
	emit_signal("on_death")
	
	$CollisionArea.monitorable = false
	$CollisionArea.monitoring = false
	queue_free()

func add_flat_base_health_modifier_with_heal(modifier_name : String, 
		modifier : FlatModifier):
	
	_flat_base_health_modifiers[modifier_name] = modifier
	var heal = modifier.get_modification_to_value(base_health)
	heal_without_overhealing(heal)

func add_percent_base_health_modifier_with_heal(modifier_name : String,
		modifier : PercentModifier):
	
	_percent_base_health_modifiers[modifier_name] = modifier
	var heal = modifier.get_modification_to_value(base_health)
	heal_without_overhealing(heal)

func remove_flat_base_health_preserve_percent(modifier_name : String):
	if _flat_base_health_modifiers.has(modifier_name):
		var flat_mod : FlatModifier = _flat_base_health_modifiers[modifier_name]
		var flat_remove = flat_mod.flat_modifier
		_set_current_health_to(PercentPreserver.removed_flat_amount(
				calculate_max_health(), current_health, flat_remove))
		
		_flat_base_health_modifiers.erase(modifier_name)

func remove_percent_base_health_preserve_percent(modifier_name : String):
	if _percent_base_health_modifiers.has(modifier_name):
		var percent_mod : PercentModifier = _percent_base_health_modifiers[modifier_name]
		var percent_remove = percent_mod.percent_modifier
		_set_current_health_to(PercentPreserver.removed_percent_amount(
				calculate_max_health(), current_health, percent_remove))
		
		_percent_base_health_modifiers.erase(modifier_name)

class PercentPreserver:
	
	static func removed_flat_amount(max_arg : float, 
			current : float, flat_remove : float) -> float:
		
		var initial_ratio = current / max_arg
		var reduced = max_arg - flat_remove
		return reduced * initial_ratio
	
	static func removed_percent_amount(max_arg : float,
			current : float, percent_remove : float) -> float:
		
		var initial_ratio = current / max_arg
		var reduced = max_arg * (1 - (percent_remove / 100))
		return reduced * initial_ratio

#Other calculation of final stuffs
func calculate_final_armor() -> float:
	#All percent modifiers here are to BASE armor only
	var final_armor = base_armor
	for modifier in percent_armor_modifiers.values():
		final_armor += modifier.get_modification_to_value(base_armor)
	
	for flat in flat_armor_modifiers.values():
		final_armor += flat.get_modification_to_value(base_armor)
	
	return final_armor

func calculate_final_toughness() -> float:
	#All percent modifiers here are to BASE toughness only
	var final_toughness = base_toughness
	for modifier in percent_toughness_modifiers.values():
		final_toughness += modifier.get_modification_to_value(base_toughness)
	
	for flat in flat_toughness_modifiers.values():
		final_toughness += flat.get_modification_to_value(base_toughness)
	
	return final_toughness

func calculate_final_resistance() -> float:
	#All percent modifiers here are to BASE resistance only
	var final_resistance = base_resistance
	for modifier in percent_resistance_modifiers.values():
		final_resistance += modifier.get_modification_to_value(base_resistance)
	
	for flat in flat_resistance_modifiers.values():
		final_resistance += flat.get_modification_to_value(base_resistance)
	
	return final_resistance

func calculate_final_player_damage() -> float:
	#All percent modifiers here are to BASE player damage only
	var final_player_damage = base_player_damage
	for modifier in percent_player_damage_modifiers.values():
		final_player_damage += modifier.get_modification_to_value(base_player_damage)
	
	for flat in flat_player_damage_modifiers.values():
		final_player_damage += flat.get_modification_to_value(base_player_damage)
	
	return final_player_damage

func calculate_final_movement_speed() -> float:
	#All percent modifiers here are to BASE mvnt speed only
	var final_movement_speed = base_movement_speed
	for modifier in percent_movement_speed_modifiers.values():
		final_movement_speed += modifier.get_modification_to_value(base_movement_speed)
	
	for flat in flat_movement_speed_modifiers.values():
		final_movement_speed += flat.get_modification_to_value(base_movement_speed)
	
	return final_movement_speed
	

#Process damages
# hit by things functions here. Processes
# on hit damages and effects.
func hit_by_bullet(generic_bullet : BaseBullet):
	generic_bullet.decrease_pierce(pierce_consumed_per_hit)
	hit_by_damage_instance(generic_bullet.damage_instance)

func hit_by_damage_instance(damage_instance : DamageInstance):
	emit_signal("on_hit")
	_process_on_hit_damages(damage_instance.on_hit_damages.duplicate(true))
	_process_on_hit_effects(damage_instance.on_hit_effects.duplicate(true))


func _process_on_hit_damages(on_hit_damages : Dictionary):
	for on_hit_key in on_hit_damages.keys():
		var on_hit_damage : OnHitDamage = on_hit_damages[on_hit_key]
		if on_hit_damage.damage_as_modifier is FlatModifier:
			_process_flat_damage(on_hit_damage.damage_as_modifier, on_hit_damage.damage_type)
		elif on_hit_damage.damage_as_modifier is PercentModifier:
			_process_percent_damage(on_hit_damage.damage_as_modifier, on_hit_damage.damage_type)

func _process_percent_damage(damage_as_modifier: PercentModifier, damage_type : int):
	var percent_type = damage_as_modifier.percent_based_on
	var damage_as_flat : float
	
	if percent_type == PercentType.MAX:
		damage_as_flat = damage_as_modifier.get_modification_to_value(calculate_max_health())
	elif percent_type == PercentType.BASE:
		damage_as_flat = damage_as_modifier.get_modification_to_value(base_health)
	elif percent_type == PercentType.CURRENT:
		damage_as_flat = damage_as_modifier.get_modification_to_value(current_health)
	elif percent_type == PercentType.MISSING:
		var missing_health = calculate_max_health() - current_health
		if missing_health < 0:
			missing_health = 0
		damage_as_flat = damage_as_modifier.get_modification_to_value(missing_health)
	
	_process_direct_damage_and_type(damage_as_flat, damage_type)

func _process_flat_damage(damage_as_modifier : FlatModifier, damage_type : int):
	_process_direct_damage_and_type(damage_as_modifier.flat_modifier, damage_type)

func _process_direct_damage_and_type(damage : float, damage_type : int):
	var final_damage = damage
	if damage_type == DamageType.ELEMENTAL:
		final_damage *= _calculate_multiplier_from_total_toughness()
		final_damage *= _calculate_multiplier_from_total_resistance()
		
	elif damage_type == DamageType.PHYSICAL:
		final_damage *= _calculate_multiplier_from_total_armor()
		final_damage *= _calculate_multiplier_from_total_resistance()
		
	elif damage_type == DamageType.PURE:
		final_damage *= 1

	_take_unmitigated_damage(final_damage)

func _calculate_multiplier_from_total_armor() -> float:
	var total_armor = calculate_final_armor()
	if total_armor >= 0:
		return 20 / (20 + total_armor)
	else:
		return 2 - (20 / (20 - total_armor))

func _calculate_multiplier_from_total_toughness():
	var total_toughness = calculate_final_toughness()
	if total_toughness >= 0:
		return 20 / (20 + total_toughness)
	else:
		return 2 - (20 / (20 - total_toughness))

func _calculate_multiplier_from_total_resistance():
	return (100 - calculate_final_resistance()) / 100

#Process effects
func _process_on_hit_effects(on_hit_effects):
	#TODO do this afterwards
	pass


# Coll

func _on_CollisionArea_body_entered(body):
	if body is BaseBullet:
		hit_by_bullet(body)

func get_enemy_parent():
	return self
