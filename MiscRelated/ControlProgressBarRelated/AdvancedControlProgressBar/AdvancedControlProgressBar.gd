extends MarginContainer

export(float) var value_per_chunk : float = 10.0
export(bool) var display_chunks : bool = false
var chunks : Array = []
export(Texture) var chunk_separator_pic : Texture

export(float) var max_value : float = 5 setget set_max_value
export(bool) var allow_overflow : bool = false setget set_overflow

export(Texture) var bar_background_pic : Texture setget set_bar_background_pic
export(float) var fill_foreground_margin_top : float
export(float) var fill_foreground_margin_left : float

var _id_to_bar_foreground_map : Dictionary
var _id_to_curr_val_map : Dictionary

export(Vector2) var scale_of_bars_scale : Vector2 = Vector2(2, 1)

export(float) var fill_foreground_width : float # not determiable during run time, must be known beforehand.
export(bool) var yield_before_update : bool = false


onready var bar_backround : TextureRect = $BarBackgroundPanel/BarBackground

onready var chunks_container : Control = $BarFillForegroundsPanel/Chunks
onready var bar_fill_foreground_marginer : MarginContainer = $BarFillForegroundsPanel



#


func _ready():
	rect_scale *= scale_of_bars_scale
	
	bar_backround.texture = bar_background_pic
	
	bar_fill_foreground_marginer.add_constant_override("margin_top", fill_foreground_margin_top) 
	bar_fill_foreground_marginer.add_constant_override("margin_left", fill_foreground_margin_left)
	
	set_max_value(max_value)
	
	connect("visibility_changed", self, "_on_visibility_changed", [], CONNECT_PERSIST | CONNECT_DEFERRED)

#

func set_bar_background_pic(value : Texture):
	bar_background_pic = value
	
	if is_instance_valid(bar_backround) and bar_backround.is_inside_tree():
		bar_backround.texture = value



##

func add_bar_foreground(arg_id : int, arg_texture : Texture):
	if !_id_to_bar_foreground_map.has(arg_id):
		var rect = _create_bar_foreground(arg_texture)
		_id_to_bar_foreground_map[arg_id] = rect
		_id_to_curr_val_map[arg_id] = 0

func _create_bar_foreground(arg_texture : Texture) -> TextureRect:
	var rect = TextureRect.new()
	rect.size_flags_horizontal = SIZE_EXPAND_FILL
	rect.texture = arg_texture
	rect.rect_scale.x = 0
	bar_fill_foreground_marginer.add_child(rect)
	
	return rect



func set_bar_foreground_texture(arg_id : int, arg_texture : Texture):
	if _id_to_bar_foreground_map.has(arg_id):
		var rect = _id_to_bar_foreground_map[arg_id]
		
		rect.texture = arg_texture

func set_bar_foreground_current_value(arg_id : int, arg_val : float, arg_adjust_pos_of_others : bool = true):
	if _id_to_bar_foreground_map.has(arg_id):
		var rect = _id_to_bar_foreground_map[arg_id]
		_id_to_curr_val_map[arg_id] = arg_val
		
		var ratio = arg_val / max_value
		
		call_deferred("_set_vals_deferred", ratio, rect, arg_id)
		
#		if yield_before_update: #and is_instance_valid(self):
#			yield(get_tree(), "idle_frame")
#
#		if !allow_overflow and ratio > 1:
#			ratio = 1
#
#		rect.rect_scale.x = ratio
#
#
#		# adjust other's position
#		var total_x_size_of_all : float = fill_foreground_margin_left
#		var skip : bool = true
#		for id in _id_to_bar_foreground_map.keys():
#			if id == arg_id:
#				skip = false
#			elif id != arg_id and !skip:
#				var curr_rect = _id_to_bar_foreground_map[id] 
#				curr_rect.rect_position.x = total_x_size_of_all
#
#
#			#
#			var _curr_rect = _id_to_bar_foreground_map[id]
#			total_x_size_of_all += _curr_rect.rect_size.x * _curr_rect.rect_scale.x


