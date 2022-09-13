extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")


const bonus_damage_percent_threshold : float = 0.5
var bonus_damage : float
var bonus_on_hit : OnHitDamage

func _init(arg_bonus_dmg : float).(StoreOfTowerEffectsUUID.ING_SPIKE):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Spike.png")
	
	bonus_damage = arg_bonus_dmg
	
	_update_description()
	_can_be_scaled_by_yel_vio = true


func _update_description():
	var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
	interpreter_for_flat_on_hit.display_body = false
	
	var ins_for_flat_on_hit = []
	ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL, "additional physical damage", bonus_damage * _current_additive_scale))
	
	interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
	
	
	description = ["All of the tower's attacks deal |0| to enemies below 50%% health.%s" % [_generate_desc_for_persisting_total_additive_scaling(true)], [interpreter_for_flat_on_hit]]




func _make_modifications_to_tower(tower):
	if bonus_on_hit == null:
		_construct_bonus_damage()
	
	if !tower.is_connected("on_any_attack_module_enemy_hit", self, "_on_enemy_hit_s"):
		tower.connect("on_any_attack_module_enemy_hit", self, "_on_enemy_hit_s", [], CONNECT_PERSIST)


func _construct_bonus_damage():
	var mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_SPIKE)
	mod.flat_modifier = bonus_damage
	
	bonus_on_hit = OnHitDamage.new(StoreOfTowerEffectsUUID.ING_SPIKE, mod, DamageType.PHYSICAL)


func _on_enemy_hit_s(enemy, damage_register_id, damage_instance, module):
	if enemy._last_calculated_max_health != 0:
		var ratio_health = enemy.current_health / enemy._last_calculated_max_health
		
		if ratio_health < bonus_damage_percent_threshold:
			damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.ING_SPIKE] = bonus_on_hit



func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_any_attack_module_enemy_hit", self, "_on_enemy_hit_s"):
		tower.disconnect("on_any_attack_module_enemy_hit", self, "_on_enemy_hit_s")


#

# SCALING related. Used by YelVio only.
func add_additive_scaling_by_amount(arg_amount):
	.add_additive_scaling_by_amount(arg_amount)
	
	_update_description()

func _consume_current_additive_scaling_for_actual_scaling_in_stats():
	bonus_damage *= _current_additive_scale
	_current_additive_scale = 1


