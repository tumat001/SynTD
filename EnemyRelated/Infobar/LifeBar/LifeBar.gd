extends MarginContainer


export(float) var value_per_chunk : float = 10.0
export(int) var big_chunk_interval : int = 5
export(bool) var display_chunks : bool = false
var chunks : Array = []
export(Texture) var chunk_separator_pic : Texture
export(Texture) var chunk_big_separator_pic : Texture

export(Texture) var bar_background_pic : Texture setget set_bar_background_pic
export(Texture) var fill_health_foreground_pic : Texture setget set_fill_health_foreground_pic
export(Texture) var fill_shield_foreground_pic : Texture setget set_fill_shield_foreground_pic
export(float) var fill_foreground_margin_top : float
export(float) var fill_foreground_margin_left : float

export(int) var max_value : float = 5 setget set_max_value
export(int) var current_health_value : float = 5 setget set_current_health_value
export(int) var current_shield_value : float = 5 setget set_current_shield_value
export(bool) var allow_overflow : bool = false setget set_overflow

export(Vector2) var scale_of_bars_scale : Vector2 = Vector2(1, 1)

onready var bar_background : TextureRect = $BarBackgroundPanel/BarBackground
onready var fill_health_foreground : TextureRect = $BarFillForeground/FillHealthForeground
onready var fill_shield_foreground : TextureRect = $BarFillForeground/FillShieldForeground
onready var chunks_container : Control = $BarFillForeground/Chunks
onready var bar_fill_foreground_marginer : MarginContainer = $BarFillForeground


# setters

func set_bar_background_pic(value : Texture):
	bar_background_pic = value
	
	if is_instance_valid(bar_background):
		bar_background.texture = value


func set_fill_health_foreground_pic(value : Texture):
	fill_health_foreground_pic = value
	
	if is_instance_valid(fill_health_foreground):
		fill_health_foreground.texture = value

func set_fill_shield_foreground_pic(value : Texture):
	fill_shield_foreground_pic = value
	
	if is_instance_valid(fill_shield_foreground):
		fill_shield_foreground.texture = value



#

func _ready():
	bar_background.texture = bar_background_pic
	fill_health_foreground.texture = fill_health_foreground_pic
	fill_shield_foreground.texture = fill_shield_foreground_pic
	
	#update_first_time()

func update_first_time():
	#rect_scale *= scale_of_bars_scale
	
	#bar_background.texture = bar_background_pic
	#fill_health_foreground.texture = fill_health_foreground_pic
	#fill_shield_foreground.texture = fill_shield_foreground_pic
	
	bar_fill_foreground_marginer.add_constant_override("margin_top", fill_foreground_margin_top * scale_of_bars_scale.y) 
	bar_fill_foreground_marginer.add_constant_override("margin_left", fill_foreground_margin_left * scale_of_bars_scale.x)
	bar_fill_foreground_marginer.add_constant_override("margin_bottom", fill_foreground_margin_top * scale_of_bars_scale.y) 
	
	yield(get_tree(), "idle_frame") #
	
	bar_background.rect_scale *= scale_of_bars_scale
	fill_health_foreground.rect_scale *= scale_of_bars_scale
	fill_shield_foreground.rect_scale *= scale_of_bars_scale
	
	set_current_health_value(current_health_value)
	set_current_shield_value(current_shield_value)
	set_max_value(max_value)
	
	rect_size.y = 0
	rect_min_size.y = 0
	bar_fill_foreground_marginer.rect_size.y = 0
	bar_fill_foreground_marginer.rect_min_size.y = 0
	#chunks_container.rect_position.y -= fill_health_foreground_pic.get_size().y



func set_current_health_value(value : float):
	current_health_value = value
	
	if is_instance_valid(fill_health_foreground):
		var ratio = current_health_value / max_value
		
		if !allow_overflow and ratio > 1:
			ratio = 1
		if ratio < 0:
			ratio = 0
		
		fill_health_foreground.rect_scale.x = ratio * scale_of_bars_scale.x
		#fill_health_foreground.rect_size.x = fill_health_foreground_pic.get_size().x * ratio * scale_of_bars_scale.x


func set_current_shield_value(value : float):
	current_shield_value = value
	
	if is_instance_valid(fill_shield_foreground):
		var ratio = current_shield_value / max_value
		
		if !allow_overflow and ratio > 1:
			ratio = 1
		if ratio < 0:
			ratio = 0
		
		fill_shield_foreground.rect_scale.x = ratio * scale_of_bars_scale.x


func set_max_value(value : float):
	max_value = value
	set_current_health_value(current_health_value)
	set_current_shield_value(current_shield_value)
	
	redraw_chunks()

func set_display_chunks(value : bool):
	display_chunks = value
	
	redraw_chunks()

func set_value_per_chunk(value : float):
	value_per_chunk = value
	
	redraw_chunks()

func set_overflow(value : bool):
	allow_overflow = value
	
	set_current_health_value(current_health_value)
	set_current_shield_value(current_shield_value)


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
				chunk.rect_scale.y = scale_of_bars_scale.y
				
				if (i + 1) % big_chunk_interval == 0:
					chunk.texture = chunk_big_separator_pic
				else:
					chunk.texture = chunk_separator_pic
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
	#sprite.texture = chunk_separator_pic
	sprite.mouse_filter = MOUSE_FILTER_IGNORE
	sprite.visible = false
	
	chunks_container.add_child(sprite)
	
	return sprite


# Chunk positioning related

func get_bar_fill_foreground_size() -> Vector2:
	return fill_health_foreground.get_size()

func _get_determined_positions_of_chunks(num) -> Array:
	var bucket : Array = []
	
	for i in num:
		i += 1
		
		var indi_value = i * value_per_chunk * scale_of_bars_scale.x
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
