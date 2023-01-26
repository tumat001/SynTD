extends "res://EnemyRelated/EnemyFactionPassives/BaseFactionPassive.gd"

const Deity = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/Deity/Deity.gd")
const EnemyTypeInformation = preload("res://EnemyRelated/EnemyTypeInformation.gd")
const EnemyConstants = preload("res://EnemyRelated/EnemyConstants.gd")

const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")
const EnemyEffectShieldEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyEffectShieldEffect.gd")
const EnemyInvulnerabilityEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyInvulnerabilityEffect.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")

const AbstractFaithfulEnemy = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/AbstractFaithfulEnemy.gd")

const Faithful_SummoningPortal_Scene = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/_FactionAssets/SummoningPortal/Faithful_SummoningPortal.tscn")
const CrossMarker_Scene = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/_FactionAssets/CrossMarker/CrossMarker.tscn")

const AttackSpritePoolComponent = preload("res://MiscRelated/AttackSpriteRelated/GenerateRelated/AttackSpritePoolComponent.gd")
const CommonAttackSpriteTemplater = preload("res://MiscRelated/AttackSpriteRelated/CommonTemplates/CommonAttackSpriteTemplater.gd")
const AttackSprite = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.gd")
const AttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")


signal on_deity_being_summoned(summon_duration, stun_effect_to_use, deity)
signal on_deity_summoning_delay_finished()
signal on_deity_killed_with_no_more_revives()
signal on_deity_escaped_map()
signal on_deity_tree_exiting()


var _round_deity_stats_map : Dictionary = {
#	"01" : _get_4_3_deity_stats(),
#	"02" : _get_4_3_deity_stats(),
#	"03" : _get_4_3_deity_stats(),
#	"04" : _get_4_3_deity_stats(),
#	"05" : _get_4_3_deity_stats(),
#
	"43" : _get_4_3_deity_stats(),
	"52" : _get_5_2_deity_stats(),
	"61" : _get_6_1_deity_stats(),
	"64" : _get_6_4_deity_stats(),
	"73" : _get_7_3_deity_stats(),
	"82" : _get_8_2_deity_stats(),
	"91" : _get_9_1_deity_stats(),
	"94" : _get_9_4_deity_stats(),
}


const deity_spawn_unit_offset : float = 0.05
const deity_spawn_at_time : float = 10.0

const deity_summon_duration : float = 3.5
var _deity_summoning_duration_timer : Timer


var _current_deity : Deity
var _is_deity_round : bool

var _current_cross
var _current_cross_unit_offset : float
var _current_cross_enemy_path

#

var game_elements : GameElements
var non_essential_rng : RandomNumberGenerator

#

var deity_spawn_timer : Timer

var deity_stun_effect_while_summoning : EnemyStunEffect
var deity_effect_shield_while_summoning : EnemyEffectShieldEffect
var deity_invulnerability_effect_while_summoning : EnemyInvulnerabilityEffect

var _faithful_inc_mov_speed_effect : EnemyAttributesEffect
var _inc_move_speed_amount : float = 20.0

var _faithful_dec_mov_speed_effect : EnemyAttributesEffect
var _dec_mov_speed_amount : float = -20.0

#

var heal_particle_from_sacrificers_attk_sprite_pool : AttackSpritePoolComponent


#

func _apply_faction_to_game_elements(arg_game_elements : GameElements):
	if game_elements == null:
		game_elements = arg_game_elements
		non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
		
		_initialize_heal_particle_from_sacrificers_attk_sprite_pool()
	
	if !is_instance_valid(deity_spawn_timer):
		deity_spawn_timer = Timer.new()
		deity_spawn_timer.one_shot = true
		CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(deity_spawn_timer)
		
		_deity_summoning_duration_timer = Timer.new()
		_deity_summoning_duration_timer.one_shot = true
		CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(_deity_summoning_duration_timer)
		_deity_summoning_duration_timer.connect("timeout", self, "_on_deity_spawn_summon_delay_finished", [], CONNECT_PERSIST)
	
	if deity_stun_effect_while_summoning == null:
		_construct_deity_related_summon_effects()
	
	if _faithful_inc_mov_speed_effect == null:
		_construct_faithful_related_effects()
	
	if !game_elements.stage_round_manager.is_connected("round_started", self, "_on_round_start"):
		game_elements.stage_round_manager.connect("round_started", self, "_on_round_start", [], CONNECT_PERSIST)
		game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
	
	if !game_elements.enemy_manager.is_connected("enemy_spawned", self, "_on_enemy_spawned"):
		game_elements.enemy_manager.connect("enemy_spawned", self, "_on_enemy_spawned", [], CONNECT_PERSIST)
	
	
	game_elements.enemy_manager.generate_enemy_sv_on_round_end_clauses.attempt_insert_clause(game_elements.enemy_manager.GenerateEnemySVClauseIds.FACTION_PASSIVE__CULTIST)
	
	._apply_faction_to_game_elements(arg_game_elements)


