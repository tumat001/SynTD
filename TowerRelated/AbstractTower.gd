extends Area2D

const Targeting = preload("res://GameInfoRelated/Targeting.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const BaseAreaTowerPlacable = preload("res://GameElementsRelated/AreaTowerPlacablesRelated/BaseAreaTowerPlacable.gd")
const TowerBenchSlot = preload("res://GameElementsRelated/AreaTowerPlacablesRelated/TowerBenchSlot.gd")
const InMapAreaPlacable = preload("res://GameElementsRelated/InMapPlacablesRelated/InMapAreaPlacable.gd")
const AbstractAttackModule = preload("res://TowerRelated/Modules/AbstractAttackModule.gd")
const RangeModule = preload("res://TowerRelated/Modules/RangeModule.gd")

const TowerBaseEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd")
const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const TowerResetEffects = preload("res://GameInfoRelated/TowerEffectRelated/TowerResetEffects.gd")
const TowerOnHitDamageAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitDamageAdderEffect.gd")
const TowerOnHitEffectAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitEffectAdderEffect.gd")
const TowerChaosTakeoverEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerChaosTakeoverEffect.gd")
const BaseTowerAttackModuleAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/BaseTowerAttackModuleAdderEffect.gd")
const TowerFullSellbackEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerFullSellbackEffect.gd")
const _704EmblemPointsEffect = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/704EmblemPointsEffect.gd")

const BulletAttackModule = preload("res://TowerRelated/Modules/BulletAttackModule.gd")
const IngredientEffect = preload("res://GameInfoRelated/TowerIngredientRelated/IngredientEffect.gd")
const AOEAttackModule = preload("res://TowerRelated/Modules/AOEAttackModule.gd")

const StoreOfTowerEffectsUUID = preload("res://GameInfoRelated/TowerEffectRelated/StoreOfTowerEffectsUUID.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")

const ingredient_decline_pic = preload("res://GameHUDRelated/BottomPanel/IngredientMode_CannotCombine.png")
const GoldManager = preload("res://GameElementsRelated/GoldManager.gd")


signal tower_being_dragged(tower_self)
signal tower_dropped_from_dragged(tower_self)
signal tower_toggle_show_info
signal tower_in_queue_free
signal update_active_synergy
signal tower_being_sold(sellback_gold)
signal tower_give_gold(gold, gold_source_as_int)

signal tower_not_in_active_map
signal tower_active_in_map

signal attack_module_added(attack_module)
signal attack_module_removed(attack_module)

signal final_base_damage_changed
signal final_attack_speed_changed
signal final_range_changed
signal ingredients_absorbed_changed
signal ingredients_limit_changed(new_limit)
signal tower_colors_changed
signal targeting_changed
signal targeting_options_modified

signal on_main_attack_finished(module)
signal on_main_attack(attk_speed_delay, enemies, module)
signal on_any_attack_finished(module)
signal on_any_attack(attk_speed_delay, enemies, module)
signal on_damage_instance_constructed(damage_instance, module)

signal on_range_module_enemy_entered(enemy, range_module)
signal on_range_module_enemy_exited(enemy, range_module)

signal energy_module_attached
signal energy_module_detached

signal on_round_end
signal on_round_start


export var tower_highlight_sprite : Resource

var tower_id : int


enum DisabledFromAttackingSource {
	
	HEAT_MODULE = 1,
	
}

###

var hovering_over_placable : BaseAreaTowerPlacable
var current_placable : BaseAreaTowerPlacable
var is_contributing_to_synergy : bool

var is_being_dragged : bool = false
var is_in_ingredient_mode : bool = false

var is_showing_ranges : bool

#####

var collision_shape

var current_power_level_used : int

var all_attack_modules : Array = []
var main_attack_module : AbstractAttackModule
var range_module : RangeModule

var disabled_from_attacking : bool = false
var _other_disabled_from_attacking_clauses : Dictionary = {}
var last_calculated_disabled_from_attacking : bool

# Tower buffs related

var _all_uuid_tower_buffs_map : Dictionary = {}


# Ingredient related

var ingredients_absorbed : Dictionary = {} # Map of tower_id (ingredient source) to ingredient_effect
var ingredient_of_self : IngredientEffect
var ingredient_compatible_colors : Array = []

var _ingredient_id_limit_modifier_map : Dictionary
var last_calculated_ingredient_limit : int

# Color related

var _tower_colors : Array = []

# Gold related

var _base_gold_cost : int
var _ingredients_tower_id_base_gold_costs_map : Dictionary = {}
var _is_full_sellback : bool = false

# Round related

var is_round_started : bool = false setget _set_round_started


# SYN RELATED ---------------------------- #
# Yellow
var energy_module setget set_energy_module

# Orange
var heat_module setget set_heat_module



# Initialization -------------------------- #

func _ready():
	$IngredientDeclinePic.visible = false
	_end_drag()

func _post_inherit_ready():
	_update_ingredient_compatible_colors()
	
	if range_module != null:
		if range_module.get_parent() == null:
			add_child(range_module)
		
		range_module.update_range() 



func _emit_final_range_changed():
	call_deferred("emit_signal", "final_range_changed")

func _emit_final_base_damage_changed():
	call_deferred("emit_signal", "final_base_damage_changed")

func _emit_final_attack_speed_changed():
	call_deferred("emit_signal", "final_attack_speed_changed")

func _emit_ingredients_absorbed_changed():
	call_deferred("emit_signal", "ingredients_absorbed_changed")

func _emit_targeting_changed():
	call_deferred("emit_signal", "targeting_changed")

func _emit_targeting_options_modified():
	call_deferred("emit_signal", "targeting_options_modified")

# Adding Attack modules related

func add_attack_module(attack_module : AbstractAttackModule, benefit_from_existing_tower_buffs : bool = true):
	if !attack_module.is_connected("in_attack_end", self, "_emit_on_any_attack_finished"):
		attack_module.connect("in_attack_end", self, "_emit_on_any_attack_finished", [attack_module])
		attack_module.connect("in_attack", self, "_emit_on_any_attack", [attack_module])
		attack_module.connect("on_damage_instance_constructed", self, "_emit_on_damage_instance_constructed")
	
	if attack_module.get_parent() == null:
		add_child(attack_module)
	
	if attack_module.range_module == null:
		attack_module.range_module = range_module
	
	if !attack_module.range_module.is_connected("enemy_entered_range", self, "_emit_on_range_module_enemy_entered"):
		attack_module.range_module.connect("enemy_entered_range", self, "_emit_on_range_module_enemy_entered", [attack_module.range_module])
		attack_module.range_module.connect("enemy_left_range" , self, "_emit_on_range_module_enemy_exited", [attack_module.range_module])
	
	attack_module.range_module.update_range()
	
	#if main_attack_module == null and attack_module.module_id == StoreOfAttackModuleID.MAIN:
	if attack_module.module_id == StoreOfAttackModuleID.MAIN:
		main_attack_module = attack_module
		
		if !main_attack_module.is_connected("in_attack_end", self, "_emit_on_main_attack_finished"):
			main_attack_module.connect("in_attack_end", self, "_emit_on_main_attack_finished", [main_attack_module])
			main_attack_module.connect("in_attack", self, "_emit_on_main_attack", [main_attack_module])
		
		if range_module == null and main_attack_module.range_module != null:
			range_module = main_attack_module.range_module
		
		if range_module != null:
			if range_module.get_parent() == null:
				add_child(range_module)
			
			range_module.update_range() 
			range_module.connect("final_range_changed", self, "_emit_final_range_changed")
			range_module.connect("targeting_changed", self, "_emit_targeting_changed")
			range_module.connect("targeting_options_modified", self, "_emit_targeting_options_modified")
	
	if benefit_from_existing_tower_buffs:
		for tower_effect in _all_uuid_tower_buffs_map.values():
			add_tower_effect(tower_effect, [attack_module], false, false)
	
	all_attack_modules.append(attack_module)
	emit_signal("attack_module_added", attack_module)


func remove_attack_module(attack_module_to_remove : AbstractAttackModule):
	if attack_module_to_remove.is_connected("in_attack_end", self, "_emit_on_any_attack_finished"):
		attack_module_to_remove.disconnect("in_attack_end", self, "_emit_on_any_attack_finished")
		attack_module_to_remove.disconnect("in_attack", self, "_emit_on_any_attack")
		attack_module_to_remove.disconnect("on_damage_instance_constructed", self, "_emit_on_damage_instance_constructed")
	
	if attack_module_to_remove.is_connected("in_attack_end", self, "_emit_on_main_attack_finished"):
		attack_module_to_remove.disconnect("in_attack_end", self, "_emit_on_main_attack_finished")
		attack_module_to_remove.disconnect("in_attack", self, "_emit_on_main_attack")
	
	for tower_effect in _all_uuid_tower_buffs_map.values():
		remove_tower_effect(tower_effect, [attack_module_to_remove], false, false)
	
	if attack_module_to_remove.range_module == range_module:
		if range_module.attack_modules_using_this.has(attack_module_to_remove) and range_module.attack_modules_using_this.size() == 1:
			range_module.disconnect("final_range_changed", self, "_emit_final_range_changed")
			range_module.disconnect("targeting_changed", self, "_emit_targeting_changed")
			range_module.disconnect("targeting_options_modified", self, "_emit_targeting_options_modified")
	
	
	all_attack_modules.erase(attack_module_to_remove)
	
	if main_attack_module == attack_module_to_remove:
		for module in all_attack_modules:
			if module.module_id == StoreOfAttackModuleID.MAIN:
				main_attack_module = module
				break
	
	emit_signal("attack_module_removed", attack_module_to_remove)


# Module signals related

func _emit_on_any_attack_finished(module):
	call_deferred("emit_signal", "on_any_attack_finished", module)

func _emit_on_any_attack(attack_delay, enemies_or_poses, module):
	emit_signal("on_any_attack", attack_delay, enemies_or_poses, module)

func _emit_on_main_attack_finished(module):
	call_deferred("emit_signal", "on_main_attack_finished", module)

func _emit_on_main_attack(attack_delay, enemies_or_poses, module):
	emit_signal("on_main_attack", attack_delay, enemies_or_poses, module)

func _emit_on_damage_instance_constructed(damage_instance, module):
	emit_signal("on_damage_instance_constructed", damage_instance, module)
	_decrease_count_of_countbounded(module)


func _emit_on_range_module_enemy_entered(enemy, module):
	emit_signal("on_range_module_enemy_entered", enemy, module)

func _emit_on_range_module_enemy_exited(enemy, module):
	emit_signal("on_range_module_enemy_exited", enemy, module)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !disabled_from_attacking and !last_calculated_disabled_from_attacking:
		for attack_module in all_attack_modules:
			if attack_module == null:
				continue
			
			attack_module.time_passed(delta)
			
			if attack_module.can_be_commanded_by_tower and attack_module.is_ready_to_attack():
				# If module itself does has a range_module
				if attack_module.range_module != null:
					attack_module.attempt_find_then_attack_enemies()
				else:
					var targets = range_module.get_targets(attack_module.number_of_unique_targets)
					attack_module.on_command_attack_enemies(targets)
	
	
	#Drag related
	if is_being_dragged:
		var mouse_pos = get_global_mouse_position()
		position.x = mouse_pos.x
		position.y = mouse_pos.y
	
	# timebounded
	
	_decrease_time_of_timebounded(delta)


# Round start/end

func _set_round_started(arg_is_round_started : bool):
	is_round_started = arg_is_round_started
	
	if !is_round_started: # Round ended
		_on_round_end()
	else:
		_on_round_start()


func _on_round_end():
	for module in all_attack_modules:
		module.on_round_end()
	
	_remove_all_timebound_and_countbound_effects()
	emit_signal("on_round_end")


func _on_round_start():
	emit_signal("on_round_start")


# Recieving buffs/debuff related

func add_tower_effect(tower_base_effect : TowerBaseEffect, target_modules : Array = all_attack_modules, register_to_buff_map : bool = true, include_non_module_effects : bool = true, ing_effect : IngredientEffect = null):
	if include_non_module_effects and register_to_buff_map:
		_all_uuid_tower_buffs_map[tower_base_effect.effect_uuid] = tower_base_effect
	
	if tower_base_effect is TowerAttributesEffect:
		if tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_ATTACK_SPEED or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED:
			_add_attack_speed_effect(tower_base_effect, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_DAMAGE_BONUS:
			_add_base_damage_effect(tower_base_effect, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_RANGE or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_RANGE:
			_add_range_effect(tower_base_effect, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_PIERCE or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_PIERCE:
			_add_pierce_effect(tower_base_effect, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_PROJ_SPEED or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_PROJ_SPEED:
			_add_proj_speed_effect(tower_base_effect, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_EXPLOSION_SCALE or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_EXPLOSION_SCALE:
			_add_explosion_scale_effect(tower_base_effect, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_ARMOR_PIERCE:
			_add_armor_pierce_effect(tower_base_effect, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_TOUGHNESS_PIERCE:
			_add_toughness_pierce_effect(tower_base_effect, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_RESISTANCE_PIERCE:
			_add_resistance_pierce_effect(tower_base_effect, target_modules)
		
	elif tower_base_effect is TowerOnHitDamageAdderEffect:
		_add_on_hit_damage_adder_effect(tower_base_effect, target_modules)
		
	elif tower_base_effect is TowerOnHitEffectAdderEffect:
		_add_on_hit_effect_adder_effect(tower_base_effect, target_modules)
		
	elif tower_base_effect is TowerChaosTakeoverEffect:
		if include_non_module_effects:
			_add_chaos_takeover_effect(tower_base_effect)
		
	elif tower_base_effect is BaseTowerAttackModuleAdderEffect:
		if include_non_module_effects:
			_add_attack_module_from_effect(tower_base_effect)
		
	elif tower_base_effect is TowerFullSellbackEffect:
		if include_non_module_effects:
			_set_full_sellback(true)
		
	elif tower_base_effect is _704EmblemPointsEffect:
		if include_non_module_effects:
			_special_case_effect_added(tower_base_effect)
			remove_ingredient(ing_effect)
		
	elif tower_base_effect is TowerResetEffects:
		if include_non_module_effects:
			_clear_ingredients_by_effect_reset()
			
			if main_attack_module != null:
				main_attack_module.reset_attack_timers()
		

func remove_tower_effect(tower_base_effect : TowerBaseEffect, target_modules : Array = all_attack_modules, erase_from_buff_map : bool = true, include_non_module_effects : bool = true):
	if include_non_module_effects and erase_from_buff_map:
		_all_uuid_tower_buffs_map.erase(tower_base_effect.effect_uuid)
	
	if tower_base_effect is TowerAttributesEffect:
		if tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_ATTACK_SPEED or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED:
			_remove_attack_speed_effect(tower_base_effect.effect_uuid, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_DAMAGE_BONUS:
			_remove_base_damage_effect(tower_base_effect.effect_uuid, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_RANGE or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_RANGE:
			_remove_range_effect(tower_base_effect.effect_uuid, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_PIERCE or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_PIERCE:
			_remove_pierce_effect(tower_base_effect.effect_uuid, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_PROJ_SPEED or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_PROJ_SPEED:
			_remove_proj_speed_effect(tower_base_effect.effect_uuid, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_EXPLOSION_SCALE or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_EXPLOSION_SCALE:
			_remove_explosion_scale_effect(tower_base_effect.effect_uuid, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_ARMOR_PIERCE:
			_remove_armor_pierce_effect(tower_base_effect.effect_uuid, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_TOUGHNESS_PIERCE:
			_remove_toughness_pierce_effect(tower_base_effect.effect_uuid, target_modules)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_RESISTANCE_PIERCE:
			_remove_resistance_pierce_effect(tower_base_effect.effect_uuid, target_modules)
		
		
	elif tower_base_effect is TowerOnHitDamageAdderEffect:
		_remove_on_hit_damage_adder_effect(tower_base_effect.effect_uuid, target_modules)
		
	elif tower_base_effect is TowerOnHitEffectAdderEffect:
		_remove_on_hit_effect_adder_effect(tower_base_effect.effect_uuid, target_modules)
		
	elif tower_base_effect is BaseTowerAttackModuleAdderEffect:
		if include_non_module_effects:
			_remove_attack_module_from_effect(tower_base_effect)
		
	elif tower_base_effect is TowerChaosTakeoverEffect:
		if include_non_module_effects:
			_remove_chaos_takeover_effect(tower_base_effect)
		
	elif tower_base_effect is TowerFullSellbackEffect:
		if include_non_module_effects:
			_set_full_sellback(false)
		

func _add_attack_speed_effect(tower_attr_effect : TowerAttributesEffect, target_modules : Array):
	for module in target_modules:
		
		if module.benefits_from_bonus_attack_speed or tower_attr_effect.force_apply:
			if tower_attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED:
				module.percent_attack_speed_effects[tower_attr_effect.effect_uuid] = tower_attr_effect
			elif tower_attr_effect.attribute_type == TowerAttributesEffect.FLAT_ATTACK_SPEED:
				module.flat_attack_speed_effects[tower_attr_effect.effect_uuid] = tower_attr_effect
			
			module.calculate_all_speed_related_attributes()
			
			if module == main_attack_module:
				_emit_final_attack_speed_changed()
			
			if tower_attr_effect.is_countbound:
				module._all_countbound_effects[tower_attr_effect.effect_uuid] = tower_attr_effect


func _remove_attack_speed_effect(attr_effect_uuid : int, target_modules : Array):
	for module in target_modules:
		
		module.percent_attack_speed_effects.erase(attr_effect_uuid)
		module.flat_attack_speed_effects.erase(attr_effect_uuid)
		module.calculate_all_speed_related_attributes()
		
		if module == main_attack_module:
			_emit_final_attack_speed_changed()
		
		if module._all_countbound_effects.has(attr_effect_uuid):
			module._all_countbound_effects.erase(attr_effect_uuid)


func _add_base_damage_effect(attr_effect : TowerAttributesEffect, target_modules : Array):
	for module in target_modules:
		
		if module.benefits_from_bonus_base_damage or attr_effect.force_apply:
			if attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_DAMAGE_BONUS:
				module.percent_base_damage_effects[attr_effect.effect_uuid] = attr_effect
			elif attr_effect.attribute_type == TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS:
				module.flat_base_damage_effects[attr_effect.effect_uuid] = attr_effect
			
			module.calculate_final_base_damage()
			
			if module == main_attack_module:
				_emit_final_base_damage_changed()
			
			if attr_effect.is_countbound:
				module._all_countbound_effects[attr_effect.effect_uuid] = attr_effect


func _remove_base_damage_effect(attr_effect_uuid : int, target_modules : Array):
	for module in target_modules:
		
		module.percent_base_damage_effects.erase(attr_effect_uuid)
		module.flat_base_damage_effects.erase(attr_effect_uuid)
		
		module.calculate_final_base_damage()
		
		if module == main_attack_module:
			_emit_final_base_damage_changed()
		
		if module._all_countbound_effects.has(attr_effect_uuid):
			module._all_countbound_effects.erase(attr_effect_uuid)


func _add_on_hit_damage_adder_effect(on_hit_adder : TowerOnHitDamageAdderEffect, target_modules : Array):
	for module in target_modules:
		if module.benefits_from_bonus_on_hit_damage or on_hit_adder.force_apply:
			module.on_hit_damage_adder_effects[on_hit_adder.effect_uuid] = on_hit_adder
			
			if on_hit_adder.is_countbound:
				module._all_countbound_effects[on_hit_adder.effect_uuid] = on_hit_adder


func _remove_on_hit_damage_adder_effect(on_hit_adder_uuid : int, target_modules : Array):
	for module in target_modules:
		module.on_hit_damage_adder_effects.erase(on_hit_adder_uuid)
		
		if module._all_countbound_effects.has(on_hit_adder_uuid):
			module._all_countbound_effects.erase(on_hit_adder_uuid)


func _add_range_effect(attr_effect : TowerAttributesEffect, target_modules : Array):
	if range_module != null:
		if range_module.benefits_from_bonus_range or attr_effect.force_apply:
			if attr_effect.attribute_type == TowerAttributesEffect.FLAT_RANGE:
				range_module.flat_range_effects[attr_effect.effect_uuid] = attr_effect
			elif attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_RANGE:
				range_module.percent_range_effects[attr_effect.effect_uuid] = attr_effect
			
			range_module.update_range()
			_emit_final_range_changed()
			
			if main_attack_module is BulletAttackModule:
				#main_attack_module.base_proj_life_distance = range_module.last_calculated_final_range
				pass
	
	for module in target_modules:
		if module.range_module != null:
			if module.range_module.benefits_from_bonus_range or attr_effect.force_apply:
				if attr_effect.attribute_type == TowerAttributesEffect.FLAT_RANGE:
					module.range_module.flat_range_effects[attr_effect.effect_uuid] = attr_effect
				elif attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_RANGE:
					module.range_module.percent_range_effects[attr_effect.effect_uuid] = attr_effect
				
				module.range_module.update_range()
				
				if module == main_attack_module:
					_emit_final_range_changed()
				
				if attr_effect.is_countbound:
					module._all_countbound_effects[attr_effect.effect_uuid] = attr_effect



func _remove_range_effect(attr_effect_uuid : int, target_modules : Array):
	if range_module != null:
		range_module.flat_range_effects.erase(attr_effect_uuid)
		range_module.percent_range_effects.erase(attr_effect_uuid)
		
		range_module.update_range()
		_emit_final_range_changed()
	
	
	for module in target_modules:
		if module.range_module != null:
			
			module.range_module.flat_range_effects.erase(attr_effect_uuid)
			module.range_module.percent_range_effects.erase(attr_effect_uuid)
			
			module.range_module.update_range()
			
			if module._all_countbound_effects.has(attr_effect_uuid):
				module._all_countbound_effects.erase(attr_effect_uuid)



func _add_pierce_effect(attr_effect : TowerAttributesEffect, target_modules : Array):
	for module in target_modules:
		
		if module is BulletAttackModule and (module.benefits_from_bonus_pierce or attr_effect.force_apply):
			if attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_PIERCE:
				module.percent_pierce_effects[attr_effect.effect_uuid] = attr_effect
			elif attr_effect.attribute_type == TowerAttributesEffect.FLAT_PIERCE:
				module.flat_pierce_effects[attr_effect.effect_uuid] = attr_effect
			
			module.calculate_final_pierce()
			
			if attr_effect.is_countbound:
				module._all_countbound_effects[attr_effect.effect_uuid] = attr_effect



func _remove_pierce_effect(attr_effect_uuid : int, target_modules : Array):
	for module in target_modules:
		
		if module is BulletAttackModule:
			module.percent_pierce_effects.erase(attr_effect_uuid)
			module.flat_pierce_effects.erase(attr_effect_uuid)
			module.calculate_final_pierce()
			
			if module._all_countbound_effects.has(attr_effect_uuid):
				module._all_countbound_effects.erase(attr_effect_uuid)



func _add_proj_speed_effect(attr_effect : TowerAttributesEffect, target_modules : Array):
	for module in target_modules:
		
		if module is BulletAttackModule and (module.benefits_from_bonus_proj_speed or attr_effect.force_apply):
			if attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_PROJ_SPEED:
				module.percent_proj_speed_effects[attr_effect.effect_uuid] = attr_effect
			elif attr_effect.attribute_type == TowerAttributesEffect.FLAT_PROJ_SPEED:
				module.flat_proj_speed_effects[attr_effect.effect_uuid] = attr_effect
			
			module.calculate_final_proj_speed()
			
			if attr_effect.is_countbound:
				module._all_countbound_effects[attr_effect.effect_uuid] = attr_effect


func _remove_proj_speed_effect(attr_effect_uuid : int, target_modules : Array):
	for module in target_modules:
		
		if module is BulletAttackModule:
			module.percent_proj_speed_effects.erase(attr_effect_uuid)
			module.flat_proj_speed_effects.erase(attr_effect_uuid)
			
			module.calculate_final_proj_speed()
			
			if module._all_countbound_effects.has(attr_effect_uuid):
				module._all_countbound_effects.erase(attr_effect_uuid)


func _add_explosion_scale_effect(attr_effect : TowerAttributesEffect, target_modules : Array):
	for module in target_modules:
		
		if module is AOEAttackModule and (module.benefits_from_bonus_explosion_scale or attr_effect.force_apply):
			if attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_EXPLOSION_SCALE:
				module.percent_explosion_scale_effects[attr_effect.effect_uuid] = attr_effect
			elif attr_effect.attribute_type == TowerAttributesEffect.FLAT_EXPLOSION_SCALE:
				module.flat_explosion_scale_effects[attr_effect.effect_uuid] = attr_effect
			
			module.calculate_final_explosion_scale()
			
			if attr_effect.is_countbound:
				module._all_countbound_effects[attr_effect.effect_uuid] = attr_effect


func _remove_explosion_scale_effect(attr_effect_uuid : int, target_modules : Array):
	for module in target_modules:
		
		if module is AOEAttackModule:
			module.percent_explosion_scale_effects.erase(attr_effect_uuid)
			module.flat_explosion_scale_effects.erase(attr_effect_uuid)
			
			module.calculate_final_explosion_scale()
			
			if module._all_countbound_effects.has(attr_effect_uuid):
				module._all_countbound_effects.erase(attr_effect_uuid)


func _add_on_hit_effect_adder_effect(effect_adder : TowerOnHitEffectAdderEffect, target_modules : Array):
	for module in target_modules:
		if module.benefits_from_bonus_on_hit_effect or effect_adder.force_apply:
			module.on_hit_effects[effect_adder.effect_uuid] = effect_adder
			
			if effect_adder.is_countbound:
				module._all_countbound_effects[effect_adder.effect_uuid] = effect_adder


func _remove_on_hit_effect_adder_effect(effect_adder_uuid : int, target_modules : Array):
	for module in target_modules:
		module.on_hit_effects.erase(effect_adder_uuid)
		
		if module._all_countbound_effects.has(effect_adder_uuid):
			module._all_countbound_effects.erase(effect_adder_uuid)



func _add_chaos_takeover_effect(takeover_effect : TowerChaosTakeoverEffect):
	takeover_effect.takeover(self)

func _remove_chaos_takeover_effect(takeover_effect : TowerChaosTakeoverEffect):
	takeover_effect.untakeover(self)


func _add_attack_module_from_effect(module_effect : BaseTowerAttackModuleAdderEffect):
	module_effect._make_modifications_to_tower(self)

func _remove_attack_module_from_effect(module_effect : BaseTowerAttackModuleAdderEffect):
	module_effect._undo_modifications_to_tower(self)


func _set_full_sellback(full_sellback : bool):
	_is_full_sellback = full_sellback


func _add_armor_pierce_effect(attr_effect : TowerAttributesEffect, target_modules : Array):
	for module in target_modules:
		
		if module.benefits_from_bonus_armor_pierce or attr_effect.force_apply:
			if attr_effect.attribute_type == TowerAttributesEffect.FLAT_ARMOR_PIERCE:
				module.flat_base_armor_pierce_effects[attr_effect.effect_uuid] = attr_effect
			
			module.calculate_final_armor_pierce()
			
			if attr_effect.is_countbound:
				module._all_countbound_effects[attr_effect.effect_uuid] = attr_effect

func _remove_armor_pierce_effect(attr_effect_uuid : int, target_modules : Array):
	for module in target_modules:
		module.flat_base_armor_pierce_effects.erase(attr_effect_uuid)
		
		module.calculate_final_armor_pierce()
		
		if module._all_countbound_effects.has(attr_effect_uuid):
			module._all_countbound_effects.erase(attr_effect_uuid)


func _add_toughness_pierce_effect(attr_effect : TowerAttributesEffect, target_modules : Array):
	for module in target_modules:
		
		if module.benefits_from_bonus_toughness_pierce or attr_effect.force_apply:
			if attr_effect.attribute_type == TowerAttributesEffect.FLAT_TOUGHNESS_PIERCE:
				module.flat_base_toughness_pierce_effects[attr_effect.effect_uuid] = attr_effect
			
			module.calculate_final_toughness_pierce()
			
			if attr_effect.is_countbound:
				module._all_countbound_effects[attr_effect.effect_uuid] = attr_effect

func _remove_toughness_pierce_effect(attr_effect_uuid : int, target_modules : Array):
	for module in target_modules:
		module.flat_base_toughness_pierce_effects.erase(attr_effect_uuid)
		
		module.calculate_final_tougness_pierce()
		
		if module._all_countbound_effects.has(attr_effect_uuid):
			module._all_countbound_effects.erase(attr_effect_uuid)


func _add_resistance_pierce_effect(attr_effect : TowerAttributesEffect, target_modules : Array):
	for module in target_modules:
		
		if module.benefits_from_bonus_resistance_pierce or attr_effect.force_apply:
			if attr_effect.attribute_type == TowerAttributesEffect.FLAT_RESISTANCE_PIERCE:
				module.flat_base_resistance_pierce_effects[attr_effect.effect_uuid] = attr_effect
			
			module.calculate_final_resistance_pierce()
			
			if attr_effect.is_countbound:
				module._all_countbound_effects[attr_effect.effect_uuid] = attr_effect

func _remove_resistance_pierce_effect(attr_effect_uuid : int, target_modules : Array):
	for module in target_modules:
		module.flat_base_resistance_pierce_effects.erase(attr_effect_uuid)
		
		module.calculate_final_resistance_pierce()
		
		if module._all_countbound_effects.has(attr_effect_uuid):
			module._all_countbound_effects.erase(attr_effect_uuid)


# special case effects

func _special_case_effect_added(effect : TowerBaseEffect):
	pass


# has tower effects

func has_tower_effect_uuid_in_buff_map(effect_uuid) -> bool:
	return _all_uuid_tower_buffs_map.has(effect_uuid)

func has_tower_effect_type_in_buff_map(tower_effect : TowerBaseEffect):
	for effect in _all_uuid_tower_buffs_map:
		if tower_effect.get_script() == effect.get_script():
			return true
	
	return false


# Decreasing timebounds related

func _decrease_time_of_timebounded(delta):
	for effect_uuid in _all_uuid_tower_buffs_map.keys():
		var effect : TowerBaseEffect = _all_uuid_tower_buffs_map[effect_uuid]
		
		if effect.is_timebound:
			effect.time_in_seconds -= delta
			
			if effect.time_in_seconds <= 0:
				remove_tower_effect(effect)


func _remove_all_timebound_effects():
	for effect_uuid in _all_uuid_tower_buffs_map.keys():
		var effect : TowerBaseEffect = _all_uuid_tower_buffs_map[effect_uuid]
		
		if effect.is_timebound:
			remove_tower_effect(effect)


# Decreasing count of countbounded

func _decrease_count_of_countbounded(module : AbstractAttackModule):
	for effect_uuid in module._all_countbound_effects.keys():
		var effect : TowerBaseEffect = module._all_countbound_effects[effect_uuid]
		
		if effect.is_countbound:
			if effect.count_reduced_by_main_attack_only and module.module_id != StoreOfAttackModuleID.MAIN:
				continue
			
			effect.count -= 1
			
			if effect.count <= 0:
				remove_tower_effect(effect)


func _remove_all_countbound_effects():
	for effect_uuid in _all_uuid_tower_buffs_map.keys():
		var effect : TowerBaseEffect = _all_uuid_tower_buffs_map[effect_uuid]
		
		if effect.is_countbound:
			remove_tower_effect(effect)


func _remove_all_timebound_and_countbound_effects():
	for effect_uuid in _all_uuid_tower_buffs_map.keys():
		var effect : TowerBaseEffect = _all_uuid_tower_buffs_map[effect_uuid]
		
		if effect.is_countbound or effect.is_timebound:
			remove_tower_effect(effect)

# Ingredient Related

func absorb_ingredient(ingredient_effect : IngredientEffect, ingredient_gold_base_cost : int):
	if ingredient_effect != null:
		ingredients_absorbed[ingredient_effect.tower_id] = ingredient_effect
		_ingredients_tower_id_base_gold_costs_map[ingredient_effect.tower_id] = ingredient_gold_base_cost
		add_tower_effect(ingredient_effect.tower_base_effect, all_attack_modules, true, true, ingredient_effect)
		
		_emit_ingredients_absorbed_changed()


func remove_ingredient(ingredient_effect : IngredientEffect):
	if ingredient_effect != null:
		remove_tower_effect(ingredients_absorbed[ingredient_effect.tower_id].tower_base_effect)
		
		_ingredients_tower_id_base_gold_costs_map.erase(ingredient_effect.tower_id)
		ingredients_absorbed.clear()
		_emit_ingredients_absorbed_changed()


func clear_ingredients():
	for ingredient_tower_id in ingredients_absorbed:
		remove_tower_effect(ingredients_absorbed[ingredient_tower_id].tower_base_effect)
	
	ingredients_absorbed.clear()
	_emit_ingredients_absorbed_changed()
	_ingredients_tower_id_base_gold_costs_map.clear()


func _clear_ingredients_by_effect_reset():
	for ingredient_tower_id in ingredients_absorbed.keys():
		remove_tower_effect(ingredients_absorbed[ingredient_tower_id].tower_base_effect)
	
	ingredients_absorbed.clear()
	emit_signal("tower_give_gold", _calculate_sellback_of_ingredients(), GoldManager.IncreaseGoldSource.TOWER_EFFECT_RESET)
	_ingredients_tower_id_base_gold_costs_map.clear()


func _can_accept_ingredient(ingredient_effect : IngredientEffect, tower_selected) -> bool:
	if ingredient_effect != null:
		if ingredients_absorbed.size() >= last_calculated_ingredient_limit and !ingredient_effect.tower_base_effect is TowerResetEffects:
			return false
	
	if ingredient_effect != null:
		if ingredients_absorbed.has(ingredient_effect.tower_id):
			return false
		
		for color in tower_selected.ingredient_compatible_colors:
			if _tower_colors.has(color):
				return true
	
	return false

func show_acceptability_with_ingredient(ingredient_effect : IngredientEffect, tower_selected):
	if tower_selected != self:
		var can_accept = _can_accept_ingredient(ingredient_effect, tower_selected)
		
		$IngredientDeclinePic.visible = !can_accept

func hide_acceptability_with_ingredient():
	$IngredientDeclinePic.visible = false


# Ingredient limit related

func set_ingredient_limit_modifier(modifier_id : int, limit_modifier : int):
	_ingredient_id_limit_modifier_map[modifier_id] = limit_modifier
	_set_active_ingredient_limit(_calculate_final_ingredient_limit())

func remove_ingredient_limit_modifier(modifier_id : int, limit_modifier : int):
	_ingredient_id_limit_modifier_map.erase(modifier_id)
	_set_active_ingredient_limit(_calculate_final_ingredient_limit())


func _calculate_final_ingredient_limit() -> int:
	var final_limit : int = 0
	
	for limit_modifier in _ingredient_id_limit_modifier_map.values():
		final_limit += limit_modifier
	
	return final_limit


func _set_active_ingredient_limit(new_limit : int):
	
	if last_calculated_ingredient_limit != new_limit:
		if last_calculated_ingredient_limit > new_limit:
			
			var ing_effects = ingredients_absorbed.values()
			for i in range(new_limit, ingredients_absorbed.size()):
				remove_tower_effect(ing_effects[i].tower_base_effect)
			
			
		elif last_calculated_ingredient_limit < new_limit:
			
			var ing_effects = ingredients_absorbed.values()
			for i in range(last_calculated_ingredient_limit, new_limit):
				if ing_effects.size() > i:
					add_tower_effect(ing_effects[i].tower_base_effect)
				else:
					break
		
		last_calculated_ingredient_limit = new_limit
		emit_signal("ingredients_limit_changed", new_limit)


func _update_ingredient_compatible_colors():
	ingredient_compatible_colors.clear()
	
	for color in _tower_colors:
		if color == TowerColors.RED:
			ingredient_compatible_colors.append(TowerColors.RED)
			ingredient_compatible_colors.append(TowerColors.ORANGE)
			ingredient_compatible_colors.append(TowerColors.VIOLET)
			
		elif color == TowerColors.ORANGE:
			ingredient_compatible_colors.append(TowerColors.ORANGE)
			ingredient_compatible_colors.append(TowerColors.RED)
			ingredient_compatible_colors.append(TowerColors.YELLOW)
			
		elif color == TowerColors.YELLOW:
			ingredient_compatible_colors.append(TowerColors.YELLOW)
			ingredient_compatible_colors.append(TowerColors.ORANGE)
			ingredient_compatible_colors.append(TowerColors.GREEN)
			
		elif color == TowerColors.GREEN:
			ingredient_compatible_colors.append(TowerColors.GREEN)
			ingredient_compatible_colors.append(TowerColors.BLUE)
			ingredient_compatible_colors.append(TowerColors.YELLOW)
			
		elif color == TowerColors.BLUE:
			ingredient_compatible_colors.append(TowerColors.BLUE)
			ingredient_compatible_colors.append(TowerColors.GREEN)
			ingredient_compatible_colors.append(TowerColors.VIOLET)
			
		elif color == TowerColors.VIOLET:
			ingredient_compatible_colors.append(TowerColors.VIOLET)
			ingredient_compatible_colors.append(TowerColors.RED)
			ingredient_compatible_colors.append(TowerColors.BLUE)
			
		elif color == TowerColors.GRAY:
			ingredient_compatible_colors.append(TowerColors.GRAY)

# Tower Colors Related

func add_color_to_tower(color : int):
	if !_tower_colors.has(color):
		_tower_colors.append(color)
		call_deferred("emit_signal", "update_active_synergy")
		call_deferred("emit_signal", "tower_colors_changed")
		_update_ingredient_compatible_colors()

func remove_color_from_tower(color : int):
	if _tower_colors.has(color):
		_tower_colors.erase(color)
		call_deferred("emit_signal", "update_active_synergy")
		call_deferred("emit_signal", "tower_colors_changed")
		_update_ingredient_compatible_colors()


# Inputs related

func _on_ClickableArea_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_RIGHT:
			_toggle_show_tower_info()
		elif event.pressed and event.button_index == BUTTON_LEFT:
			if !(is_round_started and current_placable is InMapAreaPlacable):
				_start_drag()
		elif !event.pressed and event.button_index == BUTTON_LEFT:
			if is_being_dragged:
				_end_drag()
		


# Show Ranges of modules and Tower Info

func toggle_module_ranges():
	if range_module != null:
		range_module.toggle_show_range()
	
	for attack_module in all_attack_modules:
		if attack_module.range_module != null and attack_module.use_self_range_module and attack_module.range_module.can_display_range:
			attack_module.range_module.toggle_show_range()
	
	is_showing_ranges = !is_showing_ranges


func _toggle_show_tower_info():
	emit_signal("tower_toggle_show_info", self)


# Disable Modules for whatever reason

func _disable_modules():
	for module in all_attack_modules:
		module.disable_module()

func _enable_modules():
	for module in all_attack_modules:
		module.enable_module()


# Movement Drag and Drop things related

func _start_drag():
	$PlacableDetector/DetectorShape.set_deferred("disabled", false)
	$PlacableDetector.monitoring = true
	is_being_dragged = true
	disabled_from_attacking = true
	_disable_modules()
	z_index = ZIndexStore.TOWERS_BEING_DRAGGED
	
	emit_signal("tower_being_dragged", self)

func _end_drag():
	z_index = ZIndexStore.TOWERS
	transfer_to_placable(hovering_over_placable)
	emit_signal("tower_dropped_from_dragged", self)


func transfer_to_placable(new_area_placable: BaseAreaTowerPlacable, do_not_update : bool = false):
	var should_update_active_synergy : bool
	if new_area_placable != null and !do_not_update:
		if (current_placable != null and current_placable.get_placable_type_name() != new_area_placable.get_placable_type_name()):
			should_update_active_synergy = true
		elif current_placable == null and new_area_placable is InMapAreaPlacable:
			should_update_active_synergy = true
	
	# The "old" one
	if current_placable != null:
		if current_placable.tower_occupying == self:
			current_placable.tower_occupying = null
	
	if new_area_placable != null and new_area_placable.tower_occupying != null:
		if !is_in_ingredient_mode:
			if !(is_round_started and new_area_placable is InMapAreaPlacable):
				new_area_placable.tower_occupying.transfer_to_placable(current_placable, true)
			else:
				new_area_placable = null # return tower to original location
		else:
			var target_tower = new_area_placable.tower_occupying
			
			if target_tower._can_accept_ingredient(ingredient_of_self, self):
				_give_self_ingredient_buff_to(target_tower)
				return
			else:
				new_area_placable = null # return tower to original location
	
	# The "new" one
	if new_area_placable != null:
		current_placable = new_area_placable
		$ClickableArea/ClickableShape.shape = current_placable.get_area_shape()
	
	current_placable.tower_occupying = self
	$PlacableDetector/DetectorShape.set_deferred("disabled", true)
	$PlacableDetector.monitoring = false
	is_being_dragged = false
	
	if current_placable != null:
		var pos = current_placable.get_tower_center_position()
		position.x = pos.x
		position.y = pos.y
		
		if current_placable is TowerBenchSlot:
			disabled_from_attacking = true
			_disable_modules()
			is_contributing_to_synergy = false
			
			# Update Synergy
			if should_update_active_synergy:
				emit_signal("update_active_synergy")
			
			emit_signal("tower_not_in_active_map")
		elif current_placable is InMapAreaPlacable:
			disabled_from_attacking = false
			_enable_modules()
			is_contributing_to_synergy = true
			
			# Update Synergy
			if should_update_active_synergy:
				emit_signal("update_active_synergy")
			
			emit_signal("tower_active_in_map")
	
	


func _on_PlacableDetector_area_entered(area):
	if area is BaseAreaTowerPlacable:
		hovering_over_placable = area
		
		if is_being_dragged:
			hovering_over_placable.set_tower_highlight_sprite(tower_highlight_sprite)

func _on_PlacableDetector_area_exited(area):
	if area is BaseAreaTowerPlacable:
		area.set_tower_highlight_sprite(null)
		if hovering_over_placable == area:
			hovering_over_placable = null


# Ingredient drag and drop related

func _set_is_in_ingredient_mode(mode : bool):
	is_in_ingredient_mode = mode
	
	if mode == false:
		$IngredientDeclinePic.visible = false

func _give_self_ingredient_buff_to(absorber):
	absorber.absorb_ingredient(ingredient_of_self, _calculate_sellback_value())
	queue_free()


# Gold Sellback related

func sell_tower():
	call_deferred("emit_signal", "tower_being_sold", _calculate_sellback_value())
	queue_free()


func _calculate_sellback_value() -> int:
	var sellback = _base_gold_cost
	
	sellback += _calculate_sellback_of_ingredients()
	
	return sellback

func _calculate_sellback_of_ingredients() -> int:
	var sellback = 0
	
	for cost in _ingredients_tower_id_base_gold_costs_map.values():
		if cost > 1 and !_is_full_sellback:
			cost -= 1
		
		sellback += cost
	
	return sellback


# Modulate related

func set_tower_sprite_modulate(color : Color):
	$TowerBase.modulate = color


# Disabled from attacking clauses

func set_disabled_from_attacking_clause(id : int, clause : bool):
	_other_disabled_from_attacking_clauses[id] = clause
	_update_last_calculated_disabled_from_attacking()

func erase_disabled_from_attacking_clause(id : int):
	_other_disabled_from_attacking_clauses.erase(id)
	_update_last_calculated_disabled_from_attacking()


func _update_last_calculated_disabled_from_attacking():
	for clause in _other_disabled_from_attacking_clauses.values():
		if clause:
			last_calculated_disabled_from_attacking = true
			return
	
	last_calculated_disabled_from_attacking = false


# Tracking of towers related

func is_current_placable_in_map() -> bool:
	return current_placable is InMapAreaPlacable

func queue_free():
	is_contributing_to_synergy = false
	current_placable.tower_occupying = null
	
	emit_signal("tower_in_queue_free", self) # synergy updated from tower manager
	.queue_free()

# SYNERGIES RELATED ---------------------
# YELLOW - energy module related

func set_energy_module(module):
	if energy_module != null:
		energy_module.tower_connected_to = null
		energy_module.module_effect_descriptions = []
		
		call_deferred("emit_signal", "energy_module_detached")
		energy_module.disconnect("module_turned_on", self, "_module_turned_on")
		energy_module.disconnect("module_turned_off", self, "_module_turned_off")
	
	if module != null:
		energy_module = module
		energy_module.tower_connected_to = self
		call_deferred("emit_signal", "energy_module_attached")
		energy_module.connect("module_turned_on", self, "_module_turned_on")
		energy_module.connect("module_turned_off", self, "_module_turned_off")


func _module_turned_on(_first_time_per_round : bool):
	pass

func _module_turned_off():
	pass


# ORANGE - heat module

func set_heat_module(heat_module):
	pass
