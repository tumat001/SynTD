

enum EffectType {
	
	ATTRIBUTES,
	ON_HIT_DAMAGE,
	ON_HIT_EFFECT,
	MODULE_ADDER,
	CHAOS_TAKEOVER,
	RESET,
	FULL_SELLBACK,
	MARK_EFFECT,
	
	PRIORITY_TARGET,
	
	STUN,
	KNOCK_UP,
	FORCED_PLACABLE_MOV_EFFECT,
	
	EFFECT_SHIELD,
	INVULNERABILITY,
	
	_704_EMBLEM_POINTS,
	
	TOWER_MODIFIER,
	INGREDIENT_COLOR_COMPATIBILITY,
	INGREDIENT_COLOR_ACCEPTABILITY,
	
}

var effect_uuid: int
var effect_type : int
var description # String or array (for TextFragmentInterpreter purposes)
var effect_icon : Texture

var is_timebound : bool
var time_in_seconds : float

var is_countbound : bool
var count : int
var count_reduced_by_main_attack_only : bool

var is_roundbound : bool = false
var round_count : int

var status_bar_icon : Texture

var force_apply : bool = false
var should_respect_attack_module_scale : bool = true
var should_map_in_all_effects_map : bool = true

var is_ingredient_effect : bool

var ignore_effect_shield_effect : bool = true

var is_from_enemy : bool = false


var _current_additive_scale : float = 1.0
var _persisting_total_additive_scale : float = 1.0 #used for descs
var _can_be_scaled_by_yel_vio : bool = false
var border_modi_textures : Array = []


func _init(arg_effect_type : int,
		arg_effect_uuid : int):
	
	effect_type = arg_effect_type
	effect_uuid = arg_effect_uuid


#func _shallow_duplicate():
#	pass

func _shallow_duplicate():
	var copy = get_script().new()
	_configure_copy_to_match_self(copy)
	
	return copy


func _configure_copy_to_match_self(copy):
	copy.is_timebound = is_timebound
	copy.time_in_seconds = time_in_seconds
	copy.is_ingredient_effect = is_ingredient_effect
	
	copy.is_countbound = is_countbound
	copy.count = count
	copy.count_reduced_by_main_attack_only = count_reduced_by_main_attack_only
	
	copy.effect_icon = effect_icon
	copy.status_bar_icon = status_bar_icon
	
	copy.force_apply = force_apply
	copy.should_respect_attack_module_scale = should_respect_attack_module_scale
	
	copy.is_from_enemy = is_from_enemy
	
	copy.ignore_effect_shield_effect = ignore_effect_shield_effect
	
	copy.should_map_in_all_effects_map = should_map_in_all_effects_map
	
	copy.is_roundbound = is_roundbound
	copy.round_count = round_count
	
	copy._current_additive_scale = _current_additive_scale
	copy.border_modi_textures = border_modi_textures.duplicate()
	copy._can_be_scaled_by_yel_vio = _can_be_scaled_by_yel_vio
	copy._persisting_total_additive_scale = _persisting_total_additive_scale

func _get_description():
	pass


# SCALING related. Used by YelVio only.
func add_additive_scaling_by_amount(arg_amount):
	_current_additive_scale += arg_amount
	_persisting_total_additive_scale += arg_amount
	
	description = _get_description()

# to be implemented by classes
func _consume_current_additive_scaling_for_actual_scaling_in_stats():
	pass

func _generate_desc_for_persisting_total_additive_scaling(arg_with_front_spacing : bool = false):
	if _persisting_total_additive_scale != 1.0:
		if !arg_with_front_spacing:
			return "(+%s%%)" % str((_persisting_total_additive_scale - 1) * 100)
		else:
			return " (+%s%%)" % str((_persisting_total_additive_scale - 1) * 100)
	else:
		return ""
