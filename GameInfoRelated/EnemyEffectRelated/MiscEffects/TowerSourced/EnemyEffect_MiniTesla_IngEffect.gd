extends "res://GameInfoRelated/EnemyEffectRelated/BaseEnemyModifyingEffect.gd"

const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")


var full_stun_duration : float
var sub_stun_duration : float

var stack_count_trigger_for_stun : int
var _current_stack_count : int = 1 #0

var number_of_full_duration_apply_limit : int
var _current_num_of_full_duration_application : int = 0

#

var _enemy

func _init().(StoreOfEnemyEffectsUUID.ING_MINI_TESLA_ENEMY_STACK_TRACKER):
	pass

##

func _make_modifications_to_enemy(enemy):
	_enemy = enemy


func _undo_modifications_to_enemy(enemy):
	pass

##

func increase_stack_count(arg_count : int):
	_current_stack_count += arg_count
	
	if _current_stack_count >= stack_count_trigger_for_stun:
		_current_stack_count = 0
		
		if is_instance_valid(_enemy):
			var stun_duration = full_stun_duration
			if _current_num_of_full_duration_application >= number_of_full_duration_apply_limit:
				stun_duration = sub_stun_duration
			
			var stun_effect = EnemyStunEffect.new(stun_duration, StoreOfEnemyEffectsUUID.ING_MINI_TESLA_ENEMY_STUN)
			
			_enemy._add_effect(stun_effect)
		
		_current_num_of_full_duration_application += 1