func _remove_faction_from_game_elements(arg_game_elements : GameElements):
	if game_elements.stage_round_manager.is_connected("round_started", self, "_on_round_start"):
		game_elements.stage_round_manager.disconnect("round_started", self, "_on_round_start")
		game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end")
	
	if !game_elements.enemy_manager.is_connected("enemy_spawned", self, "_on_enemy_spawned"):
		game_elements.enemy_manager.disconnect("enemy_spawned", self, "_on_enemy_spawned")
	
	_destroy_current_cross()
	
	game_elements.enemy_manager.generate_enemy_sv_on_round_end_clauses.remove_clause(game_elements.enemy_manager.GenerateEnemySVClauseIds.FACTION_PASSIVE__CULTIST)
	
	._remove_faction_from_game_elements(arg_game_elements)


func _construct_deity_related_summon_effects():
	deity_stun_effect_while_summoning = EnemyStunEffect.new(deity_summon_duration, StoreOfEnemyEffectsUUID.DEITY_STUN_EFFECT_WHILE_SUMMONING)
	deity_effect_shield_while_summoning = EnemyEffectShieldEffect.new(StoreOfEnemyEffectsUUID.DEITY_EFFECT_SHIELD_EFFECT_WHILE_SUMMONING, deity_summon_duration)
	deity_invulnerability_effect_while_summoning = EnemyInvulnerabilityEffect.new(StoreOfEnemyEffectsUUID.DEITY_INVUL_EFFECT_WHILE_SUMMONING, deity_summon_duration)
	
	deity_stun_effect_while_summoning.is_from_enemy = true
	deity_effect_shield_while_summoning.is_from_enemy = true
	deity_invulnerability_effect_while_summoning.is_from_enemy = true
	
	deity_stun_effect_while_summoning.is_clearable = false
	deity_effect_shield_while_summoning.is_clearable = false
	deity_invulnerability_effect_while_summoning.is_clearable = false

func _construct_faithful_related_effects():
	var inc_modi : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.FAITHFUL_SPEED_EFFECT)
	inc_modi.percent_based_on = PercentType.MAX
	inc_modi.percent_amount = _inc_move_speed_amount
	
	_faithful_inc_mov_speed_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, inc_modi, StoreOfEnemyEffectsUUID.FAITHFUL_SPEED_EFFECT)
	_faithful_inc_mov_speed_effect.is_from_enemy = true
	_faithful_inc_mov_speed_effect.is_clearable = false
	
	
	var dec_modi : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.FAITHFUL_SLOW_EFFECT)
	dec_modi.percent_based_on = PercentType.MAX
	dec_modi.percent_amount = _dec_mov_speed_amount
	
	_faithful_dec_mov_speed_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, dec_modi, StoreOfEnemyEffectsUUID.FAITHFUL_SLOW_EFFECT)
	_faithful_dec_mov_speed_effect.is_from_enemy = true
	_faithful_dec_mov_speed_effect.is_clearable = false
	


#
# On enemy spawn
func _on_enemy_spawned(enemy):
	if enemy is AbstractFaithfulEnemy:
		if !is_connected("on_deity_being_summoned", enemy, "on_deity_being_summoned"):
			connect("on_deity_being_summoned", enemy, "on_deity_being_summoned")
			connect("on_deity_killed_with_no_more_revives", enemy, "on_deity_killed_with_no_revives")
			connect("on_deity_escaped_map", enemy, "on_deity_escaped_map")
			connect("on_deity_tree_exiting", enemy, "on_deity_tree_exiting")
			connect("on_deity_summoning_delay_finished", enemy, "on_deity_summoning_finished")
		
		if is_instance_valid(_current_deity) and !_current_deity.is_queued_for_deletion():
			enemy.set_deity_in_round(_current_deity)
		
		enemy._slow_effect = _faithful_dec_mov_speed_effect
		enemy._speed_effect = _faithful_inc_mov_speed_effect
		
		
		if enemy.enemy_id == EnemyConstants.Enemies.CROSS_BEARER:
			enemy.connect("tree_exiting", self, "_on_cross_bearer_dies", [enemy])


