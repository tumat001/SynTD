extends "res://EnemyRelated/AbstractEnemy.gd"

var deity
var _deity_summon_timer : Timer

var _self_mov_speed_add_remove_delay : float
var _mov_speed_delay_rng : RandomNumberGenerator
var _mov_delay_timer : Timer
const _mov_delay_max_time : float = 8.0
const _mov_delay_min_time : float = 1.0

var is_in_range_of_deity : bool = false
var is_deity_done_summoning : bool = false

var _slow_effect
var _speed_effect


func _ready():
	pass

#func _construct_effects_afe():
#	pass

#

func on_self_enter_deity_range(deity):
	is_in_range_of_deity = true
	
	_start_mov_decision_delay_timer()


func on_self_leave_deity_range(deity):
	is_in_range_of_deity = false
	
	_start_mov_decision_delay_timer(0.2)


func _start_mov_decision_delay_timer(arg_delay_scale : float = 1.0):
	if _mov_delay_timer.is_inside_tree():
		_mov_delay_timer.start(_self_mov_speed_add_remove_delay * arg_delay_scale)


func _on_mov_delay_decison_timer_timeout():
	_decide_mov_speed_to_give()


func _decide_mov_speed_to_give():
	if is_in_range_of_deity:
		_add_effect(_slow_effect)
		if percent_movement_speed_id_effect_map.has(_speed_effect.effect_uuid):
			_remove_effect(_speed_effect)
		
	elif is_instance_valid(deity) and deity.unit_offset > unit_offset:
		_add_effect(_speed_effect)
		if percent_movement_speed_id_effect_map.has(_slow_effect.effect_uuid):
			_remove_effect(_slow_effect)
		
		
	else:
		_remove_all_mov_related_effects()

func _remove_all_mov_related_effects():
	if percent_movement_speed_id_effect_map.has(_slow_effect.effect_uuid):
		_remove_effect(_slow_effect)
	
	if percent_movement_speed_id_effect_map.has(_speed_effect.effect_uuid):
		_remove_effect(_speed_effect)

#


func on_deity_being_summoned(summon_time, stun_effect, arg_deity):
	_add_effect(stun_effect)
	
	set_deity_in_round(arg_deity)


func set_deity_in_round(arg_deity):
	deity = arg_deity
	
	_mov_speed_delay_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.FAITHFUL_MOV_SPEED_DELAY)
	_self_mov_speed_add_remove_delay = _mov_speed_delay_rng.randf_range(_mov_delay_min_time, _mov_delay_max_time)
	
	_mov_delay_timer = Timer.new()
	_mov_delay_timer.one_shot = true
	add_child(_mov_delay_timer)
	_mov_delay_timer.connect("timeout", self, "_on_mov_delay_decison_timer_timeout")
	
	
	_start_mov_decision_delay_timer()


func on_deity_summoning_finished():
	pass



#

func on_deity_killed_with_no_revives():
	pass
	

func on_deity_escaped_map():
	pass
	

func on_deity_tree_exiting():
	is_in_range_of_deity = false
	
	_remove_all_mov_related_effects()
