

enum EffectType {
	
	ATTRIBUTES,
	ON_HIT_DAMAGE,
	ON_HIT_EFFECT,
	MODULE_ADDER,
	CHAOS_TAKEOVER,
	RESET,
	FULL_SELLBACK,
	MARK_EFFECT,
	
	_704_EMBLEM_POINTS,
	
	TOWER_MODIFIER,
	
}

var effect_uuid: int
var effect_type : int
var description : String
var effect_icon : Texture

var is_timebound : bool
var time_in_seconds : float

var is_countbound : bool
var count : int
var count_reduced_by_main_attack_only : bool

var status_bar_icon : Texture

var force_apply : bool = false
var should_respect_attack_module_scale : bool = true

var is_ingredient_effect : bool

var is_from_enemy : bool = false


func _init(arg_effect_type : int,
		arg_effect_uuid : int):
	
	effect_type = arg_effect_type
	effect_uuid = arg_effect_uuid


func _shallow_duplicate():
	pass


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
