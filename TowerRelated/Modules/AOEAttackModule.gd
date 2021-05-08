extends "res://TowerRelated/Modules/AbstractAttackModule.gd"

const SpawnAOETemplate = preload("res://TowerRelated/Templates/SpawnAOETemplate.gd")

enum SpawnLocation {
	CENTERED_TO_MODULE,
	CENTERED_TO_ENEMY,
	IN_FRONT_OF_TOWER, # NOT TESTED YET
}

var spawn_location : int = SpawnLocation.IN_FRONT_OF_TOWER
var aoe_template : SpawnAOETemplate setget _set_template

func _set_template(template : SpawnAOETemplate):
	template.aoe_base_damage = base_damage
	template.aoe_base_damage_type = base_damage_type
	template.aoe_base_on_hit_damage_internal_name = base_on_hit_damage_internal_name
	template.aoe_on_hit_damage_scale = on_hit_damage_scale
	template.aoe_on_hit_effect_scale = on_hit_effect_scale
	template.aoe_base_on_hit_affected_by_scale = base_on_hit_affected_by_scale
	
	template.aoe_extra_on_hit_damages = extra_on_hit_damages
	template.aoe_flat_base_damage_modifiers = flat_base_damage_modifiers
	template.aoe_percent_base_damage_modifiers = percent_base_damage_modifiers
	
	template.benefits_from_bonus_base_damage = benefits_from_bonus_base_damage
	template.benefits_from_bonus_on_hit_damage = benefits_from_bonus_on_hit_damage
	template.benefits_from_bonus_on_hit_effect = benefits_from_bonus_on_hit_effect
	
	if spawn_location == SpawnLocation.IN_FRONT_OF_TOWER:
		template.aoe_shift_x = true
	
	aoe_template = template


# Attack related

func _attack_enemy(_enemy : AbstractEnemy):
	_attack_at_position(_enemy.position)

func _attack_enemies(_enemies : Array):
	for enemy in _enemies:
		_attack_enemy(enemy)

func _attack_at_positions(_positions : Array):
	for pos in _positions:
		_attack_at_position(pos)

func _attack_at_position(_pos : Vector2):
	_modify_attack(_pos)
	
	aoe_template._spawn_aoe(_calculate_center_pos_of_aoe(_pos))
	pass


func _calculate_center_pos_of_aoe(enemy_pos : Vector2) -> Vector2:
	if spawn_location == SpawnLocation.CENTERED_TO_ENEMY:
		return enemy_pos
	elif spawn_location == SpawnLocation.CENTERED_TO_MODULE:
		return global_position
	elif spawn_location == SpawnLocation.IN_FRONT_OF_TOWER:
		return global_position
	
	
	return Vector2(0, 0)

