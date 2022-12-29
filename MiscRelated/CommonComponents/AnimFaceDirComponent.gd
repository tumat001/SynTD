extends Reference

signal on_animation_of_of_anim_sprite_changed(anim_name)


const dir_omni_name : String = "Omni"
const dir_west_name : String = "W"
const dir_north_name : String = "N"
const dir_east_name : String = "E"
const dir_south_name : String = "S"

const dir_none_name_ERR : String = "ERR"

const dir_no_health_modifier : String = "_NoHealth"


# find anim with name of omni first, then with name of east. play as start as default, and on round end.
var initial_dir_as_name_hierarchy : Array = [ 
	
]


var dir_name_to_primary_rad_angle_map : Dictionary = {}

var _current_dir_name_to_rad_angle_range : Dictionary = {}
var _current_anim_names
var _sprite_frames : SpriteFrames
var _current_dir_as_name : String
var _anim_sprite : AnimatedSprite

var _aux_sprites_param : Array # NEEDED to make them not unreferenced from 0 ref count


var dir_name_normal_to_dir_name_no_health_map : Dictionary = {}
var dir_name_no_health_to_dir_name_normal_map : Dictionary = {}


#

func initialize_with_sprite_frame_to_monitor(arg_sprite_frames : SpriteFrames, arg_anim_sprite : AnimatedSprite, arg_anim_names_to_use = null, arg_custom_dir_name_to_primary_rad_angle_map = null, arg_default_dir_name_hierarcy = null):
	_sprite_frames = arg_sprite_frames
	_anim_sprite = arg_anim_sprite
	
	var animation_names
	if arg_anim_names_to_use == null:
		animation_names = _sprite_frames.get_animation_names()
	else:
		animation_names = arg_anim_names_to_use
	
	update_dir_name_to_primary_rad_angle_map(animation_names, arg_custom_dir_name_to_primary_rad_angle_map, arg_default_dir_name_hierarcy)

func generate_default_dir_name_to_primary_rad_angle_map():
	return {
		dir_omni_name : PI / 2,
		dir_west_name : 0,
		dir_north_name : PI / 2,
		dir_east_name : PI,
		dir_south_name : -PI / 2,
	}

func generate_default_dir_name_hierarchy():
	return [
		dir_omni_name,
		dir_east_name,
	]

func update_dir_name_to_primary_rad_angle_map(arg_anim_names_to_use : Array, arg_custom_dir_name_to_primary_rad_angle_map = null, arg_default_dir_name_hierarcy = null):
	# removes names with no_health "modifier"/"tag"
	for name in arg_anim_names_to_use:
		if dir_no_health_modifier in name:
			arg_anim_names_to_use.erase(name)
	
	#
	_current_anim_names = arg_anim_names_to_use
	var anim_count : int = arg_anim_names_to_use.size()
	
	if arg_custom_dir_name_to_primary_rad_angle_map == null:
		dir_name_to_primary_rad_angle_map = generate_default_dir_name_to_primary_rad_angle_map()
	else:
		dir_name_to_primary_rad_angle_map = arg_custom_dir_name_to_primary_rad_angle_map
	
	if arg_default_dir_name_hierarcy == null:
		initial_dir_as_name_hierarchy = generate_default_dir_name_hierarchy()
	else:
		initial_dir_as_name_hierarchy = arg_default_dir_name_hierarcy
	
	dir_name_normal_to_dir_name_no_health_map.clear()
	dir_name_no_health_to_dir_name_normal_map.clear()
	
	for anim_name in dir_name_to_primary_rad_angle_map.keys():#arg_anim_names_to_use:
		var primary_angle_of_anim : float = dir_name_to_primary_rad_angle_map[anim_name]
		var angle_range : Array = []
		angle_range.append(rad2deg(primary_angle_of_anim - (PI / anim_count)))
		angle_range.append(rad2deg(primary_angle_of_anim + (PI / anim_count)))
		_current_dir_name_to_rad_angle_range[anim_name] = angle_range
		
		var anim_name_for_no_health = anim_name + dir_no_health_modifier
		dir_name_normal_to_dir_name_no_health_map[anim_name] = anim_name_for_no_health
		dir_name_no_health_to_dir_name_normal_map[anim_name_for_no_health] = anim_name
	
	#
	
	if dir_name_to_primary_rad_angle_map.keys().has(_current_dir_as_name):
		set_animation_sprite_animation_using_anim_name(_anim_sprite, _current_dir_as_name)

