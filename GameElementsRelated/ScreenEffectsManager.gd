extends Node

#const ScreenTintEffect = preload("res://MiscRelated/ScreenEffectsRelated/ScreenTintEffect.gd")

onready var effects_holder : Node2D = $EffectsHolder

var _screen_effect_ins_id_map : Dictionary = {}



func add_screen_tint_effect(effect):
	destroy_screen_tint_effect(effect.ins_uuid)
	
	_screen_effect_ins_id_map[effect.ins_uuid] = effect
	
	effect.connect("on_duration_over", self, "destroy_screen_tint_effect", [effect.ins_uuid], CONNECT_ONESHOT)
	effects_holder.add_child(effect)


func destroy_screen_tint_effect(ins_uuid : int):
	if _screen_effect_ins_id_map.has(ins_uuid):
		_screen_effect_ins_id_map[ins_uuid].queue_free()
		_screen_effect_ins_id_map.erase(ins_uuid)


func force_fade_out_screen_tint_effect(ins_uuid : int, arg_fade_out_duration : float = 0.25):
	if _screen_effect_ins_id_map.has(ins_uuid):
		var effect = _screen_effect_ins_id_map[ins_uuid]
		
		effect.force_fade_out(arg_fade_out_duration)

###########



