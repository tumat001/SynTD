extends MarginContainer

#const Hero = preload("res://TowerRelated/Color_White/Hero/Hero.gd")

var hero setget set_hero

onready var hero_level_up_button_gold = $HBoxContainer/ContentMarginer/MarginContainer/VBoxContainer/TopPart/HeroLevelUpButton_Gold
onready var hero_level_up_button_relic = $HBoxContainer/ContentMarginer/MarginContainer/VBoxContainer/TopPart/HeroLevelUpButton_Relic
onready var hero_xp_bar_panel = $HBoxContainer/ContentMarginer/MarginContainer/VBoxContainer/TopPart/MarginContainer/VBoxContainer/HeroXPBar_Panel
onready var ability_light_waves_button = $HBoxContainer/ContentMarginer/MarginContainer/VBoxContainer/BottomPart/AbilityLightWavesButton
onready var ability_judgement_button = $HBoxContainer/ContentMarginer/MarginContainer/VBoxContainer/BottomPart/AbilityJudgementButton
onready var ability_vol_button = $HBoxContainer/ContentMarginer/MarginContainer/VBoxContainer/BottomPart/AbilityVOLButton
onready var hero_level_panel = $HBoxContainer/ContentMarginer/MarginContainer/VBoxContainer/MarginContainer/HeroLevelIndicator_Panel


func set_hero(arg_hero):
	hero = arg_hero
	
	# hero lvl up gold
	hero_level_up_button_gold.func_name_of_if_can_level = "can_spend_gold_and_xp_for_level_up"
	hero_level_up_button_gold.func_name_of_attempt_level = "_attempt_spend_gold_and_xp_for_level_up"
	hero_level_up_button_gold.func_name_of_desc_of_leveling = "get_gold_xp_level_up_desc"
	hero_level_up_button_gold.signal_name_of_can_spend_x_for_level = "can_spend_gold_and_xp_for_level_up_updated"
	
	# hero lvl up relic
	hero_level_up_button_relic.func_name_of_if_can_level = "can_spend_relics_for_level_up"
	hero_level_up_button_relic.func_name_of_attempt_level = "_attempt_spend_one_relic_for_level_up__from_hero_gui"
	hero_level_up_button_relic.func_name_of_desc_of_leveling = "get_relic_level_up_desc"
	hero_level_up_button_relic.signal_name_of_can_spend_x_for_level = "can_spend_relics_for_level_up_updated"
	
	# hero light waves ability button
	ability_light_waves_button.func_name_of_ability_desc = "get_light_waves_ability_descriptions"
	ability_light_waves_button.func_name_of_ability_level_up_desc = "get_light_waves_upgrade_descs"
	ability_light_waves_button.func_name_of_ability_name = "get_light_waves_ability_name"
	ability_light_waves_button.func_name_of_can_level_up_ability = "can_level_up_light_waves"
	ability_light_waves_button.func_name_of_attempt_level_up_ability = "level_up_light_waves"
	ability_light_waves_button.signal_name_of_ability_level_changed = "light_waves_level_changed"
	ability_light_waves_button.property_name_of_ability_level = "ability_light_waves_level"
	
	# hero judgement ability button
	ability_judgement_button.func_name_of_ability_desc = "get_judgement_ability_descs"
	ability_judgement_button.func_name_of_ability_level_up_desc = "get_judgement_upgrade_descs"
	ability_judgement_button.func_name_of_ability_name = "get_judgement_ability_name"
	ability_judgement_button.func_name_of_can_level_up_ability = "can_level_up_judgement"
	ability_judgement_button.func_name_of_attempt_level_up_ability = "level_up_judgement"
	ability_judgement_button.signal_name_of_ability_level_changed = "judgement_level_changed"
	ability_judgement_button.property_name_of_ability_level = "ability_judgement_level"
	
	# hero vol ability button
	ability_vol_button.func_name_of_ability_desc = "get_vol_ability_descs"
	ability_vol_button.func_name_of_ability_level_up_desc = "get_vol_upgrade_descs"
	ability_vol_button.func_name_of_ability_name = "get_voice_of_light_ability_name"
	ability_vol_button.func_name_of_can_level_up_ability = "can_level_up_VOL"
	ability_vol_button.func_name_of_attempt_level_up_ability = "level_up_VOL"
	ability_vol_button.signal_name_of_ability_level_changed = "vol_level_changed"
	ability_vol_button.property_name_of_ability_level = "ability_VOL_level"
	
	#
	
	hero_level_up_button_gold.hero = hero
	hero_level_up_button_relic.hero = hero
	hero_xp_bar_panel.hero = hero
	ability_light_waves_button.hero = hero
	ability_judgement_button.hero = hero
	ability_vol_button.hero = hero
	hero_level_panel.hero = hero
