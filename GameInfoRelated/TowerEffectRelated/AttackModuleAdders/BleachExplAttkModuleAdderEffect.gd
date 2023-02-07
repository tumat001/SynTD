extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerAttackModuleAdderEffect.gd"

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")

const ArcingBaseBullet = preload("res://TowerRelated/DamageAndSpawnables/ArcingBaseBullet.gd")
const ArcingBaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/ArcingBaseBullet.tscn")
const ArcingBulletAttackModule_Scene = preload("res://TowerRelated/Modules/ArcingBulletAttackModule.tscn")
const ArcingBulletAttackModule = preload("res://TowerRelated/Modules/ArcingBulletAttackModule.gd")
const AOEAttackModule = preload("res://TowerRelated/Modules/AOEAttackModule.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")

const Bleach_BallProj = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/Bleach_BallProj.png")
const Bleach_Explosion01 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/BleachExplosion/Bleach_Explosion_01.png")
const Bleach_Explosion02 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/BleachExplosion/Bleach_Explosion_02.png")
const Bleach_Explosion03 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/BleachExplosion/Bleach_Explosion_03.png")
const Bleach_Explosion04 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/BleachExplosion/Bleach_Explosion_04.png")
const Bleach_Explosion05 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/BleachExplosion/Bleach_Explosion_05.png")
const Bleach_Explosion06 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/BleachExplosion/Bleach_Explosion_06.png")
const Bleach_Explosion07 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/BleachExplosion/Bleach_Explosion_07.png")
const Bleach_Explosion08 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/BleachExplosion/Bleach_Explosion_08.png")
const Bleach_Explosion09 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/BleachExplosion/Bleach_Explosion_09.png")
const Bleach_Explosion_AMI = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/BleachExplosion/Bleach_Explosion_AMI.png")

const Effect_Icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Bleach.png")

const base_attack_count_trigger : int = 5
const toughness_reduc : float = 1.0
const toughness_reduc_duration : float = 5.0

var explosion_base_dmg : float = 2.0
const explosion_pierce : int = 3

var _curr_num_of_attacks : int = 0

var bleach_lob_attk_module
var bleach_burst_attk_module : AOEAttackModule
var toughness_shred_effect
var tower_attached_to

func _init().(StoreOfTowerEffectsUUID.ING_BLEACH):
	effect_icon = Effect_Icon
	
	_update_description()
	
	_can_be_scaled_by_yel_vio = true


func _update_description():
	# ins
	var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
	interpreter_for_flat_on_hit.display_body = false
	
	var ins_for_flat_on_hit = []
	ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "damage", explosion_base_dmg * _current_additive_scale))
	
	interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
	# ins
	
	description = ["On the %sth main attack, shoot a projectile that explodes, dealing |0| to %s enemies and reducing %s toughness for %s seconds.%s" % [str(base_attack_count_trigger), str(explosion_pierce), str(toughness_reduc), str(toughness_reduc_duration), _generate_desc_for_persisting_total_additive_scaling(true)], [interpreter_for_flat_on_hit]]


func _construct_lob_attack_module(arg_y_shift : float):
	var proj_attack_module : ArcingBulletAttackModule = ArcingBulletAttackModule_Scene.instance()
	proj_attack_module.base_damage = 0
	proj_attack_module.base_damage_type = DamageType.ELEMENTAL
	proj_attack_module.base_attack_speed = 0
	proj_attack_module.base_attack_wind_up = 0
	proj_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	proj_attack_module.is_main_attack = false
	proj_attack_module.base_pierce = 0
	proj_attack_module.base_proj_speed = 0.3
	proj_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	proj_attack_module.on_hit_damage_scale = 0
	
	proj_attack_module.benefits_from_bonus_base_damage = false
	proj_attack_module.benefits_from_bonus_on_hit_damage = false
	proj_attack_module.benefits_from_bonus_on_hit_effect = false
	
	proj_attack_module.position.y -= arg_y_shift
	
	proj_attack_module.bullet_scene = ArcingBaseBullet_Scene
	proj_attack_module.set_texture_as_sprite_frame(Bleach_BallProj)
	
	proj_attack_module.max_height = 50
	proj_attack_module.bullet_rotation_per_second = 0
	
	proj_attack_module.connect("before_bullet_is_shot", self, "_before_bleach_ball_proj_is_shot_b", [], CONNECT_PERSIST)
	
	proj_attack_module.can_be_commanded_by_tower = false
	
	proj_attack_module.is_displayed_in_tracker = false
	
	bleach_lob_attk_module = proj_attack_module
	
	#add_attack_module(proj_attack_module)


