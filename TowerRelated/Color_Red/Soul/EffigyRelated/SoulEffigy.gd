extends "res://EnemyRelated/AbstractEnemy.gd"

signal effigied_enemy_queue_freeing(enemy)
signal effigied_enemy_killed(enemy)

var effigied_enemy

var _offset_distance_inc : float

func _init():
	blocks_from_round_ending = false
	exits_when_at_map_end = false
	
	base_movement_speed = 0
	base_player_damage = 0
	
	connect("before_damage_instance_is_processed", self, "_effigy_before_dmg_instance_is_processed", [], CONNECT_DEFERRED)


func copy_enemy_stats_and_location(arg_enemy, arg_offset_distance_inc : float, curr_health_scale : float):
	copy_enemy_stats(arg_enemy, true)
	copy_enemy_location_and_offset(arg_enemy)
	respect_stage_round_health_scale = false
	
	#current_health *= curr_health_scale
	
	_set_current_health_to(arg_enemy.current_health * curr_health_scale)
	
	_offset_distance_inc = arg_offset_distance_inc
	
	
	base_movement_speed = 0
	base_player_damage = 0
	
	#base_armor -= 5
	#calculate_final_armor()
	
	effigied_enemy = arg_enemy
	effigied_enemy.connect("tree_exiting", self, "_effigied_enemy_tree_exiting")
	effigied_enemy.connect("on_killed_by_damage", self, "_effigied_enemy_killed_by_damage")

func spawn_effigy_to_map():
	enemy_manager.spawn_enemy_instance(self, enemy_manager.get_path_of_enemy(effigied_enemy))
	shift_offset(_offset_distance_inc)


#

func _ready():
	if effigied_enemy == null:
		_effigied_enemy_tree_exiting()

#

func _effigied_enemy_killed_by_damage(damage_instance_report, enemy):
	if effigied_enemy.is_connected("tree_exiting", self, "_effigied_enemy_tree_exiting"):
		effigied_enemy.disconnect("tree_exiting", self, "_effigied_enemy_tree_exiting")
	
	emit_signal("effigied_enemy_killed", enemy)

func _effigied_enemy_tree_exiting():
	emit_signal("effigied_enemy_queue_freeing", effigied_enemy)


func _effigy_before_dmg_instance_is_processed(damage_instance, me):
	if effigied_enemy != null:
		var copy = damage_instance.get_copy_scaled_by(1)
		for on_hit_dmg in copy.on_hit_damages.values():
			on_hit_dmg.damage_type = DamageType.PURE
		
		effigied_enemy.hit_by_damage_instance(damage_instance, 0, false)


