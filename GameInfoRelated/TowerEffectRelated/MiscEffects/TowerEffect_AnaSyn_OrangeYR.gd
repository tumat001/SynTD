extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")

const CommonAttackSpriteTemplater = preload("res://MiscRelated/AttackSpriteRelated/CommonTemplates/CommonAttackSpriteTemplater.gd")
const OrangeYR_AuraParticle = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_OrangeYR/Assets/MaxedAuraParticle/OrangeYR_AuraParticle.tscn")

var base_unit_time_before_max : float
var current_unit_time_before_max : float = 0
var max_attk_speed_percent_amount : float


var attk_speed_effect : TowerAttributesEffect
var attk_speed_modifier : PercentModifier
var tower_affected

var aura_particle


func _init(arg_base_unit_time_before_max : float).(StoreOfTowerEffectsUUID.ORANGE_YR_GIVER_EFFECT):
	base_unit_time_before_max = arg_base_unit_time_before_max


func _make_modifications_to_tower(tower):
	if attk_speed_effect == null:
		_construct_effect()
	
	if tower_affected == null:
		tower_affected = tower
		tower_affected.add_tower_effect(attk_speed_effect)
		_update_effect_modi()
	
	if !tower.is_connected("on_round_end", self, "_on_tower_round_end"):
		tower.connect("on_round_end", self, "_on_tower_round_end", [], CONNECT_PERSIST)
		tower.connect("on_main_attack", self, "_on_tower_attack", [], CONNECT_PERSIST)



func _construct_effect():
	attk_speed_modifier = PercentModifier.new(StoreOfTowerEffectsUUID.ORANGE_YR_ATTK_SPEED_EFFECT)
	attk_speed_modifier.percent_based_on = PercentType.BASE
	
	attk_speed_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_modifier, StoreOfTowerEffectsUUID.ORANGE_YR_ATTK_SPEED_EFFECT)


func _on_tower_round_end():
	current_unit_time_before_max = 0
	_update_effect_modi()
	
	if is_instance_valid(aura_particle):
		aura_particle.queue_free()


func _on_tower_attack(attk_speed_delay, enemies, module):
	current_unit_time_before_max += attk_speed_delay
	
	_update_effect_modi()


func _update_effect_modi():
	# maxxing
	if current_unit_time_before_max > base_unit_time_before_max:
		current_unit_time_before_max = base_unit_time_before_max
	
	if current_unit_time_before_max / base_unit_time_before_max == 1:
		if !is_instance_valid(aura_particle):
			_show_maxed_aura_particle()
	
	var attk_speed_bonus = current_unit_time_before_max / base_unit_time_before_max * max_attk_speed_percent_amount
	attk_speed_modifier.percent_amount = attk_speed_bonus
	
	for module in tower_affected.all_attack_modules:
		if module.benefits_from_bonus_attack_speed:
			module.calculate_all_speed_related_attributes()
		
		if tower_affected.main_attack_module == module:
			tower_affected._emit_final_attack_speed_changed()


#

func _show_maxed_aura_particle():
	aura_particle = OrangeYR_AuraParticle.instance()
	#aura_particle.position = tower_affected.global_position
	aura_particle.size_adapting_to = tower_affected
	aura_particle.adapt_ratio = 0.4
	aura_particle.position.y += (tower_affected.get_current_anim_size().y / 2) - 3
	
	tower_affected.add_child(aura_particle)




#

func _undo_modifications_to_tower(tower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.ORANGE_YR_ATTK_SPEED_EFFECT)
	if effect != null:
		tower.remove_tower_effect(effect)
	
	if is_instance_valid(aura_particle):
		aura_particle.queue_free()
	
	if tower.is_connected("on_round_end", self, "_on_tower_round_end"):
		tower.disconnect("on_round_end", self, "_on_tower_round_end")
		tower.disconnect("on_main_attack", self, "_on_tower_attack")
