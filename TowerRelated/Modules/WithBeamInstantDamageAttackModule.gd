extends "res://TowerRelated/Modules/InstantDamageAttackModule.gd"

const BeamAesthetic = preload("res://MiscRelated/BeamRelated/BeamAesthetic.gd")
const BeamAestheric_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

# Used for allocation, as to avoid deleting
# and creating many of them...
var beam_to_enemy_map : Dictionary = {}
var beam_scene : PackedScene

var beam_is_timebound : bool = false
var beam_time_visible : float
var beam_texture : Texture
var beam_sprite_frames : SpriteFrames

var show_beam_at_windup : bool = false


func _process(delta):
	update_beams_state()

func update_beams_state():
	for beam in beam_to_enemy_map:
		if beam.visible:
			var enemy = beam_to_enemy_map[beam]
			
			if enemy == null:
				beam.visible = false
			else:
				beam.update_destination_position(enemy.global_position)

# Showing beam at windup or not

func _during_windup(enemy : AbstractEnemy = null):
	._during_windup(enemy)
	if show_beam_at_windup and enemy != null:
		_connect_beam_to_enemy(enemy)

func _during_windup_multiple(enemies : Array = []):
	for enemy in enemies:
		if show_beam_at_windup and enemy != null:
			_connect_beam_to_enemy(enemy)

func _attack_enemy(enemy : AbstractEnemy):
	._attack_enemy(enemy)
	
	if enemy != null and !show_beam_at_windup:
		_connect_beam_to_enemy(enemy)

# Disabling and Enabling

func disable_module():
	.disable_module()
	
	for beam in beam_to_enemy_map.keys():
		beam_to_enemy_map[beam] = null
	
	update_beams_state()

func enable_module():
	.enable_module()


#

func _connect_beam_to_enemy(enemy : AbstractEnemy):
	if !beam_is_timebound:
		for l_enemy in beam_to_enemy_map.values():
			if l_enemy == enemy:
				return
	
	var beam = _get_available_beam_instance()
	beam.visible = true
	beam.update_destination_position(enemy.position)
	beam_to_enemy_map[beam] = enemy


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
		available_beam_instance.frames = beam_sprite_frames
		available_beam_instance.playing = true
	
	add_child(available_beam_instance)
	
	return available_beam_instance
