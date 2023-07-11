extends "res://EnemyRelated/AbstractEnemy.gd"


signal started_delay_before_dream_release(arg_pos)
signal dream_released(arg_pos, inner_circle_pos)


var _can_release_dream : bool

var _started_dream_release : bool

var unit_offset_to_release_dream : float
var delay_before_release_dream : float
var health_percent_for_release_dream : float

#

var _dream_delay_timer : Timer

onready var inner_circle_sprite = $SpriteLayer/KnockUpLayer/InnerCircle

#

func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.MAP_MEMORIES__DREAM))
	

###

func configure_dream_release_properties(arg_unit_offset, arg_delay_before_release, arg_health_for_release):
	_can_release_dream = true
	
	unit_offset_to_release_dream = arg_unit_offset
	delay_before_release_dream = arg_delay_before_release
	health_percent_for_release_dream = arg_health_for_release
	
	_dream_delay_timer = Timer.new()
	_dream_delay_timer.one_shot = true
	_dream_delay_timer.connect("timeout", self, "_on_dream_delay_timer_timeout")
	add_child(_dream_delay_timer)
	
	connect("moved__from_process", self, "_on_moved_from_process_d")
	connect("on_current_health_changed", self, "_on_current_health_changed_d")


func _on_moved_from_process_d(arg_has_moved_from_natural_means, arg_prev_angle_dir, arg_curr_angle_dir):
	if arg_has_moved_from_natural_means:
		if unit_offset >= unit_offset_to_release_dream:
			_attempt_start_delay_before_dream_release()
			

func _on_current_health_changed_d(arg_curr_health):
	if arg_curr_health / _last_calculated_max_health <= health_percent_for_release_dream:
		_attempt_start_delay_before_dream_release()
	



func _attempt_start_delay_before_dream_release():
	if !_started_dream_release and !last_calculated_no_action_from_self:
		_started_dream_release = true
		
		no_movement_from_self_clauses.attempt_insert_clause(NoMovementClauses.CUSTOM_CLAUSE_01)
		_dream_delay_timer.start(delay_before_release_dream)
		
		disconnect("moved__from_process", self, "_on_moved_from_process_d")
		disconnect("on_current_health_changed", self, "_on_current_health_changed_d")
		
		emit_signal("started_delay_before_dream_release", global_position)

func _on_dream_delay_timer_timeout():
	_release_dream()
	


func _release_dream():
	emit_signal("dream_released", global_position, inner_circle_sprite.global_position)
	
	no_movement_from_self_clauses.remove_clause(NoMovementClauses.CUSTOM_CLAUSE_01)
	
	inner_circle_sprite.visible = false