func _construct_spell_burst_explosion(arg_y_shift_of_attk_module):
	var explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage = explosion_base_dmg
	explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	explosion_attack_module.position.y -= arg_y_shift_of_attk_module
	explosion_attack_module.base_explosion_scale = 1.5
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = false
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = false
	explosion_attack_module.benefits_from_bonus_on_hit_effect = false
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Bleach_Explosion01)
	sprite_frames.add_frame("default", Bleach_Explosion02)
	sprite_frames.add_frame("default", Bleach_Explosion03)
	sprite_frames.add_frame("default", Bleach_Explosion04)
	sprite_frames.add_frame("default", Bleach_Explosion05)
	sprite_frames.add_frame("default", Bleach_Explosion06)
	sprite_frames.add_frame("default", Bleach_Explosion07)
	sprite_frames.add_frame("default", Bleach_Explosion08)
	sprite_frames.add_frame("default", Bleach_Explosion09)
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = explosion_pierce
	explosion_attack_module.duration = 0.32
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	explosion_attack_module.set_image_as_tracker_image(Effect_Icon)
	
	bleach_burst_attk_module = explosion_attack_module
	
	#add_attack_module(explosion_attack_module)

func _construct_effect():
	var tou_mod : FlatModifier = FlatModifier.new(StoreOfEnemyEffectsUUID.ING_BLEACH_SHREAD)
	tou_mod.flat_modifier = toughness_reduc
	
	toughness_shred_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_TOUGHNESS, tou_mod, StoreOfEnemyEffectsUUID.ING_BLEACH_SHREAD)
	toughness_shred_effect.is_timebound = true
	toughness_shred_effect.time_in_seconds = toughness_reduc_duration


###

func _make_modifications_to_tower(tower):
	tower_attached_to = tower
	
	if !is_instance_valid(bleach_burst_attk_module):
		_construct_effect()
		
		_construct_lob_attack_module(0)
		_construct_spell_burst_explosion(0)
		
		tower.add_attack_module(bleach_lob_attk_module)
		tower.add_attack_module(bleach_burst_attk_module)
	
	if !tower.is_connected("on_main_attack", self, "_on_main_tower_attack"):
		tower.connect("on_main_attack", self, "_on_main_tower_attack", [], CONNECT_PERSIST)
		tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)


func _on_main_tower_attack(attack_delay, enemies, module):
	_curr_num_of_attacks += 1
	
	if _curr_num_of_attacks >= base_attack_count_trigger:
		_curr_num_of_attacks = 0
		
		if enemies.size() > 0 and is_instance_valid(enemies[0]) and !enemies[0].is_queued_for_deletion():
			_fire_ball_proj_at_enemy(enemies[0])

func _fire_ball_proj_at_enemy(arg_enemy):
	bleach_lob_attk_module.on_command_attack_enemies_and_attack_when_ready([arg_enemy])

func _before_bleach_ball_proj_is_shot_b(arg_proj):
	arg_proj.connect("on_final_location_reached", self, "_on_bleach_lob_arcing_bullet_landed", [], CONNECT_ONESHOT)

func _on_bleach_lob_arcing_bullet_landed(arg_final_location : Vector2, bullet : ArcingBaseBullet):
	var explosion = bleach_burst_attk_module.construct_aoe(arg_final_location, arg_final_location)
	explosion.damage_instance.on_hit_effects[toughness_shred_effect.effect_uuid] = toughness_shred_effect
	
	bleach_burst_attk_module.set_up_aoe__add_child_and_emit_signals(explosion)

#

func _on_round_end():
	_curr_num_of_attacks = 0

#


func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_main_attack", self, "_on_main_tower_attack"):
		tower.disconnect("on_main_attack", self, "_on_main_tower_attack")
		tower.disconnect("on_round_end", self, "_on_round_end")
	
	if is_instance_valid(bleach_lob_attk_module):
		tower.remove_attack_module(bleach_lob_attk_module)
		bleach_lob_attk_module.queue_free()
		
		tower.remove_attack_module(bleach_burst_attk_module)
		bleach_burst_attk_module.queue_free()

#

func _shallow_duplicate():
	var copy = get_script().new()
	_configure_copy_to_match_self(copy)
	
	return copy

#

# SCALING related. Used by YelVio only.
func add_additive_scaling_by_amount(arg_amount):
	.add_additive_scaling_by_amount(arg_amount)
	
	_update_description()

func _consume_current_additive_scaling_for_actual_scaling_in_stats():
	explosion_base_dmg *= _current_additive_scale
	_current_additive_scale = 1
