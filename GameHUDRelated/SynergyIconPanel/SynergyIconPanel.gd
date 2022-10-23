extends Control


const container_size : float = 28.0

var show_tier : bool = false setget set_show_tier
var _syn_id
var _syn_tier

onready var tier_container = $Control/TierContainer
onready var tier_icon = $Control/TierContainer/TierIcon
onready var tier_label = $Control/TierContainer/TierLabel

onready var syn_icon = $Control/SynIconContainer/SynIcon
onready var syn_container = $Control/SynIconContainer

#

func set_synergy_id_and_tier(arg_syn_id, arg_tier):
	_syn_id = arg_syn_id
	_syn_tier = arg_tier
	
	if is_inside_tree():
		var synergy = _get_synergy_from_id(_syn_id)
		
		if synergy != null:
			var icon = synergy.get_tier_pic_to_use__from_syn_tier(_syn_tier)
			tier_icon.texture = icon
			
			syn_icon.texture = synergy.synergy_picture
			
			var num = synergy.get_tower_count_to_use__from_syn_tier(_syn_tier)
			tier_label.text = str(num)
			#tier_label.set_deferred("text", str(num))


func set_show_tier(arg_val):
	show_tier = arg_val
	
	if is_inside_tree():
		tier_container.visible = show_tier
		_update_positions_of_containers()

#

func _get_synergy_from_id(arg_id):
	var syn_compo = TowerCompositionColors.get_synergy_with_id(arg_id)
	if syn_compo != null:
		return syn_compo
	
	var syn_dom = TowerDominantColors.get_synergy_with_id(arg_id)
	return syn_dom

func _update_positions_of_containers():
	if show_tier:
		syn_container.rect_position.x = container_size
		rect_min_size.x = container_size * 2
		rect_size.x = container_size * 2
	else:
		syn_container.rect_position.x = 0
		rect_min_size.x = container_size
		rect_size.x = container_size

#

func _ready():
	set_synergy_id_and_tier(_syn_id, _syn_tier)
	set_show_tier(show_tier)
