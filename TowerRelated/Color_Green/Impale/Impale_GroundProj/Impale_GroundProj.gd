extends "res://MiscRelated/AttackSpriteRelated/AttackSprite.gd"

const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")


signal spike_retracted(enemy)

var enemy : AbstractEnemy setget set_enemy
var starting_position : Vector2

var retracting : bool = false
const max_y_shift : float = 13.0
var current_y_shift : float = 0

const max_idle_time : float = 2.2
var current_idle_time : float = 0

func _ready():
	global_position = starting_position
	frame = 0

func _process(delta):
	if is_instance_valid(enemy):
		if !retracting and current_y_shift < max_y_shift:
			var shift = delta * 80
			current_y_shift += shift
			enemy.global_position.y -= shift
	
	if retracting:
		if frame == 0:
			queue_free()
	
	
	if !is_instance_valid(enemy) and current_idle_time < max_idle_time:
		current_idle_time += delta
		
		if current_idle_time >= max_idle_time:
			_retract_spike(enemy)


func set_enemy(arg_enemy : AbstractEnemy):
	enemy = arg_enemy
	
	enemy.connect("effect_removed", self, "_enemy_effect_remove")
	starting_position = enemy.global_position - Vector2(0, -10)


func _enemy_effect_remove(effect, enemy):
	if is_instance_valid(enemy) and effect.effect_uuid == StoreOfEnemyEffectsUUID.IMPALE_STUN:
		_retract_spike(enemy)


func _retract_spike(enemy):
	emit_signal("spike_retracted", enemy)
	retracting = true
	play("default", true)