#

func set_animated_sprite_animation_to_default(arg_animated_sprite : AnimatedSprite):
	if is_instance_valid(_sprite_frames):
		var animation_names : PoolStringArray = _sprite_frames.get_animation_names()
		
		for dir_name in initial_dir_as_name_hierarchy:
			for anim_name in animation_names:
				if dir_name == anim_name:
					_current_dir_as_name = dir_name
					arg_animated_sprite.animation = dir_name
					break
	
	update_state_of_aux_sprite_texture_to_use()


func get_anim_name_to_use_based_on_angle(arg_angle):
	arg_angle = rad2deg(arg_angle)
	var index = 0
	var anim_names = _current_anim_names #_sprite_frames.get_animation_names()
	var anim_count : int = anim_names.size()
	
	for anim_name in anim_names:
		if _current_dir_name_to_rad_angle_range.has(anim_name):
			var angle_range = _current_dir_name_to_rad_angle_range[anim_name]
			#print("anim name: %s, range: %s" % [anim_name, angle_range])
			if Targeting.is_angle_between_angles__do_no_correction(arg_angle, angle_range[0], angle_range[1]):
				#print(anim_name)
				return anim_name
			
			if index == anim_count - 1: # guarantee to return last/previous anim name
				#print(anim_name)
				return anim_name
		
		index += 1
	
	#print(dir_none_name_ERR)
	return dir_none_name_ERR # unreachable unless no anim names


func set_animation_sprite_animation_using_anim_name(arg_anim_sprite : AnimatedSprite, arg_anim_name : String):
	if arg_anim_name != dir_none_name_ERR:
		arg_anim_sprite.animation = arg_anim_name
		_current_dir_as_name = arg_anim_name
		
		emit_signal("on_animation_of_of_anim_sprite_changed", arg_anim_name)


##

func get_anim_name_to_use_on_no_health_based_on_current_name():
	if dir_name_normal_to_dir_name_no_health_map.has(_current_dir_as_name):
		return dir_name_normal_to_dir_name_no_health_map[_current_dir_as_name]
	else:
		return dir_none_name_ERR

func get_anim_name_to_use_on_normal_based_on_current_no_health_name():
	if dir_name_no_health_to_dir_name_normal_map.has(_current_dir_as_name):
		return dir_name_no_health_to_dir_name_normal_map[_current_dir_as_name]
	else:
		return dir_none_name_ERR


static func get_name_of_dir_with_no_health_modifier(arg_base_dir_name : String):
	return arg_base_dir_name + dir_no_health_modifier

###

