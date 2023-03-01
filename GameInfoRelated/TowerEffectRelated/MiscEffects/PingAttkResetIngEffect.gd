extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

# TODO NOT DONE YET..

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

const TowerDamageInstanceScaleBoostEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerDamageInstanceScaleBoostEffect.gd")

#

var bonus_damage_scale_on_reset : float = 1.0

var _scale_multiplier = 1.0


var _tower
var _effects_applied

#

func _init().(StoreOfTowerEffectsUUID.ING_BOUNDED):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_PingAttkReset.png")
	_update_description()
	
	_can_be_scaled_by_yel_vio = true


func _update_description():
	var plain_fragment__enemy = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "enemy")
	
	
	var interpreter_for_bonus_dmg = TextFragmentInterpreter.new()
	interpreter_for_bonus_dmg.display_body = false
	
	var ins_for_bonus_dmg = []
	ins_for_bonus_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "damage", (bonus_damage_scale_on_reset) * 100.0 * _current_additive_scale * _scale_multiplier, true))
	
	interpreter_for_bonus_dmg.array_of_instructions = ins_for_bonus_dmg
	
	
	description = ["On |0| kill by main attack: the next main attack is immediately fired, and deals |1|." % [_generate_desc_for_persisting_total_additive_scaling(true)], [plain_fragment__enemy, interpreter_for_bonus_dmg]]
	
	emit_signal("description_updated")

#######

func _make_modifications_to_tower(tower):
	_tower = tower
	
	if !_effects_applied:
		_effects_applied = true
		
		_tower.connect("on_main_post_mitigation_damage_dealt", self, "_on_main_post_mitigation_damage_dealt", [], CONNECT_PERSIST)

func _on_main_post_mitigation_damage_dealt(damage_instance_report, killed, enemy, damage_register_id, module):
	if killed:
		_tower.connect("on_main_attack_module_damage_instance_constructed", self, "_on_main_attack_module_damage_instance_constructed", [], CONNECT_ONESHOT)
		
		if is_instance_valid(_tower.main_attack_module):
			_tower.main_attack_module.call_deferred("reset_attack_timers")


func _on_main_attack_module_damage_instance_constructed(damage_instance, module):
	var final_scale_multiplier = bonus_damage_scale_on_reset * _scale_multiplier
	final_scale_multiplier -= 1
	
	damage_instance.scale_only_damage_by(final_scale_multiplier)
	

