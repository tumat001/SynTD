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


var explosion_attack_module : AOEAttackModule

var tower_final_attk_speed : float = 1

var _curr_unit_time_before_explosion : float = 0


var base_unit_time_per_explosion : float = 2.5
var explosion_scale : float = 1.0
var explosion_base_and_on_hit_damage_scale : float = 0.5


func _init().(StoreOfTowerEffectsUUID.ORANGE_BLUE_AM_ADDER):
	pass


func _make_modifications_to_tower(tower):
	if explosion_attack_module == null:
		_construct_attk_module()
	
	
	if !tower.is_connected("on_round_end", self, "_on_tower_round_end"):
		tower.connect("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_hit", [tower], CONNECT_PERSIST)
		tower.connect("on_round_end", self, "_on_tower_round_end", [], CONNECT_PERSIST)
		tower.connect("final_attack_speed_changed", self, "_tower_final_attk_speed_changed", [tower], CONNECT_PERSIST)
		
		tower.add_attack_module(explosion_attack_module)
		
		if tower.main_attack_module != null:
			tower_final_attk_speed = tower.main_attack_module.last_calculated_final_attk_speed


func _construct_attk_module():
	explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage_scale = explosion_base_and_on_hit_damage_scale
	explosion_attack_module.base_damage = 3 / explosion_attack_module.base_damage_scale
	explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = true
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = true
	explosion_attack_module.benefits_from_bonus_on_hit_effect = false
	
	explosion_attack_module.on_hit_damage_scale = explosion_base_and_on_hit_damage_scale
	
	
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
	explosion_attack_module.pierce = 2
	explosion_attack_module.duration = 0.3
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false


func _tower_final_attk_speed_changed(tower):
	if tower.main_attack_module != null:
		tower_final_attk_speed = tower.main_attack_module.last_calculated_final_attk_speed


func _on_tower_main_attack_hit(enemy, damage_register_id, damage_instance, module, tower):
	if tower.heat_module != null and tower.heat_module.is_in_overheat_active:
		if tower_final_attk_speed != 0:
			_curr_unit_time_before_explosion -= 1 / tower_final_attk_speed
		
		if _curr_unit_time_before_explosion <= 0:
			_curr_unit_time_before_explosion = base_unit_time_per_explosion
			
			var explosion = explosion_attack_module.construct_aoe(enemy.global_position, enemy.global_position)
			explosion.enemies_to_ignore.append(enemy)
			#explosion.damage_instance = explosion.damage_instance.get_copy_damage_only_scaled_by(tower.last_calculated_final_ability_potency)
			explosion.damage_instance.scale_only_damage_by(tower.last_calculated_final_ability_potency)
			explosion.scale *= explosion_scale
			
			tower.get_tree().get_root().add_child(explosion)


func _on_tower_round_end():
	_curr_unit_time_before_explosion = 0

#

func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_round_end", self, "_on_tower_round_end"):
		tower.disconnect("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_hit")
		tower.disconnect("on_round_end", self, "_on_tower_round_end")
		tower.disconnect("final_attack_speed_changed", self, "_tower_final_attk_speed_changed")
		tower.remove_attack_module(explosion_attack_module)
		
		explosion_attack_module.queue_free()
		explosion_attack_module = null



