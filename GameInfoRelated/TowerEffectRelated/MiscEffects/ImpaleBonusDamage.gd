extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"


const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const PercentModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")


const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")


const bonus_damage_percent_threshold : float = 0.75

var bonus_damage_new_scale : float = 1.20
var bonus_damage_new_scale_against_normal_typed : float = 1.30


func _init().(StoreOfTowerEffectsUUID.ING_IMPALE):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Impale.png")
	
	_update_description()
	
	_can_be_scaled_by_yel_vio = true


func _update_description():
	#
	var interpreter_for_bonus_dmg_on_threshold = TextFragmentInterpreter.new()
	interpreter_for_bonus_dmg_on_threshold.display_body = false
	
	var ins_for_bonus_dmg_on_threshold = []
	ins_for_bonus_dmg_on_threshold.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "more damage", (bonus_damage_new_scale - 1.0) * 100.0 * _current_additive_scale, true))
	
	interpreter_for_bonus_dmg_on_threshold.array_of_instructions = ins_for_bonus_dmg_on_threshold
	
	#
	var interpreter_for_bonus_dmg_normals_on_threshold = TextFragmentInterpreter.new()
	interpreter_for_bonus_dmg_normals_on_threshold.display_body = false
	
	var ins_for_bonus_dmg_normals_on_threshold = []
	ins_for_bonus_dmg_normals_on_threshold.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "", (bonus_damage_new_scale_against_normal_typed - 1.0) * 100.0 * _current_additive_scale, true))
	
	interpreter_for_bonus_dmg_normals_on_threshold.array_of_instructions = ins_for_bonus_dmg_normals_on_threshold
	
	#
	
	description = ["All of the tower's attacks deal |0| to enemies below 75%% health. The damage bonus is increased to |1| against Normal typed enemies.%s" % [_generate_desc_for_persisting_total_additive_scaling(true)], [interpreter_for_bonus_dmg_on_threshold, interpreter_for_bonus_dmg_normals_on_threshold]]




func _make_modifications_to_tower(tower):
	if !tower.is_connected("on_any_attack_module_enemy_hit", self, "_on_enemy_hit_s"):
		tower.connect("on_any_attack_module_enemy_hit", self, "_on_enemy_hit_s", [], CONNECT_PERSIST)


func _on_enemy_hit_s(enemy, damage_register_id, damage_instance, module):
	if enemy._last_calculated_max_health != 0:
		var ratio_health = enemy.current_health / enemy._last_calculated_max_health
		
		if ratio_health < bonus_damage_percent_threshold:
			if enemy.is_enemy_type_normal():
				damage_instance.scale_only_damage_by(bonus_damage_new_scale_against_normal_typed)
			else:
				damage_instance.scale_only_damage_by(bonus_damage_new_scale)


func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_any_attack_module_enemy_hit", self, "_on_enemy_hit_s"):
		tower.disconnect("on_any_attack_module_enemy_hit", self, "_on_enemy_hit_s")

#

func _shallow_duplicate():
	var copy = get_script().new()
	_configure_copy_to_match_self(copy)
	
	return copy


# SCALING related. Used by YelVio only.
func add_additive_scaling_by_amount(arg_amount):
	.add_additive_scaling_by_amount(arg_amount)
	
	_update_description()

func _consume_current_additive_scaling_for_actual_scaling_in_stats():
	bonus_damage_new_scale *= _current_additive_scale
	bonus_damage_new_scale_against_normal_typed *= _current_additive_scale
	
	_current_additive_scale = 1

