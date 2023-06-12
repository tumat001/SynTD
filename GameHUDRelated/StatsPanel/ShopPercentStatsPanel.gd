extends MarginContainer

const ShopManager = preload("res://GameElementsRelated/ShopManager.gd")
const LevelManager = preload("res://GameElementsRelated/LevelManager.gd")

const ShopStatsBackground_Glow_Unlock = preload("res://GameHUDRelated/StatsPanel/Assets/ShopStatsBackground_IndBackgroundGlow_Unlock.png")
const ShopStatsBackground_Glow_Lock = preload("res://GameHUDRelated/StatsPanel/Assets/ShopStatsBackground_IndBackgroundGlow_Lock.png")
const ShopStatsBackground_Glow_Inc = preload("res://GameHUDRelated/StatsPanel/Assets/ShopStatsBackground_IndBackgroundGlow_Inc.png")
const ShopStatsBackground_Glow_Dec = preload("res://GameHUDRelated/StatsPanel/Assets/ShopStatsBackground_IndBackgroundGlow_Dec.png")



const background_glow_pic_max_mod_a : float = 0.3

const glow__in_duration__long = 0.6
const glow__in_duration__short = 0.3

const glow__out_duration__long = 1.6
const glow__out_duration__short = 0.6



enum TierGlowAction {
	NONE = 0,
	UNLOCK = 1,
	LOCK = 2,
	INC = 3,
	DEC = 4
}


var shop_manager : ShopManager setget set_shop_manager
var level_manager : LevelManager setget set_level_manager


onready var tier01_label = $MarginContainer/MainContent/Tier01Marginer/MarginContainer/Tier01Container/Marginer/Tier01Label
onready var tier02_label = $MarginContainer/MainContent/Tier02Marginer/MarginContainer/Tier02Container/Marginer/Tier02Label
onready var tier03_label = $MarginContainer/MainContent/Tier03Marginer/MarginContainer/Tier03Container/Marginer/Tier03Label
onready var tier04_label = $MarginContainer/MainContent/Tier04Marginer/MarginContainer/Tier04Container/Marginer/Tier04Label
onready var tier05_label = $MarginContainer/MainContent/Tier05Marginer/MarginContainer/Tier05Container/Marginer/Tier05Label
onready var tier06_label = $MarginContainer/MainContent/Tier06Marginer/MarginContainer/Tier06Container/Marginer/Tier06Label

var labels_in_tier_order : Array = []


onready var tier01_glow_background_texrect = $MarginContainer/MainContent/Tier01Marginer/Tier01BackgroundGlow
onready var tier02_glow_background_texrect = $MarginContainer/MainContent/Tier02Marginer/Tier02BackgroundGlow
onready var tier03_glow_background_texrect = $MarginContainer/MainContent/Tier03Marginer/Tier03BackgroundGlow
onready var tier04_glow_background_texrect = $MarginContainer/MainContent/Tier04Marginer/Tier04BackgroundGlow
onready var tier05_glow_background_texrect = $MarginContainer/MainContent/Tier05Marginer/Tier05BackgroundGlow
onready var tier06_glow_background_texrect = $MarginContainer/MainContent/Tier06Marginer/Tier06BackgroundGlow

var all_tier_glow_texture_rect : Array = []

#

func _ready():
	labels_in_tier_order.append(tier01_label)
	labels_in_tier_order.append(tier02_label)
	labels_in_tier_order.append(tier03_label)
	labels_in_tier_order.append(tier04_label)
	labels_in_tier_order.append(tier05_label)
	labels_in_tier_order.append(tier06_label)
	
	
	all_tier_glow_texture_rect.append(tier01_glow_background_texrect)
	all_tier_glow_texture_rect.append(tier02_glow_background_texrect)
	all_tier_glow_texture_rect.append(tier03_glow_background_texrect)
	all_tier_glow_texture_rect.append(tier04_glow_background_texrect)
	all_tier_glow_texture_rect.append(tier05_glow_background_texrect)
	all_tier_glow_texture_rect.append(tier06_glow_background_texrect)
	
	for tex_rect in all_tier_glow_texture_rect:
		tex_rect.modulate.a = 0

