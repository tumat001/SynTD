extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")

const CommonAttackSpriteTemplater = preload("res://MiscRelated/AttackSpriteRelated/CommonTemplates/CommonAttackSpriteTemplater.gd")
const Piercing_BuffParticle_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/GreenPaths/Bloom/Piercing_Assets/Piercing_BuffParticle.tscn")


var base_dmg_amount_trigger : float
var base_attk_count_trigger : int

var armor_pierce_effect : TowerAttributesEffect
var toughness_pierce_effect : TowerAttributesEffect
var attached_tower

var _armor_pierce_amount : float
var _toughness_pierce_amount : float


var _curr_dmg_amount : float
var _curr_attk_count : int


func _init(arg_dmg_amount_trigger : float, arg_attack_count_trigger : int, 
		arg_armor_pierce_amount : float, arg_toughness_pierce_amount : int).(StoreOfTowerEffectsUUID.GREEN_PATH_PIERCING_EFFECT_GIVER):
	
	base_dmg_amount_trigger = arg_dmg_amount_trigger
	base_attk_count_trigger = arg_attack_count_trigger
	
	_armor_pierce_amount = arg_armor_pierce_amount
	_toughness_pierce_amount = arg_toughness_pierce_amount


func _make_modifications_to_tower(tower):
	if attached_tower == null:
		attached_tower = tower
	
	if armor_pierce_effect == null:
		_construct_effects()
	
	
	_connect_all_signals_to_tower()


func _construct_effects():
	var armor_p_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.GREEN_PATH_PIERCING_ARMOR_PIERCE)
	armor_p_modi.flat_modifier = _armor_pierce_amount
	armor_pierce_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ARMOR_PIERCE, armor_p_modi, StoreOfTowerEffectsUUID.GREEN_PATH_PIERCING_ARMOR_PIERCE)
	
	var toughness_p_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.GREEN_PATH_PIERCING_TOUGHNESS_PIERCE)
	toughness_p_modi.flat_modifier = _toughness_pierce_amount
	toughness_pierce_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_TOUGHNESS_PIERCE, toughness_p_modi, StoreOfTowerEffectsUUID.GREEN_PATH_PIERCING_TOUGHNESS_PIERCE)

#

func _on_round_end():
	_curr_dmg_amount = 0
	_curr_attk_count = 0
	_remove_effects_from_tower()
	_connect_monitoring_signals_to_tower()


func _remove_effects_from_tower():
	var armor_effect = attached_tower.get_tower_effect(StoreOfTowerEffectsUUID.GREEN_PATH_PIERCING_ARMOR_PIERCE)
	if armor_effect != null:
		attached_tower.remove_tower_effect(armor_effect)
	
	var tough_effect = attached_tower.get_tower_effect(StoreOfTowerEffectsUUID.GREEN_PATH_PIERCING_TOUGHNESS_PIERCE)
	if tough_effect != null:
		attached_tower.remove_tower_effect(tough_effect)
	


func _on_any_post_mitigation_damage_dealt(damage_instance_report, killed, enemy, damage_register_id, module):
	_curr_dmg_amount += damage_instance_report.get_total_effective_damage()
	_check_if_requirements_met()

func _on_main_attack(attk_speed_delay, enemies, module):
	_curr_attk_count += 1
	_check_if_requirements_met()


func _check_if_requirements_met():
	if _curr_dmg_amount >= base_dmg_amount_trigger or _curr_attk_count >= base_attk_count_trigger:
		_disconnect_monitoring_signals_from_tower()
		attached_tower.add_tower_effect(armor_pierce_effect)
		attached_tower.add_tower_effect(toughness_pierce_effect)
		_display_particle_at_tower()


func _display_particle_at_tower():
	var particle = Piercing_BuffParticle_Scene.instance()
	CommonAttackSpriteTemplater.configure_properties_of_attk_sprite(particle, CommonAttackSpriteTemplater.TemplateIDs.COMMON_UPWARD_DECELERATING_PARTICLE)
	
	particle.position = attached_tower.global_position
	particle.position.y -= 12
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(particle)

#

func _connect_all_signals_to_tower():
	if !attached_tower.is_connected("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigation_damage_dealt"):
		attached_tower.connect("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigation_damage_dealt", [], CONNECT_PERSIST)
		attached_tower.connect("on_main_attack", self, "_on_main_attack", [], CONNECT_PERSIST)
	
	if !attached_tower.is_connected("on_round_end", self, "_on_round_end"):
		attached_tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)


func _connect_monitoring_signals_to_tower():
	if !attached_tower.is_connected("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigation_damage_dealt"):
		attached_tower.connect("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigation_damage_dealt", [], CONNECT_PERSIST)
		attached_tower.connect("on_main_attack", self, "_on_main_attack", [], CONNECT_PERSIST)


func _disconnect_all_signals_from_tower():
	if attached_tower.is_connected("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigation_damage_dealt"):
		attached_tower.disconnect("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigation_damage_dealt")
		attached_tower.disconnect("on_main_attack", self, "_on_main_attack")
	
	if attached_tower.is_connected("on_round_end", self, "_on_round_end"):
		attached_tower.disconnect("on_round_end", self, "_on_round_end")

func _disconnect_monitoring_signals_from_tower():
	if attached_tower.is_connected("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigation_damage_dealt"):
		attached_tower.disconnect("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigation_damage_dealt")
		attached_tower.disconnect("on_main_attack", self, "_on_main_attack")




#

func _undo_modifications_to_tower(tower):
	_remove_effects_from_tower()
	
	_disconnect_all_signals_from_tower()
	
	attached_tower = null
