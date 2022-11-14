extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const EnemyEffect_MiniTesla_IngEffect = preload("res://GameInfoRelated/EnemyEffectRelated/MiscEffects/TowerSourced/EnemyEffect_MiniTesla_IngEffect.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")


const stack_count_trigger_for_stun : int = 5

var full_stun_duration : float = 2.0
var sub_stun_duration : float = 0.2

const number_of_full_duration_apply_limit : int = 3

var plain_text_fragment__stuns

func _init().(StoreOfTowerEffectsUUID.ING_MINI_TESLA):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Static.png")
	plain_text_fragment__stuns = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stuns")
	
	_update_description()
	
	_can_be_scaled_by_yel_vio = true

func _update_description():
	description = ["%s attacks against an enemy |0| them for %s seconds. Enemies are stunned only for %s seconds after being stunned by this for %s times.%s" % [str(stack_count_trigger_for_stun), str(full_stun_duration * _current_additive_scale), str(sub_stun_duration * _current_additive_scale), str(number_of_full_duration_apply_limit), _generate_desc_for_persisting_total_additive_scaling(true)], [plain_text_fragment__stuns]]


#

func _make_modifications_to_tower(tower):
	if !tower.is_connected("on_any_attack_module_enemy_hit", self, "_on_any_attack_module_enemy_hit"):
		tower.connect("on_any_attack_module_enemy_hit", self, "_on_any_attack_module_enemy_hit", [], CONNECT_PERSIST)


func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_any_attack_module_enemy_hit", self, "_on_any_attack_module_enemy_hit"):
		tower.disconnect("on_any_attack_module_enemy_hit", self, "_on_any_attack_module_enemy_hit")


#

func _on_any_attack_module_enemy_hit(enemy, damage_register_id, damage_instance, module):
	if is_instance_valid(module) and is_instance_valid(enemy) and module.benefits_from_bonus_on_hit_effect:
		var effect = enemy.get_effect_with_uuid(StoreOfEnemyEffectsUUID.ING_MINI_TESLA_ENEMY_STACK_TRACKER)
		
		if effect == null:
			var stun_tracker_effect = EnemyEffect_MiniTesla_IngEffect.new()
			stun_tracker_effect.stack_count_trigger_for_stun = stack_count_trigger_for_stun
			stun_tracker_effect.full_stun_duration = full_stun_duration
			stun_tracker_effect.sub_stun_duration = sub_stun_duration
			stun_tracker_effect.number_of_full_duration_apply_limit = number_of_full_duration_apply_limit
			
			effect = enemy._add_effect(stun_tracker_effect, 1, false, false)
		else:
			effect.increase_stack_count(1)

#####

# SCALING related. Used by YelVio only.
func add_additive_scaling_by_amount(arg_amount):
	.add_additive_scaling_by_amount(arg_amount)
	
	_update_description()

func _consume_current_additive_scaling_for_actual_scaling_in_stats():
	full_stun_duration *= _current_additive_scale
	sub_stun_duration *= _current_additive_scale
	_current_additive_scale = 1


