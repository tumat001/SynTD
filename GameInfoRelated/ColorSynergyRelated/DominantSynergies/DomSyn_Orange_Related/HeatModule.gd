
const TowerBaseEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd")
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")

const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const TowerOnHitDamageAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitDamageAdderEffect.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const TowerOnHitEffectAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitEffectAdderEffect.gd")
const EnemyBaseEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd")

const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")


signal should_be_shown_in_info_panel_changed
signal current_heat_changed
signal max_heat_per_round_reached
signal heat_per_attack_changed
signal on_round_end

signal current_heat_effect_changed
signal base_heat_effect_changed

signal in_overheat_cooldown
signal on_overheat_reached


var base_effect_multiplier : float = 1 setget set_base_effect_multiplier
var base_heat_effect : TowerBaseEffect setget set_base_heat_effect
var current_heat_effect : TowerBaseEffect

var tower : AbstractTower setget set_tower

const max_heat : int = 100
const heat_reduction_per_inactive_round : int = 50
var heat_per_attack : int = 1 setget set_heat_per_attack
var current_heat : int = 0 setget set_current_heat
var _current_heat_gained_in_round : int
const max_heat_gain_per_round : int = 74
var last_calculated_final_effect_multiplier : float

var is_max_heat_per_round_reached : bool
var is_in_overheat_active : bool
var is_in_overheat_cooldown : bool

var has_attacked_in_round : bool


# Syn stuffs
var should_be_shown_in_info_panel : bool setget set_should_be_shown_in_info_panel
var overheat_effects : Array

# trail related

var multiple_trails_component : MultipleTrailsForNodeComponent

const heat_needed_for_show_trail : int = 25
var _current_should_show_trail : bool

const trail_color : Color = Color(0.8, 0.35, 0, 0.75)

const base_trail_length : int = 5
const trail_length_multiplier_per_100_heat : int = 1
var _current_trail_length : int = base_trail_length

const base_trail_width : int = 3
const trail_width_multiplier_per_100_heat : int = 1
var _current_trail_width : int = base_trail_width


func _init():
	pass


# round related
# Note: accessed by domsyn_orange thru signal
func on_round_end():
	_current_heat_gained_in_round = 0
	is_max_heat_per_round_reached = false
	
	if is_instance_valid(tower): #and tower.is_current_placable_in_map():
		if is_in_overheat_active:
			is_in_overheat_active = false
			set_current_heat(0)
			
			
			#is_in_overheat_cooldown = true
			#is_in_overheat_active = false
			#_tower_exited_overheat()
			#
			#tower.set_disabled_from_attacking_clause(tower.DisabledFromAttackingSourceClauses.HEAT_MODULE)
			
		else:
			pass
			#is_in_overheat_cooldown = false
			
			#if tower.disabled_from_attacking_clauses.has_clause(tower.DisabledFromAttackingSourceClauses.HEAT_MODULE):
			#	# INTENTIONAL THAT THE SET METHOD IS NOT USED
			#	current_heat = 0
			#	tower.erase_disabled_from_attacking_clause(tower.DisabledFromAttackingSourceClauses.HEAT_MODULE)
		
		
		if !has_attacked_in_round:
			set_current_heat(current_heat - heat_reduction_per_inactive_round)
	
	has_attacked_in_round = false
	
	call_deferred("emit_signal", "on_round_end")


# setters and incs

func increment_current_heat(arg_increment : int = heat_per_attack):
	if _current_heat_gained_in_round < max_heat_gain_per_round and !is_max_heat_per_round_reached:
		var total = _current_heat_gained_in_round + arg_increment
		var inc = arg_increment
		
		if total > max_heat_gain_per_round:
			inc = total - max_heat_gain_per_round
		
		_current_heat_gained_in_round += inc
		
		if _current_heat_gained_in_round >= max_heat_gain_per_round:
			set_max_heat_reached_in_round()
		
		set_current_heat(current_heat + inc)


func set_max_heat_reached_in_round():
	is_max_heat_per_round_reached = true
	call_deferred("emit_signal", "max_heat_per_round_reached")



func set_current_heat(arg_current_heat : int):
	current_heat = arg_current_heat
	if current_heat > 100:
		current_heat = 100
	elif current_heat < 0:
		current_heat = 0
	
	if current_heat == 100:
		if !is_in_overheat_active:
			_tower_reached_overheat()
		is_in_overheat_active = true
	
	call_deferred("emit_signal", "current_heat_changed")
	_calculate_final_effect_multiplier()
	update_current_heat_effect()
	
	
	_current_should_show_trail = current_heat >= heat_needed_for_show_trail
	_current_trail_length = base_trail_length + (base_trail_length * trail_length_multiplier_per_100_heat * (current_heat / 100.0))
	_current_trail_width = base_trail_width + (base_trail_width * trail_width_multiplier_per_100_heat * (current_heat / 100.0))

func set_base_heat_effect(arg_heat_effect : TowerBaseEffect):
	base_heat_effect = arg_heat_effect
	
	if arg_heat_effect != null:
		base_heat_effect.effect_uuid = StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT
		call_deferred("emit_signal", "base_heat_effect_changed")
		
		current_heat_effect = base_heat_effect._shallow_duplicate()
		update_current_heat_effect()
		
		if is_instance_valid(tower):
			_set_tower_current_heat_effect()

# Note: accessed by domsyn_orange thru signal
func set_base_effect_multiplier(scale : float):
	base_effect_multiplier = scale
	_calculate_final_effect_multiplier()
	update_current_heat_effect()


