extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")


const BaseAOE = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.gd")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")

const MagnetizerMagnetBall_Scene = preload("res://TowerRelated/Color_Yellow/Magnetizer/MagnetizerMagnetBall.tscn")
const MagnetizerMagnetBall = preload("res://TowerRelated/Color_Yellow/Magnetizer/MagnetizerMagnetBall.gd")

const MagnetizerBeam_Pic01 = preload("res://TowerRelated/Color_Yellow/Magnetizer/MagnetizerBeam_00.png")
const MagnetizerBeam_Pic02 = preload("res://TowerRelated/Color_Yellow/Magnetizer/MagnetizerBeam_01.png")
const MagnetizerBeam_Pic03 = preload("res://TowerRelated/Color_Yellow/Magnetizer/MagnetizerBeam_02.png")
const MagnetizerBeam_Pic04 = preload("res://TowerRelated/Color_Yellow/Magnetizer/MagnetizerBeam_03.png")
const MagnetizerBeam_Pic05 = preload("res://TowerRelated/Color_Yellow/Magnetizer/MagnetizerBeam_04.png")
const MagnetizerBeam_Pic06 = preload("res://TowerRelated/Color_Yellow/Magnetizer/MagnetizerBeam_05.png")
const MagnetizerBeam_Pic07 = preload("res://TowerRelated/Color_Yellow/Magnetizer/MagnetizerBeam_06.png")
const MagnetizerBeam_Pic08 = preload("res://TowerRelated/Color_Yellow/Magnetizer/MagnetizerBeam_07.png")
const MagnetizerBeam_Pic09 = preload("res://TowerRelated/Color_Yellow/Magnetizer/MagnetizerBeam_08.png")
const MagnetizerBeam_Pic10 = preload("res://TowerRelated/Color_Yellow/Magnetizer/MagnetizerBeam_09.png")

const MagnetizerMagnet_AttackModule_Icon = preload("res://TowerRelated/Color_Yellow/Magnetizer/AMAssets/MagnetizerMagnet_AttackModule_Icon.png")
const MagnetizerBeam_AttackModule_Icon = preload("res://TowerRelated/Color_Yellow/Magnetizer/AMAssets/MagnetizerBeam_AttackModule_Icon.png")

const BasePic_Blue = preload("res://TowerRelated/Color_Yellow/Magnetizer/Magnetizer_Base_Blue.png")
const BasePic_Red = preload("res://TowerRelated/Color_Yellow/Magnetizer/Magnetizer_Base_Red.png")


const use_count_energy_module_on : int = 4
const use_count_energy_module_off : int = 1


var magnet_attack_module : BulletAttackModule
var beam_attack_module : AOEAttackModule

var activated_blue_magnets : Array = []
var activated_red_magnets : Array = []

var next_magnet_type : int = MagnetizerMagnetBall.BLUE
onready var tower_base_sprite : Sprite = $TowerBase/KnockUpLayer/TowerBaseSprite

