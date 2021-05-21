
const BaseAOE = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.gd")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")

const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")


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

var benefits_from_bonus_on_hit_damage : bool = true
var benefits_from_bonus_base_damage : bool = true
var benefits_from_bonus_on_hit_effect : bool = true


var aoe_damage_repeat_count : int = 1
var aoe_duration : float
var aoe_pierce : int = -1

var aoe_texture : Texture
var aoe_sprite_frames : SpriteFrames
var aoe_sprite_frames_play_only_once : bool = true
var aoe_default_coll_shape : int
var aoe_shift_x : bool = false
var aoe_scale_x : float = 1
var aoe_scale_y : float = 1

var attack_module_source
var damage_register_id : int

#

var spawn_aoe_at_death : bool = true
var tree

var aoe_rotation_deg : float = 0


func _spawn_aoe(global_pos : Vector2):
	var aoe_instance : BaseAOE = aoe_scene.instance()
	
	aoe_instance.damage_repeat_count = aoe_damage_repeat_count
	aoe_instance.duration = aoe_duration
	aoe_instance.pierce = aoe_pierce
	
	aoe_instance.aoe_texture = aoe_texture
	aoe_instance.aoe_sprite_frames = aoe_sprite_frames
	aoe_instance.sprite_frames_play_only_once = aoe_sprite_frames_play_only_once
	aoe_instance.aoe_default_coll_shape = aoe_default_coll_shape
	
	var damage_instance = DamageInstance.new()
	damage_instance.on_hit_damages = _get_all_scaled_aoe_on_hit_damages()
	damage_instance.on_hit_effects = _get_all_scaled_aoe_on_hit_effects()
	aoe_instance.damage_instance = damage_instance
	
	aoe_instance.global_position = global_pos
	aoe_instance.rotation_degrees = aoe_rotation_deg
	aoe_instance.shift_x = aoe_shift_x
	aoe_instance.scale.x = aoe_scale_x
	aoe_instance.scale.y = aoe_scale_y
	
	aoe_instance.attack_module_source = attack_module_source
	aoe_instance.damage_register_id = damage_register_id
	
	#tree.get_root().add_child(aoe_instance)
	tree.get_root().call_deferred("add_child", aoe_instance)


#

func _get_base_damage_of_aoe_as_on_hit_damage() -> OnHitDamage:
	var modifier : FlatModifier = FlatModifier.new(aoe_base_on_hit_damage_internal_name)
	modifier.flat_modifier = calculate_final_base_damage()
	
	if aoe_on_hit_damage_scale != 1 and aoe_base_on_hit_affected_by_scale:
		modifier = modifier.get_copy_scaled_by(aoe_on_hit_damage_scale)
	
	return OnHitDamage.new(aoe_base_on_hit_damage_internal_name, modifier, aoe_base_damage_type)

func calculate_final_base_damage():
	#All percent modifiers here are to BASE damage only
	var final_base_damage = aoe_base_damage
	
	if benefits_from_bonus_base_damage:
		for modifier in aoe_percent_base_damage_modifiers.values():
			final_base_damage += modifier.get_modification_to_value(aoe_base_damage)
		
		for flat in aoe_flat_base_damage_modifiers.values():
			final_base_damage += flat.get_modification_to_value(aoe_base_damage)
	
	return final_base_damage


func _get_all_scaled_aoe_on_hit_damages() -> Dictionary:
	
	var scaled_on_hit_damages = {}
	
	# BASE ON HIT
	scaled_on_hit_damages[aoe_base_on_hit_damage_internal_name] = _get_base_damage_of_aoe_as_on_hit_damage()
	
	if benefits_from_bonus_on_hit_damage:
		# EXTRA ON HITS
		for extra_on_hit_key in aoe_extra_on_hit_damages.keys():
			var duplicate = extra_on_hit_key
			
			if aoe_on_hit_damage_scale != 1:
				duplicate = duplicate.duplicate()
				duplicate.damage_as_modifier = aoe_extra_on_hit_damages[extra_on_hit_key].damage_as_modifier.get_copy_scaled_by(aoe_on_hit_damage_scale)
			
			scaled_on_hit_damages[extra_on_hit_key] = duplicate
	
	return scaled_on_hit_damages

func _get_all_scaled_aoe_on_hit_effects() -> Dictionary:
	if !benefits_from_bonus_on_hit_effect:
		return {}
	
	var scaled_on_hit_effects = {}
	
	for on_hit_effect_key in aoe_on_hit_effects.keys():
		var duplicate = on_hit_effect_key
		
		if aoe_on_hit_effect_scale != 1:
			duplicate.duplicate()
			duplicate.effect_strength_modifier = aoe_on_hit_effects[on_hit_effect_key].effect_strength_modifier.get_copy_scaled_by(aoe_on_hit_effect_scale)
		
		scaled_on_hit_effects[on_hit_effect_key] = duplicate
	
	return scaled_on_hit_effects
