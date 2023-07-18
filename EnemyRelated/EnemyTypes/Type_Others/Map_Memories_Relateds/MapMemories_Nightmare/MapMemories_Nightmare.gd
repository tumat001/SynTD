extends "res://EnemyRelated/AbstractEnemy.gd"

signal reached_near_end_or_at_end(arg_self)


var offset_to_trigger_reached_near_end : float


var already_reached_end_once : bool = false setget set_already_reached_end_once


var _stem_life__position__E : Vector2
var _stem_life__position__W : Vector2

#

onready var stem_life_sprite = $SpriteLayer/KnockUpLayer/StemLife

#

func _init():
	can_cause_player_damage = false
	can_cause_round_lose = false
	
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.MAP_MEMORIES__NIGHTMARE))

#

func configure_nightmare_properties(arg_offset_to_trigger_reached_near_end):
	offset_to_trigger_reached_near_end = arg_offset_to_trigger_reached_near_end


##

func _ready():
	exits_when_at_map_end_clauses.attempt_insert_clause(ExitsWhenAtEndClauseIds.MAP_MEMORIES__NIGHTMARE)
	
	connect("attempted_exit_map_but_prevented_by_clause", self, "_on_attempted_exit_map_but_prevented_by_clause_m")
	connect("moved__from_process", self, "_on_moved_from_process_m")
	
	connect("anim_name_used_changed", self, "_on_anim_name_used_changed_n")
	
	_stem_life__position__E = stem_life_sprite.position
	_stem_life__position__W = Vector2(-_stem_life__position__E.x, _stem_life__position__E.y)


func _on_attempted_exit_map_but_prevented_by_clause_m():
	emit_signal("reached_near_end_or_at_end", self)

func _on_moved_from_process_m(arg_has_moved_from_natural_means, arg_prev_angle_dir, arg_curr_angle_dir):
	if arg_has_moved_from_natural_means:
		if distance_to_exit <= offset_to_trigger_reached_near_end:
			emit_signal("reached_near_end_or_at_end", self)
	

#

func set_already_reached_end_once(arg_val):
	already_reached_end_once = arg_val
	
	if !already_reached_end_once:
		stem_life_sprite.visible = true
		
	else:
		stem_life_sprite.visible = false
		


func _on_anim_name_used_changed_n(arg_prev_anim_name, arg_current_anim_name):
	if arg_current_anim_name == "W":
		stem_life_sprite.position = _stem_life__position__W
		stem_life_sprite.flip_h = true
		
	elif arg_current_anim_name == "E":
		stem_life_sprite.position = _stem_life__position__E
		stem_life_sprite.flip_h = false
		



