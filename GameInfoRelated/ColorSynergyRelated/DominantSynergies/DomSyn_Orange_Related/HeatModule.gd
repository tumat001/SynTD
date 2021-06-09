
const TowerBaseEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd")
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")

const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const TowerOnHitDamageAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitDamageAdderEffect.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const TowerOnHitEffectAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitEffectAdderEffect.gd")
const EnemyBaseEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd")


signal should_be_shown_in_info_panel_changed
signal current_heat_changed
signal max_heat_per_round_reached
signal heat_per_attack_changed
signal on_round_end

signal current_heat_effect_changed
signal base_heat_effect_changed


var base_effect_multiplier : float = 1
var base_heat_effect : TowerBaseEffect setget set_base_heat_effect
var current_heat_effect : TowerBaseEffect

var tower : AbstractTower setget set_tower

const max_heat : int = 100
const heat_reduction_per_inactive_round : int = 50
var heat_per_attack : int setget set_heat_per_attack
var current_heat : int setget set_current_heat
var _current_heat_gained_in_round : int
const max_heat_gain_per_round : int = 75
var last_calculated_final_effect_multiplier : float

var is_max_heat_per_round_reached : bool
var is_in_overheat_active : bool
var is_in_overheat_cooldown : bool

var has_attacked_in_round : bool


# Syn stuffs
var should_be_shown_in_info_panel : bool
var overheat_effects : Array

func _init():
	pass


# round related

func on_round_end():
	has_attacked_in_round = false
	_current_heat_gained_in_round = 0
	is_max_heat_per_round_reached = false
	
	if tower != null and tower.is_current_placable_in_map():
		if is_in_overheat_active:
			is_in_overheat_cooldown = true
			is_in_overheat_active = false
			_tower_exited_overheat()
			
			tower.set_disabled_from_attacking_clause(tower.DisabledFromAttackingSource.HEAT_MODULE, true)
			
		else:
			is_in_overheat_cooldown = false
			
			if tower._other_disabled_from_attacking_clauses.has(tower.DisabledFromAttackingSource.HEAT_MODULE):
				tower.erase_disabled_from_attacking_clause(tower.DisabledFromAttackingSource.HEAT_MODULE)
		
		
		if !has_attacked_in_round:
			set_current_heat(current_heat - heat_reduction_per_inactive_round)
	
	call_deferred("emit_signal", "on_round_end")

# setters and incs

func increment_current_heat():
	if _current_heat_gained_in_round < max_heat_gain_per_round:
		var total = _current_heat_gained_in_round + heat_per_attack
		var inc = heat_per_attack
		if total > max_heat_gain_per_round:
			inc = total - max_heat_gain_per_round
		
		_current_heat_gained_in_round += inc
		
		if _current_heat_gained_in_round >= max_heat_gain_per_round:
			is_max_heat_per_round_reached = true
			call_deferred("emit_signal", "max_heat_per_round_reached")
		
		
		set_current_heat(current_heat + inc)


func set_current_heat(arg_current_heat : int):
	current_heat = arg_current_heat
	if current_heat > 100:
		current_heat = 100
	elif current_heat < 0:
		current_heat = 0
	
	if current_heat == 100:
		is_in_overheat_active = true
		call_deferred("_tower_reached_overheat")
	
	call_deferred("emit_signal", "current_heat_changed")
	update_current_heat_effect()

func set_base_heat_effect(arg_heat_effect : TowerBaseEffect):
	base_heat_effect = arg_heat_effect
	base_heat_effect.effect_uuid = StoreOfTowerEffectsUUID.HEAT_MODULE_EFFECT
	call_deferred("emit_signal", "base_heat_effect_changed")
	update_current_heat_effect()
	
	if tower != null:
		_set_tower_current_heat_effect()


func set_base_effect_multiplier(scale : float):
	base_effect_multiplier = scale
	update_current_heat_effect()


func set_tower(arg_tower : AbstractTower):
	if tower != null:
		_remove_tower_current_heat_effect()
		
		if tower.is_connected("on_main_attack_finished", self, "_on_tower_attack_finished"):
			tower.disconnect("on_main_attack_finished", self, "_on_tower_attack_finished")
	
	tower = arg_tower
	
	if tower != null:
		_set_tower_current_heat_effect()
		
		if !tower.is_connected("on_main_attack_finished", self, "_on_tower_attack_finished"):
			tower.connect("on_main_attack_finished", self, "_on_tower_attack_finished")


func set_should_be_shown_in_info_panel(value : bool):
	should_be_shown_in_info_panel = value
	call_deferred("emit_signal", "should_be_shown_in_info_panel_changed")


func set_heat_per_attack(arg_heat_per_attack : int):
	heat_per_attack = arg_heat_per_attack
	call_deferred("emit_signal", "heat_per_attack_changed")


# Tower related

func _on_tower_attack_finished(_module):
	has_attacked_in_round = true
	increment_current_heat()


# One time set.. Any modifications will be handled
# due to how objects work (reference)
func _set_tower_current_heat_effect():
	if current_heat_effect != null and !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT):
		tower.add_tower_effect(current_heat_effect)

func _remove_tower_current_heat_effect():
	if tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT):
		tower.remove_tower_effect(current_heat_effect)


func _tower_reached_overheat():
	# pass overheat effects to tower
	pass

func _tower_exited_overheat():
	pass

# Current heat effect calcs/updates

func update_current_heat_effect():
	var scale = _calculate_final_effect_multiplier()
	var s_copy
	
	if base_heat_effect is TowerAttributesEffect:
		s_copy = base_heat_effect._shallow_duplicate()
		var modifier_copy = s_copy.attribute_as_modifier.get_copy_scaled_by(scale)
		s_copy.attribute_as_modifier = modifier_copy
		
		current_heat_effect = s_copy
		
	elif base_heat_effect is TowerOnHitDamageAdderEffect:
		s_copy = base_heat_effect._shallow_duplicate()
		var on_hit_d_copy : OnHitDamage = s_copy.on_hit_damage.duplicate()
		on_hit_d_copy.damage_as_modifier = on_hit_d_copy.damage_as_modifier.get_copy_scaled_by(scale)
		s_copy.on_hit_damage = on_hit_d_copy
		
		current_heat_effect = s_copy
		
	elif base_heat_effect is TowerOnHitEffectAdderEffect:
		s_copy = base_heat_effect._shallow_duplicate()
		var effect_copy = s_copy.enemy_base_effect._get_copy_scaled_by(scale)
		s_copy.enemy_base_effect = effect_copy
		
		current_heat_effect = s_copy
	
	call_deferred("emit_signal", "current_heat_effect_changed")


# Stat calculation related

func _calculate_final_effect_multiplier():
	var step_and_remainder : Array = _calculate_effect_step_and_remainder()
	step_and_remainder[1] = _calculate_remainder_true_multiplier(step_and_remainder[1])
	
	last_calculated_final_effect_multiplier = (step_and_remainder[0] + step_and_remainder[1]) * base_effect_multiplier
	return last_calculated_final_effect_multiplier


func _calculate_effect_step_and_remainder() -> Array:
	var ratio = current_heat / max_heat
	var n = (ratio / 100) * 4
	
	var step : float = round(n)
	var remainder : float = n -  step
	
	step /= 4
	
	return [step, remainder]

func _calculate_remainder_true_multiplier(remainder : float):
	return remainder * remainder