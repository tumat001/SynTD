extends Reference

enum EffectType {
	ATTRIBUTES,
	
	DAMAGE_OVER_TIME,
	HEAL_OVER_TIME,
	
	STACK_EFFECT,
	
	STUN,
	
	HEAL,
	SHIELD,
	INVULNERABILITY,
	EFFECT_SHIELD,
	HEAL_MODIFIER,
	
	INVISIBILITY,
	
	REVIVE,
	
	CLEAR_ALL_EFFECTS,
	
	KNOCK_UP,
	FORCED_PATH_OFFSET_MOVEMENT,
	FORCED_POSITIONAL_MOVEMENT,
	
	BEFORE_ENEMY_REACHING_END_PATH,
	
	BASE_MODIFYING_EFFECT,
	
	
	MISC,
}

var effect_uuid : int
var effect_type : int
var description : String setget ,_get_overriden_description
var effect_icon : Texture setget ,_get_overriden_icon
var should_map_in_all_effects_map : bool = true

var is_timebound : bool
var time_in_seconds : float

var respect_scale : bool = true

var is_from_enemy : bool = false
var is_clearable : bool = true

var effect_source_ref setget set_effect_source

var status_bar_icon : Texture

var _current_additive_scale : float = 1.0
var _persisting_total_additive_scale : float = 1.0 #used for descs
var _can_be_scaled_by_yel_vio : bool = false
var border_modi_textures : Array = []


func _init(arg_effect_type : int,
		arg_effect_uuid : int):
	
	effect_type = arg_effect_type
	effect_uuid = arg_effect_uuid

#

func set_effect_source(source):
	if source is WeakRef:
		effect_source_ref = source
	else:
		effect_source_ref = weakref(source)

#

func _get_copy_scaled_by(scale : float):
	pass


func _get_overriden_description() -> String:
	return description

func _get_overriden_icon() -> Texture:
	return effect_icon

func _reapply(copy):
	pass

#

func _configure_copy_to_match_self(copy):
	copy.is_timebound = is_timebound
	copy.time_in_seconds = time_in_seconds
	copy.status_bar_icon = status_bar_icon
	copy.respect_scale = respect_scale
	copy.is_from_enemy = is_from_enemy
	copy.set_effect_source(effect_source_ref)
	copy.should_map_in_all_effects_map = should_map_in_all_effects_map
	copy.is_clearable = is_clearable
	
	copy._current_additive_scale = _current_additive_scale
	copy.border_modi_textures = border_modi_textures.duplicate()
	copy._can_be_scaled_by_yel_vio = _can_be_scaled_by_yel_vio
	copy._persisting_total_additive_scale = _persisting_total_additive_scale

#

# SCALING related. Used by YelVio only.
func add_additive_scaling_by_amount(arg_amount):
	_current_additive_scale += arg_amount
	_persisting_total_additive_scale += arg_amount
	
	var desc = _get_overriden_description()
	if desc != null:
		description = desc
	else:
		description = ""

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
