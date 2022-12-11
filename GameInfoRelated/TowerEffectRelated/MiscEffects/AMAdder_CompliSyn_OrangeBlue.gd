extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerAttackModuleAdderEffect.gd"

const AOEAttackModule = preload("res://TowerRelated/Modules/AOEAttackModule.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")

const DamageType = preload("res://GameInfoRelated/DamageType.gd")

const Explosion_Pic01 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_OrangeBlue/OrangeBlue_Explosion/OrangeBlue_Explosion01.png")
const Explosion_Pic02 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_OrangeBlue/OrangeBlue_Explosion/OrangeBlue_Explosion02.png")
const Explosion_Pic03 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_OrangeBlue/OrangeBlue_Explosion/OrangeBlue_Explosion03.png")
const Explosion_Pic04 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_OrangeBlue/OrangeBlue_Explosion/OrangeBlue_Explosion04.png")
const Explosion_Pic05 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_OrangeBlue/OrangeBlue_Explosion/OrangeBlue_Explosion05.png")
const Explosion_Pic06 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_OrangeBlue/OrangeBlue_Explosion/OrangeBlue_Explosion06.png")
const Explosion_Pic07 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_OrangeBlue/OrangeBlue_Explosion/OrangeBlue_Explosion07.png")
const Explosion_Pic08 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_OrangeBlue/OrangeBlue_Explosion/OrangeBlue_Explosion08.png")

const OB_AttackModule_Icon = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_OrangeBlue/AMAssets/OrangeBlue_AttackModule_Icon.png")


var explosion_attack_module : AOEAttackModule


var _explosion_timer : Timer

var _explosion_base_damage : float
var base_unit_time_per_explosion : float
var explosion_scale : float
var explosion_on_hit_damage_scale : float

# When towers are overheating (100 heat)
var _explosion_cooldown_lowered_ratio : float
# When towers are overheating (100 heat)
var _explosion_buffed_dmg_ratio : float


func _init(arg_explosion_dmg : float, arg_explosion_cooldown_lowered_ratio : float, arg_overheat_dmg_scale : float).(StoreOfTowerEffectsUUID.ORANGE_BLUE_AM_ADDER):
	_explosion_base_damage = arg_explosion_dmg
	
	_explosion_cooldown_lowered_ratio = arg_explosion_cooldown_lowered_ratio
	_explosion_buffed_dmg_ratio = arg_overheat_dmg_scale


func _make_modifications_to_tower(tower):
	if explosion_attack_module == null:
		_construct_attk_module()
	
	
	if !tower.is_connected("on_round_end", self, "_on_round_end"):
		tower.connect("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_hit", [tower], CONNECT_PERSIST)
		tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)
		
		tower.add_attack_module(explosion_attack_module)
	
	if _explosion_timer == null:
		_explosion_timer = Timer.new()
		_explosion_timer.one_shot = true
		_explosion_timer.wait_time = 0.1
		CommsForBetweenScenes.ge_add_child_to_other_node_hoster(_explosion_timer)
	

func _construct_attk_module():
	explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage_scale = 1 #explosion_base_and_on_hit_damage_scale
	explosion_attack_module.base_damage = _explosion_base_damage / explosion_attack_module.base_damage_scale
	explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	explosion_attack_module.on_hit_damage_scale = explosion_on_hit_damage_scale
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = true
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = true
	explosion_attack_module.benefits_from_bonus_on_hit_effect = false
	
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Explosion_Pic01)
	sprite_frames.add_frame("default", Explosion_Pic02)
	sprite_frames.add_frame("default", Explosion_Pic03)
	sprite_frames.add_frame("default", Explosion_Pic04)
	sprite_frames.add_frame("default", Explosion_Pic05)
	sprite_frames.add_frame("default", Explosion_Pic06)
	sprite_frames.add_frame("default", Explosion_Pic07)
	sprite_frames.add_frame("default", Explosion_Pic08)
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = 3
	explosion_attack_module.duration = 0.3
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	explosion_attack_module.set_image_as_tracker_image(OB_AttackModule_Icon)


func _on_tower_main_attack_hit(enemy, damage_register_id, damage_instance, module, tower):
	if _explosion_timer.time_left <= 0:
		var explosion = explosion_attack_module.construct_aoe(enemy.global_position, enemy.global_position)
		
		if tower.heat_module != null and tower.heat_module.is_in_overheat_active:
			_explosion_timer.start(base_unit_time_per_explosion * _explosion_cooldown_lowered_ratio)
			explosion.damage_instance.scale_only_damage_by(_explosion_buffed_dmg_ratio)
		else:
			_explosion_timer.start(base_unit_time_per_explosion)
		
		#explosion.enemies_to_ignore.append(enemy)
		explosion.damage_instance.scale_only_damage_by(tower.last_calculated_final_ability_potency)
		explosion.scale *= explosion_scale
		
		explosion_attack_module.set_up_aoe__add_child_and_emit_signals(explosion)


func _on_round_end():
	if is_instance_valid(_explosion_timer):
		_explosion_timer.wait_time = 0.1
		_explosion_timer.start()


#

func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_round_end", self, "_on_round_end"):
		tower.disconnect("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_hit")
		tower.disconnect("on_round_end", self, "_on_round_end")
		tower.remove_attack_module(explosion_attack_module)
		
		explosion_attack_module.queue_free()
		explosion_attack_module = null
		
		_explosion_timer.queue_free()
		_explosion_timer = null



