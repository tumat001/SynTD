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

const BulletAttackModule = preload("res://TowerRelated/Modules/BulletAttackModule.gd")
const IngredientEffect = preload("res://GameInfoRelated/TowerIngredientRelated/IngredientEffect.gd")

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

signal final_base_damage_changed
signal final_attack_speed_changed
signal final_range_changed
signal ingredients_absorbed_changed
signal ingredients_limit_changed(new_limit)
signal tower_colors_changed

export var tower_highlight_sprite : Resource

var tower_id : int

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

var attack_modules_and_target_num : Dictionary = {}
var main_attack_module : AbstractAttackModule
var range_module : RangeModule

var disabled_from_attacking : bool = false

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
var _ingredients_base_gold_costs : Array = []

# Round related

var is_round_started : bool = false setget _set_round_started


# Initialization

func _ready():
	$IngredientDeclinePic.visible = false
	_end_drag()

func _post_inherit_ready():
	_update_ingredient_compatible_colors()
	
	_add_all_modules_as_children()

func _add_all_modules_as_children():
	for attack_module in attack_modules_and_target_num.keys():
		add_attack_module(attack_module, attack_modules_and_target_num[attack_module])


func _emit_final_range_changed():
	range_module.calculate_final_range_radius()
	call_deferred("emit_signal", "final_range_changed")

func _emit_final_base_damage_changed():
	main_attack_module.calculate_final_base_damage()
	call_deferred("emit_signal", "final_base_damage_changed")

func _emit_final_attack_speed_changed():
	main_attack_module.calculate_final_attack_speed()
	call_deferred("emit_signal", "final_attack_speed_changed")

func _emit_ingredients_absorbed_changed():
	call_deferred("emit_signal", "ingredients_absorbed_changed")


# Adding Attack modules related

func add_attack_module(attack_module : AbstractAttackModule, num_of_targets : int, benefit_from_existing_tower_buffs : bool = true):
	if attack_module.get_parent() == null:
		add_child(attack_module)
	
	if attack_module.range_module == null:
		attack_module.range_module = range_module
	
	attack_module.range_module.update_range()
	
	if main_attack_module == null and attack_module.module_id == StoreOfAttackModuleID.MAIN:
		main_attack_module = attack_module
		#main_attack_module.connect("final_attack_speed_changed", self, "_emit_final_attack_speed_changed")
		#main_attack_module.connect("final_base_damage_changed", self, "_emit_final_base_damage_changed")
		
		if range_module == null and main_attack_module.range_module != null:
			range_module = main_attack_module.range_module
		
		if range_module != null:
			if range_module.get_parent() == null:
				add_child(range_module)
			
			range_module.update_range() 
			range_module.connect("final_range_changed", self, "_emit_final_range_changed")
		
	
	if benefit_from_existing_tower_buffs:
		for tower_effect in _all_uuid_tower_buffs_map.values():
			add_tower_effect(tower_effect, [attack_module], false)
	
	
	attack_modules_and_target_num[attack_module] = num_of_targets


func remove_attack_module(attack_module_to_remove : AbstractAttackModule):
	for tower_effect in _all_uuid_tower_buffs_map.values():
		remove_tower_effect(tower_effect, [attack_module_to_remove], false)
	
	attack_modules_and_target_num.erase(attack_module_to_remove)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !disabled_from_attacking:
		for attack_module in attack_modules_and_target_num.keys():
			if attack_module.current_time_metadata == AbstractAttackModule.Time_Metadata.TIME_AS_SECONDS:
				attack_module.time_passed(delta)
			
			if attack_module.can_be_commanded_by_tower and attack_module.is_ready_to_attack():
				
				var success : bool = false
				# If module itself does has a range_module
				if attack_module.range_module != null:
					success = attack_module.attempt_find_then_attack_enemies(attack_modules_and_target_num[attack_module])
					if attack_module.is_main_attack and success:
						_on_main_attack_success()
				else:
					var targets = range_module.get_targets(attack_modules_and_target_num[attack_module])
					
					if targets.size() > 0:
						success = attack_module.on_command_attack_enemies(targets)
						if attack_module.is_main_attack and success:
							_on_main_attack_success()
	
	
	#Drag related
	if is_being_dragged:
		var mouse_pos = get_global_mouse_position()
		position.x = mouse_pos.x
		position.y = mouse_pos.y
	
	# timebounded
	
	_decrease_time_of_timebounded(delta)


