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

var scale_of_scale : Vector2 = Vector2(1, 1)

export(bool) var yield_before_update : bool = false

onready var bar_backround : TextureRect = $BarBackgroundPanel/BarBackground
onready var fill_foreground : TextureRect = $BarFillForeground/FillForeground
onready var chunks_container : Control = $BarFillForeground/Chunks
onready var bar_fill_foreground_marginer : MarginContainer = $BarFillForeground


# setters

func set_bar_background_pic(value : Texture):
	bar_background_pic = value
	
	if bar_backround != null:
		bar_backround.texture = value


func set_fill_foreground_pic(value : Texture):
	fill_foreground_pic = value
	
	if fill_foreground != null:
		fill_foreground.texture = value


#

func _ready():
	rect_scale *= scale_of_scale
	
	bar_backround.texture = bar_background_pic
	fill_foreground.texture = fill_foreground_pic
	
	bar_fill_foreground_marginer.add_constant_override("margin_top", fill_foreground_margin_top) 
	bar_fill_foreground_marginer.add_constant_override("margin_left", fill_foreground_margin_left)
	
	set_current_value(current_value)
	set_max_value(max_value)


func set_current_value(value : float):
	current_value = value
	
	if fill_foreground != null:
		var ratio = current_value / max_value
		
		if yield_before_update:
			yield(get_tree(), "idle_frame")
		
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
	if chunks_container != null:
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


# Overriding stuffs

func queue_free():
	for n in chunks:
		n.queue_free()
	
	.queue_free()
