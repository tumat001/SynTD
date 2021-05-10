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
const TowerOnHitDamageAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitDamageAdderEffect.gd")
const BulletAttackModule = preload("res://TowerRelated/Modules/BulletAttackModule.gd")
const IngredientEffect = preload("res://GameInfoRelated/TowerIngredientRelated/IngredientEffect.gd")

const StoreOfTowerEffectsUUID = preload("res://GameInfoRelated/TowerEffectRelated/StoreOfTowerEffectsUUID.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")

const ingredient_decline_pic = preload("res://GameHUDRelated/BottomPanel/IngredientMode_CannotCombine.png")


signal tower_being_dragged(tower_self)
signal tower_dropped_from_dragged(tower_self)
signal tower_toggle_show_info
signal tower_in_queue_free
signal update_active_synergy


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
var range_module : RangeModule

var disabled_from_attacking : bool = false

# Ingredient related

var ingredients_absorbed : Dictionary = {} # Map of tower_id (ingredient source) to ingredient_effect
var ingredient_active_limit : int = 2
var ingredient_of_self : IngredientEffect

# Color related

# TODO Non functional for now.. Update soon
var tower_colors : Array = []


# Initialization

func _ready():
	$IngredientDeclinePic.visible = false
	_end_drag()

func _post_inherit_ready():
	if range_module != null:
		range_module.update_range()
	
	for attack_module in attack_modules_and_target_num.keys():
		if attack_module.range_module != null:
			attack_module.range_module.update_range()
	
	# Add things as children
	_add_all_as_children()

func _add_all_as_children():
	if range_module != null:
		add_child(range_module)
	
	for attack_module in attack_modules_and_target_num.keys():
		add_child(attack_module)
		attack_module.range_module = range_module


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !disabled_from_attacking:
		for attack_module in attack_modules_and_target_num.keys():
			if attack_module.current_time_metadata == AbstractAttackModule.Time_Metadata.TIME_AS_SECONDS:
				attack_module.time_passed(delta)
			
			if attack_module.is_ready_to_attack():
				
				var success : bool = false
				# If tower itself does not have a range_module
				if range_module == null:
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


func _on_main_attack_success():
	for am in attack_modules_and_target_num.keys():
		if am.current_time_metadata == AbstractAttackModule.Time_Metadata.TIME_AS_NUM_OF_ATTACKS:
			am.time_passed(1)
			
			if am.is_ready_to_attack():
				am.attempt_find_then_attack_enemies(attack_modules_and_target_num[am])


# Recieving buffs/debuff related

func add_tower_effect(tower_base_effect : TowerBaseEffect):
	if tower_base_effect is TowerAttributesEffect:
		if tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_ATTACK_SPEED or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED:
			_add_attack_speed_effect(tower_base_effect)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_DAMAGE_BONUS:
			_add_base_damage_effect(tower_base_effect)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_RANGE or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_RANGE:
			_add_range_effect(tower_base_effect)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_PIERCE or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_PIERCE:
			_add_pierce_effect(tower_base_effect)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_PROJ_SPEED or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_PROJ_SPEED:
			_add_proj_speed_effect(tower_base_effect)
		
	elif tower_base_effect is TowerOnHitDamageAdderEffect:
		_add_on_hit_damage_adder_effect(tower_base_effect)


func remove_tower_effect(tower_base_effect : TowerBaseEffect):
	if tower_base_effect is TowerAttributesEffect:
		if tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_ATTACK_SPEED or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED:
			_remove_attack_speed_effect(tower_base_effect.effect_uuid)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_DAMAGE_BONUS:
			_remove_base_damage_effect(tower_base_effect.effect_uuid)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_RANGE or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_RANGE:
			_remove_range_effect(tower_base_effect.effect_uuid)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_PIERCE or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_PIERCE:
			_remove_pierce_effect(tower_base_effect.effect_uuid)
		elif tower_base_effect.attribute_type == TowerAttributesEffect.FLAT_PROJ_SPEED or tower_base_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_PROJ_SPEED:
			_remove_proj_speed_effect(tower_base_effect.effect_uuid)
		
	elif tower_base_effect is TowerOnHitDamageAdderEffect:
		_remove_on_hit_damage_adder_effect(tower_base_effect.effect_uuid)


