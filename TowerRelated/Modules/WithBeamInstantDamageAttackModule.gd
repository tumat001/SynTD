extends "res://TowerRelated/Modules/InstantDamageAttackModule.gd"

const BeamAesthetic = preload("res://MiscRelated/BeamRelated/BeamAesthetic.gd")
const BeamAestheric_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

signal beam_connected_to_enemy(beam, enemy)
signal kill_all_spawned_beams()

# Used for allocation, as to avoid deleting
# and creating many of them...
var beam_to_enemy_map : Dictionary = {}
var beam_scene : PackedScene

var beam_is_timebound : bool = false
var beam_time_visible : float
var beam_texture : Texture
var beam_sprite_frames : SpriteFrames

var show_beam_at_windup : bool = false
var show_beam_regardless_of_state : bool = false

# internals

var _should_update_beams : bool = true
var _terminate_update_on_next : bool = false

func _process(delta):
	if !beam_is_timebound:
		update_beams_state()

func update_beams_state():
	if _should_update_beams:
		force_update_beam_state()
		
		if _terminate_update_on_next:
			_should_update_beams = false
	
	#if range_module.enemies_in_range.size() == 0:
	if range_module != null and range_module._current_enemies.size() == 0:
		_terminate_update_on_next = true
		
	else:
		_should_update_beams = true
		_terminate_update_on_next = false


func force_update_beam_state():
	for beam in beam_to_enemy_map:
		if beam.visible:
			var enemy = beam_to_enemy_map[beam]
			
			if !show_beam_regardless_of_state and (enemy == null or !range_module._current_enemies.has(enemy)):
				beam.visible = false
			else:
				if enemy != null:
					beam.update_destination_position(enemy.global_position)
				else:
					beam.visible = false



# Showing beam at windup or not

func _during_windup(enemy : AbstractEnemy = null):
	._during_windup(enemy)
	if show_beam_at_windup and enemy != null:
		_connect_beam_to_enemy(enemy)

func _during_windup_multiple(enemies : Array = []):
	._during_windup_multiple(enemies)
	
	for enemy in enemies:
		if show_beam_at_windup and enemy != null:
			_connect_beam_to_enemy(enemy)

func _attack_enemy(enemy : AbstractEnemy):
	._attack_enemy(enemy)
	
	if enemy != null and !show_beam_at_windup:
		_connect_beam_to_enemy(enemy)

# Disabling and Enabling

func disable_module(disabled_clause_id : int):
	.disable_module(disabled_clause_id)
	
	for beam in beam_to_enemy_map.keys():
		beam_to_enemy_map[beam] = null
	
	update_beams_state()

func enable_module(disabled_clause_id : int):
	.enable_module(disabled_clause_id)


#

func _connect_beam_to_enemy(enemy : AbstractEnemy):
	if !beam_is_timebound:
		for l_enemy_key in beam_to_enemy_map.keys():
			if beam_to_enemy_map[l_enemy_key] == enemy:
				l_enemy_key.visible = true  # the beam
				return
	
	var beam = _get_available_beam_instance()
	beam.frame = 0
	beam.visible = true
	beam.position = global_position
	beam.update_destination_position(enemy.position)
	beam_to_enemy_map[beam] = enemy
	
	emit_signal("beam_connected_to_enemy", beam, enemy)


# Gets available beam from beams array
# If none is found, create one, put in array, then return
func _get_available_beam_instance() -> BeamAesthetic:
	var available_beam_instance : BeamAesthetic
	for beam in beam_to_enemy_map.keys():
		if !beam.visible:
			return beam
	
	available_beam_instance = beam_scene.instance()
	available_beam_instance.time_visible = beam_time_visible
	available_beam_instance.is_timebound = beam_is_timebound
	if beam_texture != null:
		available_beam_instance.set_texture_as_default_anim(beam_texture)
	elif beam_sprite_frames != null:
		available_beam_instance.set_sprite_frames(beam_sprite_frames)
	
	available_beam_instance.position = global_position
	
	available_beam_instance.is_from_tower_attack_module = true
	available_beam_instance.attack_module_source = self
	available_beam_instance.is_blockable = (base_attack_wind_up != 0)
	
	get_tree().get_root().add_child(available_beam_instance)
	
	connect("kill_all_spawned_beams", available_beam_instance, "queue_free", [], CONNECT_ONESHOT)
	
	return available_beam_instance


#

func queue_free():
#	for beam in beam_to_enemy_map.keys():
#		beam.queue_free()
	emit_signal("kill_all_spawned_beams")
	
	.queue_free()

#

func set_parent_tower(arg_parent_tower):
	if parent_tower != null:
		parent_tower.disconnect("global_position_changed", self, "_on_tower_global_pos_changed")
	
	.set_parent_tower(arg_parent_tower)
	
	arg_parent_tower.connect("global_position_changed", self, "_on_tower_global_pos_changed", [], CONNECT_PERSIST)


func _on_tower_global_pos_changed(old_pos, new_pos):
	for beam in beam_to_enemy_map.keys():
		beam.global_position = global_position


