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

signal tower_being_dragged
signal tower_dropped_from_dragged
signal tower_show_info
signal tower_in_queue_free
signal update_active_synergy

export var tower_highlight_sprite : Resource

var tower_id : int

###

var hovering_over_placable : BaseAreaTowerPlacable
var current_placable : BaseAreaTowerPlacable
var is_contributing_to_synergy : bool

var is_being_dragged : bool = false

#####

var collision_shape

var current_power_level_used : int

var ingredients_absorbed : Dictionary = {}

var attack_modules_and_target_num : Dictionary = {}
var range_module : RangeModule

var disabled_from_attacking : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
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

func add_attack_speed_modifier(modifier : Modifier):
	for module in attack_modules_and_target_num.keys():
		
		if module.benefits_from_bonus_attack_speed:
			if modifier is PercentModifier:
				module.percent_attack_speed_modifiers[modifier.internal_name] = modifier
			elif modifier is FlatModifier:
				module.flat_attack_speed_modifiers[modifier.internal_name] = modifier

func remove_attack_speed_modifier(modifier_name : String):
	for module in attack_modules_and_target_num.keys():
		
		if module.benefits_from_bonus_attack_speed:
			module.percent_attack_speed_modifiers.erase(modifier_name)
			module.flat_attack_speed_modifiers.erase(modifier_name)


func add_base_damage_modifier(modifier : Modifier):
	for module in attack_modules_and_target_num.keys():
		
		if module.benefits_from_bonus_base_damage:
			if modifier is PercentModifier:
				module.percent_base_damage_modifiers[modifier.internal_name] = modifier
			elif modifier is FlatModifier:
				module.flat_base_damage_modifiers[modifier.internal_name] = modifier

func remove_base_damage_modifier(modifier_name : String):
	for module in attack_modules_and_target_num.keys():
		
		if module.benefits_from_bonus_damage:
			module.percent_base_damage_modifiers.erase(modifier_name)
			module.flat_base_damage_modifiers.erase(modifier_name)


func add_extra_on_hit_damage(on_hit_damage : OnHitDamage):
	for module in attack_modules_and_target_num.keys():
		var modifier = on_hit_damage.damage_as_modifier
		
		if module.benefits_from_bonus_on_hit_damage:
			module.extra_on_hit_damages[on_hit_damage.internal_name] = on_hit_damage

func remove_extra_on_hit_damage(on_hit_damage_name : String):
	for module in attack_modules_and_target_num.keys():
		
		if module.benefits_from_bonus_on_hit_damage:
			module.extra_on_hit_damages.erase(on_hit_damage_name)


func add_base_range_modifier(modifier : Modifier):
	if range_module != null:
		if range_module.range_module.benefits_from_bonus_range:
				if modifier is FlatModifier:
					range_module.range_module.flat_range_modifiers[modifier.internal_name] = modifier
				elif modifier is PercentModifier:
					range_module.range_module.percent_range_modifiers[modifier.internal_name] = modifier
	
	
	for module in attack_modules_and_target_num.keys():
		
		if module.range_module != null:
			if module.range_module.benefits_from_bonus_range:
				if modifier is FlatModifier:
					module.range_module.flat_range_modifiers[modifier.internal_name] = modifier
				elif modifier is PercentModifier:
					module.range_module.percent_range_modifiers[modifier.internal_name] = modifier

func remove_base_range_modifier(modifier_name : String):
	if range_module != null:
		if range_module.benefits_from_bonus_range:
			range_module.range_module.flat_range_modifiers.erase(modifier_name)
			range_module.range_module.percent_range_modifiers.erase(modifier_name)
	
	
	for module in attack_modules_and_target_num.keys():
		
		if module.range_module != null:
			if module.range_module.benefits_from_bonus_range:
					module.range_module.flat_range_modifiers.erase(modifier_name)
					module.range_module.percent_range_modifiers.erase(modifier_name)

# Inputs related

func _on_ClickableArea_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_RIGHT:
			_toggle_module_ranges()
			_show_tower_info()
		elif event.pressed and event.button_index == BUTTON_LEFT:
			_start_drag()
		elif !event.pressed and event.button_index == BUTTON_LEFT:
			if is_being_dragged:
				_end_drag()


# Show Ranges of modules and Tower Info

func _toggle_module_ranges():
	if range_module != null:
		range_module.toggle_show_range()
	
	for attack_module in attack_modules_and_target_num.keys():
		if attack_module.range_module != null:
			attack_module.range_module.toggle_show_range()
	

func _show_tower_info():
	emit_signal("tower_show_info")


# Disable Modules for whatever reason

func _disable_modules():
	for module in attack_modules_and_target_num.keys():
		module.disable_module()

func _enable_modules():
	for module in attack_modules_and_target_num.keys():
		module.enable_module()


# Drag and Drop things related

func _start_drag():
	$PlacableDetector/DetectorShape.set_deferred("disabled", false)
	$PlacableDetector.monitoring = true
	is_being_dragged = true
	disabled_from_attacking = true
	_disable_modules()
	z_index = ZIndexStore.TOWERS_BEING_DRAGGED
	
	emit_signal("tower_being_dragged")

func _end_drag():
	z_index = ZIndexStore.TOWERS
	transfer_to_placable(hovering_over_placable)
	emit_signal("tower_dropped_from_dragged")


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
		new_area_placable.tower_occupying.transfer_to_placable(current_placable, true)
	
	# The "new" one
	if new_area_placable != null:
		current_placable = new_area_placable
		current_placable.tower_occupying = self
		$ClickableArea/ClickableShape.shape = current_placable.get_area_shape()
	
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
		hovering_over_placable.set_tower_highlight_sprite(tower_highlight_sprite)

func _on_PlacableDetector_area_exited(area):
	if area is BaseAreaTowerPlacable:
		area.set_tower_highlight_sprite(null)
		if hovering_over_placable == area:
			hovering_over_placable = null


# Tracking of towers related
func queue_free():
	is_contributing_to_synergy = false
	emit_signal("tower_in_queue_free")
	.queue_free()