# deity spawning related

func _on_round_start(curr_stageround):
	_is_deity_round = has_deity_for_round(curr_stageround.id)
	
	if _is_deity_round:
		_set_up_deity_for_round(curr_stageround.id)



func _set_up_deity_for_round(round_id):
	deity_spawn_timer.connect("timeout", self, "_deity_spawn_timer_timeout", [round_id], CONNECT_ONESHOT)
	deity_spawn_timer.start(deity_spawn_at_time)


func _deity_spawn_timer_timeout(round_id):
	if game_elements.stage_round_manager.round_started and game_elements.stage_round_manager.current_stageround.id == round_id and is_instance_valid(_current_cross_enemy_path):
		game_elements.enemy_manager.connect("before_enemy_stats_are_set", self, "_on_deity_before_stats_initialized", [round_id], CONNECT_ONESHOT)
		game_elements.enemy_manager.connect("enemy_spawned", self, "_on_deity_spawned", [], CONNECT_ONESHOT)
		game_elements.enemy_manager.spawn_enemy(EnemyConstants.Enemies.DEITY, _current_cross_enemy_path)


# before deity stats initialized and before added to scene
func _on_deity_before_stats_initialized(deity : Deity, round_id):
	var deity_info = get_deity_stats_for_round(round_id)
	
	deity._stats_initialize(deity_info)
	
	deity._current_cross_marker_unit_offset = _current_cross_unit_offset
	deity.faithful_faction_passive = self

# after deity's ready
func _on_deity_spawned(deity):
	_current_deity = deity
	
	deity._add_effect(deity_stun_effect_while_summoning)
	deity._add_effect(deity_effect_shield_while_summoning)
	deity._add_effect(deity_invulnerability_effect_while_summoning)
	
	#
	
	deity.shift_unit_offset(deity_spawn_unit_offset)
	
	var portal_particle = Faithful_SummoningPortal_Scene.instance()
	portal_particle.z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
	portal_particle.position = deity.global_position
	portal_particle.lifetime = deity_summon_duration
	portal_particle.scale *= 2
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(portal_particle)
	
	#
	
	emit_signal("on_deity_being_summoned", deity_summon_duration, deity_stun_effect_while_summoning, deity)
	game_elements.enemy_manager.pause_spawning(deity_summon_duration)
	
	_deity_summoning_duration_timer.start(deity_summon_duration)
	
	deity.connect("reached_end_of_path", self, "_on_deity_reached_end_of_path", [], CONNECT_ONESHOT)
	deity.connect("on_killed_by_damage_with_no_more_revives", self, "_on_deity_killed_by_damage_with_no_revives", [], CONNECT_ONESHOT)
	deity.connect("tree_exiting", self, "_on_deity_tree_exiting")


func _on_deity_spawn_summon_delay_finished():
	emit_signal("on_deity_summoning_delay_finished")


func _on_deity_reached_end_of_path(deity):
	emit_signal("on_deity_escaped_map")

func _on_deity_killed_by_damage_with_no_revives(damage_instance_report, deity):
	emit_signal("on_deity_killed_with_no_more_revives")

func _on_deity_tree_exiting():
	emit_signal("on_deity_tree_exiting")


# on round end

func _on_round_end(curr_stageround):
	if _is_deity_round:
		if is_instance_valid(_current_cross):
			_destroy_current_cross()
		
		game_elements.enemy_manager.randomize__current_strength_value()

func _destroy_current_cross():
	_current_cross.queue_free()
	
	_current_cross_unit_offset = 0
	
	if is_instance_valid(_current_cross_enemy_path):
		if !_current_cross_enemy_path.is_connected("curve_changed", self, "_on_current_cross_path_curve_changed"):
			_current_cross_enemy_path.disconnect("curve_changed", self, "_on_current_cross_path_curve_changed")
		
		if !_current_cross_enemy_path.is_connected("is_used_and_active_changed", self, "_on_current_cross_path_is_used_and_active_changed"):
			_current_cross_enemy_path.disconnect("is_used_and_active_changed", self, "_on_current_cross_path_is_used_and_active_changed")
		