#

func set_shop_manager(arg_manager : ShopManager):
	shop_manager = arg_manager
	
	shop_manager.connect("on_effective_shop_odds_level_changed", self, "_on_effective_shop_level_odds_changed", [], CONNECT_PERSIST)
	_on_effective_shop_level_odds_changed(shop_manager.last_calculated_effective_shop_level_odds)
	
	shop_manager.connect("on_effective_shop_odds_level_changed__probability_changes", self, "_on_effective_shop_odds_level_changed__probability_changes", [], CONNECT_PERSIST)

func set_level_manager(arg_manager : LevelManager):
	level_manager = arg_manager
	
	#level_manager.connect("on_current_level_changed", self, "_on_level_changed", [], CONNECT_PERSIST)
	#_on_level_changed(level_manager.current_level)

#

#func _on_level_changed(_new_level):
#	if shop_manager != null:
#		var probabilities : Array = shop_manager.get_shop_roll_chances_at_level()
#
#		for i in 6:
#			labels_in_tier_order[i].text = (str(probabilities[i]) + "%")


func _on_effective_shop_level_odds_changed(new_lvl_odds):
	if is_instance_valid(shop_manager):
		var probabilities : Array = shop_manager.get_shop_roll_chances_at_level()
		
		for i in 6:
			labels_in_tier_order[i].text = (str(probabilities[i]) + "%")


##############

func _on_effective_shop_odds_level_changed__probability_changes(arg_old_probabilties, arg_current_probabilties, arg_old_level, arg_new_level, arg_first_time_tier_unlock_list, arg_tier_becomes_zero_prob_list, arg_tier_to_inc_or_same_or_dec_val_map):
	var tier_to_action_map : Dictionary = {}
	
	for tier in arg_first_time_tier_unlock_list:
		tier_to_action_map[tier] = TierGlowAction.UNLOCK
	
	for tier in arg_tier_becomes_zero_prob_list:
		tier_to_action_map[tier] = TierGlowAction.LOCK
	
	for tier in arg_tier_to_inc_or_same_or_dec_val_map.keys():
		if !tier_to_action_map.has(tier):
			var val = arg_tier_to_inc_or_same_or_dec_val_map[tier]
			
			if val == 1:
				tier_to_action_map[tier] = TierGlowAction.INC
			elif val == 0:
				tier_to_action_map[tier] = TierGlowAction.NONE
			elif val == -1:
				tier_to_action_map[tier] = TierGlowAction.DEC
	
	_play_tier_panel_glow_actions(tier_to_action_map)


func _play_tier_panel_glow_actions(arg_tier_to_action_map : Dictionary):
	for tier in arg_tier_to_action_map:
		var action = arg_tier_to_action_map[tier]
		var texrect : TextureRect = all_tier_glow_texture_rect[tier - 1]
		
		if action == TierGlowAction.UNLOCK:
			texrect.texture = ShopStatsBackground_Glow_Unlock
			_play_glow_action_to_tier_texrect(texrect, glow__in_duration__long, glow__out_duration__long)
			
		elif action == TierGlowAction.LOCK:
			#texrect.texture = ShopStatsBackground_Glow_Lock
			#_play_glow_action_to_tier_texrect(texrect, glow__in_duration__long, glow__out_duration__long)
			pass
			
		elif action == TierGlowAction.INC:
			texrect.texture = ShopStatsBackground_Glow_Inc
			_play_glow_action_to_tier_texrect(texrect, glow__in_duration__short, glow__out_duration__short)
			
		elif action == TierGlowAction.DEC:
			#texrect.texture = ShopStatsBackground_Glow_Dec
			#_play_glow_action_to_tier_texrect(texrect, glow__in_duration__short, glow__out_duration__short)
			pass
		

func _play_glow_action_to_tier_texrect(texrect, arg_glow_fade_in_duration, arg_glow_fade_out_duration):
	var tweener = create_tween()
	tweener.tween_property(texrect, "modulate:a", background_glow_pic_max_mod_a, arg_glow_fade_in_duration)
	tweener.tween_property(texrect, "modulate:a", 0.0, arg_glow_fade_out_duration)
	




