extends Sprite

const PillarColor_Blue_Inactive_Pic = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_Pillar/Enchant_Pillar_Blue_Inactive.png")
const PillarColor_Blue_Active_Pic = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_Pillar/Enchant_Pillar_Blue_Active.png")
const PillarColor_Yellow_Inactive_Pic = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_Pillar/Enchant_Pillar_Yellow_Inactive.png")
const PillarColor_Yellow_Active_Pic = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_Pillar/Enchant_Pillar_Yellow_Active.png")
const PillarColor_Red_Inactive_Pic = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_Pillar/Enchant_Pillar_Red_Inactive.png")
const PillarColor_Red_Active_Pic = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_Pillar/Enchant_Pillar_Red_Active.png")
const PillarColor_Green_Inactive_Pic = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_Pillar/Enchant_Pillar_Green_Inactive.png")
const PillarColor_Green_Active_Pic = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_Pillar/Enchant_Pillar_Green_Active.png")
const PillarColor_Gray_Pic = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_Pillar/Enchant_Pillar_Gray_Inactive.png")

#const InMapPlacable_Pic_Blue = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_CustomPlacableTextures/Enchant_InMapPlacable_Blue.png")
#const InMapPlacable_Pic_Yellow = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_CustomPlacableTextures/Enchant_InMapPlacable_Yellow.png")
#const InMapPlacable_Pic_Red = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_CustomPlacableTextures/Enchant_InMapPlacable_Red.png")
#const InMapPlacable_Pic_Green = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_CustomPlacableTextures/Enchant_InMapPlacable_Green.png")

const InMapPlacable_Pic_Default = preload("res://GameElementsRelated/InMapPlacablesRelated/InMapPlacable_Normal.png")

enum PillarColor {
	BLUE = 0,
	YELLOW = 1,
	RED = 2,
	GREEN = 3,
}
var pillar_color : int setget set_pillar_color
var is_active : bool setget set_is_active

var tower_effect_to_give setget set_tower_effect_to_give


var _inactive_texture : Texture
var _active_texture : Texture

var _not_glowing_placable_texture : Texture = InMapPlacable_Pic_Default

var _associated_placables : Array


#

func _ready():
	z_index = ZIndexStore.ABOVE_MAP_ENVIRONMENT
	z_as_relative = false

#

func set_pillar_color(arg_color : int):
	pillar_color = arg_color
	
	if pillar_color == PillarColor.BLUE:
		_inactive_texture = PillarColor_Blue_Inactive_Pic
		_active_texture = PillarColor_Blue_Active_Pic
		
		#_not_glowing_placable_texture = InMapPlacable_Pic_Blue
	elif pillar_color == PillarColor.YELLOW:
		_inactive_texture = PillarColor_Yellow_Inactive_Pic
		_active_texture = PillarColor_Yellow_Active_Pic
		
		#_not_glowing_placable_texture = InMapPlacable_Pic_Yellow
	elif pillar_color == PillarColor.RED:
		_inactive_texture = PillarColor_Red_Inactive_Pic
		_active_texture = PillarColor_Red_Active_Pic
		
		#_not_glowing_placable_texture = InMapPlacable_Pic_Red
	elif pillar_color == PillarColor.GREEN:
		_inactive_texture = PillarColor_Green_Inactive_Pic
		_active_texture = PillarColor_Green_Active_Pic
		
		#_not_glowing_placable_texture = InMapPlacable_Pic_Green
	else:
		_inactive_texture = PillarColor_Gray_Pic
		_active_texture = PillarColor_Gray_Pic
		
		#_not_glowing_placable_texture = InMapPlacable_Pic_Default
	
	_update_pillar_texture_display()
	#_update_associated_placable_textures()

func set_is_active(arg_active):
	var old_is_active_val = is_active
	
	#
	is_active = arg_active
	
	if old_is_active_val != is_active:   # if value has changed
		_update_pillar_texture_display()
		
		if is_active:
			_add_effect_to_all_towers_in_associated_placables()
		else:
			_remove_effect_from_all_towers_in_associated_placables()


