extends "res://TowerRelated/DamageAndSpawnables/BaseBullet.gd"


var initial_enemy_to_target
var diamond_attack_module
var enemy_manager
var chaos_tower

var current_delay_before_move : float

var is_from_diamond_storm : bool


var _is_delay_over : bool


func _ready():
	
	#if !is_from_diamond_storm:
	#	set_process_internal(false)
	pass


func _process(delta):
	if is_from_diamond_storm:
		current_delay_before_move -= delta
		if current_delay_before_move < 0 and !_is_delay_over:
			_is_delay_over = true
			rotation_per_second = 0
			
			_target_towards_enemy()
			
			#set_process_internal(false)

func _target_towards_enemy():
	var enemy = _get_enemy_to_target()
	
	if is_instance_valid(enemy):
		diamond_attack_module._adjust_bullet_physics_settings(self, enemy.global_position, global_position)
		
	else:
		queue_free()


func _get_enemy_to_target():
	if is_instance_valid(initial_enemy_to_target) and !initial_enemy_to_target.is_queued_for_deletion():
		return initial_enemy_to_target
	elif is_instance_valid(diamond_attack_module.range_module) and diamond_attack_module.range_module.is_a_targetable_enemy_in_range():
		var arr = diamond_attack_module.range_module.get_targets_without_affecting_self_current_targets(1)
		if arr.size() > 0:
			return arr[0]
		else:
			pass
	
	var arr = enemy_manager.get_random_targetable_enemies(1)
	if arr.size() > 0:
		return arr[0]
	
	
	return null


##

func _move(delta):
	if _is_delay_over or !is_from_diamond_storm:
		._move(delta)
	
