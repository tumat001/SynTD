extends MarginContainer


const Bar_NotFull = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/OverflowBar/Black_OverflowBar_Fill_NotFull.png")
const Bar_Full = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/Assets/OverflowBar/Black_OverflowBar_Fill_Full.png")


onready var dmg_scale_bar = $BonusDmgBar

var _tower
var _effect

#

func _ready():
	update_display()

#

func set_tower_and_effect(arg_tower, arg_effect):
	if _effect != null:
		_effect.disconnect("on_damage_scale_changed", self, "_on_effect_curr_dmg_scale_changed")
		_effect.disconnect("on_effect_being_removed_b", self, "_on_effect_being_removed")
	
	_tower = arg_tower
	_effect = arg_effect
	
	if _effect != null:
		_effect.connect("on_damage_scale_changed", self, "_on_effect_curr_dmg_scale_changed", [], CONNECT_PERSIST)
		_effect.connect("on_effect_being_removed_b", self, "_on_effect_being_removed", [], CONNECT_PERSIST)
		
		dmg_scale_bar.max_value = _effect.max_scale_including_base
		
		update_display()

#


func _on_effect_curr_dmg_scale_changed(curr_dmg_scale : float, max_dmg_scale : float):
	dmg_scale_bar.current_value = curr_dmg_scale
	
	if is_equal_approx(curr_dmg_scale, max_dmg_scale):
		dmg_scale_bar.fill_foreground_pic = Bar_Full
		print("is full: " + str(curr_dmg_scale))
	else:
		dmg_scale_bar.fill_foreground_pic = Bar_NotFull
		print("is not full: " + str(curr_dmg_scale))
	
#	siphon_bar.current_value = tower.current_siphon_stacks
#	#print(str(ap_bar.current_value) + " --- " + str(ap_bar.max_value))
#
#	if tower.current_siphon_stacks > siphon_bar.max_value:
#		siphon_bar.fill_foreground_pic = Bar_Overflow
#	else:
#		siphon_bar.fill_foreground_pic = Bar_Normal


func _on_effect_being_removed():
	queue_free()

#

func update_display():
	if _effect != null:
		_on_effect_curr_dmg_scale_changed(_effect._current_dmg_scale, _effect.max_scale_including_base)