func _on_main_attack_success():
	for am in attack_modules_and_target_num.keys():
		if am.current_time_metadata == AbstractAttackModule.Time_Metadata.TIME_AS_NUM_OF_ATTACKS:
			am.time_passed(1)
			
			if am.is_ready_to_attack():
				am.attempt_find_then_attack_enemies(attack_modules_and_target_num[am])


# Round start/end

func _set_round_started(arg_is_round_started : bool):
	is_round_started = arg_is_round_started
	
	if !is_round_started: # Round ended
		_on_round_end()
	else:
		_on_round_start()


func _on_round_end():
	for module in attack_modules_and_target_num.keys():
		module.on_round_end()
	

func _on_round_start():
	pass

# Recieving buffs/debuff related

func add_tower_effect(tower_base_effect : TowerBaseEffect, target_modules : Array = attack_modules_and_target_num.keys(), include_non_module_effects : bool = true):
	if include_non_module_effects:
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
		
	elif tower_base_effect is TowerResetEffects:
		if include_non_module_effects:
			_clear_ingredients_by_effect_reset()
		

func remove_tower_effect(tower_base_effect : TowerBaseEffect, target_modules : Array = attack_modules_and_target_num.keys(), include_non_module_effects : bool = true):
	if include_non_module_effects:
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


func _add_attack_speed_effect(tower_attr_effect : TowerAttributesEffect, target_modules : Array):
	for module in target_modules:
		
		if module.benefits_from_bonus_attack_speed:
			if tower_attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED:
				module.percent_attack_speed_effects[tower_attr_effect.effect_uuid] = tower_attr_effect
			elif tower_attr_effect.attribute_type == TowerAttributesEffect.FLAT_ATTACK_SPEED:
				module.flat_attack_speed_effects[tower_attr_effect.effect_uuid] = tower_attr_effect
		
		if module == main_attack_module and module.benefits_from_bonus_attack_speed:
			_emit_final_attack_speed_changed()

func _remove_attack_speed_effect(attr_effect_uuid : int, target_modules : Array):
	for module in target_modules:
		
		if module.benefits_from_bonus_attack_speed:
			module.percent_attack_speed_effects.erase(attr_effect_uuid)
			module.flat_attack_speed_effects.erase(attr_effect_uuid)
		
		if module == main_attack_module and module.benefits_from_bonus_attack_speed:
			_emit_final_attack_speed_changed()


func _add_base_damage_effect(attr_effect : TowerAttributesEffect, target_modules : Array):
	for module in target_modules:
		
		if module.benefits_from_bonus_base_damage:
			if attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_DAMAGE_BONUS:
				module.percent_base_damage_effects[attr_effect.effect_uuid] = attr_effect
			elif attr_effect.attribute_type == TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS:
				module.flat_base_damage_effects[attr_effect.effect_uuid] = attr_effect
		
		if module == main_attack_module and module.benefits_from_bonus_attack_speed:
			_emit_final_base_damage_changed()

func _remove_base_damage_effect(attr_effect_uuid : int, target_modules : Array):
	for module in target_modules:
		
		if module.benefits_from_bonus_base_damage:
			module.percent_base_damage_effects.erase(attr_effect_uuid)
			module.flat_base_damage_effects.erase(attr_effect_uuid)
		
		if module == main_attack_module and module.benefits_from_bonus_attack_speed:
			_emit_final_base_damage_changed()


func _add_on_hit_damage_adder_effect(on_hit_adder : TowerOnHitDamageAdderEffect, target_modules : Array):
	for module in target_modules:
		if module.benefits_from_bonus_on_hit_damage:
			module.on_hit_damage_adder_effects[on_hit_adder.effect_uuid] = on_hit_adder

