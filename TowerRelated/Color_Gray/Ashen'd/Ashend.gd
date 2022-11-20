extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const Ashend_MainProjPic_01 = preload("res://TowerRelated/Color_Gray/Ashen'd/Attks/ProjAttk/Ashend_Proj_01.png")
const Ashend_MainProjPic_02 = preload("res://TowerRelated/Color_Gray/Ashen'd/Attks/ProjAttk/Ashend_Proj_02.png")
const Ashend_MainProjPic_03 = preload("res://TowerRelated/Color_Gray/Ashen'd/Attks/ProjAttk/Ashend_Proj_03.png")
const Ashend_MainProjPic_04 = preload("res://TowerRelated/Color_Gray/Ashen'd/Attks/ProjAttk/Ashend_Proj_04.png")
const Ashend_MainProjPic_05 = preload("res://TowerRelated/Color_Gray/Ashen'd/Attks/ProjAttk/Ashend_Proj_05.png")
const Ashend_MainProjPic_06 = preload("res://TowerRelated/Color_Gray/Ashen'd/Attks/ProjAttk/Ashend_Proj_06.png")
const Ashend_EffluxWavePic = preload("res://TowerRelated/Color_Gray/Ashen'd/Attks/Ashend_WaveAttk.png")

const Ashend_EffluxAttkModuleGiverEffect = preload("res://TowerRelated/Color_Gray/Ashen'd/Effects/Ashend_EffluxAttkModuleGiver.gd")

const Smolder_StatusBarIcon = preload("res://TowerRelated/Color_Gray/Ashen'd/StatusBarIcons/Ashend_Smolder_StatusBarIcon.png")


const EnemyDmgOverTimeEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyDmgOverTimeEffect.gd")
const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")


const smolder_burn_dmg_per_instance : float = 1.0
const smolder_burn_dmg_tick_rate : float = 1.0
const smolder_burn_dmg_duration : float = 10.0


var efflux_ability : BaseAbility
var efflux_attk_module : BulletAttackModule

const efflux_wave_life_distance_ratio_to_current_range : float = 3.0
const efflux_main_attacks_count_required : int = 16
const efflux_tower_empower__base_duration : float = 15.0
const efflux_tower_empower__explosion_dmg_ratio_to_main : float = 0.25
const efflux_tower_empower__explosion_pierce : int = 3

const efflux_proj_size_scale : float = 2.5
const efflux_proj_width : float = 30.0 * efflux_proj_size_scale

var _current_main_attk_count : int
var _is_efflux_ability_ready : bool


func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.ASHEND)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	var y_shift_of_attack_module : float = 22
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += y_shift_of_attack_module
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 290#240
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= y_shift_of_attack_module
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 6
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	
	var sp = SpriteFrames.new()
	sp.add_frame("default", Ashend_MainProjPic_01)
	sp.add_frame("default", Ashend_MainProjPic_02)
	sp.add_frame("default", Ashend_MainProjPic_03)
	sp.add_frame("default", Ashend_MainProjPic_04)
	sp.add_frame("default", Ashend_MainProjPic_05)
	sp.add_frame("default", Ashend_MainProjPic_06)
	
	attack_module.bullet_sprite_frames = sp
	attack_module.bullet_play_animation = true
	
	
	add_attack_module(attack_module)
	
	#
	
	_construct_and_add_efflux_attk_module(y_shift_of_attack_module)
	
	#
	
	connect("on_main_attack_finished", self, "_on_main_attack_finished_a", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_a", [], CONNECT_PERSIST)
	
	_construct_and_register_ability()
	
	_post_inherit_ready()


func _construct_and_add_efflux_attk_module(arg_y_shift_of_attack_module):
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = 0
	attack_module.base_damage_type = DamageType.ELEMENTAL
	attack_module.base_attack_speed = 0
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = false
	attack_module.base_pierce = 1
	attack_module.base_proj_speed = 160
	#attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	attack_module.on_hit_damage_scale = 1
	attack_module.position.y -= arg_y_shift_of_attack_module
	
	attack_module.benefits_from_bonus_attack_speed = false
	attack_module.benefits_from_bonus_base_damage = false
	attack_module.benefits_from_bonus_on_hit_damage = false
	attack_module.benefits_from_bonus_on_hit_effect = true
	attack_module.benefits_from_bonus_pierce = false
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(5, efflux_proj_width / (efflux_proj_size_scale * 2))
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Ashend_EffluxWavePic)
	
	attack_module.can_be_commanded_by_tower = false
	
	#attack_module.set_image_as_tracker_image(ProbePiercing_AttackModule_Icon)
	
	efflux_attk_module = attack_module
	
	add_attack_module(attack_module)



func _post_inherit_ready():
	._post_inherit_ready()
	
	var burn_dmg : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ASHEND_BURN_EFFECT)
	burn_dmg.flat_modifier = smolder_burn_dmg_per_instance
	
	var burn_on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ASHEND_BURN_EFFECT, burn_dmg, DamageType.ELEMENTAL)
	var burn_dmg_instance = DamageInstance.new()
	burn_dmg_instance.on_hit_damages[burn_on_hit.internal_id] = burn_on_hit
	
	var burn_effect = EnemyDmgOverTimeEffect.new(burn_dmg_instance, StoreOfEnemyEffectsUUID.ASHEND_BURN_EFFECT, smolder_burn_dmg_tick_rate)
	burn_effect.is_timebound = true
	burn_effect.time_in_seconds = smolder_burn_dmg_duration
	burn_effect.effect_source_ref = self
	burn_effect.status_bar_icon = Smolder_StatusBarIcon
	
	var tower_effect = TowerOnHitEffectAdderEffect.new(burn_effect, StoreOfTowerEffectsUUID.ASHEND_BURN_EFFECT)
	
	add_tower_effect(tower_effect)