#

func _on_cross_bearer_dies(cross_bearer):
	if cross_bearer.unit_offset > _current_cross_unit_offset:
		_get_current_cross_or_construct()
#		if _current_cross.is_inside_tree():
#			_update_cross_pos(cross_bearer.current_path)
#		else:
#			_current_cross.position = cross_bearer.global_position
#
		_current_cross_enemy_path = cross_bearer.current_path
		#_update_cross_pos(cross_bearer.current_path.curve)
		call_deferred("_update_cross_pos", cross_bearer.current_path.curve)
		
		_current_cross_unit_offset = cross_bearer.unit_offset
		#_current_cross_enemy_path = cross_bearer.current_path
		
		_current_cross.enemy_path_associated = cross_bearer.current_path
		
		if !_current_cross_enemy_path.is_connected("curve_changed", self, "_on_current_cross_path_curve_changed"):
			_current_cross_enemy_path.connect("curve_changed", self, "_on_current_cross_path_curve_changed", [], CONNECT_PERSIST)
		
		if !_current_cross_enemy_path.is_connected("is_used_and_active_changed", self, "_on_current_cross_path_is_used_and_active_changed"):
			_current_cross_enemy_path.connect("is_used_and_active_changed", self, "_on_current_cross_path_is_used_and_active_changed", [], CONNECT_PERSIST)
		

func _get_current_cross_or_construct():
	if is_instance_valid(_current_cross):
		return _current_cross
	else:
		_current_cross = CrossMarker_Scene.instance()
		_current_cross.z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
		CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(_current_cross)
		
		return _current_cross



func _on_current_cross_path_curve_changed(arg_curve : Curve2D, arg_curve_id):
	_update_cross_pos(arg_curve)

func _update_cross_pos(arg_curve):
	if is_instance_valid(_current_cross):
		if _current_cross.is_inside_tree():
			var rel_pos = arg_curve.interpolate_baked(_current_cross_unit_offset * arg_curve.get_baked_length())
			var global_pos = rel_pos + _current_cross_enemy_path.global_position
			
			_current_cross.global_position = global_pos
		else:
			var rel_pos = arg_curve.interpolate_baked(_current_cross_unit_offset * arg_curve.get_baked_length())
			var global_pos = rel_pos + _current_cross_enemy_path.global_position
			
			_current_cross.position = global_pos


func _on_current_cross_path_is_used_and_active_changed(arg_val):
	if !arg_val:
		var new_path = game_elements.map_manager.base_map.get_random_enemy_path__with_params(game_elements.map_manager.BaseMap.EnemyPathState.USED_AND_ACTIVE)
		
		if is_instance_valid(new_path):
			_current_cross_enemy_path = new_path
			
			_update_cross_pos(new_path.curve)

# particle related

func _initialize_heal_particle_from_sacrificers_attk_sprite_pool():
	heal_particle_from_sacrificers_attk_sprite_pool = AttackSpritePoolComponent.new()
	heal_particle_from_sacrificers_attk_sprite_pool.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	heal_particle_from_sacrificers_attk_sprite_pool.node_to_listen_for_queue_free = CommsForBetweenScenes.current_game_elements__other_node_hoster
	heal_particle_from_sacrificers_attk_sprite_pool.source_for_funcs_for_attk_sprite = self
	heal_particle_from_sacrificers_attk_sprite_pool.func_name_for_creating_attack_sprite = "_create_heal_particle_from_sacrificers_particle"

func _create_heal_particle_from_sacrificers_particle():
	var particle = AttackSprite_Scene.instance()
	
	particle.texture_to_use = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/_FactionAssets/DeityAbilityAssets/HealParticleFromSacrificers.png")
	
	particle.queue_free_at_end_of_lifetime = false
	particle.stop_process_at_invisible = true
	
	return particle