func _remove_on_hit_damage_adder_effect(on_hit_adder_uuid : int, target_modules : Array):
	for module in target_modules:
		
		if module.benefits_from_bonus_on_hit_damage:
			module.on_hit_damage_adder_effects.erase(on_hit_adder_uuid)


func _add_range_effect(attr_effect : TowerAttributesEffect, target_modules : Array):
	if range_module != null:
		if range_module.benefits_from_bonus_range:
			if attr_effect.attribute_type == TowerAttributesEffect.FLAT_RANGE:
				range_module.flat_range_effects[attr_effect.effect_uuid] = attr_effect
			elif attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_RANGE:
				range_module.percent_range_effects[attr_effect.effect_uuid] = attr_effect
			
			range_module.update_range()
			_emit_final_range_changed()
			
			if main_attack_module is BulletAttackModule:
				main_attack_module.projectile_life_distance = range_module.last_calculated_final_range
	
	
	for module in target_modules:
		if module.range_module != null:
			if module.range_module.benefits_from_bonus_range:
				if attr_effect.attribute_type == TowerAttributesEffect.FLAT_RANGE:
					module.range_module.flat_range_effects[attr_effect.effect_uuid] = attr_effect
				elif attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_RANGE:
					module.range_module.percent_range_effects[attr_effect.effect_uuid] = attr_effect
			
			module.range_module.update_range()
			if module is BulletAttackModule:
				module.projectile_life_distance = module.range_module.last_calculated_final_range


func _remove_range_effect(attr_effect_uuid : int, target_modules : Array):
	if range_module != null:
		if range_module.benefits_from_bonus_range:
			
			range_module.flat_range_effects.erase(attr_effect_uuid)
			range_module.percent_range_effects.erase(attr_effect_uuid)
			
			if main_attack_module is BulletAttackModule:
				main_attack_module.projectile_life_distance = range_module.last_calculated_final_range
			
			range_module.update_range()
			_emit_final_range_changed()
	
	
	for module in target_modules:
		if module.range_module != null:
			if module.range_module.benefits_from_bonus_range:
				module.range_module.flat_range_effects.erase(attr_effect_uuid)
				module.range_module.percent_range_effects.erase(attr_effect_uuid)
				
				module.range_module.update_range()
				if module is BulletAttackModule:
					module.projectile_life_distance = module.range_module.last_calculated_final_range


func _add_pierce_effect(attr_effect : TowerAttributesEffect, target_modules : Array):
	for module in target_modules:
		
		if module is BulletAttackModule and module.benefits_from_bonus_pierce:
			if attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_PIERCE:
				module.percent_pierce_effects[attr_effect.effect_uuid] = attr_effect
			elif attr_effect.attribute_type == TowerAttributesEffect.FLAT_PIERCE:
				module.flat_pierce_effects[attr_effect.effect_uuid] = attr_effect

func _remove_pierce_effect(attr_effect_uuid : int, target_modules : Array):
	for module in target_modules:
		
		if module is BulletAttackModule and module.benefits_from_bonus_pierce:
			module.percent_pierce_effects.erase(attr_effect_uuid)
			module.flat_pierce_effects.erase(attr_effect_uuid)


func _add_proj_speed_effect(attr_effect : TowerAttributesEffect, target_modules : Array):
	for module in target_modules:
		
		if module is BulletAttackModule and module.benefits_from_bonus_proj_speed:
			if attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_PROJ_SPEED:
				module.percent_proj_speed_effects[attr_effect.effect_uuid] = attr_effect
			elif attr_effect.attribute_type == TowerAttributesEffect.FLAT_PROJ_SPEED:
				module.flat_proj_speed_effects[attr_effect.effect_uuid] = attr_effect

func _remove_proj_speed_effect(attr_effect_uuid : int, target_modules : Array):
	for module in target_modules:
		
		if module is BulletAttackModule and module.benefits_from_bonus_pierce:
			module.percent_proj_speed_effects.erase(attr_effect_uuid)
			module.flat_proj_speed_effects.erase(attr_effect_uuid)

