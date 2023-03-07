extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")


const Impede_BeamPic_01 = preload("res://TowerRelated/Color_Violet/Impede/Assets/BeamAssets/Impede_Beam01.png")
const Impede_BeamPic_02 = preload("res://TowerRelated/Color_Violet/Impede/Assets/BeamAssets/Impede_Beam02.png")
const Impede_BeamPic_03 = preload("res://TowerRelated/Color_Violet/Impede/Assets/BeamAssets/Impede_Beam03.png")
const Impede_BeamPic_04 = preload("res://TowerRelated/Color_Violet/Impede/Assets/BeamAssets/Impede_Beam04.png")
const Impede_BeamPic_05 = preload("res://TowerRelated/Color_Violet/Impede/Assets/BeamAssets/Impede_Beam05.png")
const Impede_BeamPic_06 = preload("res://TowerRelated/Color_Violet/Impede/Assets/BeamAssets/Impede_Beam06.png")
const Impede_BeamPic_07 = preload("res://TowerRelated/Color_Violet/Impede/Assets/BeamAssets/Impede_Beam07.png")
const Impede_BeamPic_08 = preload("res://TowerRelated/Color_Violet/Impede/Assets/BeamAssets/Impede_Beam08.png")
const Impede_BeamPic_09 = preload("res://TowerRelated/Color_Violet/Impede/Assets/BeamAssets/Impede_Beam09.png")
const Impede_BeamPic_10 = preload("res://TowerRelated/Color_Violet/Impede/Assets/BeamAssets/Impede_Beam10.png")
const Impede_BeamPic_11 = preload("res://TowerRelated/Color_Violet/Impede/Assets/BeamAssets/Impede_Beam11.png")
const Impede_BeamPic_12 = preload("res://TowerRelated/Color_Violet/Impede/Assets/BeamAssets/Impede_Beam12.png")
const Impede_BeamPic_13 = preload("res://TowerRelated/Color_Violet/Impede/Assets/BeamAssets/Impede_Beam13.png")

const Shader_Grayscale = preload("res://MiscRelated/ShadersRelated/Shader_Grayscale.shader")

####

const stone_base_duration : float = 4.0
const stone_bonus_duration_per_1_ap : float = 3.0

var stone_aoe_attack_module : AOEAttackModule

var stoned_ability : BaseAbility


var _enemy_to_stone_entered_count_map : Dictionary

var shader_material_of_aoe : ShaderMaterial
 
###

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.IMPEDE)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += 29
	
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 1 / 0.20
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 29
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.commit_to_targets_of_windup = true
	attack_module.fill_empty_windup_target_slots = false
	attack_module.show_beam_at_windup = true
	attack_module.show_beam_regardless_of_state = true
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Impede_BeamPic_01)
	beam_sprite_frame.add_frame("default", Impede_BeamPic_02)
	beam_sprite_frame.add_frame("default", Impede_BeamPic_03)
	beam_sprite_frame.add_frame("default", Impede_BeamPic_04)
	beam_sprite_frame.add_frame("default", Impede_BeamPic_05)
	beam_sprite_frame.add_frame("default", Impede_BeamPic_06)
	beam_sprite_frame.add_frame("default", Impede_BeamPic_07)
	beam_sprite_frame.add_frame("default", Impede_BeamPic_08)
	beam_sprite_frame.add_frame("default", Impede_BeamPic_09)
	beam_sprite_frame.add_frame("default", Impede_BeamPic_10)
	beam_sprite_frame.add_frame("default", Impede_BeamPic_11)
	beam_sprite_frame.add_frame("default", Impede_BeamPic_12)
	beam_sprite_frame.add_frame("default", Impede_BeamPic_13)
	beam_sprite_frame.set_animation_loop("default", false)
	beam_sprite_frame.set_animation_speed("default", 13 / 0.20)
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	attack_module.always_update_beam_state_at_process = true
	attack_module.beam_is_timebound = true
	attack_module.beam_time_visible = 0.20
	
	add_attack_module(attack_module)
	
	#
	
	shader_material_of_aoe = ShaderMaterial.new()
	shader_material_of_aoe.shader = Shader_Grayscale
	
	#
	
	_construct_and_add_stone_aoe_attk_module()
	_construct_and_register_ability()
	
	#####
	
	connect("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigation_damage_dealt_i", [], CONNECT_PERSIST)
	
	###
	
	_post_inherit_ready()

func _construct_and_register_ability():
	stoned_ability = BaseAbility.new()
	
	stoned_ability.is_timebound = false
	
	stoned_ability.set_properties_to_usual_tower_based()
	stoned_ability.tower = self
	
	register_ability_to_manager(stoned_ability, false)
	

