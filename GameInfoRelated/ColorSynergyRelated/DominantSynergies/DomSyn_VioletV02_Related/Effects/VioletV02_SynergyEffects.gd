extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const VioletV02_UnstableCountMarkerEffect = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_VioletV02_Related/Effects/VioletV02_UnstableCountMarker.gd")
const CommonAttackSpriteTemplater = preload("res://MiscRelated/AttackSpriteRelated/CommonTemplates/CommonAttackSpriteTemplater.gd")
const TowerEffect_DomSyn_VioletV02ColorMasteryGiver = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TowerEffect_DomSyn_VioletV02ColorMasteryGiver.gd")


signal gold_salvaged(arg_amount)
signal request_configure_self_to_dom_syn()

# setted by dom syn

var unstable_particle_pool_component
var non_essential_rng

var initial_unstable_round_count : int


#

var unstable_marker_effect : VioletV02_UnstableCountMarkerEffect


const unstable_particle_show_delta : float = 0.4
const unstable_particle_show_delta__last_round : float = 0.15

var unstable_particle_timer : Timer

#

var _effects_applied : bool

var _tower

var _is_in_unstable_mode : bool

var _dom_syn_vio

###

func _init().(StoreOfTowerEffectsUUID.VIOLET_V02__SYNERGY_EFFECTS):
	pass



func _make_modifications_to_tower(tower):
	_tower = tower
	
	if !_effects_applied:
		_effects_applied = true
		
		_tower.ignore_ing_limit__for_absorbing_clauses.attempt_insert_clause(_tower.IgnoreIngredientLimitClauses_ForAbsorbing.DOM_SYN_VIOLET_V02)
		_tower.ignore_ing_limit__for_applying_clauses.attempt_insert_clause(_tower.IgnoreIngredientLimitClauses_ForApplying.DOM_SYN_VIOLET_V02)
		
		_tower.connect("on_ingredient_absorbed", self, "_on_ingredient_absorbed", [], CONNECT_PERSIST)
		_tower.connect("ingredients_limit_changed", self, "_on_ingredients_limit_changed", [], CONNECT_PERSIST)
		
		
		_construct_and_add_unstable_particle_timer()
		
		unstable_marker_effect = _tower.get_tower_effect(StoreOfTowerEffectsUUID.VIOLET_V02__UNSTABLE_EFFECT_MARKER)
		_attempt_start_unstable_particle_timer_based_on_properties()
		
		_tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)
		
		#
		emit_signal("request_configure_self_to_dom_syn")

#

func make_modification_to_tower__with_dom_syn(arg_dom_syn):
	_dom_syn_vio = arg_dom_syn
	
	arg_dom_syn.connect("current_bonus_ingredient_slot_count_changed", self, "_on_current_bonus_ingredient_slot_count_changed", [], CONNECT_PERSIST)
	arg_dom_syn.connect("is_applying_omni_color_changed", self, "_on_is_applying_omni_color_changed", [], CONNECT_PERSIST)
	
	_on_current_bonus_ingredient_slot_count_changed(null)
	_on_is_applying_omni_color_changed(null)

func _on_current_bonus_ingredient_slot_count_changed(_arg_val):
	_tower.set_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.VIOLET_V02_SYNERGY, _dom_syn_vio.current_bonus_ingredient_slot_count)
	

func _on_is_applying_omni_color_changed(_arg_val):
	if _dom_syn_vio.is_applying_omni_color:
		if !_tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.VIOLET_V02__COLOR_MASTERY_EFFECT_GIVER):
			var effect = TowerEffect_DomSyn_VioletV02ColorMasteryGiver.new()
			
			_tower.add_tower_effect(effect)
		
	else:
		_remove_omni_color_effect()

func _remove_omni_color_effect():
	var effect = _tower.get_tower_effect(StoreOfTowerEffectsUUID.VIOLET_V02__COLOR_MASTERY_EFFECT_GIVER)
	if effect != null:
		_tower.remove_tower_effect(effect)


#

func _construct_and_add_unstable_particle_timer():
	unstable_particle_timer = Timer.new()
	unstable_particle_timer.one_shot = false
	unstable_particle_timer.connect("timeout", self, "_on_unstable_particle_timer_timeout", [], CONNECT_PERSIST)
	_tower.add_child(unstable_particle_timer)