func _add_on_hit_effect_adder_effect(effect_adder : TowerOnHitEffectAdderEffect, target_modules : Array):
	for module in target_modules:
		if module.benefits_from_bonus_on_hit_effect:
			module.on_hit_effects[effect_adder.effect_uuid] = effect_adder

func _remove_on_hit_effect_adder_effect(effect_adder_uuid : int, target_modules : Array):
	for module in target_modules:
		
		if module.benefits_from_bonus_on_hit_effect:
			module.on_hit_effects.erase(effect_adder_uuid)


func _add_chaos_takeover_effect(takeover_effect : TowerChaosTakeoverEffect):
	takeover_effect.takeover(self)

func _remove_chaos_takeover_effect(takeover_effect : TowerChaosTakeoverEffect):
	takeover_effect.untakeover(self)


func _add_attack_module_from_effect(module_effect : BaseTowerAttackModuleAdderEffect):
	module_effect._make_modifications_to_tower(self)

func _remove_attack_module_from_effect(module_effect : BaseTowerAttackModuleAdderEffect):
	module_effect._undo_modifications_to_tower(self)


# Decreasing timebounds related

func _decrease_time_of_timebounded(delta):
	for effect_uuid in _all_uuid_tower_buffs_map.keys():
		var effect : TowerBaseEffect = _all_uuid_tower_buffs_map[effect_uuid]
		
		if effect.is_timebound:
			effect.time_in_seconds -= delta
			
			if effect.time_in_seconds <= 0:
				_all_uuid_tower_buffs_map.erase(effect_uuid)
				remove_tower_effect(effect)


# Ingredient Related

func absorb_ingredient(ingredient_effect : IngredientEffect, ingredient_gold_base_cost : int):
	if ingredient_effect != null:
		ingredients_absorbed[ingredient_effect.tower_id] = ingredient_effect
		add_tower_effect(ingredient_effect.tower_base_effect)
		
		_ingredients_base_gold_costs.append(ingredient_gold_base_cost)
		_emit_ingredients_absorbed_changed()

func clear_ingredients():
	for ingredient_tower_id in ingredients_absorbed:
		remove_tower_effect(ingredients_absorbed[ingredient_tower_id].tower_base_effect)
	
	_emit_ingredients_absorbed_changed()
	ingredients_absorbed.clear()
	_ingredients_base_gold_costs.clear()


func _clear_ingredients_by_effect_reset():
	for ingredient_tower_id in ingredients_absorbed.keys():
		remove_tower_effect(ingredients_absorbed[ingredient_tower_id].tower_base_effect)
	
	ingredients_absorbed.clear()
	emit_signal("tower_give_gold", _calculate_sellback_of_ingredients(), GoldManager.IncreaseGoldSource.TOWER_EFFECT_RESET)


func _can_accept_ingredient(ingredient_effect : IngredientEffect, tower_selected) -> bool:
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
	
	for attack_module in attack_modules_and_target_num.keys():
		if attack_module.range_module != null and attack_module.use_self_range_module and attack_module.range_module.can_display_range:
			attack_module.range_module.toggle_show_range()
	
	is_showing_ranges = !is_showing_ranges


func _toggle_show_tower_info():
	emit_signal("tower_toggle_show_info", self)


# Disable Modules for whatever reason

func _disable_modules():
	for module in attack_modules_and_target_num.keys():
		module.disable_module()

func _enable_modules():
	for module in attack_modules_and_target_num.keys():
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
			
			emit_signal("tower_not_in_active_map")
		elif current_placable is InMapAreaPlacable:
			disabled_from_attacking = false
			_enable_modules()
			is_contributing_to_synergy = true
			
			emit_signal("tower_active_in_map")
	
	# Update Synergy
	if should_update_active_synergy:
		emit_signal("update_active_synergy")


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
	
	for cost in _ingredients_base_gold_costs:
		if cost > 1:
			cost -= 1
		
		sellback += cost
	
	return sellback


# Tracking of towers related
func queue_free():
	is_contributing_to_synergy = false
	current_placable.tower_occupying = null
	
	emit_signal("tower_in_queue_free") # synergy updated from tower manager
	.queue_free()
