extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"


# For Green towers

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const EnemyStackEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStackEffect.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")

#const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
#const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
#const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
#const BeamAesthetic = preload("res://MiscRelated/BeamRelated/BeamAesthetic.gd")

const TantrumBeam_01 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/Red_Tantrum/RedTantrum_01.png")
const TantrumBeam_02 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/Red_Tantrum/RedTantrum_02.png")
const TantrumBeam_03 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/Red_Tantrum/RedTantrum_03.png")
const TantrumBeam_04 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/Red_Tantrum/RedTantrum_04.png")
const TantrumBeam_05 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/Red_Tantrum/RedTantrum_05.png")
const TantrumBeam_06 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/Red_Tantrum/RedTantrum_06.png")
const TantrumBeam_07 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/Red_Tantrum/RedTantrum_07.png")
const TantrumBeam_08 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/Red_Tantrum/RedTantrum_08.png")
const TantrumBeam_09 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/Red_Tantrum/RedTantrum_09.png")
const TantrumBeam_10 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/Red_Tantrum/RedTantrum_10.png")
const TantrumBeam_11 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/Red_Tantrum/RedTantrum_11.png")
const TantrumBeam_12 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/Red_Tantrum/RedTantrum_12.png")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const BulletAttackModule = preload("res://TowerRelated/Modules/BulletAttackModule.gd")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const TantrumBullet_Pic = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/Red_Tantrum/RedTantrum_Bullet.png")

const GreenStack_Pic_01 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/GreenStack/GreenStack_02.png")
const GreenStack_Pic_02 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/GreenStack/GreenStack_03.png")

const RedGreenTantrum_AttackModule_Icon = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/AMAssets/RedGreenTantrum_AttackModule_Icon.png")


var stack_per_attack_against_normal_enemies : int

var damage_per_stack : float
var damage_per_bolt : float

var base_bolt_amount : int
var bolt_per_stack_ratio : float

var tantrum_trigger_amount : int
var pulse_trigger_amount : int

var green_stack_effect : EnemyStackEffect
var green_stack_effect_id : int
var red_stack_effect_id : int


var tantrum_attack_module : BulletAttackModule


func _init(arg_dmg_per_stack : float, arg_dmg_per_bolt : float,
		arg_base_bolt_amount : int, arg_bolt_per_stack_ratio : float,
		arg_tantrum_trigger_amount : int, arg_pulse_trigger_amount).(StoreOfTowerEffectsUUID.RED_GREEN_RED_DETONATE_SIDE_EFFECT_GIVER):
	
	damage_per_stack = arg_dmg_per_stack
	damage_per_bolt = arg_dmg_per_bolt
	
	base_bolt_amount = arg_base_bolt_amount
	bolt_per_stack_ratio = arg_bolt_per_stack_ratio
	
	tantrum_trigger_amount = arg_tantrum_trigger_amount
	pulse_trigger_amount = arg_pulse_trigger_amount



func _make_modifications_to_tower(tower):
	if tower._tower_colors.has(TowerColors.GREEN):
		if !tower.is_connected("on_main_attack_module_enemy_hit", self, "_on_main_attack_hit_enemy"):
			tower.connect("on_main_attack_module_enemy_hit", self, "_on_main_attack_hit_enemy", [], CONNECT_PERSIST)
		
		_construct_green_stack_effect()
		_construct_and_add_tantrum_attack_module(tower)


func _construct_green_stack_effect():
	if green_stack_effect == null:
		green_stack_effect_id = StoreOfEnemyEffectsUUID.RED_GREEN_GREEN_STACK_EFFECT
		green_stack_effect = EnemyStackEffect.new(null, 1, 99999, green_stack_effect_id)
		
		red_stack_effect_id = StoreOfEnemyEffectsUUID.RED_GREEN_RED_STACK_EFFECT

#func _construct_and_add_tantrum_attack_module(tower):
#	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
#	attack_module.base_damage = damage_per_bolt
#	attack_module.base_damage_type = DamageType.PHYSICAL
#	attack_module.base_attack_speed = 12
#	attack_module.base_attack_wind_up = 1 / 0.1
#	attack_module.is_main_attack = false
#	attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
#	#attack_module.position.y -= 20
#	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
#	attack_module.on_hit_damage_scale = 0
#
#	attack_module.commit_to_targets_of_windup = true
#	attack_module.fill_empty_windup_target_slots = false
#
#	attack_module.benefits_from_bonus_attack_speed = true
#	attack_module.benefits_from_bonus_base_damage = false
#	attack_module.benefits_from_bonus_on_hit_damage = false
#	attack_module.benefits_from_bonus_on_hit_effect = false
#
#	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
#	beam_sprite_frame.add_frame("default", TantrumBeam_01)
#	beam_sprite_frame.add_frame("default", TantrumBeam_02)
#	beam_sprite_frame.add_frame("default", TantrumBeam_03)
#	beam_sprite_frame.add_frame("default", TantrumBeam_04)
#	beam_sprite_frame.add_frame("default", TantrumBeam_05)
#	beam_sprite_frame.add_frame("default", TantrumBeam_06)
#	beam_sprite_frame.add_frame("default", TantrumBeam_07)
#	beam_sprite_frame.add_frame("default", TantrumBeam_08)
#	beam_sprite_frame.add_frame("default", TantrumBeam_09)
#	beam_sprite_frame.add_frame("default", TantrumBeam_10)
#	beam_sprite_frame.add_frame("default", TantrumBeam_11)
#	beam_sprite_frame.add_frame("default", TantrumBeam_12)
#	beam_sprite_frame.set_animation_speed("default", 12 / 0.1)
#	beam_sprite_frame.set_animation_loop("default", false)
#
#	attack_module.beam_scene = BeamAesthetic_Scene
#	attack_module.beam_sprite_frames = beam_sprite_frame
#	attack_module.beam_is_timebound = true
#	attack_module.beam_time_visible = 0.1
#
#	attack_module.show_beam_at_windup = true
#	attack_module.show_beam_regardless_of_state = true
#
#	attack_module.can_be_commanded_by_tower = false
#
#
#	attack_module.use_own_targeting = true
#	attack_module.own_targeting_option = Targeting.RANDOM
#
#	attack_module.set_image_as_tracker_image(RedGreenTantrum_AttackModule_Icon)
#
#	tower.add_attack_module(attack_module)
#
#	tantrum_attack_module = attack_module