func _set_vals_deferred(ratio : float, rect, arg_id):
	if !allow_overflow and ratio > 1:
		ratio = 1
	
	rect.rect_scale.x = ratio
	
	# adjust other's position
	var total_x_size_of_all : float = fill_foreground_margin_left
	var skip : bool = true
	for id in _id_to_bar_foreground_map.keys():
		if id == arg_id:
			skip = false
		elif id != arg_id and !skip:
			var curr_rect = _id_to_bar_foreground_map[id] 
			curr_rect.rect_position.x = total_x_size_of_all
			
		
		#
		var _curr_rect = _id_to_bar_foreground_map[id]
		#total_x_size_of_all += (_curr_rect.rect_size.x * _curr_rect.rect_scale.x)
		total_x_size_of_all += (_curr_rect.texture.get_size().x * _curr_rect.rect_scale.x)




func update_each_bar_position_based_on_each_other():
	var total_x_size_of_all : float = fill_foreground_margin_left
	
	for id in _id_to_bar_foreground_map.keys():
		var curr_rect = _id_to_bar_foreground_map[id] 
		curr_rect.rect_position.x = total_x_size_of_all
		
		#
		
		var _curr_rect = _id_to_bar_foreground_map[id]
		total_x_size_of_all += _curr_rect.rect_size.x * _curr_rect.rect_scale.x



func _update_all_bar_foregrounds_curr_val():
	var first_id : float = -1
	var is_first_id_known : bool = false
	
	for id in _id_to_bar_foreground_map.keys():
		if !is_first_id_known:
			is_first_id_known = true
			first_id = id
		
		var curr_val = _id_to_curr_val_map[id]
		set_bar_foreground_current_value(id, curr_val, false)
	
	if _id_to_bar_foreground_map.has(first_id):
		set_bar_foreground_current_value(first_id, _id_to_curr_val_map[first_id], true)

#

func set_overflow(value : bool):
	allow_overflow = value
	
	_update_all_bar_foregrounds_curr_val()



func set_max_value(value : float):
	if value <= 0:
		value = 1
	
	max_value = value
	_update_all_bar_foregrounds_curr_val()
	
	redraw_chunks()


# Chunks related

func redraw_chunks():
	if is_instance_valid(chunks_container):
		if display_chunks:
			var num = _number_of_chunks()
			
			_update_chunk_sprites_pool(num)
			var poses = _get_determined_positions_of_chunks(num)
			
			for n in chunks_container.get_children():
				n.visible = false
				#chunks_container.remove_child(n)
			
			for i in num:
				var chunk = chunks[i]
				chunk.rect_position.x = poses[i]
				chunk.visible = true
				#chunks_container.add_child(chunk)
			
		else:
			for n in chunks_container.get_children():
				n.visible = false
				#chunks_container.remove_child(n)
		

##### Updating chunk pool related #######

func _update_chunk_sprites_pool(num : int):
	while num > chunks.size():
		chunks.append(_construct_chunk_sprite_node())

func _number_of_chunks():
	return floor((max_value - 1) / value_per_chunk)

func _construct_chunk_sprite_node() -> TextureRect:
	var sprite : TextureRect = TextureRect.new()
	sprite.texture = chunk_separator_pic
	sprite.mouse_filter = MOUSE_FILTER_IGNORE
	sprite.visible = false
	
	chunks_container.add_child(sprite)
	
	return sprite


# Chunk positioning related

func get_bar_fill_foreground_x() -> float:
	return fill_foreground_width

func _get_determined_positions_of_chunks(num) -> Array:
	var bucket : Array = []
	
	for i in num:
		i += 1
		
		var indi_value = i * value_per_chunk
		var total_width = get_bar_fill_foreground_x()
		var precise_pos = (indi_value / max_value) * total_width  
		precise_pos -= (chunk_separator_pic.get_size().x / 2)
		
		
		bucket.append(round(precise_pos))
	
	return bucket

#

func _on_visibility_changed():
	if visible:
		_update_all_bar_foregrounds_curr_val()
		set_max_value(max_value)

