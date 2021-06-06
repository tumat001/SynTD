extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
const BeamAesthetic = preload("res://MiscRelated/BeamRelated/BeamAesthetic.gd")

const _704_Beam01 = preload("res://TowerRelated/Color_Orange/704/704_Beam/704_Beam01.png")
const _704_Beam02 = preload("res://TowerRelated/Color_Orange/704/704_Beam/704_Beam02.png")
const _704_Beam03 = preload("res://TowerRelated/Color_Orange/704/704_Beam/704_Beam03.png")
const _704_Beam04 = preload("res://TowerRelated/Color_Orange/704/704_Beam/704_Beam04.png")
const _704_Beam05 = preload("res://TowerRelated/Color_Orange/704/704_Beam/704_Beam05.png")
const _704_Beam06 = preload("res://TowerRelated/Color_Orange/704/704_Beam/704_Beam06.png")
const _704_Beam07 = preload("res://TowerRelated/Color_Orange/704/704_Beam/704_Beam07.png")
const _704_Beam08 = preload("res://TowerRelated/Color_Orange/704/704_Beam/704_Beam08.png")

const _704_Explosion01 = preload("res://TowerRelated/Color_Orange/704/704_Explosion/704_Explosion01.png")
const _704_Explosion02 = preload("res://TowerRelated/Color_Orange/704/704_Explosion/704_Explosion02.png")
const _704_Explosion03 = preload("res://TowerRelated/Color_Orange/704/704_Explosion/704_Explosion03.png")
const _704_Explosion04 = preload("res://TowerRelated/Color_Orange/704/704_Explosion/704_Explosion04.png")
const _704_Explosion05 = preload("res://TowerRelated/Color_Orange/704/704_Explosion/704_Explosion05.png")
const _704_Explosion06 = preload("res://TowerRelated/Color_Orange/704/704_Explosion/704_Explosion06.png")
const _704_Explosion07 = preload("res://TowerRelated/Color_Orange/704/704_Explosion/704_Explosion07.png")

var available_points : int = 4
var emblem_fire_points : int = 0
var emblem_explosive_points : int = 0
var emblem_toughness_pierce_points : int = 0


var sky_attack_module : InstantDamageAttackModule
var sky_attack_sprite_frames : SpriteFrames
var sky_attack_beams_enemy_map : Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers._704)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	range_module.position.y += 3
	
	var attack_module : InstantDamageAttackModule = InstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 4
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 3
	attack_module.base_on_hit_damage_internal_name = "704_base_damage"
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.commit_to_targets_of_windup = true
	attack_module.fill_empty_windup_target_slots = false
	
	sky_attack_module = attack_module
	
	attack_module.connect("in_attack_windup", self, "_on_704_attack_windup")
	
	add_attack_module(attack_module)
	
	
	# sprite frames
	
	sky_attack_sprite_frames = SpriteFrames.new()
	sky_attack_sprite_frames.add_frame("default", _704_Beam01)
	sky_attack_sprite_frames.add_frame("default", _704_Beam02)
	sky_attack_sprite_frames.add_frame("default", _704_Beam03)
	sky_attack_sprite_frames.add_frame("default", _704_Beam04)
	sky_attack_sprite_frames.add_frame("default", _704_Beam05)
	sky_attack_sprite_frames.add_frame("default", _704_Beam06)
	sky_attack_sprite_frames.add_frame("default", _704_Beam07)
	sky_attack_sprite_frames.add_frame("default", _704_Beam08)
	
	_post_inherit_ready()


func _on_704_attack_windup(windup_time : float, enemies : Array):
	var available_beams = _get_available_beams()
	var enemies_count : float = enemies.size()
	var beam_count : float = available_beams.size()
	
	if enemies_count > beam_count:
		for i in range(0, enemies_count - beam_count):
			_construct_sky_beam()
	
	if enemies_count > 0:
		available_beams = _get_available_beams()
		for i in enemies.size():
			var beam = available_beams[i]
			sky_attack_beams_enemy_map[beam] = enemies[i]
			
			beam.connect("time_visible_is_over", self, "_beam_in_sky", [beam, windup_time], CONNECT_ONESHOT)
			
			beam.frames.set_animation_speed("default", 8 / (windup_time / 2))
			beam.frame = 0
			beam.play("default", false)
			
			beam.time_visible = windup_time / 2
			beam.visible = true
			beam.global_position = global_position
			beam.update_destination_position(Vector2(global_position.x, global_position.y - 100))


func _beam_in_sky(beam : BeamAesthetic, windup_time : float):
	var enemy = sky_attack_beams_enemy_map[beam]
	if enemy != null:
		var enemy_pos = enemy.global_position
		
		beam.time_visible = windup_time / 2
		beam.frames.set_animation_speed("default", 8 / (windup_time / 2))
		beam.frame = 8
		beam.play("default", true)
		
		beam.visible = true
		#beam.global_position = Vector2(enemy_pos.x, enemy_pos.y - 300)
		#beam.update_destination_position(enemy_pos)
		beam.global_position = enemy_pos
		beam.update_destination_position(Vector2(enemy_pos.x, enemy_pos.y - 100))


func _get_available_beams():
	var bucket : Array = []
	for beam in sky_attack_beams_enemy_map.keys():
		if !beam.visible:
			bucket.append(beam)
	
	return bucket


func _construct_sky_beam():
	var beam : BeamAesthetic = BeamAesthetic_Scene.instance()
	beam.is_timebound = true
	beam.visible = false
	
	beam.set_sprite_frames(sky_attack_sprite_frames)
	beam.frames.set_animation_loop("default", false)
	
	get_tree().get_root().add_child(beam)
	
	sky_attack_beams_enemy_map[beam] = null

