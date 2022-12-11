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
const BasePic_Blue_NoHealth = preload("res://TowerRelated/Color_Yellow/Magnetizer/Magnetizer_Base_Blue_NoHealth.png")
const BasePic_Red = preload("res://TowerRelated/Color_Yellow/Magnetizer/Magnetizer_Base_Red.png")
const BasePic_Red_NoHealth = preload("res://TowerRelated/Color_Yellow/Magnetizer/Magnetizer_Base_Red_NoHealth.png")


const use_count_energy_module_on : int = 3
const use_count_energy_module_off : int = 1

const beam_position_offset_from_ball : float = 13.0 # increase to make beam go more beyond the ball

const beam_modulate : Color = Color(1, 1, 1, 0.7)

var magnet_attack_module : BulletAttackModule
var beam_attack_module : AOEAttackModule

var activated_blue_magnets : Array = []
var activated_red_magnets : Array = []

var next_magnet_type : int = MagnetizerMagnetBall.BLUE
onready var tower_base_sprite : Sprite = $TowerBase/KnockUpLayer/TowerBaseSprite

var is_energy_module_on : bool = false

var magnetize_ability : BaseAbility


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
	
	_initialize_stats_from_tower_info(info)
	
	# Magnet related
	
	var attack_module_y_shift : float = 7.0
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += attack_module_y_shift
	
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
	magnet_attack_module.position.y -= attack_module_y_shift
	
	magnet_attack_module.benefits_from_bonus_on_hit_damage = true
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 7
	
	magnet_attack_module.bullet_shape = bullet_shape
	magnet_attack_module.bullet_scene = MagnetizerMagnetBall_Scene
	
	magnet_attack_module.connect("before_bullet_is_shot", self, "_modify_magnet")
	
	magnet_attack_module.set_image_as_tracker_image(MagnetizerMagnet_AttackModule_Icon)
	
	add_attack_module(magnet_attack_module)
	
	
	# Stretched AOE 
	
	beam_attack_module = AOEAttackModule_Scene.instance()
	beam_attack_module.base_damage = 5
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
	#sprite_frames.set_animation_speed("default", 10 / 0.15)
	
	beam_attack_module.base_aoe_scene = BaseAOE_Scene
	beam_attack_module.aoe_sprite_frames = sprite_frames
	beam_attack_module.sprite_frames_only_play_once = true
	beam_attack_module.duration = 0.15#0.15
	beam_attack_module.initial_delay = 0.05 #0.10
	beam_attack_module.is_decrease_duration = true
	
	beam_attack_module.aoe_default_coll_shape = BaseAOE.BaseAOEDefaultShapes.RECTANGLE
	beam_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.STRECHED_AS_BEAM
	
	beam_attack_module.can_be_commanded_by_tower = false
	
	beam_attack_module.set_image_as_tracker_image(MagnetizerBeam_AttackModule_Icon)
	
	add_attack_module(beam_attack_module)
	
	
	
	connect("changed_anim_from_alive_to_dead", self, "_on_changed_anim_from_alive_to_dead", [], CONNECT_PERSIST)
	connect("changed_anim_from_dead_to_alive", self, "_on_changed_anim_from_dead_to_alive", [], CONNECT_PERSIST)
	
	
	_construct_and_connect_ability()
	
	_post_inherit_ready()


func _construct_and_connect_ability():
	magnetize_ability = BaseAbility.new()
	
	magnetize_ability.is_timebound = false
	
	register_ability_to_manager(magnetize_ability, false)


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
	if is_instance_valid(magnet):
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
		if !is_dead_for_the_round:
			tower_base_sprite.texture = BasePic_Red
		else:
			tower_base_sprite.texture = BasePic_Red_NoHealth
	else:
		if !is_dead_for_the_round:
			tower_base_sprite.texture = BasePic_Blue
		else:
			tower_base_sprite.texture = BasePic_Blue_NoHealth


func _on_round_end():
	._on_round_end()
	
	for blue in activated_blue_magnets:
		if is_instance_valid(blue):
			blue.queue_free()
	activated_blue_magnets.clear()
	
	for red in activated_red_magnets:
		if is_instance_valid(red):
			red.queue_free()
	activated_red_magnets.clear()

# Activation of Magnetize related

func _attempt_form_beam():
	for blue_mag in activated_blue_magnets:
		if !is_instance_valid(blue_mag) or blue_mag.is_queued_for_deletion() and blue_mag.current_uses_left <= 0:
			activated_blue_magnets.erase(blue_mag)
	
	for red_mag in activated_red_magnets:
		if !is_instance_valid(red_mag) or red_mag.is_queued_for_deletion() and red_mag.current_uses_left <= 0:
			activated_red_magnets.erase(red_mag)
	
	#
	
	if _can_form_beam():
		magnetize_ability.on_ability_before_cast_start(magnetize_ability.ON_ABILITY_CAST_NO_COOLDOWN)
		
		for blue_magnet in activated_blue_magnets:
			if is_instance_valid(blue_magnet):
				for red_magnet in activated_red_magnets:
					if is_instance_valid(red_magnet):
						_form_beam_between_points(blue_magnet.global_position, red_magnet.global_position)
						red_magnet.used_in_beam_formation()
					
					#activated_red_magnets.erase(red_magnet)
				
				blue_magnet.used_in_beam_formation()
			#activated_blue_magnets.erase(blue_magnet)
		
		magnetize_ability.on_ability_after_cast_ended(magnetize_ability.ON_ABILITY_CAST_NO_COOLDOWN)
		#activated_blue_magnets.clear()
		#activated_red_magnets.clear()

func _can_form_beam() -> bool:
	return activated_blue_magnets.size() >= 1 and activated_red_magnets.size() >= 1

func _form_beam_between_points(origin_pos : Vector2, destination_pos : Vector2):
	var shifted_origin_pos = _get_extended_position_away_from_position(origin_pos, destination_pos)
	var shifted_dest_pos = _get_extended_position_away_from_position(destination_pos, origin_pos)
	
	var aoe = beam_attack_module.construct_aoe(shifted_origin_pos, shifted_dest_pos)
	
	aoe.modulate = Color(1, 1, 1, 0.7)
	aoe.damage_instance.scale_only_damage_by(last_calculated_final_ability_potency)
	aoe.scale.y *= 1.4
	aoe.scale.x *= 1.25
	
	beam_attack_module.set_up_aoe__add_child_and_emit_signals(aoe)

func _get_extended_position_away_from_position(var base_pos : Vector2, var pos_to_expand_away_from : Vector2):
	return base_pos.move_toward(pos_to_expand_away_from, -beam_position_offset_from_ball)


#

func _on_changed_anim_from_alive_to_dead():
	set_next_magnet_type_and_update_others(next_magnet_type)  # update anim

func _on_changed_anim_from_dead_to_alive():
	set_next_magnet_type_and_update_others(next_magnet_type)  # update anim


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
