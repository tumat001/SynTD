const IngredientEffect = preload("res://GameInfoRelated/TowerIngredientRelated/IngredientEffect.gd")

enum Metadata {
	ABILITY_DESCRIPTION = 0
	ABILITY_SIMPLE_DESCRIPTION = 1
}


var tower_name : String
var tower_type_id : int
var tower_cost : int
var tower_tier : int
var energy_consumption_levels : Array = []
var energy_consumption_level_buffs : Array = []
var colors : Array = []
var ingredient_effect : IngredientEffect
var ingredient_effect_simple_description : String = ""

var base_tower_image : Texture setget set_base_tower_image

var tower_image_in_buy_card : AtlasTexture
var tower_atlased_image : AtlasTexture
var tower_atlased_images_list : Array

var tower_descriptions : Array = []
var tower_simple_descriptions : Array

# if changing these names, change var names in AlmanacManager as well
var base_damage : float
var base_damage_type : int
var base_attk_speed : float
var base_range : float
var base_ability_potency : float = 1
var base_pierce : float
var on_hit_multiplier : float = 1
var base_on_hit_damage : float = 0  # unused by tower. only shown for almanac purposes

var base_percent_cdr : float = 0

var metadata_id_to_data_map : Dictionary



func _init(arg_tower_name : String, arg_tower_type_id : int):
	tower_name = arg_tower_name
	tower_type_id = arg_tower_type_id
	tower_cost = 0

###

func set_base_tower_image(arg_image):
	base_tower_image = arg_image
	
	tower_image_in_buy_card = _generate_tower_image_for_buy_card_atlas_texture(base_tower_image)



static func _generate_tower_image_for_buy_card_atlas_texture(tower_sprite) -> AtlasTexture:
	var tower_image_icon_atlas_texture := AtlasTexture.new()
	
	tower_image_icon_atlas_texture.atlas = tower_sprite
	tower_image_icon_atlas_texture.region = _get_atlas_region(tower_sprite)
	
	return tower_image_icon_atlas_texture


static func _get_atlas_region(tower_sprite) -> Rect2:
	var center = _get_default_center_for_atlas(tower_sprite)
	var size = _get_default_region_size_for_atlas(tower_sprite)
	
	#return Rect2(0, 0, size.x, size.y)
	return Rect2(center.x, center.y, size.x, size.y)

static func _get_default_center_for_atlas(tower_sprite) -> Vector2:
	var highlight_sprite_size = tower_sprite.get_size()
	
	return Vector2(0, 0)

static func _get_default_region_size_for_atlas(tower_sprite) -> Vector2:
	var max_width = tower_sprite.get_size().x
	var max_height = tower_sprite.get_size().y
	
	var width_to_use = 38
	if width_to_use > max_width:
		width_to_use = max_width
	
	var length_to_use = 38
	if length_to_use > max_height:
		length_to_use = max_height
	
	return Vector2(width_to_use, length_to_use)

#

func has_simple_description() -> bool:
	return tower_simple_descriptions != null and tower_simple_descriptions.size() != 0


func get_description__for_almanac_use():
	return tower_descriptions

func get_simple_description__for_almanac_use():
	return tower_simple_descriptions


func get_atlased_image_as_list__for_almanac_use():
	if tower_atlased_images_list.size() == 0:
		return [tower_image_in_buy_card]
	else:
		return tower_atlased_images_list
		#return tower_image_in_buy_card

func get_altasted_image_list_size():
	return tower_atlased_images_list.size()

func get_name__for_almanac_use():
	return tower_name

func get_id__for_almanac_use():
	return tower_type_id

