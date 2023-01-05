extends "res://GameElementsRelated/AreaTowerPlacablesRelated/BaseAreaTowerPlacable.gd"

const glowing = preload("res://GameElementsRelated/InMapPlacablesRelated/InMapPlacable_Glowing.png")
const normal = preload("res://GameElementsRelated/InMapPlacablesRelated/InMapPlacable_Normal.png")
const hidden = preload("res://GameElementsRelated/InMapPlacablesRelated/InMapPlacable_Hidden.png")

var current_texture
var is_hidden : bool
var is_glowing : bool


const default_normal_texture : Texture = normal

export (Texture) var current_glowing_texture : Texture = glowing setget set_current_glowing_texture
export(Texture) var current_normal_texture : Texture = default_normal_texture setget set_current_normal_texture
export(Texture) var current_hidden_texture : Texture = hidden setget set_current_hidden_texture

onready var area_sprite = $AreaSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	set_hidden(false)
	set_area_texture_to_not_glow()
	
	set_current_glowing_texture(current_glowing_texture)
	set_current_normal_texture(current_normal_texture)
	set_current_hidden_texture(current_hidden_texture)

func set_area_texture_to_glow():
	if is_inside_tree():
		area_sprite.texture = current_glowing_texture
	
	current_texture = current_glowing_texture
	is_glowing = true

func set_area_texture_to_not_glow():
	if is_inside_tree():
		if !is_hidden:
			area_sprite.texture = current_normal_texture
		else:
			area_sprite.texture = current_hidden_texture
	
	current_texture = current_normal_texture
	is_glowing = false

func set_hidden(arg_hidden : bool):
	is_hidden = arg_hidden
	if arg_hidden:
		area_sprite.texture = current_hidden_texture
	else:
		area_sprite.texture = current_texture


func get_placable_type_name() -> String:
	return "InMapAreaPlacable"


############

func configure_placable_to_copy_own_properties(arg_placable):
	arg_placable.global_position = global_position
	arg_placable.is_hidden = is_hidden
	arg_placable.layer_on_terrain = layer_on_terrain


##############

func set_current_glowing_texture(arg_texture):
	current_glowing_texture = arg_texture
	if is_glowing and !is_hidden:
		set_area_texture_to_glow()

func set_current_normal_texture(arg_texture):
	current_normal_texture = arg_texture
	
	if !is_glowing and !is_hidden:
		set_area_texture_to_not_glow()

func set_current_hidden_texture(arg_texture):
	current_hidden_texture = arg_texture
	if is_hidden:
		set_hidden(true)