func _update_pillar_texture_display():
	if is_active:
		texture = _active_texture
	else:
		texture = _inactive_texture


######

func set_tower_effect_to_give(arg_effect):
	if is_active:
		_remove_effect_from_all_towers_in_associated_placables()
	
	tower_effect_to_give = arg_effect
	
	if is_active:
		_add_effect_to_all_towers_in_associated_placables()

func _remove_effect_from_all_towers_in_associated_placables():
	if tower_effect_to_give != null:
		for placable in _associated_placables:
			if is_instance_valid(placable.tower_occupying):
				_remove_effect_from_tower(placable.tower_occupying)

func _remove_effect_from_tower(arg_tower):
	var effect = arg_tower.get_tower_effect(tower_effect_to_give.effect_uuid)
	if effect != null:
		arg_tower.remove_tower_effect(effect)

func _add_effect_to_all_towers_in_associated_placables():
	if tower_effect_to_give != null:
		
		for placable in _associated_placables:
			if is_instance_valid(placable.tower_occupying):
				_add_effect_to_tower(placable.tower_occupying)


func _add_effect_to_tower(arg_tower):
	if !arg_tower.has_tower_effect_uuid_in_buff_map(tower_effect_to_give.effect_uuid):
		
		var effect = tower_effect_to_give._get_copy_scaled_by(1)
		arg_tower.add_tower_effect(effect)



###########

func add_associated_placable(arg_placable):
	if !_associated_placables.has(arg_placable):
		_associated_placables.append(arg_placable)
	
	if !arg_placable.is_connected("on_occupancy_changed", self, "_on_associated_placable_occupancy_changed"):
		arg_placable.connect("on_occupancy_changed", self, "_on_associated_placable_occupancy_changed", [arg_placable], CONNECT_PERSIST)
		arg_placable.connect("tree_exiting", self, "_on_associated_placable_tree_exiting", [arg_placable], CONNECT_PERSIST)
	
	arg_placable.current_normal_texture = _not_glowing_placable_texture

func _on_associated_placable_occupancy_changed(arg_occupancy_nullable, arg_placable):
	if is_instance_valid(arg_occupancy_nullable) and "tower_type_info" in arg_occupancy_nullable:
		if !arg_occupancy_nullable.is_connected("on_tower_transfered_to_placable", self, "_on_associated_placable_tower_transfered_to_another_placable"):
			arg_occupancy_nullable.connect("on_tower_transfered_to_placable", self, "_on_associated_placable_tower_transfered_to_another_placable", [arg_placable], CONNECT_PERSIST)
		
		if is_active:
			_add_effect_to_tower(arg_occupancy_nullable)

func _on_associated_placable_tower_transfered_to_another_placable(arg_tower, arg_new_placable, arg_orig_placable):
	#if arg_new_placable != arg_orig_placable:
	if !_associated_placables.has(arg_new_placable):
		if arg_tower.is_connected("on_tower_transfered_to_placable", self, "_on_associated_placable_tower_transfered_to_another_placable"):
			arg_tower.disconnect("on_tower_transfered_to_placable", self, "_on_associated_placable_tower_transfered_to_another_placable")
		
		#if !_associated_placables.has(arg_new_placable):
		_remove_effect_from_tower(arg_tower)


func _on_associated_placable_tree_exiting(arg_placable):
	_associated_placables.erase(arg_placable)


#

func set_not_glowing_placable_texture(arg_texture):
	_not_glowing_placable_texture = arg_texture
	_update_associated_placable_textures()

func set_not_glowing_placable_texture_to_default():
	_not_glowing_placable_texture = InMapPlacable_Pic_Default
	_update_associated_placable_textures()

func _update_associated_placable_textures():
	for placable in _associated_placables:
		if is_instance_valid(placable):
			placable.current_normal_texture = _not_glowing_placable_texture

###

func get_position_of_top():
	return global_position + Vector2(0, -offset.y - 4)
	


