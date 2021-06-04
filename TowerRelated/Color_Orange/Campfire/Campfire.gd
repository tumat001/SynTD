extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const TowerDetectingRangeModule_Scene = preload("res://TowerRelated/Modules/TowerInteractingModules/TowerDetectingRangeModule.tscn")
const TowerDetectingRangeModule = preload("res://TowerRelated/Modules/TowerInteractingModules/TowerDetectingRangeModule.gd")

const PercentType = preload("res://GameInfoRelated/PercentType.gd")

const CampfireParticle_Scene = preload("res://TowerRelated/Color_Orange/Campfire/CampfireTriggerParticle.tscn")


var tower_detecting_range_module : TowerDetectingRangeModule
const base_rage_threshold : float = 50.0
var _current_rage : float = 0
var last_calculated_rage_threshold : float = base_rage_threshold

var cf_attack_module : InstantDamageAttackModule

var physical_on_hit_effect : TowerOnHitDamageAdderEffect
var physical_on_hit : OnHitDamage

onready var flame_anim_sprite := $TowerBase/BaseSprites
const base_frame_rate : int = 5

var campfire_base_damage : float

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.CAMPFIRE)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	
	campfire_base_damage = info.base_damage
	
	tower_detecting_range_module = TowerDetectingRangeModule_Scene.instance()
	tower_detecting_range_module.can_display_range = false
	tower_detecting_range_module.detection_range = info.base_range
	
	add_child(tower_detecting_range_module)
	
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	range_module.clear_all_targeting()
	
	
	var attack_module = InstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_name = "beacon_base_damage"
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.can_be_commanded_by_tower = false
	
	cf_attack_module = attack_module
	
	add_attack_module(attack_module)
	
	connect("final_range_changed", self, "_final_range_changed")
	connect("on_range_module_enemy_entered", self, "_enemy_entered_range")
	connect("on_range_module_enemy_exited", self, "_enemy_exited_range")
	connect("final_attack_speed_changed", self, "_calculate_final_rage_threshold")
	connect("attack_module_added", self, "_on_main_attack_module_changed")
	connect("final_base_damage_changed", self, "_final_base_damage_changed")
	
	_construct_on_hit_and_modifiers()
	_construct_effects()
	
	_post_inherit_ready()



func _construct_on_hit_and_modifiers():
	var physical_on_hit_modifier = FlatModifier.new("cf_phy_on_hit_buff")
	
	physical_on_hit = OnHitDamage.new("cf_phy_on_hit_buff", physical_on_hit_modifier, DamageType.PHYSICAL)


func _construct_effects():
	physical_on_hit_effect = TowerOnHitDamageAdderEffect.new(physical_on_hit, StoreOfTowerEffectsUUID.CAMPFIRE_PHY_ON_HIT)
	physical_on_hit_effect.is_countbound = true
	physical_on_hit_effect.count = 1
	physical_on_hit_effect.count_reduced_by_main_attack_only = false


# Giving effects and trigger

func _enemy_damage_taken(damage, damage_type, is_lethal, enemy):
	_current_rage += damage
	if _current_rage >= last_calculated_rage_threshold:
		_update_physical_on_hit_effect()
		_give_buffs_to_towers()
		_construct_particle()
		_current_rage = 0


func _update_physical_on_hit_effect():
	if main_attack_module != null:
		physical_on_hit.damage_as_modifier.flat_modifier = main_attack_module.last_calculated_final_damage
		physical_on_hit_effect.on_hit_damage = physical_on_hit.duplicate()


func _give_buffs_to_towers():
	for tower in tower_detecting_range_module.get_all_in_map_towers_in_range():
		tower.add_tower_effect(physical_on_hit_effect._shallow_duplicate())


func _construct_particle():
	var particle = CampfireParticle_Scene.instance()
	add_child(particle)


# Trigger

func _calculate_final_rage_threshold():
	var total_atk_speed = main_attack_module.last_calculated_final_attk_speed
	last_calculated_rage_threshold = base_rage_threshold / total_atk_speed
	
	_match_fire_fps_to_attack_speed(total_atk_speed)


# Module related

func _on_main_attack_module_changed(attack_module):
	_calculate_final_rage_threshold()
	_final_base_damage_changed()


# Aesthetics

func _match_fire_fps_to_attack_speed(total_atk_speed):
	flame_anim_sprite.frames.set_animation_speed("default", 5 * total_atk_speed)

func _match_fire_size_to_base_dmg(total_base_dmg):
	flame_anim_sprite.scale = Vector2(1, 1) # original scale
	flame_anim_sprite.scale *= 1 + ((total_base_dmg - campfire_base_damage) / 5)
	
	var sprite_height : float = flame_anim_sprite.frames.get_frame("default", 0).get_size().y
	var height_change = ((flame_anim_sprite.scale.y * sprite_height) - sprite_height) / 2
	
	flame_anim_sprite.position.y = -10 # original height
	flame_anim_sprite.position.y -= height_change


func _final_base_damage_changed():
	_match_fire_size_to_base_dmg(main_attack_module.last_calculated_final_damage)

# range related

func _enemy_entered_range(enemy, range_module):
	if !enemy.is_connected("on_post_mitigated_damage_taken", self, "_enemy_damage_taken"):
		enemy.connect("on_post_mitigated_damage_taken", self, "_enemy_damage_taken")


func _enemy_exited_range(enemy, range_module):
	if enemy.is_connected("on_post_mitigated_damage_taken", self, "_enemy_damage_taken"):
		enemy.disconnect("on_post_mitigated_damage_taken", self, "_enemy_damage_taken")



func _final_range_changed():
	tower_detecting_range_module.detection_range = range_module.last_calculated_final_range


func toggle_module_ranges():
	.toggle_module_ranges()
	
	if is_showing_ranges:
		if current_placable is InMapAreaPlacable:
			_on_tower_show_range()
	else:
		_on_tower_hide_range()


func _on_tower_show_range():
	tower_detecting_range_module.glow_all_towers_in_range()

func _on_tower_hide_range():
	tower_detecting_range_module.unglow_all_towers_in_range()


# On round end

func _on_round_end():
	._on_round_end()
	
	_current_rage = 0