func _add_attack_speed_effect(tower_attr_effect : TowerAttributesEffect):
	for module in attack_modules_and_target_num.keys():
		
		if module.benefits_from_bonus_attack_speed:
			if tower_attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED:
				module.percent_attack_speed_effects[tower_attr_effect.effect_uuid] = tower_attr_effect
			elif tower_attr_effect.attribute_type == TowerAttributesEffect.FLAT_ATTACK_SPEED:
				module.flat_attack_speed_effects[tower_attr_effect.effect_uuid] = tower_attr_effect

func _remove_attack_speed_effect(attr_effect_uuid : int):
	for module in attack_modules_and_target_num.keys():
		
		if module.benefits_from_bonus_attack_speed:
			module.percent_attack_speed_modifiers.erase(attr_effect_uuid)
			module.flat_attack_speed_modifiers.erase(attr_effect_uuid)


func _add_base_damage_effect(attr_effect : TowerAttributesEffect):
	for module in attack_modules_and_target_num.keys():
		
		if module.benefits_from_bonus_base_damage:
			if attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_DAMAGE_BONUS:
				module.percent_base_damage_effects[attr_effect.effect_uuid] = attr_effect
			elif attr_effect.attribute_type == TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS:
				module.flat_base_damage_effects[attr_effect.effect_uuid] = attr_effect

func _remove_base_damage_effect(attr_effect_uuid : int):
	for module in attack_modules_and_target_num.keys():
		
		if module.benefits_from_bonus_damage:
			module.percent_base_damage_effects.erase(attr_effect_uuid)
			module.flat_base_damage_effects.erase(attr_effect_uuid)


func _add_on_hit_damage_adder_effect(on_hit_adder : TowerOnHitDamageAdderEffect):
	for module in attack_modules_and_target_num.keys():
		if module.benefits_from_bonus_on_hit_damage:
			module.on_hit_damage_adder_effects[on_hit_adder.effect_uuid] = on_hit_adder

func _remove_on_hit_damage_adder_effect(on_hit_adder_uuid : int):
	for module in attack_modules_and_target_num.keys():
		
		if module.benefits_from_bonus_on_hit_damage:
			module.on_hit_damage_adder_effects.erase(on_hit_adder_uuid)


func _add_range_effect(attr_effect : TowerAttributesEffect):
	if range_module != null:
		if range_module.range_module.benefits_from_bonus_range:
				if attr_effect.attribute_type == TowerAttributesEffect.FLAT_RANGE:
					range_module.range_module.flat_range_effects[attr_effect.effect_uuid] = attr_effect
				elif attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_RANGE:
					range_module.range_module.percent_range_effects[attr_effect.effect_uuid] = attr_effect
	
	
	for module in attack_modules_and_target_num.keys():
		if module.range_module != null and module.use_self_range_module:
			if module.range_module.benefits_from_bonus_range:
				if attr_effect.attribute_type == TowerAttributesEffect.FLAT_RANGE:
					module.range_module.range_module.flat_range_effects[attr_effect.effect_uuid] = attr_effect
				elif attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_RANGE:
					module.range_module.range_module.percent_range_effects[attr_effect.effect_uuid] = attr_effect

func _remove_range_effect(attr_effect_uuid : int):
	if range_module != null:
		if range_module.benefits_from_bonus_range:
			range_module.range_module.flat_range_effects.erase(attr_effect_uuid)
			range_module.range_module.percent_range_effects.erase(attr_effect_uuid)
	
	for module in attack_modules_and_target_num.keys():
		if module.range_module != null and module.use_self_range_module:
			if module.range_module.benefits_from_bonus_range:
				module.range_module.range_module.flat_range_effects.erase(attr_effect_uuid)
				module.range_module.range_module.percent_range_effects.erase(attr_effect_uuid)