func set_tower(arg_tower : AbstractTower):
	if is_instance_valid(tower):
		_remove_tower_current_heat_effect()
		
		if tower.is_connected("on_main_attack_finished", self, "_on_tower_attack_finished"):
			tower.disconnect("on_main_attack_finished", self, "_on_tower_attack_finished")
			tower.disconnect("on_main_bullet_attack_module_after_bullet_is_shot", self, "_tower_after_bullet_shot")
	
	tower = arg_tower
	
	if is_instance_valid(tower):
		_set_tower_current_heat_effect()
		_calculate_final_effect_multiplier()
		
		if !tower.is_connected("on_main_attack_finished", self, "_on_tower_attack_finished"):
			tower.connect("on_main_attack_finished", self, "_on_tower_attack_finished", [], CONNECT_PERSIST)
			tower.connect("on_main_bullet_attack_module_after_bullet_is_shot", self, "_tower_after_bullet_shot", [], CONNECT_PERSIST)
		
		if multiple_trails_component == null:
			_construct_multiple_trails_component(tower)
		multiple_trails_component.node_to_host_trails = arg_tower


func set_should_be_shown_in_info_panel(value : bool):
	should_be_shown_in_info_panel = value
	
	if is_instance_valid(tower) and !tower.is_queued_for_deletion():
		call_deferred("emit_signal", "should_be_shown_in_info_panel_changed")


func set_heat_per_attack(arg_heat_per_attack : int):
	heat_per_attack = arg_heat_per_attack
	call_deferred("emit_signal", "heat_per_attack_changed")


# trail

func _construct_multiple_trails_component(arg_tower):
	multiple_trails_component = MultipleTrailsForNodeComponent.new()
	
	multiple_trails_component.trail_type_id = StoreOfTrailType.BASIC_TRAIL
	multiple_trails_component.connect("on_trail_before_attached_to_node", self, "_trail_before_attached_to_node", [], CONNECT_PERSIST)
	

# Tower related

func _on_tower_attack_finished(_module):
	if base_effect_multiplier != 0: # if not disabled
		has_attacked_in_round = true
		increment_current_heat()


# One time set until removal.. 
# Any modifications will be handled
# due to how objects work (reference)
func _set_tower_current_heat_effect():
	if current_heat_effect != null and !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT):
		tower.add_tower_effect(current_heat_effect)

func _remove_tower_current_heat_effect():
	if tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT):
		tower.remove_tower_effect(current_heat_effect)


func _tower_reached_overheat():
	# pass overheat effects to tower
	call_deferred("emit_signal", "on_overheat_reached")

func _tower_exited_overheat():
	call_deferred("emit_signal", "in_overheat_cooldown")


# Current heat effect calcs/updates

func update_current_heat_effect():
	var scale = last_calculated_final_effect_multiplier
	var s_copy = current_heat_effect
	
	if base_heat_effect is TowerAttributesEffect:
		var modifier_copy = base_heat_effect.attribute_as_modifier.get_copy_scaled_by(scale)
		s_copy.attribute_as_modifier = modifier_copy
		
	elif base_heat_effect is TowerOnHitDamageAdderEffect:
		var on_hit_d_copy : OnHitDamage = base_heat_effect.on_hit_damage.duplicate()
		on_hit_d_copy.damage_as_modifier = on_hit_d_copy.damage_as_modifier.get_copy_scaled_by(scale)
		s_copy.on_hit_damage = on_hit_d_copy
	
	elif base_heat_effect is TowerOnHitEffectAdderEffect:
		var effect_copy = base_heat_effect.enemy_base_effect._get_copy_scaled_by(scale)
		s_copy.enemy_base_effect = effect_copy
	
	
	current_heat_effect = s_copy
	
	emit_signal("current_heat_effect_changed")

# Stat calculation related

func _calculate_final_effect_multiplier():
	var step_and_remainder : Array = _calculate_effect_step_and_remainder()
	step_and_remainder[1] = _calculate_remainder_true_multiplier(step_and_remainder[1])
	
	last_calculated_final_effect_multiplier = (step_and_remainder[0] + step_and_remainder[1]) * base_effect_multiplier
	return last_calculated_final_effect_multiplier


func _calculate_effect_step_and_remainder() -> Array:
	var ratio = float(current_heat) / float(max_heat)
	var n = ratio * 4
	
	var step : float = floor(n)
	var remainder : float = (n - step) / 4
	
	step /= 4
	
	return [step, remainder]

func _calculate_remainder_true_multiplier(remainder : float):
	return ((remainder * remainder) / (0.25 * 0.25)) / 4


# MAX

func get_max_effect():
	var scale = base_effect_multiplier
	var s_copy = base_heat_effect._shallow_duplicate()
	
	if base_heat_effect is TowerAttributesEffect:
		var modifier_copy = base_heat_effect.attribute_as_modifier.get_copy_scaled_by(scale)
		s_copy.attribute_as_modifier = modifier_copy
		
	elif base_heat_effect is TowerOnHitDamageAdderEffect:
		var on_hit_d_copy : OnHitDamage = base_heat_effect.on_hit_damage.duplicate()
		on_hit_d_copy.damage_as_modifier = on_hit_d_copy.damage_as_modifier.get_copy_scaled_by(scale)
		s_copy.on_hit_damage = on_hit_d_copy
	
	elif base_heat_effect is TowerOnHitEffectAdderEffect:
		var effect_copy = base_heat_effect.enemy_base_effect._get_copy_scaled_by(scale)
		s_copy.enemy_base_effect = effect_copy
	
	return s_copy


## TRAIL related

func _tower_after_bullet_shot(arg_bullet, module):
	if _current_should_show_trail:
		multiple_trails_component.create_trail_for_node(arg_bullet)


func _trail_before_attached_to_node(arg_trail, node):
	arg_trail.max_trail_length = _current_trail_length
	arg_trail.trail_color = trail_color
	arg_trail.width = _current_trail_width
	#arg_trail.modulate.a = trail_transparency
	