func request_play_heal_particle_from_sacrificers(arg_pos):
	var particle = heal_particle_from_sacrificers_attk_sprite_pool.get_or_create_attack_sprite_from_pool()
	
	CommonAttackSpriteTemplater.configure_properties_of_attk_sprite(particle, CommonAttackSpriteTemplater.TemplateIDs.COMMON_UPWARD_DECELERATING_PARTICLE)
	particle.position = arg_pos
	
	particle.position.x += non_essential_rng.randi_range(-17, 17)
	particle.position.y += non_essential_rng.randi_range(-16, 10)
	
	particle.modulate.a = 0.85
	particle.visible = true



# deity INFO PER ROUND

func has_deity_for_round(arg_round_id : String):
	return _round_deity_stats_map.has(arg_round_id)

func get_deity_stats_for_round(arg_round_id : String):
	return _round_deity_stats_map.get(arg_round_id, _get_default_deity_stats())
	

func _construct_deity_enemy_type_info() -> EnemyTypeInformation:
	return EnemyConstants.get_enemy_info(EnemyConstants.Enemies.DEITY)
#	var info = EnemyTypeInformation.new(EnemyConstants.EnemyFactions.FAITHFUL, EnemyConstants.Enemies.DEITY)
#	info.enemy_type = EnemyTypeInformation.EnemyType.BOSS
#	info.base_movement_speed = 14
#	info.base_player_damage = 18
#
#	info.base_armor = 13
#	info.base_toughness = 13
#
#	info.enemy_name = "Deity"
#
#	return info


func _get_default_deity_stats(): # for un predefined rounds
	var info = _construct_deity_enemy_type_info()
	
	info.base_health = 200
	
	info.type_info_metadata[info.TypeInfoMetadata.DEITY_FORM] = Deity.DeityFormId.FORM_01
	
	return info



func _get_4_3_deity_stats():
	var info = _construct_deity_enemy_type_info()
	
	info.base_health = 328 #365
	info.base_effect_vulnerability = 0.75
	
	info.type_info_metadata[info.TypeInfoMetadata.DEITY_FORM] = Deity.DeityFormId.FORM_01
	
	return info

func _get_5_2_deity_stats():
	var info = _construct_deity_enemy_type_info()
	
	info.base_health = 373 #415
	info.base_effect_vulnerability = 0.75
	
	info.type_info_metadata[info.TypeInfoMetadata.DEITY_FORM] = Deity.DeityFormId.FORM_01
	
	return info


func _get_6_1_deity_stats():
	var info = _construct_deity_enemy_type_info()
	
	info.base_health = 418 #465
	info.base_effect_vulnerability = 0.75
	
	info.type_info_metadata[info.TypeInfoMetadata.DEITY_FORM] = Deity.DeityFormId.FORM_01
	
	return info


func _get_6_4_deity_stats():
	var info = _construct_deity_enemy_type_info()
	
	info.base_health = 472 #525
	info.base_effect_vulnerability = 0.70
	
	info.type_info_metadata[info.TypeInfoMetadata.DEITY_FORM] = Deity.DeityFormId.FORM_02
	
	return info


func _get_7_3_deity_stats():
	var info = _construct_deity_enemy_type_info()
	
	info.base_health = 562 #625
	info.base_effect_vulnerability = 0.65
	
	info.type_info_metadata[info.TypeInfoMetadata.DEITY_FORM] = Deity.DeityFormId.FORM_02
	
	return info


func _get_8_2_deity_stats():
	var info = _construct_deity_enemy_type_info()
	
	info.base_health = 652 #725
	info.base_effect_vulnerability = 0.60
	
	info.type_info_metadata[info.TypeInfoMetadata.DEITY_FORM] = Deity.DeityFormId.FORM_02
	
	return info

func _get_9_1_deity_stats():
	var info = _construct_deity_enemy_type_info()
	
	info.base_health = 740 #825
	info.base_effect_vulnerability = 0.55
	
	info.type_info_metadata[info.TypeInfoMetadata.DEITY_FORM] = Deity.DeityFormId.FORM_03
	
	return info


func _get_9_4_deity_stats():
	var info = _construct_deity_enemy_type_info()
	
	info.base_health = 900 #1000
	info.base_effect_vulnerability = 0.50
	info.base_player_damage = 36
	
	info.type_info_metadata[info.TypeInfoMetadata.DEITY_FORM] = Deity.DeityFormId.FORM_03
	
	return info
