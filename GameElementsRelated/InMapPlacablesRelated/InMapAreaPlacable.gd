extends "res://GameElementsRelated/AreaTowerPlacablesRelated/BaseAreaTowerPlacable.gd"

const glowing = preload("res://GameElementsRelated/InMapPlacablesRelated/InMapPlacable_Glowing.png")
const normal = preload("res://GameElementsRelated/InMapPlacablesRelated/InMapPlacable_Normal.png")
const hidden = preload("res://GameElementsRelated/InMapPlacablesRelated/InMapPlacable_Hidden.png")

var current_texture
var is_hidden : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	set_area_texture_to_not_glow()
	set_hidden(false)

func set_area_texture_to_glow():
	$AreaSprite.texture = glowing
	current_texture = glowing

func set_area_texture_to_not_glow():
	if !is_hidden:
		$AreaSprite.texture = normal
	else:
		$AreaSprite.texture = hidden
	current_texture = normal

func set_hidden(hidden : bool):
	is_hidden = hidden
	if hidden:
		$AreaSprite.texture = hidden
	else:
		$AreaSprite.texture = current_texture


func get_placable_type_name() -> String:
	return "InMapAreaPlacable"
