extends "res://TowerRelated/Modification/ModuleModification/BaseModuleModification.gd"

const BaseBullet = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const SpawnAOETemplate = preload("res://TowerRelated/Modification/Templates/SpawnAOETemplate.gd")
const BulletSpawnAOEModification = preload("res://TowerRelated/Modification/BulletModification/SpawnAOEBulletModification.gd")

var aoe_scene : PackedScene

var aoe_base_damage : float
var aoe_base_damage_type : int
var aoe_flat_base_damage_modifiers : Dictionary = {}
var aoe_percent_base_damage_modifiers : Dictionary = {}
var aoe_base_on_hit_damage_internal_name
var aoe_extra_on_hit_damages : Dictionary
var aoe_on_hit_effects : Dictionary

var aoe_on_hit_damage_scale : float = 1
var aoe_base_on_hit_affected_by_scale : bool = false
var aoe_on_hit_effect_scale : float = 1

var aoe_damage_repeat_count : int = 1
var aoe_duration : float
var aoe_pierce : int = -1

var aoe_texture : Texture
var aoe_sprite_frames : SpriteFrames
var aoe_sprite_frames_play_only_once : bool = true
var aoe_default_coll_shape : int

var aoe_spawn_on_hit : bool = true
var tree


func _modify_attack(to_modify):
	._modify_attack(to_modify)
	
	if to_modify is BaseBullet:
		_finalize_bullet(to_modify)
	elif to_modify is AbstractEnemy:
		_after_effect_to_enemy(to_modify)


func _finalize_bullet(bullet : BaseBullet):
	
	var template = _generate_template()
	
	if bullet.modifications == null:
		bullet.modifications = []
	var bullet_modification = BulletSpawnAOEModification.new()
	bullet_modification.spawn_aoe_template = template
	bullet_modification.trigger_on_death = aoe_spawn_on_hit
	
	bullet.modifications.append(bullet_modification)

func _generate_template() -> SpawnAOETemplate:
	var template : SpawnAOETemplate = SpawnAOETemplate.new()
	
	template.aoe_scene = aoe_scene
	
	template.aoe_damage_repeat_count = aoe_damage_repeat_count
	template.aoe_duration = aoe_duration
	template.aoe_pierce = aoe_pierce
	
	template.aoe_texture = aoe_texture
	template.aoe_sprite_frames = aoe_sprite_frames
	template.aoe_sprite_frames_play_only_once = aoe_sprite_frames_play_only_once
	template.aoe_default_coll_shape = aoe_default_coll_shape
	template.tree = tree
	
	var damage_instance = DamageInstance.new()
	damage_instance.on_hit_damages = _get_all_scaled_aoe_on_hit_damages()
	damage_instance.on_hit_effects = _get_all_scaled_aoe_on_hit_effects()
	template.aoe_damage_instance = damage_instance
	
	return template


func _get_base_damage_of_aoe_as_on_hit_damage() -> OnHitDamage:
	var modifier : FlatModifier = FlatModifier.new(aoe_base_on_hit_damage_internal_name)
	modifier.flat_modifier = calculate_final_base_damage()
	
	if aoe_on_hit_damage_scale != 1 and aoe_base_on_hit_affected_by_scale:
		modifier = modifier.get_copy_scaled_by(aoe_on_hit_damage_scale)
	
	return OnHitDamage.new(aoe_base_on_hit_damage_internal_name, modifier, aoe_base_damage_type)

func calculate_final_base_damage():
	#All percent modifiers here are to BASE damage only
	var final_base_damage = aoe_base_damage
	for modifier in aoe_percent_base_damage_modifiers.values():
		final_base_damage += modifier.get_modification_to_value(aoe_base_damage)
	
	for flat in aoe_flat_base_damage_modifiers.values():
		final_base_damage += flat.get_modification_to_value(aoe_base_damage)
	
	return final_base_damage


func _get_all_scaled_aoe_on_hit_damages() -> Dictionary:
	
	var scaled_on_hit_damages = {}
	
	# BASE ON HIT
	scaled_on_hit_damages[aoe_base_on_hit_damage_internal_name] = _get_base_damage_of_aoe_as_on_hit_damage()
	
	# EXTRA ON HITS
	for extra_on_hit_key in aoe_extra_on_hit_damages.keys():
		var duplicate = extra_on_hit_key
		
		if aoe_on_hit_damage_scale != 1:
			duplicate = duplicate.duplicate()
			duplicate.damage_as_modifier = aoe_extra_on_hit_damages[extra_on_hit_key].damage_as_modifier.get_copy_scaled_by(aoe_on_hit_damage_scale)
		
		scaled_on_hit_damages[extra_on_hit_key] = duplicate
	
	return scaled_on_hit_damages

func _get_all_scaled_aoe_on_hit_effects() -> Dictionary:
	var scaled_on_hit_effects = {}
	
	for on_hit_effect_key in aoe_on_hit_effects.keys():
		var duplicate = on_hit_effect_key
		
		if aoe_on_hit_effect_scale != 1:
			duplicate.duplicate()
			duplicate.effect_strength_modifier = aoe_on_hit_effects[on_hit_effect_key].effect_strength_modifier.get_copy_scaled_by(aoe_on_hit_effect_scale)
		
		scaled_on_hit_effects[on_hit_effect_key] = duplicate
	
	return scaled_on_hit_effects

#

func _after_effect_to_enemy(enemy : AbstractEnemy):
	var template = _generate_template()
	
	template._spawn_aoe(enemy.global_position)
