extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const TowerDamageInstanceScaleBoostEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerDamageInstanceScaleBoostEffect.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const MapManager = preload("res://GameElementsRelated/MapManager.gd")
const HealthManager = preload("res://GameElementsRelated/HealthManager.gd")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const AttackSprite = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.gd")
const AttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")

const AttackBeam_01 = preload("res://TowerRelated/Color_Green/L'Assaut/Assets/Attks/L'Assaut_Beam_01.png")
const AttackBeam_02 = preload("res://TowerRelated/Color_Green/L'Assaut/Assets/Attks/L'Assaut_Beam_02.png")
const AttackBeam_03 = preload("res://TowerRelated/Color_Green/L'Assaut/Assets/Attks/L'Assaut_Beam_03.png")
const AttackBeam_04 = preload("res://TowerRelated/Color_Green/L'Assaut/Assets/Attks/L'Assaut_Beam_04.png")
const AttackBeam_05 = preload("res://TowerRelated/Color_Green/L'Assaut/Assets/Attks/L'Assaut_Beam_05.png")
const AttackBeam_06 = preload("res://TowerRelated/Color_Green/L'Assaut/Assets/Attks/L'Assaut_Beam_06.png")
const AttackBeam_07 = preload("res://TowerRelated/Color_Green/L'Assaut/Assets/Attks/L'Assaut_Beam_07.png")
const AttackBeam_08 = preload("res://TowerRelated/Color_Green/L'Assaut/Assets/Attks/L'Assaut_Beam_08.png")
const AttackBeam_09 = preload("res://TowerRelated/Color_Green/L'Assaut/Assets/Attks/L'Assaut_Beam_09.png")
const AttackBeam_10 = preload("res://TowerRelated/Color_Green/L'Assaut/Assets/Attks/L'Assaut_Beam_10.png")
const AttackBeam_11 = preload("res://TowerRelated/Color_Green/L'Assaut/Assets/Attks/L'Assaut_Beam_11.png")

const Victory_StackIcon = preload("res://TowerRelated/Color_Green/L'Assaut/Assets/GUI/BonusStatIcon_Damage.png")
const Defeat_StackIcon = preload("res://TowerRelated/Color_Green/L'Assaut/Assets/GUI/BonusStatIcon_Healing.png")
const None_StackIcon = preload("res://TowerRelated/Color_Green/L'Assaut/Assets/GUI/BonusStatIcon_None.png")

const Petal_Normal = preload("res://TowerRelated/Color_Green/L'Assaut/Assets/PetalHead/L'Assaut_Petal_Base.png")
const Petal_Yellow = preload("res://TowerRelated/Color_Green/L'Assaut/Assets/PetalHead/L'Assaut_Petal_Yellow.png")
const Petal_Red = preload("res://TowerRelated/Color_Green/L'Assaut/Assets/PetalHead/L'Assaut_Petal_Red.png")
const Petal_Violet = preload("res://TowerRelated/Color_Green/L'Assaut/Assets/PetalHead/L'Assaut_Petal_Violet.png")
const Petal_Blue = preload("res://TowerRelated/Color_Green/L'Assaut/Assets/PetalHead/L'Assaut_Petal_Blue.png")


signal stack_state_changed(new_state)


enum PetalColor {
	NORMAL = 0,
	YELLOW = 1,
	RED = 2,
	VIOLET = 3,
	BLUE = 4,
}
var _current_petal_color : int = PetalColor.NORMAL
var _current_petal_E_AND_W_texture : Texture = Petal_Normal

enum PursueState {
	NONE = 0,
	FADING = 1,
	APPEARING = 2,
}

enum StackState {
	VICTORY = 0,
	DEFEAT = 1,
	NONE = 2,
}

const max_bonus_dmg_from_victory : float = 1.5
const bonus_damage_per_victory : float = 0.1
var victory_count : int = 0
var current_bonus_dmg_from_victory_count : float = 1.0

var damage_instance_scale_boost_effect : TowerDamageInstanceScaleBoostEffect

const heal_per_defeat_count : int = 2
var defeat_count : int = 0

#

const victory_count_for_red_petal : int = 5
const victory_count_for_yellow_petal : int = 1

const defeat_count_for_blue_petal : int = 5
const defeat_count_for_violet_petal : int = 1

onready var petal_head_sprite = $TowerBase/KnockUpLayer/PetalSprite

#

var initial_placable_at_round_start : InMapAreaPlacable

const pursue_attack_speed_percent_amount : float = 150.0
const pursue_range_flat_amount : float = 25.0
const pursue_buff_duration : float = 1.5

var pursue_attack_speed_effect : TowerAttributesEffect
var pursue_range_effect : TowerAttributesEffect


