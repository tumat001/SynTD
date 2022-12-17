extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const FruitBlue_Pic = preload("res://TowerRelated/Color_Green/FruitTree/Fruits/Fruits_Blue.png")
const FruitGreen_Pic = preload("res://TowerRelated/Color_Green/FruitTree/Fruits/Fruits_Green.png")
const FruitRed_Pic = preload("res://TowerRelated/Color_Green/FruitTree/Fruits/Fruits_Red.png")
const FruitViolet_Pic = preload("res://TowerRelated/Color_Green/FruitTree/Fruits/Fruits_Violet.png")
const FruitWhite_Pic = preload("res://TowerRelated/Color_Green/FruitTree/Fruits/Fruits_White.png")
const FruitYellow_Pic = preload("res://TowerRelated/Color_Green/FruitTree/Fruits/Fruits_Yellow.png")

const GreenFruitEffect = preload("res://GameInfoRelated/TowerEffectRelated/FruitEffects/GreenFruitEffect.gd")
const BlueFruitEffect = preload("res://GameInfoRelated/TowerEffectRelated/FruitEffects/BlueFruitEffect.gd")
const RedFruitEffect = preload("res://GameInfoRelated/TowerEffectRelated/FruitEffects/RedFruitEffect.gd")
const VioletFruitEffect = preload("res://GameInfoRelated/TowerEffectRelated/FruitEffects/VioletFruitEffect.gd")
const WhiteFruitEffect = preload("res://GameInfoRelated/TowerEffectRelated/FruitEffects/WhiteFruitEffect.gd")
const YellowFruitEffect = preload("res://GameInfoRelated/TowerEffectRelated/FruitEffects/YellowFruitEffect.gd")


enum {
	BLUE = 0,
	GREEN = 1,
	RED = 2,
	VIOLET = 3,
	WHITE = 4,
	YELLOW = 5,
}


var fruit_type : int = BLUE  #can be anything, as it is overriden by fruit tree

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.FRUIT_TREE_FRUIT)
	
	tower_id = info.tower_type_id
	tower_type_info = info
	
	#_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	
	can_be_placed_in_map_conditional_clause.attempt_insert_clause(CanBePlacedInMapClauses.GENERIC_CANNOT_BE_PLACED_IN_MAP)
	tower_limit_slots_taken = 0
	is_a_summoned_tower = true
	
	_initialize_stats_from_tower_info(info)
	
	_set_fruit_properties()
	
	_post_inherit_ready()


func _set_fruit_properties():
	var ing_effect : IngredientEffect
	
	var new_sprite_frames = SpriteFrames.new()
	
	if fruit_type == BLUE:
		new_sprite_frames.add_frame("default", FruitBlue_Pic)
		tower_highlight_sprite = FruitBlue_Pic
		ing_effect = IngredientEffect.new(StoreOfTowerEffectsUUID.ING_BLUE_FRUIT, BlueFruitEffect.new())
		
	elif fruit_type == GREEN:
		new_sprite_frames.add_frame("default", FruitGreen_Pic)
		tower_highlight_sprite = FruitGreen_Pic
		ing_effect = IngredientEffect.new(StoreOfTowerEffectsUUID.ING_GREEN_FRUIT, GreenFruitEffect.new())
		
	elif fruit_type == RED:
		new_sprite_frames.add_frame("default", FruitRed_Pic)
		tower_highlight_sprite = FruitRed_Pic
		ing_effect = IngredientEffect.new(StoreOfTowerEffectsUUID.ING_RED_FRUIT, RedFruitEffect.new())
		
	elif fruit_type == VIOLET:
		new_sprite_frames.add_frame("default", FruitViolet_Pic)
		tower_highlight_sprite = FruitViolet_Pic
		ing_effect = IngredientEffect.new(StoreOfTowerEffectsUUID.ING_VIOLET_FRUIT, VioletFruitEffect.new())
		
	elif fruit_type == WHITE:
		new_sprite_frames.add_frame("default", FruitWhite_Pic)
		tower_highlight_sprite = FruitWhite_Pic
		ing_effect = IngredientEffect.new(StoreOfTowerEffectsUUID.ING_WHITE_FRUIT, WhiteFruitEffect.new())
		
	elif fruit_type == YELLOW:
		new_sprite_frames.add_frame("default", FruitYellow_Pic)
		tower_highlight_sprite = FruitYellow_Pic
		ing_effect = IngredientEffect.new(StoreOfTowerEffectsUUID.ING_YELLOW_FRUIT, YellowFruitEffect.new())
	
	tower_base_sprites.frames = new_sprite_frames
	ingredient_of_self = ing_effect


func _can_accept_ingredient(ingredient_effect : IngredientEffect, tower_selected) -> bool:
	return false