func _construct_and_add_stone_aoe_attk_module():
	stone_aoe_attack_module = AOEAttackModule_Scene.instance()
	stone_aoe_attack_module.base_damage = 0
	stone_aoe_attack_module.base_damage_type = DamageType.ELEMENTAL
	stone_aoe_attack_module.base_attack_speed = 0
	stone_aoe_attack_module.base_attack_wind_up = 0
	stone_aoe_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	stone_aoe_attack_module.is_main_attack = false
	stone_aoe_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	stone_aoe_attack_module.base_explosion_scale = 01
	
	stone_aoe_attack_module.benefits_from_bonus_explosion_scale = false
	stone_aoe_attack_module.benefits_from_bonus_base_damage = false
	stone_aoe_attack_module.benefits_from_bonus_attack_speed = false
	stone_aoe_attack_module.benefits_from_bonus_on_hit_damage = false
	stone_aoe_attack_module.benefits_from_bonus_on_hit_effect = false
	stone_aoe_attack_module.benefits_from_any_effect = false
	
	#var sprite_frames = SpriteFrames.new()
	
	#stone_aoe_attack_module.aoe_sprite_frames = sprite_frames
	#stone_aoe_attack_module.sprite_frames_only_play_once = true
	stone_aoe_attack_module.pierce = -1
	stone_aoe_attack_module.duration = 1
	stone_aoe_attack_module.damage_repeat_count = 1
	
	stone_aoe_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.RECTANGLE
	stone_aoe_attack_module.base_aoe_scene = BaseAOE_Scene
	stone_aoe_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	stone_aoe_attack_module.can_be_commanded_by_tower = false
	
	stone_aoe_attack_module.is_displayed_in_tracker = false
	
	stone_aoe_attack_module.kill_all_created_aoe_at_round_end = false
	stone_aoe_attack_module.pause_decrease_duration_of_aoe_at_round_end = true
	stone_aoe_attack_module.unpause_decrease_duration_of_aoe_at_round_start = true
	
	
	add_attack_module(stone_aoe_attack_module)


func _on_any_post_mitigation_damage_dealt_i(damage_instance_report, killed, enemy, damage_register_id, module):
	if killed:
		var cd = BaseAbility.ABILITY_MINIMUM_COOLDOWN
		stoned_ability.on_ability_before_cast_start(cd)
		
		_create_stone_aoe_based_on_enemy(enemy)
		
		stoned_ability.on_ability_after_cast_ended(cd)
	


func _create_stone_aoe_based_on_enemy(enemy):
	var enemy_curr_texture = enemy.get_current_texture_of_anim()
	var pos = enemy.global_position + enemy.get_offset_modifiers()
	
	var aoe = stone_aoe_attack_module.construct_aoe(pos, pos)
	aoe.aoe_texture = enemy_curr_texture
	aoe.material = shader_material_of_aoe
	aoe.duration = stone_base_duration + (stone_bonus_duration_per_1_ap * stoned_ability.get_potency_to_use(get_bonus_ability_potency()))
	aoe.duration_decrease_based_on_amount_of_enmeies_collided = true
	
	aoe.connect("enemy_entered", self, "_on_stone_aoe_enemy_entered", [enemy.distance_to_exit])
	aoe.connect("enemy_exited", self, "_on_stone_aoe_enemy_exited")
	
	stone_aoe_attack_module.set_up_aoe__add_child_and_emit_signals(aoe)


##

func _on_stone_aoe_enemy_entered(arg_enemy, arg_distance_to_exit):
	if arg_enemy.distance_to_exit > arg_distance_to_exit:
		if !_enemy_to_stone_entered_count_map.has(arg_enemy):
			_enemy_to_stone_entered_count_map[arg_enemy] = 1
		else:
			_enemy_to_stone_entered_count_map[arg_enemy] += 1
		
		arg_enemy.no_movement_from_self_clauses.attempt_insert_clause(arg_enemy.NoMovementClauses.IMPEDE_STONE_STOP_MOV)

func _on_stone_aoe_enemy_exited(arg_enemy):
	if _enemy_to_stone_entered_count_map.has(arg_enemy):
		_enemy_to_stone_entered_count_map[arg_enemy] -= 1
		if _enemy_to_stone_entered_count_map[arg_enemy] <= 0:
			arg_enemy.no_movement_from_self_clauses.remove_clause(arg_enemy.NoMovementClauses.IMPEDE_STONE_STOP_MOV)