const pursue_burrow_cast_time : float = 0.35
const pursue_surface_cast_time : float = 0.35
const base_pursue_cooldown : float = pursue_buff_duration + pursue_burrow_cast_time + pursue_surface_cast_time #0.8

const pursue_range_of_new_placable_to_enemy_buffer : float = 10.0

var pursue_ability : BaseAbility
var is_pursue_ability_ready : bool

var current_pursue_state : int = PursueState.NONE
var targeted_placable : InMapAreaPlacable

var is_range_being_changed : bool = false

#

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.L_ASSAUT)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += 10
	
	#
	
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 1 / 0.18
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 17
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.commit_to_targets_of_windup = true
	attack_module.fill_empty_windup_target_slots = false
	attack_module.show_beam_at_windup = true
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", AttackBeam_01)
	beam_sprite_frame.add_frame("default", AttackBeam_02)
	beam_sprite_frame.add_frame("default", AttackBeam_03)
	beam_sprite_frame.add_frame("default", AttackBeam_04)
	beam_sprite_frame.add_frame("default", AttackBeam_05)
	beam_sprite_frame.add_frame("default", AttackBeam_06)
	beam_sprite_frame.add_frame("default", AttackBeam_07)
	beam_sprite_frame.add_frame("default", AttackBeam_08)
	beam_sprite_frame.add_frame("default", AttackBeam_09)
	beam_sprite_frame.add_frame("default", AttackBeam_10)
	beam_sprite_frame.add_frame("default", AttackBeam_11)
	
	beam_sprite_frame.set_animation_loop("default", false)
	beam_sprite_frame.set_animation_speed("default", 11 / 0.18)
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	attack_module.beam_is_timebound = true
	attack_module.beam_time_visible = 0.18
	
	add_attack_module(attack_module)
	
	#
	
	_construct_related_effects()
	
	connect("on_round_start", self, "_on_round_start_l", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_l", [], CONNECT_PERSIST)
	connect("on_any_range_module_current_enemy_exited", self, "_on_enemy_exited_range", [], CONNECT_PERSIST)
	#attack_module.connect("before_attack_sprite_is_shown", self, "")
	connect("before_effect_is_removed", self, "_before_effect_is_removed_l", [], CONNECT_PERSIST)
	connect("on_effect_removed", self, "_on_effect_removed_l", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	
	_construct_and_register_ability()
	
	#
	
	var aux_sprite_param__for_petal := AnimFaceDirComponent.AuxSpritesParameters.new()
	var dir_name_to_texture_get_method_map : Dictionary = AnimFaceDirComponent.AuxSpritesParameters.construct_empty_texture_dir_name_to_get_methods_map__for_W_and_E()
	dir_name_to_texture_get_method_map[AnimFaceDirComponent.dir_east_name] = "_get_petal_texture__at_E_and_W_dir"
	dir_name_to_texture_get_method_map[AnimFaceDirComponent.dir_west_name] = "_get_petal_texture__at_E_and_W_dir"
	
	dir_name_to_texture_get_method_map[AnimFaceDirComponent.get_name_of_dir_with_no_health_modifier(AnimFaceDirComponent.dir_east_name)] = "_get_petal_texture__at_E_and_W_dir"
	dir_name_to_texture_get_method_map[AnimFaceDirComponent.get_name_of_dir_with_no_health_modifier(AnimFaceDirComponent.dir_west_name)] = "_get_petal_texture__at_E_and_W_dir"
	
	aux_sprite_param__for_petal.configure_param_with__E_pos__E_texture_get_method__E_flip__for_W_and_E(petal_head_sprite.position, dir_name_to_texture_get_method_map, self, false)
	aux_sprite_param__for_petal.sprite = petal_head_sprite
	anim_face_dir_component.set__and_update_auxilliary_sprites_on_anim_change(aux_sprite_param__for_petal)
	
	_post_inherit_ready()

func _post_inherit_ready():
	._post_inherit_ready()
	
	add_tower_effect(damage_instance_scale_boost_effect)


#

func _on_round_start_l():
	if is_current_placable_in_map():
		initial_placable_at_round_start = current_placable

func _on_round_end_l():
	if is_current_placable_in_map():
		#if is_instance_valid(initial_placable_at_round_start) and initial_placable_at_round_start.tower_occupying == null:
		#	_transfer_to_placable_with_default_params(initial_placable_at_round_start)
		
		_check_if_round_won_or_lost()

func _transfer_to_placable_with_default_params(arg_placable):
	transfer_to_placable(arg_placable, false, !tower_manager.can_place_tower_based_on_limit_and_curr_placement(self))


#

func _construct_related_effects():
	var attk_speed_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.L_ASSAUT_ATTACK_SPEED_EFFECT)
	attk_speed_attr_mod.percent_amount = pursue_attack_speed_percent_amount
	attk_speed_attr_mod.percent_based_on = PercentType.BASE
	
	pursue_attack_speed_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_attr_mod, StoreOfTowerEffectsUUID.L_ASSAUT_ATTACK_SPEED_EFFECT)
	pursue_attack_speed_effect.is_timebound = true
	pursue_attack_speed_effect.time_in_seconds = pursue_buff_duration
	
	#
	
	var range_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.L_ASSAUT_RANGE_EFFECT)
	range_attr_mod.flat_modifier = pursue_range_flat_amount
	
	pursue_range_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_RANGE, range_attr_mod, StoreOfTowerEffectsUUID.L_ASSAUT_RANGE_EFFECT)
	pursue_range_effect.is_timebound = true
	pursue_range_effect.time_in_seconds = pursue_buff_duration
	
	#
	
	damage_instance_scale_boost_effect = TowerDamageInstanceScaleBoostEffect.new(TowerDamageInstanceScaleBoostEffect.DmgInstanceTypesToBoost.ANY, TowerDamageInstanceScaleBoostEffect.DmgInstanceBoostType.BASE_AND_ON_HIT_DMG_ONLY, 1, StoreOfTowerEffectsUUID.L_ASSAUT_BONUS_DMG_EFFECT)
	

