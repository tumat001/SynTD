extends MarginContainer


export(float) var value_per_chunk : float = 10.0
export(bool) var display_chunks : bool = false
var chunks : Array = []
export(Texture) var chunk_separator_pic : Texture

export(Texture) var bar_background_pic : Texture setget set_bar_background_pic
export(Texture) var fill_foreground_pic : Texture setget set_fill_foreground_pic
export(float) var fill_foreground_margin_top : float
export(float) var fill_foreground_margin_left : float

export(float) var max_value : float = 5 setget set_max_value
export(float) var current_value : float = 5 setget set_current_value
export(bool) var allow_overflow : bool = false setget set_overflow

export(Vector2) var scale_of_bars_scale : Vector2 = Vector2(2, 1)

export(bool) var yield_before_update : bool = false

var _is_in_yield : bool = false
var _queue_free_called_during_yield : bool = false

onready var bar_backround : TextureRect = $BarBackgroundPanel/BarBackground
onready var fill_foreground : TextureRect = $BarFillForeground/FillForeground

onready var chunks_container : Control = $BarFillForeground/Chunks
onready var bar_fill_foreground_marginer : MarginContainer = $BarFillForeground


# setters

func set_bar_background_pic(value : Texture):
	bar_background_pic = value
	
	if is_instance_valid(bar_backround) and bar_backround.is_inside_tree():
		bar_backround.texture = value


func set_fill_foreground_pic(value : Texture):
	fill_foreground_pic = value
	
	if is_instance_valid(fill_foreground) and fill_foreground.is_inside_tree():
		fill_foreground.texture = value


#

func _ready():
	rect_scale *= scale_of_bars_scale
	
	bar_backround.texture = bar_background_pic
	fill_foreground.texture = fill_foreground_pic
	
	bar_fill_foreground_marginer.add_constant_override("margin_top", fill_foreground_margin_top) 
	bar_fill_foreground_marginer.add_constant_override("margin_left", fill_foreground_margin_left)
	
	
	set_current_value(current_value)
	set_max_value(max_value)
	
	connect("visibility_changed", self, "_on_visibility_changed", [], CONNECT_PERSIST | CONNECT_DEFERRED)


func set_current_value(value : float):
	current_value = value
	
	if is_instance_valid(fill_foreground):
		var ratio = current_value / max_value
		call_deferred("_set_curr_value_deferred", ratio)
#		if yield_before_update:
#			set_val_for_is_in_yield(true)
#			if !is_queued_for_deletion():
#				yield(get_tree(), "idle_frame")
#
#			set_val_for_is_in_yield(false)
#
#		if !allow_overflow and ratio > 1:
#			ratio = 1
#
#		fill_foreground.rect_scale.x = ratio

func _set_curr_value_deferred(ratio : float):
	if !allow_overflow and ratio > 1:
		ratio = 1
	
	fill_foreground.rect_scale.x = ratio




func set_max_value(value : float):
	max_value = value
	set_current_value(current_value)
	
	redraw_chunks()

func set_display_chunks(value : bool):
	display_chunks = value
	
	redraw_chunks()

func set_value_per_chunk(value : float):
	value_per_chunk = value
	
	redraw_chunks()

func set_overflow(value : bool):
	allow_overflow = value
	
	set_current_value(current_value)


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
		

# Updating chunk pool related

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

func get_bar_fill_foreground_size() -> Vector2:
	return fill_foreground_pic.get_size()

func _get_determined_positions_of_chunks(num) -> Array:
	var bucket : Array = []
	
	for i in num:
		i += 1
		
		var indi_value = i * value_per_chunk
		var total_width = get_bar_fill_foreground_size().x
		var precise_pos = (indi_value / max_value) * total_width  
		precise_pos -= (chunk_separator_pic.get_size().x / 2)
		
		
		bucket.append(round(precise_pos))
	
	return bucket


#

func set_val_for_is_in_yield(arg_val):
	_is_in_yield = arg_val
	
	if !_is_in_yield and _queue_free_called_during_yield:
		queue_free()

# Overriding stuffs

func queue_free():
	if !_is_in_yield:
		if !is_queued_for_deletion():
			for n in chunks:
				n.queue_free()
			
			.queue_free()
		
	else:
		_queue_free_called_during_yield = true


#

func _on_visibility_changed():
	if visible:
		set_current_value(current_value)
		set_max_value(max_value)

