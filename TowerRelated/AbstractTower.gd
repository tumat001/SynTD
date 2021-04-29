extends Area2D

const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")
const Targeting = preload("res://GameInfoRelated/Targeting.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const BaseAreaTowerPlacable = preload("res://GameElementsRelated/AreaTowerPlacablesRelated/BaseAreaTowerPlacable.gd")
const TowerBenchSlot = preload("res://GameElementsRelated/AreaTowerPlacablesRelated/TowerBenchSlot.gd")
const InMapAreaPlacable = preload("res://GameElementsRelated/InMapPlacablesRelated/InMapAreaPlacable.gd")
const AbstractAttackModule = preload("res://TowerRelated/AbstractAttackModule.gd")


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
var disabled_from_attacking : bool = false

var current_power_level_used : int

var ingredients_absorbed : Dictionary = {}

var attack_modules : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	_end_drag()

func _post_inherit_ready():
	for attack_module in attack_modules:
		attack_module._update_range()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	for attack_module in attack_modules:
		if attack_module.current_time_metadata == AbstractAttackModule.Time_Metadata.TIME_AS_SECONDS:
			attack_module.time_passed(delta)
		
		if attack_module.is_ready_to_attack():
			var success = attack_module.attempt_find_then_attack_enemy()
			if attack_module.is_main_attack and success:
				_on_main_attack_success()
		
	
	#Drag related
	if is_being_dragged:
		var mouse_pos = get_global_mouse_position()
		position.x = mouse_pos.x
		position.y = mouse_pos.y


func _on_main_attack_success():
	for am in attack_modules:
		if am.current_time_metadata == AbstractAttackModule.Time_Metadata.TIME_AS_NUM_OF_ATTACKS:
			am.time_passed(1)
			
			if am.is_ready_to_attack():
				am.attempt_find_then_attack_enemy()



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
	for module in attack_modules:
		module._toggle_show_range()

func _show_tower_info():
	emit_signal("tower_show_info")


# Drag and Drop things related

func _start_drag():
	$PlacableDetector/DetectorShape.set_deferred("disabled", false)
	$PlacableDetector.monitoring = true
	is_being_dragged = true
	disabled_from_attacking = true
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
		$ClickableArea/ClickableShape.shape.extents = current_placable.get_area_shape().extents
	
	$PlacableDetector/DetectorShape.set_deferred("disabled", true)
	$PlacableDetector.monitoring = false
	is_being_dragged = false
	
	if current_placable != null:
		var pos = current_placable.get_tower_center_position()
		position.x = pos.x
		position.y = pos.y
		
		if current_placable is TowerBenchSlot:
			disabled_from_attacking = true
			is_contributing_to_synergy = false
		elif current_placable is InMapAreaPlacable:
			disabled_from_attacking = false
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