#

func _construct_and_register_ability():
	pursue_ability = BaseAbility.new()
	
	pursue_ability.is_timebound = true
	
	pursue_ability.set_properties_to_usual_tower_based()
	pursue_ability.tower = self
	
	pursue_ability.connect("updated_is_ready_for_activation", self, "_can_cast_pursue_updated", [], CONNECT_PERSIST)
	register_ability_to_manager(pursue_ability, false)

func _can_cast_pursue_updated(is_ready):
	is_pursue_ability_ready = is_ready


#

func _on_enemy_exited_range(enemy, module, arg_range_module):
	if module == main_attack_module:
		if is_instance_valid(main_attack_module) and main_attack_module.range_module == arg_range_module:
			if is_pursue_ability_ready and !is_range_being_changed:
				_attempt_check_and_cast_pursue_on_target(enemy)


func _attempt_check_and_cast_pursue_on_target(arg_enemy):
	if is_instance_valid(arg_enemy) and !arg_enemy.is_queued_for_deletion():
		var candidate_placable = _get_candidate_placable(arg_enemy)
		
		if is_instance_valid(candidate_placable):
			_cast_pursue_on_target(arg_enemy, candidate_placable)
			


func _get_candidate_placable(arg_enemy) -> InMapAreaPlacable:
	var map_manager = game_elements.map_manager
	
	var placables_nearest_to_enemy = _get_placables_nearest_from_enemy(arg_enemy, map_manager)
	
	if placables_nearest_to_enemy.size() > 0:
		return placables_nearest_to_enemy[0]
	
	return null


func _get_placables_nearest_from_enemy(arg_enemy, arg_map_manager : MapManager):
	return arg_map_manager.get_all_placables_in_range(arg_enemy.global_position, _get_self_range_reduced_by_buffer(), arg_map_manager.PlacableState.UNOCCUPIED, arg_map_manager.SortOrder.CLOSEST)

func _get_self_range_reduced_by_buffer(arg_range : float = range_module.last_calculated_final_range) -> float:
	return arg_range - pursue_range_of_new_placable_to_enemy_buffer


#

func _cast_pursue_on_target(arg_enemy, arg_new_placable):
	var cd = _get_cd_to_use(base_pursue_cooldown)
	pursue_ability.on_ability_before_cast_start(cd)
	
	targeted_placable = arg_new_placable
	
	#
	_start_pursue_fading(arg_new_placable)
	
	pursue_ability.start_time_cooldown(cd)
	
	pursue_ability.on_ability_after_cast_ended(cd)

func _start_pursue_fading(arg_new_placable):
	current_pursue_state = PursueState.FADING
	
	set_disabled_from_attacking_clause(DisabledFromAttackingSourceClauses.L_ASSAUT_PURSUE_ACTIVE)
	set_untargetability_clause(UntargetabilityClauses.L_ASSAUT_PURSUE_ACTIVE)

func _process(delta):
	if current_pursue_state == PursueState.FADING:
		modulate.a -= delta / pursue_burrow_cast_time
		
		if modulate.a <= 0:
			_start_pursue_appearing()
		
	elif current_pursue_state == PursueState.APPEARING:
		modulate.a += delta / pursue_surface_cast_time
		
		if modulate.a >= 1:
			_pursue_ended()

func _start_pursue_appearing():
	if is_instance_valid(targeted_placable) and targeted_placable.tower_occupying == null:
		_transfer_to_placable_with_default_params(targeted_placable)
	
	current_pursue_state = PursueState.APPEARING

#

