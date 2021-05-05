extends Node2D

var tower_occupying

# Called when the node enters the scene tree for the first time.
func _ready():
	z_as_relative = false
	z_index = ZIndexStore.TOWER_PLACABLES

func get_tower_center_position() -> Vector2:
	return $TowerCenterLocation.global_position

func set_tower_highlight_sprite(texture : Resource):
	$TowerHighlightSprite.texture = texture

func set_area_texture_to_glow():
	pass

func set_area_texture_to_not_glow():
	pass

func get_area_shape():
	var new_rect = RectangleShape2D.new() 
	new_rect.extents.x = $AreaShape.shape.extents.x
	new_rect.extents.y = $AreaShape.shape.extents.y
	
	return new_rect