func _add_pierce_effect(attr_effect : TowerAttributesEffect):
	for module in attack_modules_and_target_num.keys():
		
		if module is BulletAttackModule and module.benefits_from_bonus_pierce:
			if attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_PIERCE:
				module.percent_pierce_effects[attr_effect.effect_uuid] = attr_effect
			elif attr_effect.attribute_type == TowerAttributesEffect.FLAT_PIERCE:
				module.flat_pierce_effects[attr_effect.effect_uuid] = attr_effect

func _remove_pierce_effect(attr_effect_uuid : int):
	for module in attack_modules_and_target_num.keys():
		
		if module is BulletAttackModule and module.benefits_from_bonus_pierce:
			module.percent_pierce_effects.erase(attr_effect_uuid)
			module.flat_pierce_effects.erase(attr_effect_uuid)


func _add_proj_speed_effect(attr_effect : TowerAttributesEffect):
	for module in attack_modules_and_target_num.keys():
		
		if module is BulletAttackModule and module.benefits_from_bonus_proj_speed:
			if attr_effect.attribute_type == TowerAttributesEffect.PERCENT_BASE_PROJ_SPEED:
				module.percent_proj_speed_effects[attr_effect.effect_uuid] = attr_effect
			elif attr_effect.attribute_type == TowerAttributesEffect.FLAT_PROJ_SPEED:
				module.flat_proj_speed_effects[attr_effect.effect_uuid] = attr_effect

func _remove_proj_speed_effect(attr_effect_uuid : int):
	for module in attack_modules_and_target_num.keys():
		
		if module is BulletAttackModule and module.benefits_from_bonus_pierce:
			module.percent_proj_speed_effects.erase(attr_effect_uuid)
			module.flat_proj_speed_effects.erase(attr_effect_uuid)

# Ingredient Related

func absorb_ingredient(ingredient_effect : IngredientEffect):
	if ingredient_effect != null:
		ingredients_absorbed[ingredient_effect.tower_id] = ingredient_effect
		add_tower_effect(ingredient_effect.tower_base_effect)

func clear_ingredients():
	for ingredient_effect in ingredients_absorbed:
		remove_tower_effect(ingredient_effect.tower_base_effect)
	
	ingredients_absorbed.clear()


func _can_accept_ingredient(ingredient_effect : IngredientEffect) -> bool:
	if ingredients_absorbed.size() >= ingredient_active_limit:
		return false
	
	if ingredient_effect != null:
		if ingredients_absorbed.has(ingredient_effect.tower_id):
			return false
		
		for color in ingredient_effect.compatible_colors:
			if tower_colors.has(color):
				return true
	
	return false

func show_acceptability_with_ingredient(ingredient_effect : IngredientEffect, tower_selected):
	if tower_selected != self:
		var can_accept = _can_accept_ingredient(ingredient_effect)
		
		$IngredientDeclinePic.visible = !can_accept

func hide_acceptability_with_ingredient():
	$IngredientDeclinePic.visible = false

# Inputs related

func _on_ClickableArea_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_RIGHT:
			_toggle_show_tower_info()
		elif event.pressed and event.button_index == BUTTON_LEFT:
			_start_drag()
		elif !event.pressed and event.button_index == BUTTON_LEFT:
			if is_being_dragged:
				_end_drag()
		


# Show Ranges of modules and Tower Info

func toggle_module_ranges():
	if range_module != null:
		range_module.toggle_show_range()
	
	for attack_module in attack_modules_and_target_num.keys():
		if attack_module.range_module != null and attack_module.use_self_range_module:
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
			new_area_placable.tower_occupying.transfer_to_placable(current_placable, true)
		else:
			var target_tower = new_area_placable.tower_occupying
			
			if target_tower._can_accept_ingredient(ingredient_of_self):
				_give_self_ingredient_buff_to(target_tower)
				return
			else:
				new_area_placable.tower_occupying.transfer_to_placable(current_placable, true)
	
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
		elif current_placable is InMapAreaPlacable:
			disabled_from_attacking = false
			_enable_modules()
			is_contributing_to_synergy = true
	
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
	absorber.absorb_ingredient(ingredient_of_self)
	queue_free()




# Tracking of towers related
func queue_free():
	is_contributing_to_synergy = false
	emit_signal("tower_in_queue_free")
	.queue_free()