func _on_unstable_particle_timer_timeout():
	var particle = unstable_particle_pool_component.get_or_create_attack_sprite_from_pool()
	
	CommonAttackSpriteTemplater.configure_properties_of_attk_sprite(particle, CommonAttackSpriteTemplater.TemplateIDs.COMMON_UPWARD_DECELERATING_PARTICLE)
	particle.position = _tower.global_position
	var tower_half_size : Vector2 = _tower.get_current_anim_size() / 2.0
	particle.position.x += non_essential_rng.randi_range(-tower_half_size.x, tower_half_size.x)
	particle.position.y += non_essential_rng.randi_range(-16, 10)
	
	particle.modulate.a = 0.8
	particle.visible = true


#

func _undo_modifications_to_tower(tower):
	if _effects_applied:
		_effects_applied = false
		
		_tower.ignore_ing_limit__for_absorbing_clauses.remove_clause(_tower.IgnoreIngredientLimitClauses_ForAbsorbing.DOM_SYN_VIOLET_V02)
		_tower.ignore_ing_limit__for_applying_clauses.remove_clause(_tower.IgnoreIngredientLimitClauses_ForApplying.DOM_SYN_VIOLET_V02)
		
		_tower.disconnect("on_ingredient_absorbed", self, "_on_ingredient_absorbed")
		_tower.disconnect("ingredients_limit_changed", self, "_on_ingredients_limit_changed")
		
		unstable_particle_timer.queue_free()
		
		# NOTE do not remove unstable_marker_effect
		
		_tower.disconnect("on_round_end", self, "_on_round_end")
		
		unmake_modification_to_tower__with_dom_syn()

func unmake_modification_to_tower__with_dom_syn():
	_dom_syn_vio.disconnect("current_bonus_ingredient_slot_count_changed", self, "_on_current_bonus_ingredient_slot_count_changed")
	_dom_syn_vio.disconnect("is_applying_omni_color_changed", self, "_on_is_applying_omni_color_changed")
	
	_tower.remove_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.VIOLET_V02_SYNERGY)
	_remove_omni_color_effect()

################


func _on_ingredient_absorbed(arg_ingredient):
	_check__if_tower_has_at_least_one_ing_above_limit()
	

func _on_ingredients_limit_changed(arg_limit):
	_check__if_tower_has_at_least_one_ing_above_limit()
	

#

func _check__if_tower_has_at_least_one_ing_above_limit():
	if _tower.ingredients_absorbed.size() > _tower.last_calculated_ingredient_limit:
		_make_tower_unstable()
	


func _make_tower_unstable():
	_construct_and_add_marker_effect()
	set_unstable_round_count(initial_unstable_round_count)
	
	_is_in_unstable_mode = true

func _construct_and_add_marker_effect():
	unstable_marker_effect = VioletV02_UnstableCountMarkerEffect.new()
	
	_tower.add_tower_effect(unstable_marker_effect)


func set_unstable_round_count(arg_count):
	unstable_marker_effect.unstable_round_count = arg_count
	_attempt_start_unstable_particle_timer_based_on_properties()

func _attempt_start_unstable_particle_timer_based_on_properties():
	if unstable_marker_effect != null:
		var count = unstable_marker_effect.unstable_round_count
		
		if count == 1:
			unstable_particle_timer.start(unstable_particle_show_delta__last_round)
			_is_in_unstable_mode = true
		elif count > 1:
			unstable_particle_timer.start(unstable_particle_show_delta)
			_is_in_unstable_mode = true
		else:
			unstable_particle_timer.stop()
			_is_in_unstable_mode = false
		
	else:
		unstable_particle_timer.stop()
		_is_in_unstable_mode = false


func _on_round_end():
	if _is_in_unstable_mode:
		var count = unstable_marker_effect.unstable_round_count - 1
		
		if count > 0:
			set_unstable_round_count(count)
		else:
			end_unstable_effects()


func end_unstable_effects():
	_is_in_unstable_mode = false
	
	_tower.remove_tower_effect(unstable_marker_effect)
	unstable_marker_effect = null
	
	var gold_val = 0
	var ing_ids_beyond_limit = _tower.get_ingredient_ids_beyond_ing_limit()
	for ing_id in ing_ids_beyond_limit:
		gold_val += _tower.remove_ingredient(_tower.ingredients_absorbed[ing_id])[1]
	
	_attempt_start_unstable_particle_timer_based_on_properties()
	
	emit_signal("gold_salvaged", gold_val, _tower.global_position)



