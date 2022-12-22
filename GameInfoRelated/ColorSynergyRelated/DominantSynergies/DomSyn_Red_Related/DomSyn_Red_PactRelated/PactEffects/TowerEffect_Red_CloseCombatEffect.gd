extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")

const AOEAttackModule = preload("res://TowerRelated/Modules/AOEAttackModule.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const CloseCombat_Explosion_01 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_CloseCombat_Assets/Pact_CloseCombat_Explosion_01.png")
const CloseCombat_Explosion_02 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_CloseCombat_Assets/Pact_CloseCombat_Explosion_02.png")
const CloseCombat_Explosion_03 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_CloseCombat_Assets/Pact_CloseCombat_Explosion_03.png")
const CloseCombat_Explosion_04 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_CloseCombat_Assets/Pact_CloseCombat_Explosion_04.png")
const CloseCombat_Explosion_05 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_CloseCombat_Assets/Pact_CloseCombat_Explosion_05.png")
const CloseCombat_Explosion_06 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_CloseCombat_Assets/Pact_CloseCombat_Explosion_06.png")
const CloseCombat_Explosion_07 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_CloseCombat_Assets/Pact_CloseCombat_Explosion_07.png")
const CloseCombat_Explosion_08 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_CloseCombat_Assets/Pact_CloseCombat_Explosion_08.png")

const CloseCombat_AttackModuleIcon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_CloseCombat_Assets/Pact_CloseCombat_AttackModuleIcon.png")

const DamageType = preload("res://GameInfoRelated/DamageType.gd")

const TowerDetectingRangeModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.gd")
const TowerDetectingRangeModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.tscn")



var range_percent_reduc : float
var explosion_cooldown : float

var current_explosion_dmg : float
var range_trigger_for_explosion : float

var _explosion_cooldown_timer : Timer
var _tower

var _range_effect : TowerAttributesEffect
var explosion_attack_module : AOEAttackModule

# for arc showing only
var tower_detecting_range_module : TowerDetectingRangeModule
const color_of_trigger_range : Color = Color(0.9, 0, 0, 0.5)


var _pact_parent


func _init(arg_pact_parent).(StoreOfTowerEffectsUUID.RED_PACT_CLOSE_COMBAT_EFFECT):
	_pact_parent = arg_pact_parent 


func _make_modifications_to_tower(tower):
	_tower = tower
	
	if !is_instance_valid(_explosion_cooldown_timer):
		_explosion_cooldown_timer = Timer.new()
		_explosion_cooldown_timer.one_shot = true
		CommsForBetweenScenes.ge_add_child_to_other_node_hoster(_explosion_cooldown_timer)
	
	if !_tower.is_connected("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_hit_enemy"):
		_tower.connect("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_hit_enemy", [], CONNECT_PERSIST)
	
	if !_pact_parent.is_connected("on_damage_of_explosion_changed", self, "_on_pact_parent_damage_of_explosion_changed"):
		_pact_parent.connect("on_damage_of_explosion_changed", self, "_on_pact_parent_damage_of_explosion_changed", [], CONNECT_PERSIST)
	
	if !_tower.is_connected("on_tower_toggle_showing_range", self, "_on_tower_toggle_showing_range"):
		_tower.connect("on_tower_toggle_showing_range", self, "_on_tower_toggle_showing_range", [], CONNECT_PERSIST)
	
	_construct_and_add_range_effects()
	
	_construct_and_add_attk_module()
	
	_construct_tower_detecting_range_module()
	_tower.add_child(tower_detecting_range_module)


func _construct_tower_detecting_range_module():
	tower_detecting_range_module = TowerDetectingRangeModule_Scene.instance()
	tower_detecting_range_module.detection_range = range_trigger_for_explosion
	tower_detecting_range_module.can_display_range = false
	
	tower_detecting_range_module.can_display_circle_arc = true
	tower_detecting_range_module.circle_arc_color = color_of_trigger_range



