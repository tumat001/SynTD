extends Node2D


export(float) var value_per_chunk : float = 10.0
export(bool) var display_chunks : bool = false
var chunks : Array = []
export(Texture) var chunk_separator_pic : Texture

var max_value : float setget set_max_value
var current_value : float setget set_current_value

var scale_of_scale : Vector2 = Vector2(1, 1)

onready var fill_foreground : AnimatedSprite = $BarFillForeground
onready var chunks_container : Node2D = $Chunks


func _ready():
	scale *= scale_of_scale


func set_current_value(value : float):
	current_value = value
	var ratio = current_value / max_value
	
	fill_foreground.scale.x = ratio

func set_max_value(value : float):
	max_value = value
	
	redraw_chunks()

func set_display_chunks(value : bool):
	display_chunks = value
	
	redraw_chunks()

func set_value_per_chunk(value : float):
	value_per_chunk = value
	
	redraw_chunks()

# Chunks related

func redraw_chunks():
	if display_chunks:
		var num = _number_of_chunks()
		
		_update_chunk_sprites_pool(num)
		var poses = _get_determined_positions_of_chunks(num)
		
		for n in chunks_container.get_children():
			#chunks_container.remove_child(n)
			n.visible = false
		
		for i in num:
			var chunk = chunks[i]
			chunk.position.x = poses[i]
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

func _construct_chunk_sprite_node() -> Sprite:
	var sprite : Sprite = Sprite.new()
	sprite.texture = chunk_separator_pic
	sprite.centered = false
	sprite.visible = false
	
	chunks_container.add_child(sprite)
	
	return sprite

# Chunk positioning related

func get_bar_fill_foreground_size() -> Vector2:
	return fill_foreground.frames.get_frame(fill_foreground.animation, fill_foreground.frame).get_size()

func _get_determined_positions_of_chunks(num) -> Array:
	var bucket : Array = []
	
	for i in num:
		i += 1
		
		var indi_value = i * value_per_chunk
		var total_width = get_bar_fill_foreground_size().x
		var precise_pos = (indi_value / max_value) * total_width  
		
		bucket.append(round(precise_pos))
	
	return bucket

# Overriding stuffs

func queue_free():
	for n in chunks:
		n.queue_free()
	
	.queue_free()
