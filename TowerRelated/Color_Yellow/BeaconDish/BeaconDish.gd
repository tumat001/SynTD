extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const TowerDetectingRangeModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.tscn")
const TowerDetectingRangeModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.gd")

const BeaconDishSignalParticle = preload("res://TowerRelated/Color_Yellow/BeaconDish/BeaconDishSignalParticle.tscn")


signal elemental_buff_changed()
signal attk_speed_buff_changed()
signal range_buff_changed()


const beacon_dish_panel_about_descriptions : Array = [
	"Beacon dish gives buffs to all towers in range based on its stats.",
]

var tower_detecting_range_module : TowerDetectingRangeModule
var refresh_cooldown : float = 5.0
var _current_refresh_cooldown : float = 0
var effect_duration : float = 5.2

var elemental_on_hit_effect : TowerOnHitDamageAdderEffect
var attack_speed_effect : TowerAttributesEffect
var range_effect : TowerAttributesEffect

var elemental_on_hit : OnHitDamage
var attack_speed_modifier : PercentModifier
var range_modifier : FlatModifier

var bd_attack_module : AbstractAttackModule

var buff_aura_ability : BaseAbility

# ratios


const original_ratio_elemental_on_hit : float = 0.3#0.20 
const original_ratio_attack_speed : float = 35.0 #25.0 
const original_ratio_range : float = 0.20 #0.15

const empowered_ratio_elemental_on_hit : float = 0.55 #0.45 
const empowered_ratio_attack_speed : float = 60.0 #45.0
const empowered_ratio_range : float = 0.25 #0.20


var ratio_elemental_on_hit : float = original_ratio_elemental_on_hit
var ratio_attack_speed : float = original_ratio_attack_speed
var ratio_range : float = original_ratio_range

# INI related

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.BEACON_DISH)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	
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
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.can_be_commanded_by_tower = false
	
	bd_attack_module = attack_module
	
	attack_module.is_displayed_in_tracker = false
	
	add_attack_module(attack_module)
	
	connect("final_range_changed", self, "_final_range_changed", [], CONNECT_PERSIST)
	
	connect("final_range_changed", self, "_update_flat_range_effect", [], CONNECT_PERSIST)
	connect("final_attack_speed_changed", self, "_update_flat_attk_speed_effect", [], CONNECT_PERSIST)
	connect("final_base_damage_changed", self, "_update_elemental_on_hit_effect", [], CONNECT_PERSIST)
	#connect("final_ability_potency_changed", self, "_on_last_calculated_ap_changed_b", [], CONNECT_PERSIST)
	
	_construct_on_hit_and_modifiers()
	_construct_effects()
	
	_construct_and_connect_ability()
	
	_post_inherit_ready()


func _construct_on_hit_and_modifiers():
	var elemental_on_hit_modifier = FlatModifier.new(StoreOfTowerEffectsUUID.BEACON_ELE_ON_HIT)
	
	elemental_on_hit = OnHitDamage.new(StoreOfTowerEffectsUUID.BEACON_ELE_ON_HIT, elemental_on_hit_modifier, DamageType.ELEMENTAL)
	attack_speed_modifier = PercentModifier.new(StoreOfTowerEffectsUUID.BEACON_ATTK_SPEED)
	attack_speed_modifier.percent_based_on = PercentType.BASE
	
	range_modifier = FlatModifier.new(StoreOfTowerEffectsUUID.BEACON_RANGE)


func _construct_effects():
	elemental_on_hit_effect = TowerOnHitDamageAdderEffect.new(elemental_on_hit, StoreOfTowerEffectsUUID.BEACON_ELE_ON_HIT)
	elemental_on_hit_effect.is_timebound = true
	elemental_on_hit_effect.time_in_seconds = effect_duration
	
	attack_speed_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attack_speed_modifier, StoreOfTowerEffectsUUID.BEACON_ATTK_SPEED)
	attack_speed_effect.is_timebound = true
	attack_speed_effect.time_in_seconds = effect_duration
	
	range_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_RANGE, range_modifier, StoreOfTowerEffectsUUID.BEACON_RANGE)
	range_effect.is_timebound = true
	range_effect.time_in_seconds = effect_duration