func _construct_and_add_range_effects():
	if _range_effect == null:
		var _range_modi = PercentModifier.new(StoreOfTowerEffectsUUID.RED_PACT_CLOSE_COMBAT_RANGE_REDUC_EFFECT) 
		_range_modi.percent_amount = range_percent_reduc
		_range_modi.percent_based_on = PercentType.BASE
		
		_range_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_RANGE, _range_modi, StoreOfTowerEffectsUUID.RED_PACT_CLOSE_COMBAT_RANGE_REDUC_EFFECT)
		
		_tower.add_tower_effect(_range_effect)


func _construct_and_add_attk_module():
	explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage_scale = 1
	explosion_attack_module.base_damage = current_explosion_dmg
	explosion_attack_module.base_damage_type = DamageType.PHYSICAL
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	explosion_attack_module.on_hit_damage_scale = 1
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = false
	explosion_attack_module.benefits_from_bonus_base_damage = false
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = false
	explosion_attack_module.benefits_from_bonus_on_hit_effect = false
	explosion_attack_module.benefits_from_ingredient_effect = false
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", CloseCombat_Explosion_01)
	sprite_frames.add_frame("default", CloseCombat_Explosion_02)
	sprite_frames.add_frame("default", CloseCombat_Explosion_03)
	sprite_frames.add_frame("default", CloseCombat_Explosion_04)
	sprite_frames.add_frame("default", CloseCombat_Explosion_05)
	sprite_frames.add_frame("default", CloseCombat_Explosion_06)
	sprite_frames.add_frame("default", CloseCombat_Explosion_07)
	sprite_frames.add_frame("default", CloseCombat_Explosion_08)
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = -1
	explosion_attack_module.duration = 0.3
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ORIGIN
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	explosion_attack_module.set_image_as_tracker_image(CloseCombat_AttackModuleIcon)
	
	_tower.add_attack_module(explosion_attack_module)


#

func _on_tower_main_attack_hit_enemy(enemy, damage_register_id, damage_instance, module):
	if _explosion_cooldown_timer.time_left == 0 and _if_distance_between_enemy_and_self_is_less_than_trigger(enemy):
		_create_explosion_around_self()
		
		_explosion_cooldown_timer.start(explosion_cooldown)


func _if_distance_between_enemy_and_self_is_less_than_trigger(arg_enemy):
	var enemy_pos = arg_enemy.global_position
	var curr_pos : Vector2 = _tower.global_position
	
	return curr_pos.distance_to(enemy_pos) <= range_trigger_for_explosion
	

func _create_explosion_around_self():
	var aoe_explosion_inst = explosion_attack_module.construct_aoe(_tower.global_position, _tower.global_position)
	aoe_explosion_inst.damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE].damage_as_modifier.flat_modifier = current_explosion_dmg
	aoe_explosion_inst.scale *= 3
	aoe_explosion_inst.modulate.a = 0.7
	
	explosion_attack_module.set_up_aoe__add_child_and_emit_signals(aoe_explosion_inst)


#

func _on_pact_parent_damage_of_explosion_changed(new_val):
	current_explosion_dmg = _pact_parent._current_explosion_dmg


#

func _on_tower_toggle_showing_range(is_showing_range):
	if is_showing_range:
		tower_detecting_range_module.show_range()
	else:
		tower_detecting_range_module.hide_range()

#

func _undo_modifications_to_tower(tower):
	var range_effect = _tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_CLOSE_COMBAT_RANGE_REDUC_EFFECT)
	if range_effect != null:
		_tower.remove_tower_effect(range_effect)
	
	if is_instance_valid(_explosion_cooldown_timer):
		_explosion_cooldown_timer.queue_free()
	
	if _tower.is_connected("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_hit_enemy"):
		_tower.disconnect("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_hit_enemy")
	
	if _pact_parent.is_connected("on_damage_of_explosion_changed", self, "_on_pact_parent_damage_of_explosion_changed"):
		_pact_parent.disconnect("on_damage_of_explosion_changed", self, "_on_pact_parent_damage_of_explosion_changed")
	
	if _tower.is_connected("on_tower_toggle_showing_range", self, "_on_tower_toggle_showing_range"):
		_tower.disconnect("on_tower_toggle_showing_range", self, "_on_tower_toggle_showing_range")

	
	tower_detecting_range_module.queue_free()
	
	_tower.remove_attack_module(explosion_attack_module)
	explosion_attack_module.queue_free()
	