var is_energy_module_on : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.MAGNETIZER)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	# Magnet related
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	
	magnet_attack_module = BulletAttackModule_Scene.instance()
	magnet_attack_module.base_damage = info.base_damage
	magnet_attack_module.base_damage_type = info.base_damage_type
	magnet_attack_module.base_attack_speed = info.base_attk_speed
	magnet_attack_module.base_attack_wind_up = 0
	magnet_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	magnet_attack_module.is_main_attack = true
	magnet_attack_module.base_pierce = info.base_pierce
	magnet_attack_module.base_proj_speed = 350
	magnet_attack_module.base_proj_life_distance = info.base_range
	magnet_attack_module.module_id = StoreOfAttackModuleID.MAIN
	magnet_attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	magnet_attack_module.benefits_from_bonus_on_hit_damage = false
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 7
	
	magnet_attack_module.bullet_shape = bullet_shape
	magnet_attack_module.bullet_scene = MagnetizerMagnetBall_Scene
	
	magnet_attack_module.connect("before_bullet_is_shot", self, "_modify_magnet")
	
	magnet_attack_module.set_image_as_tracker_image(MagnetizerMagnet_AttackModule_Icon)
	
	add_attack_module(magnet_attack_module)
	
	
	# Stretched AOE 
	
	beam_attack_module = AOEAttackModule_Scene.instance()
	beam_attack_module.base_damage = 7
	beam_attack_module.base_damage_type = DamageType.ELEMENTAL
	beam_attack_module.base_attack_speed = 0
	beam_attack_module.base_attack_wind_up = 0
	beam_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	beam_attack_module.is_main_attack = false
	beam_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	beam_attack_module.pierce = -1
	
	beam_attack_module.benefits_from_bonus_attack_speed = false
	
	var sprite_frames : SpriteFrames = SpriteFrames.new()
	sprite_frames.add_frame("default", MagnetizerBeam_Pic01)
	sprite_frames.add_frame("default", MagnetizerBeam_Pic02)
	sprite_frames.add_frame("default", MagnetizerBeam_Pic03)
	sprite_frames.add_frame("default", MagnetizerBeam_Pic04)
	sprite_frames.add_frame("default", MagnetizerBeam_Pic05)
	sprite_frames.add_frame("default", MagnetizerBeam_Pic06)
	sprite_frames.add_frame("default", MagnetizerBeam_Pic07)
	sprite_frames.add_frame("default", MagnetizerBeam_Pic08)
	sprite_frames.add_frame("default", MagnetizerBeam_Pic09)
	sprite_frames.add_frame("default", MagnetizerBeam_Pic10)
	
	
	beam_attack_module.base_aoe_scene = BaseAOE_Scene
	beam_attack_module.aoe_sprite_frames = sprite_frames
	beam_attack_module.sprite_frames_only_play_once = true
	beam_attack_module.duration = 0.15
	beam_attack_module.initial_delay = 0.10
	beam_attack_module.is_decrease_duration = true
	
	beam_attack_module.aoe_default_coll_shape = BaseAOE.BaseAOEDefaultShapes.RECTANGLE
	beam_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.STRECHED_AS_BEAM
	
	beam_attack_module.can_be_commanded_by_tower = false
	
	beam_attack_module.set_image_as_tracker_image(MagnetizerBeam_AttackModule_Icon)
	
	add_attack_module(beam_attack_module)
	
	_post_inherit_ready()


# Magnet related

func _modify_magnet(magnet : MagnetizerMagnetBall):
	magnet.connect("hit_an_enemy", self, "_magnet_hit_an_enemy")
	magnet.connect("on_curr_distance_expired_after_setup", self, "_magnet_curr_distance_expired_after_setup", [magnet])
	
	magnet.type = next_magnet_type
	magnet.lifetime_after_beam_formation = 0.15
	magnet.rotation_degrees = 0
	_cycle_magnet_type()
	
	if is_energy_module_on:
		magnet.current_uses_left = use_count_energy_module_on
	else:
		magnet.current_uses_left = use_count_energy_module_off
	
	magnet_attack_module.range_module.targeting_cycle_right()


func _cycle_magnet_type():
	if next_magnet_type == MagnetizerMagnetBall.BLUE:
		set_next_magnet_type_and_update_others(MagnetizerMagnetBall.RED)
	else:
		set_next_magnet_type_and_update_others(MagnetizerMagnetBall.BLUE)

func _magnet_hit_an_enemy(magnet : MagnetizerMagnetBall):
	_add_magnet_to_activated_list(magnet)
	
	_attempt_form_beam()

func _add_magnet_to_activated_list(magnet):
	if magnet != null:
		if magnet.type == MagnetizerMagnetBall.RED:
			activated_red_magnets.append(magnet)
		else:
			activated_blue_magnets.append(magnet)

func _magnet_curr_distance_expired_after_setup(magnet : MagnetizerMagnetBall):
	_add_magnet_to_activated_list(magnet)


