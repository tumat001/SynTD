extends "res://EnemyRelated/AbstractEnemy.gd"

const AntiMagik_BeamSuck_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Others/MapEnchant_AntiMagik/Assets/MapEnchant_AntiMagik_BeamSuck.png")
const AntiMagik_BeamSuck_Particle_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Others/MapEnchant_AntiMagik/Assets/MapEnchant_AntiMagik_BeamSuck_Particle.png")


#signal preparing_sucking()
#signal sucking_started()
#signal sucking_ended()

#

const beam_stretch_duration : float = 0.5

#

var beam_source_pos__E := Vector2(12, 5)
var beam_source_pos__W := Vector2(-12, 5)

var _is_sucking : bool
var _was_sucking_when_killed_by_dmg : bool

var _particle_sucking_timer : Timer
const sucking_delta_for_particle_show : float = 0.25

# Vars in this section are setted by the map

var map_enchant setget set_map_enchant
var beam_stretch_destination_pos : Vector2
var delta_for_suck : float
var upgrade_suck_per_detla : float

#

var _sucking_timer__for_upgrade : Timer
var _make_fade_self_particle_flipped_h : bool

#

onready var beam_stretch = $SpriteLayer/KnockUpLayer/BeamStretch

#

func set_map_enchant(arg_map):
	map_enchant = arg_map

##

func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK))

##

func _ready():
	beam_stretch.visible = false
	beam_stretch.reset()

func _on_finished_ready_prep():
	beam_source_pos__W = get_position_added_pos_and_offset_modifiers(beam_source_pos__W)
	beam_source_pos__E = get_position_added_pos_and_offset_modifiers(beam_source_pos__E)
	
	

# make sure to configure needed vars first before calling this
func configure_properties_to_behave_at_special_path():
	exits_when_at_map_end_clauses.attempt_insert_clause(ExitsWhenAtEndClauseIds.MAP_ENCHANT__SPECIAL_ENEMIES)
	connect("attempted_exit_map_but_prevented_by_clause", self, "_on_attempted_exit_map_but_prevented_by_clause__a")
	connect("relieved_from__attempted_exit_map_but_prevented_by_clause", self, "_on_relieved_from__attempted_exit_map_but_prevented_by_clause__a")
	connect("on_killed_by_damage", self, "_on_killed_by_damage_a")
	connect("on_revive_completed", self, "_on_revive_completed_a")
	
	connect("anim_name_used_changed", self, "_on_anim_name_used_changed_a")
	
	beam_stretch.connect("beam_fully_stretched", self, "_on_beam_fully_stretched_a")
	
	_particle_sucking_timer = Timer.new()
	_particle_sucking_timer.one_shot = false
	_particle_sucking_timer.connect("timeout", self, "_on_particle_sucking_timer_timeout")
	add_child(_particle_sucking_timer)
	
	
	_sucking_timer__for_upgrade = Timer.new()
	_sucking_timer__for_upgrade.one_shot = false
	_sucking_timer__for_upgrade.connect("timeout", self, "_on__sucking_timer__for_upgrade_timeout")
	add_child(_sucking_timer__for_upgrade)
	
	map_enchant.connect("current_upgrade_val_depleted_by_enemies", self, "_on_current_upgrade_val_depleted_by_enemies_a")

#

func _on_anim_name_used_changed_a(arg_prev_name, arg_curr_name):
	if arg_curr_name == "W":
		beam_stretch.position = beam_source_pos__W
		_make_fade_self_particle_flipped_h = true
		
	elif arg_curr_name == "E":
		beam_stretch.position = beam_source_pos__E
		_make_fade_self_particle_flipped_h = false
		



func _on_attempted_exit_map_but_prevented_by_clause__a():
	_prepare_suck()
	

func _on_relieved_from__attempted_exit_map_but_prevented_by_clause__a():
	_end_suck()
	

func _on_killed_by_damage_a(damage_instance_report, me):
	if _is_sucking:
		_was_sucking_when_killed_by_dmg = true
	
	_end_suck()

func _on_revive_completed_a():
	if _was_sucking_when_killed_by_dmg:
		_prepare_suck()



####

func _prepare_suck():
	if !_is_sucking:
		_is_sucking = true
		no_movement_from_self_clauses.attempt_insert_clause(NoMovementClauses.CUSTOM_CLAUSE_01)
		
		#emit_signal("preparing_sucking")
		
		#_change_animation_to_face_position(beam_stretch_destination_pos)
		#call_deferred("_change_animation_to_face_position", beam_stretch_destination_pos)
		call_deferred("_change_anim_to_do_sucking")

func _change_anim_to_do_sucking():
	_change_animation_to_face_position(beam_stretch_destination_pos)
	beam_stretch.start_stretch__V2(beam_stretch_destination_pos, beam_stretch_duration)


func _end_suck():
	if _is_sucking:
		_is_sucking = false
		no_movement_from_self_clauses.remove_clause(NoMovementClauses.CUSTOM_CLAUSE_01)
		
		beam_stretch.reset()
		_particle_sucking_timer.stop()
		_sucking_timer__for_upgrade.stop()
		
		#emit_signal("sucking_ended")


func _on_beam_fully_stretched_a():
	#emit_signal("sucking_started")
	
	_particle_sucking_timer.start(sucking_delta_for_particle_show)
	_sucking_timer__for_upgrade.start(delta_for_suck)

func _on_particle_sucking_timer_timeout():
	map_enchant.request_suck_particle_to_play(beam_stretch_destination_pos, beam_stretch.global_position)

######


func _on__sucking_timer__for_upgrade_timeout():
	map_enchant.decrease_upgrade_var_value__by_enemies(upgrade_suck_per_detla)
	


func _on_current_upgrade_val_depleted_by_enemies_a():
	map_enchant.request_anti_magik_self_fade_particle_to_play(global_position, _make_fade_self_particle_flipped_h)
	
	#
	queue_free()
	

