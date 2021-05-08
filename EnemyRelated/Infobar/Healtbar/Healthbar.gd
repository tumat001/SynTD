extends Node2D

const chunk_separator_pic = preload("res://EnemyRelated/Infobar/Healtbar/Healthbar_separator.png")

const health_per_chunk : float = 10.0

var base_health : float
var default_scale = 1

var chunks : Array = []

func _ready():
	scale *= default_scale

func get_size() -> Vector2:
	return $Healthbar_background.texture.get_size()


func _on_current_health_changed(curr_health : float):
	var ratio = curr_health / base_health
	
	$Healthbar_health.scale.x = ratio

func _on_base_health_changed(arg_base_health : float):
	base_health = arg_base_health
	redraw_chunks()

# Chunks related

func redraw_chunks():
	var num = _number_of_chunks()
	
	_update_chunk_sprites_pool(num)
	var poses = _get_determined_positions_of_chunks(num)
	
	for n in $Chunks.get_children():
		$Chunks.remove_child(n)
	
	for i in num:
		var chunk = chunks[i]
		chunk.position.x = poses[i]
		$Chunks.add_child(chunk)
		
	


# Updating chunk pool related

func _update_chunk_sprites_pool(num : int):
	while num > chunks.size():
		chunks.append(_construct_chunk_sprite_node())

func _number_of_chunks():
	return floor((base_health - 1) / health_per_chunk)

func _construct_chunk_sprite_node() -> Sprite:
	var sprite : Sprite = Sprite.new()
	sprite.texture = chunk_separator_pic
	sprite.centered = false
	
	return sprite

# Chunk positioning related

func _get_healthbar_heath_size() -> Vector2:
	return $Healthbar_health.texture.get_size()

func _get_determined_positions_of_chunks(num) -> Array:
	var bucket : Array = []
	
	for i in num:
		i += 1
		
		var indi_health = i * health_per_chunk
		var total_width = _get_healthbar_heath_size().x
		var precise_pos = (indi_health / base_health) * total_width  
		
		bucket.append(round(precise_pos))
	
	return bucket

# Overriding stuffs

func queue_free():
	for n in chunks:
		n.queue_free()
	
	.queue_free()