# Round related

func _on_round_start():
	._on_round_start()
	
	set_next_magnet_type_and_update_others(MagnetizerMagnetBall.BLUE)

func set_next_magnet_type_and_update_others(type : int):
	next_magnet_type = type
	
	if next_magnet_type == MagnetizerMagnetBall.BLUE:
		tower_base_sprite.texture = BasePic_Red
	else:
		tower_base_sprite.texture = BasePic_Blue

func _on_round_end():
	._on_round_end()
	
	for blue in activated_blue_magnets:
		if blue != null:
			blue.queue_free()
	activated_blue_magnets.clear()
	
	for red in activated_red_magnets:
		if red != null:
			red.queue_free()
	activated_red_magnets.clear()

# Activation of Magnetize related

func _attempt_form_beam():
	for blue_mag in activated_blue_magnets:
		if blue_mag == null or blue_mag.is_queued_for_deletion():
			activated_blue_magnets.erase(blue_mag)
	
	for red_mag in activated_red_magnets:
		if red_mag == null or red_mag.is_queued_for_deletion():
			activated_red_magnets.erase(red_mag)
	
	#
	
	if _can_form_beam():
		for blue_magnet in activated_blue_magnets:
			if blue_magnet != null:
				for red_magnet in activated_red_magnets:
					if red_magnet != null:
						_form_beam_between_points(blue_magnet.global_position, red_magnet.global_position)
						red_magnet.used_in_beam_formation()
					
					#activated_red_magnets.erase(red_magnet)
				
				blue_magnet.used_in_beam_formation()
			#activated_blue_magnets.erase(blue_magnet)
		
		#activated_blue_magnets.clear()
		#activated_red_magnets.clear()

func _can_form_beam() -> bool:
	return activated_blue_magnets.size() >= 1 and activated_red_magnets.size() >= 1

func _form_beam_between_points(origin_pos : Vector2, destination_pos : Vector2):
	var aoe = beam_attack_module.construct_aoe(origin_pos, destination_pos)
	
	aoe.damage_instance.scale_only_damage_by(last_calculated_final_ability_potency)
	
	get_tree().get_root().add_child(aoe)


# energy module rel


func set_energy_module(module):
	.set_energy_module(module)
	
	if module != null:
		module.module_effect_descriptions = [
			#"Enemies killed by Magnetize (the beam) will drop a blue magnet at their location."
			"Magnets have %s uses for beam formation (instead of %s)" % [str(use_count_energy_module_on), str(use_count_energy_module_off)]
		]


func _module_turned_on(_first_time_per_round : bool):
	#if !beam_attack_module.is_connected("on_post_mitigation_damage_dealt", self, "_check_enemy_killed"):
	#	beam_attack_module.connect("on_post_mitigation_damage_dealt", self, "_check_enemy_killed")
	
	is_energy_module_on = true

func _module_turned_off():
	#if beam_attack_module.is_connected("on_post_mitigation_damage_dealt", self, "_check_enemy_killed"):
	#	beam_attack_module.disconnect("on_post_mitigation_damage_dealt", self, "_check_enemy_killed")
	
	is_energy_module_on = false

#
#func _check_enemy_killed(damage_report, killed, enemy, damage_register_id, module):
#	if module == beam_attack_module and killed:
#		_enemy_killed(enemy)
#
#
#func _enemy_killed(enemy):
#	var pos = enemy.global_position
#
#	var magnet = magnet_attack_module.construct_bullet(pos)
#	magnet.connect("hit_an_enemy", self, "_magnet_hit_an_enemy")
#
#	magnet.speed = 0
#	magnet.type = MagnetizerMagnetBall.BLUE
#	magnet.lifetime_after_beam_formation = 0.15
#	magnet.rotation_degrees = 0
#	magnet.global_position = pos
#
#	get_tree().get_root().add_child(magnet)
#	magnet.hit_by_enemy(enemy)