class AuxSpritesParameters:
	var pos_of_sprite_on_dir : Dictionary
	var texture_to_use_on_dir : Dictionary
	var flip_h_to_use_on_dir : Dictionary
	
	var use_get_method_for_texture : bool = false
	var get_method_source_for_texture
	var texture_get_method_to_use_on_dir : Dictionary
	
	var sprite : Sprite
	
	#
	
	func configure_param_with__E_pos__E_texture__E_flip__for_W_and_E(arg_E_pos : Vector2, arg_E_texture : Texture, arg_E_flip : bool):
		_generate_poses_based_on_E_pos__for_W_and_E(arg_E_pos)
		_generate_textures_and_flip_based_on_E_texture_and_flip__for_W_and_E(arg_E_texture, arg_E_flip)
	
	func _generate_poses_based_on_E_pos__for_W_and_E(arg_E_pos : Vector2):
		pos_of_sprite_on_dir[dir_east_name] = arg_E_pos
		pos_of_sprite_on_dir[dir_west_name] = Vector2(-arg_E_pos.x, arg_E_pos.y)
		
		pos_of_sprite_on_dir[dir_east_name + dir_no_health_modifier] = arg_E_pos
		pos_of_sprite_on_dir[dir_west_name + dir_no_health_modifier] = Vector2(-arg_E_pos.x, arg_E_pos.y)
		
	
	func _generate_textures_and_flip_based_on_E_texture_and_flip__for_W_and_E(arg_E_texture : Texture, arg_E_flip):
		use_get_method_for_texture = false
		texture_to_use_on_dir[dir_east_name] = arg_E_texture
		flip_h_to_use_on_dir[dir_east_name] = arg_E_flip
		
		texture_to_use_on_dir[dir_east_name + dir_no_health_modifier] = arg_E_texture
		flip_h_to_use_on_dir[dir_east_name + dir_no_health_modifier] = arg_E_flip
		
		
		texture_to_use_on_dir[dir_west_name] = arg_E_texture
		flip_h_to_use_on_dir[dir_east_name] = !arg_E_flip
		
		texture_to_use_on_dir[dir_west_name + dir_no_health_modifier] = arg_E_texture
		flip_h_to_use_on_dir[dir_east_name + dir_no_health_modifier] = !arg_E_flip
	
	
	func configure_param_with__E_pos__E_texture_get_method__E_flip__for_W_and_E(arg_E_pos : Vector2, arg_texture_dir_name_to_get_methods : Dictionary, arg_E_texture_get_source, arg_E_flip : bool):
		get_method_source_for_texture = arg_E_texture_get_source
		_generate_poses_based_on_E_pos__for_W_and_E(arg_E_pos)
		_generate_textures_and_flip_based_on_E_texture_get_method_and_flip__for_W_and_E(arg_texture_dir_name_to_get_methods, arg_E_flip)
	
	func _generate_textures_and_flip_based_on_E_texture_get_method_and_flip__for_W_and_E(arg_texture_dir_name_to_get_methods : Dictionary, arg_E_flip):
		use_get_method_for_texture = true
		texture_get_method_to_use_on_dir = arg_texture_dir_name_to_get_methods
		
		flip_h_to_use_on_dir[dir_east_name] = arg_E_flip
		flip_h_to_use_on_dir[dir_east_name + dir_no_health_modifier] = arg_E_flip
		
		flip_h_to_use_on_dir[dir_west_name] = !arg_E_flip
		flip_h_to_use_on_dir[dir_west_name + dir_no_health_modifier] = !arg_E_flip
		
	
	static func construct_empty_texture_dir_name_to_get_methods_map__for_W_and_E() -> Dictionary:
		return {
			dir_east_name : "",
			dir_west_name : "",
			
			dir_east_name + dir_no_health_modifier : "",
			dir_west_name + dir_no_health_modifier : "",
		}
	
	
	#
	
	func _connect_with_anim_face_dir__change_aux_sprites_on_dir_changed(arg_anim_dir_compo, update_now : bool):
		arg_anim_dir_compo.connect("on_animation_of_of_anim_sprite_changed", self, "_on_anim_dir_changed", [], CONNECT_PERSIST)
		if update_now:
			_on_anim_dir_changed(arg_anim_dir_compo._current_dir_as_name)
	
	func _on_anim_dir_changed(arg_anim_dir_name):
		update_state_of_sprite_texture_to_use(arg_anim_dir_name)

	
	func update_state_of_sprite_texture_to_use(arg_anim_dir_name):
		if !use_get_method_for_texture:
			sprite.texture = texture_to_use_on_dir[arg_anim_dir_name]
		else:
			sprite.texture = get_method_source_for_texture.call(texture_get_method_to_use_on_dir[arg_anim_dir_name])
		
		sprite.position = pos_of_sprite_on_dir[arg_anim_dir_name]
		sprite.flip_h = flip_h_to_use_on_dir[arg_anim_dir_name]

func set__and_update_auxilliary_sprites_on_anim_change(arg_aux_sprites_param : AuxSpritesParameters, update_now : bool = false):
	arg_aux_sprites_param._connect_with_anim_face_dir__change_aux_sprites_on_dir_changed(self, update_now)
	_aux_sprites_param.append(arg_aux_sprites_param)

func update_state_of_aux_sprite_texture_to_use():
	for aux_param in _aux_sprites_param:
		aux_param.update_state_of_sprite_texture_to_use(_current_dir_as_name)

###

func get_current_dir_as_name():
	return _current_dir_as_name

# use this if you know what you're doing (look at LesSemis for example)
func set_current_dir_as_name(arg_name):
	_current_dir_as_name = arg_name