func _construct_and_add_tantrum_attack_module(tower):
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = damage_per_bolt
	attack_module.base_damage_type = DamageType.PHYSICAL
	attack_module.base_attack_speed = 10
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = false
	attack_module.base_pierce = 1
	attack_module.base_proj_speed = 400
	attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	attack_module.on_hit_damage_scale = 0
	
	attack_module.benefits_from_bonus_attack_speed = true
	attack_module.benefits_from_bonus_base_damage = false
	attack_module.benefits_from_bonus_on_hit_damage = false
	attack_module.benefits_from_bonus_on_hit_effect = false
	attack_module.benefits_from_bonus_pierce = false
	
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(6, 3)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(TantrumBullet_Pic)
	
	attack_module.can_be_commanded_by_tower = false
	
	
	attack_module.use_own_targeting = true
	attack_module.own_targeting_option = Targeting.RANDOM
	
	attack_module.set_image_as_tracker_image(RedGreenTantrum_AttackModule_Icon)
	
	tower.add_attack_module(attack_module)
	
	tantrum_attack_module = attack_module



func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_main_attack_module_enemy_hit", self, "_on_main_attack_hit_enemy"):
		tower.disconnect("on_main_attack_module_enemy_hit", self, "_on_main_attack_hit_enemy")
	
	if tower.all_attack_modules.has(tantrum_attack_module):
		tower.remove_attack_module(tantrum_attack_module)
		tantrum_attack_module.queue_free()


#

func _on_main_attack_hit_enemy(enemy, damage_register_id, damage_instance, module):
	_check_if_red_detonatable(enemy, damage_instance)
	
	if !enemy.is_connected("effect_added", self, "_effect_added_to_enemy"):
		enemy.connect("effect_added", self, "_effect_added_to_enemy")
	
	if enemy.is_enemy_type_normal():
		green_stack_effect.num_of_stacks_per_apply = stack_per_attack_against_normal_enemies
	else:
		green_stack_effect.num_of_stacks_per_apply = 1
	
	damage_instance.on_hit_effects[green_stack_effect_id] = green_stack_effect


func _check_if_red_detonatable(enemy, damage_instance):
	if enemy._stack_id_effects_map.has(red_stack_effect_id):
		var stack_amount = enemy._stack_id_effects_map[red_stack_effect_id]._current_stack
		
		_add_damage_detonation_to_damage_instance(stack_amount, damage_instance)
		
		if stack_amount >= tantrum_trigger_amount:
			_execute_tantrum(stack_amount)
		
		enemy._remove_effect(enemy._stack_id_effects_map[red_stack_effect_id])
		enemy.statusbar.remove_status_icon(red_stack_effect_id)


func _add_damage_detonation_to_damage_instance(stack_amount, damage_instance):
	var dmg_amount : float = damage_per_stack * stack_amount
	var dmg_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.RED_GREEN_RED_DETONATE_DAMAGE)
	var on_hit_dmg : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.RED_GREEN_RED_DETONATE_DAMAGE, dmg_modi, DamageType.PHYSICAL)
	
	damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.RED_GREEN_RED_DETONATE_DAMAGE] = on_hit_dmg


func _execute_tantrum(stack_amount : int):
	var attack_count = _get_attack_amount_from_stack_amount(stack_amount)
	
	tantrum_attack_module.on_command_attack_enemies_in_range_and_attack_when_ready(1, attack_count)


func _get_attack_amount_from_stack_amount(stack_amount : int) -> int:
	return base_bolt_amount + int(round(stack_amount * bolt_per_stack_ratio))


#

func _effect_added_to_enemy(effect, enemy):
	if effect.effect_uuid == green_stack_effect_id:
		effect = enemy._stack_id_effects_map[green_stack_effect_id]
		
		var effect_curr_stack = effect._current_stack
		
		if effect_curr_stack >= pulse_trigger_amount:
			enemy.statusbar.add_status_icon(green_stack_effect_id, GreenStack_Pic_02)
		elif effect_curr_stack > 0:
			enemy.statusbar.add_status_icon(green_stack_effect_id, GreenStack_Pic_01)
		
		if enemy.is_connected("effect_added", self, "_effect_added_to_enemy"):
			enemy.disconnect("effect_added", self, "_effect_added_to_enemy")