##


func _construct_and_register_ability():
	efflux_ability = BaseAbility.new()
	
	efflux_ability.is_timebound = true
	
	efflux_ability.set_properties_to_usual_tower_based()
	efflux_ability.tower = self
	
	efflux_ability.connect("updated_is_ready_for_activation", self, "_on_efflux_ability_updated_ready_for_activation", [], CONNECT_PERSIST)
	register_ability_to_manager(efflux_ability, false)
	



func _on_main_attack_finished_a(arg_module):
	_current_main_attk_count += 1
	
	_attempt_cast_efflux()

func _on_efflux_ability_updated_ready_for_activation(arg_is_ready : bool):
	_is_efflux_ability_ready = arg_is_ready
	
	_attempt_cast_efflux()


func _attempt_cast_efflux():
	if _is_efflux_ability_ready and _current_main_attk_count >= efflux_main_attacks_count_required:
		_cast_efflux()


func _cast_efflux():
	_current_main_attk_count = 0
	
	efflux_ability.on_ability_before_cast_start(BaseAbility.ON_ABILITY_CAST_NO_COOLDOWN)
	_construct_and_add_efflux_wave()
	
	efflux_ability.on_ability_after_cast_ended(BaseAbility.ON_ABILITY_CAST_NO_COOLDOWN)


#


func _construct_and_add_efflux_wave():
	var life_distance_of_wave = get_last_calculated_range_of_main_attk_module() * efflux_wave_life_distance_ratio_to_current_range
	
	var all_targetable_enemies = game_elements.enemy_manager.get_all_targetable_enemies()
	var targeting_line_params = Targeting.LineTargetParameters.new()
	targeting_line_params.line_width = efflux_proj_width
	targeting_line_params.line_width_reduction_forgiveness = efflux_proj_width / 3
	targeting_line_params.line_range = life_distance_of_wave
	targeting_line_params.target_positions = _get_poses_of_enemies(all_targetable_enemies)
	targeting_line_params.source_position = efflux_attk_module.global_position
	
	var deg_angle_and_hit_count_arr = Targeting.get_deg_angle_and_enemy_hit_count__that_hits_most_enemies(targeting_line_params)
	
	if deg_angle_and_hit_count_arr.size() > 0:
		var target_pos = Targeting.convert_deg_angle_to_pos_to_target(deg_angle_and_hit_count_arr, life_distance_of_wave, efflux_attk_module.global_position)  #_convert_deg_angle_to_pos_to_target(deg_angle_and_hit_count_arr, life_distance_of_wave)
		
		#
		var efflux_wave = efflux_attk_module.construct_bullet(target_pos)
		
		
		efflux_wave.can_hit_towers = true
		efflux_wave.connect("hit_a_tower", self, "_on_efflux_wave_hit_tower")
		efflux_wave.life_distance = life_distance_of_wave
		efflux_wave.decrease_pierce = false
		efflux_wave.scale *= efflux_proj_size_scale
		efflux_wave.modulate.a = 0.7
		
		efflux_attk_module.set_up_bullet__add_child_and_emit_signals(efflux_wave)
		


func _get_poses_of_enemies(arg_enemies : Array) -> Array:
	var poses = []
	
	for enemy in arg_enemies:
		poses.append(enemy.global_position)
	
	return poses

#func _convert_deg_angle_to_pos_to_target(arg_deg_angle_hit_count_arr : Array, arg_life_distance_of_wave : float):
#	if arg_deg_angle_hit_count_arr.size() > 0:
#		return efflux_attk_module.global_position + Vector2(-arg_life_distance_of_wave, 0).rotated(deg2rad(arg_deg_angle_hit_count_arr[0]))
#	else:
#		return efflux_attk_module.global_position + Vector2(-1, 0)


func _on_efflux_wave_hit_tower(arg_wave, arg_tower):
	var efflux_effect = arg_tower.get_tower_effect(StoreOfTowerEffectsUUID.ASHEND_EFFLUX_EXPLOSION_AM_GIVER)
	if efflux_effect == null:
		efflux_effect = Ashend_EffluxAttkModuleGiverEffect.new()
		
		efflux_effect.explosion_pierce = efflux_tower_empower__explosion_pierce
		
		efflux_effect.is_roundbound = true
		efflux_effect.round_count = 1
		
		arg_tower.add_tower_effect(efflux_effect)
	
	efflux_effect.explosion_dmg_ratio_from_main = efflux_tower_empower__explosion_dmg_ratio_to_main * efflux_ability.get_potency_to_use(last_calculated_final_ability_potency)
	efflux_effect.on_buff_refreshed(efflux_tower_empower__base_duration)
	

#

func _on_round_end_a():
	_current_main_attk_count = 0