func _construct_and_connect_ability():
	buff_aura_ability = BaseAbility.new()
	
	buff_aura_ability.is_timebound = false
	
	register_ability_to_manager(buff_aura_ability, false)


# Round start related

func _on_round_start():
	._on_round_start()
	
	_current_refresh_cooldown = 0


# TDRange related

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


# Giving of effects related

func _process(delta):
	if is_round_started:
		_current_refresh_cooldown -= delta
		
		if _current_refresh_cooldown <= 0:
			if current_placable is InMapAreaPlacable and !last_calculated_disabled_from_attacking:
				var cd = _get_cd_to_use(refresh_cooldown)
				_current_refresh_cooldown = cd 
				
				buff_aura_ability.on_ability_before_cast_start(cd)
				#_update_elemental_on_hit_effect()
				#_update_flat_attk_speed_effect()
				#_update_flat_range_effect()
				
				_give_buffs_to_active_towers_in_range()
				
				_show_signal_particle()
				
				_decrease_count_of_countbounded(bd_attack_module)
				buff_aura_ability.on_ability_after_cast_ended(cd)


func _give_buffs_to_active_towers_in_range():
	for a_tower in tower_detecting_range_module.get_all_in_map_towers_in_range():
		a_tower.add_tower_effect(elemental_on_hit_effect._shallow_duplicate())
		a_tower.add_tower_effect(attack_speed_effect._shallow_duplicate())
		a_tower.add_tower_effect(range_effect._shallow_duplicate())


func _show_signal_particle():
	var particle = BeaconDishSignalParticle.instance()
	particle.position.y -= 19
	particle.position.x += 0.5
	add_child(particle)


#

#func _on_last_calculated_ap_changed_b():
#	_update_all_bd_effects()

func _update_all_bd_effects():
	_update_elemental_on_hit_effect()
	_update_flat_attk_speed_effect()
	_update_flat_range_effect()

func _update_elemental_on_hit_effect():
	if is_instance_valid(main_attack_module):
		elemental_on_hit.damage_as_modifier.flat_modifier = (main_attack_module.last_calculated_final_damage * ratio_elemental_on_hit) #* last_calculated_final_ability_potency
		elemental_on_hit_effect.on_hit_damage = elemental_on_hit.duplicate()
		emit_signal("elemental_buff_changed")

func _update_flat_attk_speed_effect():
	if is_instance_valid(main_attack_module):
		attack_speed_modifier.percent_amount = (main_attack_module.last_calculated_final_attk_speed * ratio_attack_speed) #* last_calculated_final_ability_potency
		attack_speed_effect.attribute_as_modifier = attack_speed_modifier.get_copy_scaled_by(1)
		emit_signal("attk_speed_buff_changed")

func _update_flat_range_effect():
	if is_instance_valid(main_attack_module):
		main_attack_module.range_module.calculate_final_range_radius()
		
		range_modifier.flat_modifier = (main_attack_module.range_module.last_calculated_final_range * ratio_range) #* last_calculated_final_ability_potency
		range_effect.attribute_as_modifier = range_modifier.get_copy_scaled_by(1)
		emit_signal("range_buff_changed")


# energy module related


func set_energy_module(module):
	.set_energy_module(module)
	
	if module != null:
		module.module_effect_descriptions = [
			"The ratio this tower's total stats compared to its given bonuses is increased.",
			"45%% of its total base damage as a buff (from %s%%)." % str(original_ratio_elemental_on_hit * 100),
			"45%% of its total attack speed as a buff (from %s%%)." % str(original_ratio_elemental_on_hit),
			"20%% of its total range as a buff (from %s%%)." % str(original_ratio_range * 100)
		]


func _module_turned_on(_first_time_per_round : bool):
	ratio_elemental_on_hit = empowered_ratio_elemental_on_hit
	ratio_attack_speed = empowered_ratio_attack_speed
	ratio_range = empowered_ratio_range
	
	_update_all_bd_effects()


func _module_turned_off():
	ratio_elemental_on_hit = original_ratio_elemental_on_hit
	ratio_attack_speed = original_ratio_attack_speed
	ratio_range = original_ratio_range
	
	_update_all_bd_effects()