func _pursue_ended():
	_give_self_pursue_effects()
	
	current_pursue_state = PursueState.NONE
	erase_disabled_from_attacking_clause(DisabledFromAttackingSourceClauses.L_ASSAUT_PURSUE_ACTIVE)
	erase_untargetability_clause(UntargetabilityClauses.L_ASSAUT_PURSUE_ACTIVE)
	
	main_attack_module.reset_attack_timers()


func _give_self_pursue_effects():
	var ability_potency_to_use = pursue_ability.get_potency_to_use(last_calculated_final_ability_potency)
	var attk_speed_copy = pursue_attack_speed_effect._get_copy_scaled_by(ability_potency_to_use)
	add_tower_effect(attk_speed_copy)
	
	var range_copy = pursue_range_effect._get_copy_scaled_by(ability_potency_to_use)
	add_tower_effect(range_copy)

###

func _check_if_round_won_or_lost():
	var stage_round_manager = game_elements.stage_round_manager
	
	if stage_round_manager.current_round_lost:
		_on_round_lost_in_map()
	else:
		_on_round_won_in_map()


func _on_round_lost_in_map():
	defeat_count += 1
	
	if victory_count > 0:
		damage_instance_scale_boost_effect.boost_scale_amount = 1
		victory_count = 0
	
	call_deferred("emit_signal", "stack_state_changed", get_stack_state())
	
	if defeat_count_for_blue_petal <= defeat_count:
		_current_petal_E_AND_W_texture = Petal_Blue
		_set_petal_color(PetalColor.BLUE)
	elif defeat_count_for_violet_petal <= defeat_count:
		_current_petal_E_AND_W_texture = Petal_Violet
		_set_petal_color(PetalColor.VIOLET)
	else:
		_current_petal_E_AND_W_texture = Petal_Normal
		_set_petal_color(PetalColor.NORMAL)
	#petal_head_sprite.texture = _current_petal_E_AND_W_texture
	

func _on_round_won_in_map():
	victory_count += 1
	if damage_instance_scale_boost_effect.boost_scale_amount < max_bonus_dmg_from_victory:
		damage_instance_scale_boost_effect.boost_scale_amount += bonus_damage_per_victory
		current_bonus_dmg_from_victory_count = damage_instance_scale_boost_effect.boost_scale_amount
	
	if defeat_count > 0:
		var heal_amount = defeat_count * heal_per_defeat_count
		game_elements.health_manager.increase_health_by(heal_amount, HealthManager.IncreaseHealthSource.TOWER)
		
		defeat_count = 0
	
	call_deferred("emit_signal", "stack_state_changed", get_stack_state())
	
	if victory_count_for_red_petal <= victory_count:
		_current_petal_E_AND_W_texture = Petal_Red
		_set_petal_color(PetalColor.RED)
		
	elif victory_count_for_yellow_petal <= victory_count:
		_current_petal_E_AND_W_texture = Petal_Yellow
		_set_petal_color(PetalColor.YELLOW)
	else:
		_current_petal_E_AND_W_texture = Petal_Normal
		_set_petal_color(PetalColor.NORMAL)
	#petal_head_sprite.texture = _current_petal_E_AND_W_texture
	


# GUI Related

func get_stack_state() -> int:
	if victory_count > 0:
		return StackState.VICTORY
	elif defeat_count > 0:
		return StackState.DEFEAT
	else:
		return StackState.NONE

func get_stat_icon_to_display() -> Resource:
	var stack_state = get_stack_state()
	
	if stack_state == StackState.VICTORY:
		return Victory_StackIcon
	elif stack_state == StackState.DEFEAT:
		return Defeat_StackIcon
	else:
		return None_StackIcon

func get_stat_label_to_display() -> String:
	var stack_state = get_stack_state()
	
	if stack_state == StackState.VICTORY:
		return "+ %s%% dmg" % [str((current_bonus_dmg_from_victory_count - 1) * 100)]
	elif stack_state == StackState.DEFEAT:
		return "+ %s heal" % [str(defeat_count * heal_per_defeat_count)]
	else:
		return "None"

#

func _before_effect_is_removed_l(arg_tower_effect):
	if arg_tower_effect.effect_uuid == StoreOfTowerEffectsUUID.L_ASSAUT_RANGE_EFFECT:
		is_range_being_changed = true

func _on_effect_removed_l(arg_tower_effect):
	if arg_tower_effect.effect_uuid == StoreOfTowerEffectsUUID.L_ASSAUT_RANGE_EFFECT:
		is_range_being_changed = false


## PETAL RELATED

func _set_petal_color(arg_color : int):
	_current_petal_color = arg_color
	anim_face_dir_component.update_state_of_aux_sprite_texture_to_use()

func _get_petal_texture__at_E_and_W_dir():
	return _current_petal_E_AND_W_texture


