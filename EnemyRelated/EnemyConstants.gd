extends Node

const EnemyTypeInformation = preload("res://EnemyRelated/EnemyTypeInformation.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
#const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")
const EnemyStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/EnemyStatTextFragment.gd")

#

const Basic_E = preload("res://EnemyRelated/EnemyTypes/Type_Basic/Basic/Basic_E.png")
const Brute_E = preload("res://EnemyRelated/EnemyTypes/Type_Basic/Brute/Brute_E.png")
const Dash_E = preload("res://EnemyRelated/EnemyTypes/Type_Basic/Dash/Dash_E.png")
const Healer_E = preload("res://EnemyRelated/EnemyTypes/Type_Basic/Healer/Healer_E.png")
const Wizard_E = preload("res://EnemyRelated/EnemyTypes/Type_Basic/Wizard/Wizard_E.png")
const Pain_E = preload("res://EnemyRelated/EnemyTypes/Type_Basic/Pain/Pain_E.png")

const Experienced_E = preload("res://EnemyRelated/EnemyTypes/Type_Expert/Experienced(Basic)/Experienced_E.png")
const Fiend_E = preload("res://EnemyRelated/EnemyTypes/Type_Expert/Fiend(Brute)/Fiend_E.png")
const Charge_E = preload("res://EnemyRelated/EnemyTypes/Type_Expert/Charge(Dash)/Charge_E.png")
const Enchantress_E = preload("res://EnemyRelated/EnemyTypes/Type_Expert/Enchantress(Healer)/Enchantress_E.png")

#

enum EnemyFactions {
	BASIC = 0,
	
	EXPERT = 1,
	FAITHFUL = 2,
	SKIRMISHERS = 3,
	
	#BEAST,
	#LIFE_MEDDLERS,
	#REBELS,
	
	OTHERS = 1000,
}

enum Enemies {
	############## BASIC (100)
	BASIC = 100,
	BRUTE = 101,
	DASH = 102,
	HEALER = 103,
	WIZARD = 104,
	PAIN = 105,
	
	############# EXPERT (200)
	EXPERIENCED = 200,
	FIEND = 201,
	CHARGE = 202,
	ENCHANTRESS = 203,
	MAGUS = 204,
	ASSASSIN = 205,
	GRANDMASTER = 206,
	
	########### FAITHFUL (300)
	DEITY = 300,
	BELIEVER = 301,
	PRIEST = 302,
	SACRIFICER = 303,
	SEER = 304,
	CROSS_BEARER = 305,
	DVARAPALA = 306,
	PROVIDENCE = 307,
	
	########## SKIRMISHERS (400)
	#BLUE (400)
	COSMIC = 400,
	SMOKE = 401,
	RALLIER = 402,
	PROXIMITY = 403,
	BLESSER = 404,
	ASCENDER = 405,
	
	# RED (440)
	BLASTER = 450
	ARTILLERY = 451
	DANSEUR = 452
	FINISHER = 453
	TOSSER = 454
	
	# BOTH (480)
	HOMERUNNER = 480
	RUFFIAN = 481
	
	############
	
	# OTHERS (10000)
	TRIASYN_OGV_SOUL = 10000,
	DOMSYN_RED_ORACLES_EYE_SHADOW = 10001,
	MAP_ENCHANT_ANTI_MAGIK = 10002,
	
}


var first_half_faction_id_pool : Array
var second_half_faction_id_pool : Array

const enemy_id_info_type_singleton_map : Dictionary = {}


func _init():
	first_half_faction_id_pool.append(EnemyFactions.BASIC)
	
	second_half_faction_id_pool.append(EnemyFactions.EXPERT)
	second_half_faction_id_pool.append(EnemyFactions.FAITHFUL)
	second_half_faction_id_pool.append(EnemyFactions.SKIRMISHERS)
	
	for enemy_id in Enemies.values():
		enemy_id_info_type_singleton_map[enemy_id] = get_enemy_info(enemy_id, true)
	

#

static func _generate_enemy_image_icon_atlas_texture(tower_sprite, center_offset := Vector2(0, 0)) -> AtlasTexture:
	var tower_image_icon_atlas_texture := AtlasTexture.new()
	
	tower_image_icon_atlas_texture.atlas = tower_sprite
	tower_image_icon_atlas_texture.region = _get_atlas_region(tower_sprite, center_offset)
	
	return tower_image_icon_atlas_texture


static func _get_atlas_region(tower_sprite, center_offset = Vector2(0, 0)) -> Rect2:
	var center = _get_default_center_for_atlas(tower_sprite, center_offset)
	var size = _get_default_region_size_for_atlas(tower_sprite)
	
	#return Rect2(0, 0, size.x, size.y)
	return Rect2(center.x, center.y, size.x, size.y)

static func _get_default_center_for_atlas(tower_sprite, center_offset = Vector2(0, 0)) -> Vector2:
	var highlight_sprite_size = tower_sprite.get_size()
	
	return Vector2(0, 0) + center_offset
	#return Vector2(highlight_sprite_size.x / 4, 0) + center_offset

static func _get_default_region_size_for_atlas(tower_sprite) -> Vector2:
	var max_width = tower_sprite.get_size().x
	var max_height = tower_sprite.get_size().y
	
	var width_to_use = 40
	if width_to_use > max_width:
		width_to_use = max_width
	
	var length_to_use = 40
	if length_to_use > max_height:
		length_to_use = max_height
	
	return Vector2(width_to_use, length_to_use)


#

static func get_enemy_info(enemy_id : int, arg_include_non_combat_info : bool = false) -> EnemyTypeInformation:
	var info : EnemyTypeInformation
	
	############################### BASIC FACTION
	if enemy_id == Enemies.BASIC:
		info = EnemyTypeInformation.new(Enemies.BASIC, EnemyFactions.BASIC)
		info.base_health = 16
		info.base_movement_speed = 60
		
		if arg_include_non_combat_info:
			info.enemy_name = "Basic"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(Basic_E)
			info.descriptions = [
				"A basic and weak enemy."
			]
		
	elif enemy_id == Enemies.BRUTE:
		info = EnemyTypeInformation.new(Enemies.BRUTE, EnemyFactions.BASIC)
		info.base_health = 88
		info.base_movement_speed = 37
		info.enemy_type = info.EnemyType.ELITE
		
		if arg_include_non_combat_info:
			info.enemy_name = "Brute"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(Brute_E)
			info.descriptions = [
				"A slow but bulky unit."
			]
		
	elif enemy_id == Enemies.DASH:
		info = EnemyTypeInformation.new(Enemies.DASH, EnemyFactions.BASIC)
		info.base_health = 27 
		info.base_movement_speed = 51
		
		if arg_include_non_combat_info:
			var plain_fragment__speed = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.MOV_SPEED, "speed")
			
			info.enemy_name = "Dash"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(Dash_E)
			info.descriptions = [
				["Gains a burst of temporary |0| upon reaching half health.", [plain_fragment__speed]]
			]
		
	elif enemy_id == Enemies.HEALER:
		info = EnemyTypeInformation.new(Enemies.HEALER, EnemyFactions.BASIC)
		info.base_health = 26
		info.base_movement_speed = 45
		
		if arg_include_non_combat_info:
			var plain_fragment__heal = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.HEALTH, "Heals")
			var plain_fragment__enemy = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "enemy")
			
			
			info.enemy_name = "Healer"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(Healer_E)
			info.descriptions = [
				["|0| the lowest percent health |1| for 6 every 10 seconds within its range (140).", [plain_fragment__heal, plain_fragment__enemy]]
			]
			info.simple_descriptions = [
				["|0| the lowest health |1| every 10 seconds.", [plain_fragment__heal, plain_fragment__enemy]]
			]
		
	elif enemy_id == Enemies.WIZARD:
		info = EnemyTypeInformation.new(Enemies.WIZARD, EnemyFactions.BASIC)
		info.base_health = 22
		info.base_movement_speed = 44
		
		if arg_include_non_combat_info:
			var plain_fragment__tower = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "tower")
			
			info.enemy_name = "Wizard"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(Wizard_E)
			info.descriptions = [
				["Deals 2.05 damage over 3 attacks to a random |0| every 6 seconds within its range (80).", [plain_fragment__tower]],
				"Most towers have 10 health."
			]
			info.simple_descriptions = [
				["Deals damage to a random |0| every 6 seconds.", [plain_fragment__tower]],
			]
		
	elif enemy_id == Enemies.PAIN:
		info = EnemyTypeInformation.new(Enemies.PAIN, EnemyFactions.BASIC)
		info.base_health = 17
		info.base_movement_speed = 57
		info.base_player_damage = 2
		
		if arg_include_non_combat_info:
			info.enemy_name = "Pain"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(Pain_E)
			info.descriptions = [
				"Deals more player damage when escaping." 
			]
		
	################################# EXPERT FACTION
	elif enemy_id == Enemies.EXPERIENCED:
		info = EnemyTypeInformation.new(Enemies.EXPERIENCED, EnemyFactions.EXPERT)
		info.base_health = 23
		info.base_movement_speed = 60
		#info.base_resistance = 25
		info.base_toughness = 4.5
		info.base_armor = 3
		
		if arg_include_non_combat_info:
			info.enemy_name = "Experienced"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(Experienced_E)
			info.descriptions = [
				"Having survived as a basic, the experienced become stronger."
			]
		
	elif enemy_id == Enemies.FIEND:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 120
		info.base_movement_speed = 38
		info.base_armor = 18
		info.base_toughness = 10
		info.enemy_type = info.EnemyType.ELITE
		
		if arg_include_non_combat_info:
			var plain_fragment__armor = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ARMOR, "armor")
			var plain_fragment__toughness = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOUGHNESS, "toughness")
			
			
			info.enemy_name = "Fiend"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(Fiend_E)
			info.descriptions = [
				["A slow but extremely tanky enemy. Has high amounts of |0| and |1|.", [plain_fragment__armor, plain_fragment__toughness]]
			]
		
	elif enemy_id == Enemies.CHARGE:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 38
		info.base_movement_speed = 54
		
		if arg_include_non_combat_info:
			var plain_fragment__speed = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.MOV_SPEED, "speed")
			
			info.enemy_name = "Charge"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(Charge_E)
			info.descriptions = [
				["Gains a burst of temporary |0| upon reaching 75% health and 25% health.", [plain_fragment__speed]]
			]
		
	elif enemy_id == Enemies.ENCHANTRESS:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 20
		info.base_movement_speed = 45
		info.base_toughness = 1
		
		if arg_include_non_combat_info:
			var plain_fragment__heals = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.HEALTH, "Heals")
			var plain_fragment__shields = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SHIELD, "shields")
			var plain_fragment__enemy = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "enemy")
			
			
			info.enemy_name = "Enchantress"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(Enchantress_E)
			info.simple_descriptions = [
				["|0| and |1| the two lowest percent health |2| every 7.5 seconds.", [plain_fragment__heals, plain_fragment__shields, plain_fragment__enemy]],
				"Heal amount: 10.",
				"Shield amount: 35% of target's missing health after the heal."
			]
			info.descriptions = [
				["|0| and |1| the two lowest percent health |2| every 7.5 seconds.", [plain_fragment__heals, plain_fragment__shields, plain_fragment__enemy]],
			]
		
	elif enemy_id == Enemies.MAGUS:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 21
		info.base_movement_speed = 43
		
		if arg_include_non_combat_info:
			var plain_fragment__tower = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "tower")
			
			info.enemy_name = "Magus"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Expert/Magus(Wizard)/Magus_E.png"))
			info.descriptions = [
				["Deals 5.05 damage over 3 attacks to the lowest health |0| every 5 seconds within its range (140).", [plain_fragment__tower]],
				"Most towers have 10 health."
			]
			info.simple_descriptions = [
				["Deals significant damage to the lowest health |0| every 5 seconds.", [plain_fragment__tower]],
			]
		
	elif enemy_id == Enemies.ASSASSIN:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 23
		info.base_movement_speed = 60
		info.base_player_damage = 2
		
		if arg_include_non_combat_info:
			var plain_fragment__invisible = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INVISIBLE, "invisible")
			
			info.enemy_name = "Assassin"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Expert/Assassin(Pain)/Assassin_E.png"))
			info.descriptions = [
				"Deals more player damage.",
				["Becomes |0| for 8 seconds upon reaching 50% health.", [plain_fragment__invisible]],
				"Invisibility is removed upon being too close to the exit."
			]
			info.simple_descriptions = [
				"Deals more player damage.",
				["Becomes |0| for 8 seconds upon reaching 50% health.", [plain_fragment__invisible]],
			]
		
	elif enemy_id == Enemies.GRANDMASTER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 67 
		info.base_movement_speed = 60
		info.base_effect_vulnerability = 0.2
		#info.base_resistance = 25
		info.base_toughness = 3
		info.base_armor = 2
		info.enemy_type = info.EnemyType.ELITE
		
		if arg_include_non_combat_info:
			var plain_fragment__speed = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.MOV_SPEED, "speed")
			var plain_fragment__shield = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SHIELD, "shield")
			var plain_fragment__invisible = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INVISIBLE, "invisible")
			
			
			info.enemy_name = "Grandmaster"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Expert/Grandmaster/Grandmaster_E.png"))
			info.descriptions = [
				["Gains a burst of temporary |0| and a 75% max health |1| for 2 seconds upon reaching 75% and 25% health.", [plain_fragment__speed, plain_fragment__shield]],
				["Becomes |0| for 2 seconds upon reaching 50% health.", [plain_fragment__invisible]],
				"",	
				"\"Mastery of techniques.\""
			]
			info.simple_descriptions = [
				["Gains a burst of temporary |0| and a 75% max health |1| for 2 seconds upon reaching 75% and 25% health.", [plain_fragment__speed, plain_fragment__shield]],
				["Becomes |0| for 2 seconds upon reaching 50% health.", [plain_fragment__invisible]],
			]
		
	################################# FAITHFUL FACTION
	elif enemy_id == Enemies.DEITY:
		# stats set by faction
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.enemy_type = EnemyTypeInformation.EnemyType.BOSS
		
		info.base_health = EnemyTypeInformation.VALUE_DETERMINED_BY_OTHER_FACTORS
		info.base_effect_vulnerability = EnemyTypeInformation.VALUE_DETERMINED_BY_OTHER_FACTORS
		info.base_player_damage = EnemyTypeInformation.VALUE_DETERMINED_BY_OTHER_FACTORS
		
		info.base_movement_speed = 14
		info.base_player_damage = 18
		
		info.base_armor = 13
		info.base_toughness = 13
		
		if arg_include_non_combat_info:
			#var plain_fragment__armor = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ARMOR, "armor")
			#var plain_fragment__toughness = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOUGHNESS, "toughness")
			var plain_fragment__Faithfuls = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "Faithfuls")
			
			var interpreter_for_armor = TextFragmentInterpreter.new()
			interpreter_for_armor.enemy_info_to_use_for_enemy_stat_fragments = info
			interpreter_for_armor.display_body = true
			var ins_for_armor = []
			ins_for_armor.append(OutcomeTextFragment.new(EnemyStatTextFragment.STAT_TYPE.ARMOR, -1, "armor"))
			ins_for_armor.append(NumericalTextFragment.new(1, false, -1))
			ins_for_armor.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
			ins_for_armor.append(EnemyStatTextFragment.new(null, info, EnemyStatTextFragment.STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY, EnemyStatTextFragment.STAT_BASIS.TOTAL, 1.0))
			interpreter_for_armor.array_of_instructions = ins_for_armor
			
			var interpreter_for_toughness = TextFragmentInterpreter.new()
			interpreter_for_toughness.enemy_info_to_use_for_enemy_stat_fragments = info
			interpreter_for_toughness.display_body = true
			var ins_for_toughness = []
			ins_for_toughness.append(OutcomeTextFragment.new(EnemyStatTextFragment.STAT_TYPE.TOUGHNESS, -1, "toughness"))
			ins_for_toughness.append(NumericalTextFragment.new(1, false, -1))
			ins_for_toughness.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
			ins_for_toughness.append(EnemyStatTextFragment.new(null, info, EnemyStatTextFragment.STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY, EnemyStatTextFragment.STAT_BASIS.TOTAL, 1.0))
			interpreter_for_toughness.array_of_instructions = ins_for_toughness
			
			var plain_fragment__faithful_enemy = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "Faithful enemy")
			
			var interpreter_for_health_per_sec = TextFragmentInterpreter.new()
			interpreter_for_health_per_sec.enemy_info_to_use_for_enemy_stat_fragments = info
			interpreter_for_health_per_sec.display_body = true
			var ins_for_health_per_sec = []
			ins_for_health_per_sec.append(OutcomeTextFragment.new(EnemyStatTextFragment.STAT_TYPE.HEALTH, -1, "health per second"))
			ins_for_health_per_sec.append(NumericalTextFragment.new(3, false, -1))
			ins_for_health_per_sec.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
			ins_for_health_per_sec.append(EnemyStatTextFragment.new(null, info, EnemyStatTextFragment.STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY, EnemyStatTextFragment.STAT_BASIS.TOTAL, 1.0))
			interpreter_for_health_per_sec.array_of_instructions = ins_for_health_per_sec
			
			var plain_fragment__sacrificer = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "Sacrificer")
			
			var ap_per_seer : float = 0.5
			var plain_fragment__x_ability_potency = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY_POTENCY, "%s Ability Potency" % ap_per_seer)
			var plain_fragment__seer = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "Seer")
			
			var health_gain_for_cross : float = 15.0
			var plain_fragment__x_health_gain = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.HEALTH, "%s%% additional Health" % health_gain_for_cross)
			var plain_fragment__cross_bearer = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "Cross Bearer")
			
			var plain_fragment__Towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Towers")
			
			
			var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "ability")
			var plain_fragment__Shockwave = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Shockwave")
			var plain_fragment__knock_up = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.KNOCK_UP, "Knock up")
			var plain_fragment__stun = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stun")
			var interpreter_for_stun_duration = TextFragmentInterpreter.new()
			interpreter_for_stun_duration.enemy_info_to_use_for_enemy_stat_fragments = info
			interpreter_for_stun_duration.display_body = true
			interpreter_for_stun_duration.header_description = "seconds"
			var ins_for_stun_duration = []
			ins_for_stun_duration.append(NumericalTextFragment.new(2.5, false, -1))
			ins_for_stun_duration.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
			ins_for_stun_duration.append(EnemyStatTextFragment.new(null, info, EnemyStatTextFragment.STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY, EnemyStatTextFragment.STAT_BASIS.TOTAL, 1.0))
			interpreter_for_stun_duration.array_of_instructions = ins_for_stun_duration
			
			var plain_fragment__Taunt = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Taunt")
			var interpreter_for_taunt_duration = TextFragmentInterpreter.new()
			interpreter_for_taunt_duration.enemy_info_to_use_for_enemy_stat_fragments = info
			interpreter_for_taunt_duration.display_body = true
			interpreter_for_taunt_duration.header_description = "seconds"
			var ins_for_taunt_duration = []
			ins_for_taunt_duration.append(NumericalTextFragment.new(8.0, false, -1))
			ins_for_taunt_duration.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
			ins_for_taunt_duration.append(EnemyStatTextFragment.new(null, info, EnemyStatTextFragment.STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY, EnemyStatTextFragment.STAT_BASIS.TOTAL, 1.0))
			interpreter_for_taunt_duration.array_of_instructions = ins_for_taunt_duration
			
			var plain_fragment__Revive = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Revive")
			var interpreter_for_revive_count = TextFragmentInterpreter.new()
			interpreter_for_revive_count.enemy_info_to_use_for_enemy_stat_fragments = info
			interpreter_for_revive_count.display_body = true
			interpreter_for_revive_count.header_description = "Faithfuls"
			interpreter_for_revive_count.estimate_method_for_final_num_val = interpreter_for_revive_count.ESTIMATE_METHOD.FLOOR
			var ins_for_revive_count = []
			ins_for_revive_count.append(NumericalTextFragment.new(15, false, -1))
			ins_for_revive_count.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
			ins_for_revive_count.append(EnemyStatTextFragment.new(null, info, EnemyStatTextFragment.STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY, EnemyStatTextFragment.STAT_BASIS.TOTAL, 1.0))
			interpreter_for_revive_count.array_of_instructions = ins_for_revive_count
			
			var interpreter_for_revive_heal_amount = TextFragmentInterpreter.new()
			interpreter_for_revive_heal_amount.enemy_info_to_use_for_enemy_stat_fragments = info
			interpreter_for_revive_heal_amount.display_body = true
			var ins_for_revive_heal_amount = []
			ins_for_revive_heal_amount.append(OutcomeTextFragment.new(EnemyStatTextFragment.STAT_TYPE.HEALTH, -1, "max health"))
			ins_for_revive_heal_amount.append(NumericalTextFragment.new(50, true, -1))
			ins_for_revive_heal_amount.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
			ins_for_revive_heal_amount.append(EnemyStatTextFragment.new(null, info, EnemyStatTextFragment.STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY, EnemyStatTextFragment.STAT_BASIS.TOTAL, 1.0))
			interpreter_for_revive_heal_amount.array_of_instructions = ins_for_revive_heal_amount
			
			var plain_fragment__stunned = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stunned")
			
			var plain_fragment__towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "towers")
			
			var plain_fragment__abilities = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "abilities")
			
			info.enemy_name = "Deity"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Faithful/Deity/Deity_E.png"))
			info.descriptions = [
				"The centerpiece of the Faithfuls.",
				["Deity interacts with |0| within 200 range.", [plain_fragment__Faithfuls]],
				["Gains |0| and |1| per nearby |2|.", [interpreter_for_armor, interpreter_for_toughness, plain_fragment__faithful_enemy]],
				["Gains |0| per second per nearby |1|.", [interpreter_for_health_per_sec, plain_fragment__sacrificer]],
				["Gains |0| per nearby |1|.", [plain_fragment__x_ability_potency, plain_fragment__seer]],
				["Gains |0| while behind the cross left by |1|.", [plain_fragment__x_health_gain, plain_fragment__cross_bearer]],
				"",
				["Deity interacts with |0| within 160 range.", [plain_fragment__Towers]],
				["Every 12 seconds, Deity casts an appropriate |0|.", [plain_fragment__ability]],
				["|0|: |1| and |2| towers for |3|.", [plain_fragment__Shockwave, plain_fragment__knock_up, plain_fragment__stun, interpreter_for_stun_duration]],
				["|0|: |1| are forced to target Deity for |2|.", [plain_fragment__Taunt, plain_fragment__Towers, interpreter_for_taunt_duration]],
				["|0|: Bless |1| for 15 seconds. When they die, they are revived with |2|.", [plain_fragment__Revive, interpreter_for_revive_count, interpreter_for_revive_heal_amount]],
				"",
				["When |0| for 3 seconds (slowly resets when not stunned), clear all stun effects and become immune to tower effects for 5 seconds.", [plain_fragment__stunned]]
			]
			info.simple_descriptions = [
				"The centerpiece of the Faithfuls.",
				"",
				["Deity becomes more powerful the more |0| there are.", [plain_fragment__Faithfuls]],
				"",
				["Deity casts |0|, some affecting |1| while others affect |2|.", [plain_fragment__abilities, plain_fragment__towers, plain_fragment__Faithfuls]],
				"",
				["When |0| for 3 seconds (slowly resets when not stunned), clear all stun effects and become immune to tower effects for 5 seconds.", [plain_fragment__stunned]]
			]
		
	elif enemy_id == Enemies.BELIEVER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 29
		info.base_movement_speed = 57
		
		if arg_include_non_combat_info:
			info.enemy_name = "Believer"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Faithful/Believer/Believer_E.png"))
			info.descriptions = [
				"The standard Faithful."
			]
		
	elif enemy_id == Enemies.PRIEST:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 28
		info.base_movement_speed = 37
		
		if arg_include_non_combat_info:
			var plain_fragment__invulnerability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INVULNERABLE, "invulnerability")
			
			info.enemy_name = "Priest"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Faithful/Priest/Priest_E.png"))
			info.descriptions = [
				["If within Deity's range, Priest gives an |0| effect for 1.75 seconds every 14 seconds.", [plain_fragment__invulnerability]]
			]
		
	elif enemy_id == Enemies.SACRIFICER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 26
		info.base_movement_speed = 35
		
		if arg_include_non_combat_info:
			var plain_fragment__health_regen = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.HEALTH, "health regen")
			
			info.enemy_name = "Sacrificer"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Faithful/Sacrificer/Sacrificer_E.png"))
			info.descriptions = [
				["If within Deity's range, Sacrificer gives |0|.", [plain_fragment__health_regen]]
			]
		
	elif enemy_id == Enemies.SEER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 28
		info.base_movement_speed = 37
		info.base_toughness = 2
		
		if arg_include_non_combat_info:
			var plain_fragment__ability_potency = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY_POTENCY, "ability potency")
			
			info.enemy_name = "Seer"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Faithful/Seer/Seer_E.png"))
			info.descriptions = [
				["If within Deity's range, Seer gives |0|.", [plain_fragment__ability_potency]]
			]
		
		
	elif enemy_id == Enemies.CROSS_BEARER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 32
		info.base_movement_speed = 51
		info.base_armor = 2
		info.base_toughness = 2
		
		if arg_include_non_combat_info:
			var plain_fragment__ability_potency = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY_POTENCY, "ability potency")
			var plain_fragment__max_health_increase = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.HEALTH, "max health increase")
			
			info.enemy_name = "Cross Bearer"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Faithful/CrossBearer/CrossBearer_E.png"))
			info.descriptions = [
				"Drops a Cross upon death or escaping, marking the impending approach of the Deity.",
				["The Cross gives |0|, which is lost when the Deity crosses beyond it.", [plain_fragment__max_health_increase]]
			]
		
		
	elif enemy_id == Enemies.DVARAPALA:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 88
		info.base_movement_speed = 39
		info.base_armor = 9
		info.base_toughness = 9
		info.enemy_type = info.EnemyType.ELITE
		
		if arg_include_non_combat_info:
			info.enemy_name = "Dvarapala"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Faithful/Dvarapala/Dvarapala_E.png"))
			info.descriptions = [
				"A resilient Faithful capable of taking considerable damage."
			]
		
	elif enemy_id == Enemies.PROVIDENCE:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 60
		info.base_movement_speed = 44
		info.base_armor = 5
		info.base_toughness = 5
		info.enemy_type = info.EnemyType.ELITE
		
		if arg_include_non_combat_info:
			var plain_fragment__attk_speed_reduc = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ATTACK_SPEED, "30% total attack speed")
			var plain_fragment__base_dmg_reduc = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.BASE_DAMAGE, "20% total base damage")
			
			info.enemy_name = "Providence"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Faithful/Providence/Providence_E.png"))
			info.descriptions = [
				"Upon being hit by an attack from a tower, Providence places a debuff on that tower.",
				["The tower loses |0| and |1|.", [plain_fragment__attk_speed_reduc, plain_fragment__base_dmg_reduc]]
			]
		
	########################### SKIRMISHER
	elif enemy_id == Enemies.COSMIC:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 32
		info.base_movement_speed = 35
		info.enemy_type = info.EnemyType.NORMAL
		
		if arg_include_non_combat_info:
			var interpreter_for_shield_amount = TextFragmentInterpreter.new()
			interpreter_for_shield_amount.enemy_info_to_use_for_enemy_stat_fragments = info
			interpreter_for_shield_amount.display_body = true
			var ins_for_shield_amount = []
			ins_for_shield_amount.append(OutcomeTextFragment.new(EnemyStatTextFragment.STAT_TYPE.SHIELD, -1, "health shield"))
			ins_for_shield_amount.append(NumericalTextFragment.new(40, false, -1))
			ins_for_shield_amount.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
			ins_for_shield_amount.append(EnemyStatTextFragment.new(null, info, EnemyStatTextFragment.STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY, EnemyStatTextFragment.STAT_BASIS.TOTAL, 1.0))
			interpreter_for_shield_amount.array_of_instructions = ins_for_shield_amount
			
			var plain_fragment__aoe_resistance = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.AOE_RESISTANCE, "30% AOE resistance")
			
			
			info.enemy_name = "Cosmic"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic_E.png"))
			info.descriptions = [
				["Every 12 seconds, Cosmic sends a blessing to a target location that gives a |0| and |1| to enemies hit.", [interpreter_for_shield_amount, plain_fragment__aoe_resistance]]
			]
		
	elif enemy_id == Enemies.SMOKE:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 30
		info.base_movement_speed = 55
		info.enemy_type = info.EnemyType.NORMAL
		
		
		if arg_include_non_combat_info:
			var interpreter_for_invis_duration = TextFragmentInterpreter.new()
			interpreter_for_invis_duration.enemy_info_to_use_for_enemy_stat_fragments = info
			interpreter_for_invis_duration.display_body = true
			var ins_for_invis_duration = []
			ins_for_invis_duration.append(NumericalTextFragment.new(1.65, false, -1))
			ins_for_invis_duration.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
			ins_for_invis_duration.append(EnemyStatTextFragment.new(null, info, EnemyStatTextFragment.STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY, EnemyStatTextFragment.STAT_BASIS.TOTAL, 1.0))
			interpreter_for_invis_duration.array_of_instructions = ins_for_invis_duration
			
			var plain_fragment__invisible = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INVISIBLE, "invisible")
			
			
			info.enemy_name = "Smoke"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Smoke/Smoke_E.png"))
			info.descriptions = [
				["Upon reaching 50% health, Smoke makes itself and all enemies within 60 range become |0| for |1|.", [plain_fragment__invisible, interpreter_for_invis_duration]]
			]
		
	elif enemy_id == Enemies.RALLIER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 29
		info.base_movement_speed = 55
		info.enemy_type = info.EnemyType.NORMAL
		
		
		if arg_include_non_combat_info:
			var interpreter_for_speed_boost = TextFragmentInterpreter.new()
			interpreter_for_speed_boost.enemy_info_to_use_for_enemy_stat_fragments = info
			interpreter_for_speed_boost.display_body = true
			var ins_for_speed_boost = []
			ins_for_speed_boost.append(OutcomeTextFragment.new(EnemyStatTextFragment.STAT_TYPE.MOV_SPEED, -1, "mov speed"))
			ins_for_speed_boost.append(NumericalTextFragment.new(50, false, -1))
			ins_for_speed_boost.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
			ins_for_speed_boost.append(EnemyStatTextFragment.new(null, info, EnemyStatTextFragment.STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY, EnemyStatTextFragment.STAT_BASIS.TOTAL, 1.0))
			interpreter_for_speed_boost.array_of_instructions = ins_for_speed_boost
			
			info.enemy_name = "Rallier"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Rallier/Rallier_E.png"))
			info.descriptions = [
				["Upon reaching 50% health, Rallier makes itself and all enemies within 60 range to gain |0| for 0.75 seconds.", [interpreter_for_speed_boost]]
			]
		
	elif enemy_id == Enemies.PROXIMITY:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 36.5
		info.base_movement_speed = 45
		info.base_toughness = 3
		info.enemy_type = info.EnemyType.NORMAL
		
		if arg_include_non_combat_info:
			var plain_fragment__towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "towers")
			
			info.enemy_name = "Proximity"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Proximity/Proximity_E.png"))
			info.descriptions = [
				["Forces |0| within 80 range to attack Proximity instead.", [plain_fragment__towers]]
			]
		
		
	elif enemy_id == Enemies.BLESSER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 26
		info.base_movement_speed = 40
		info.enemy_type = info.EnemyType.NORMAL
		
		if arg_include_non_combat_info:
			var plain_fragment__towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "towers")
			
			var interpreter_for_heal_normal = TextFragmentInterpreter.new()
			interpreter_for_heal_normal.enemy_info_to_use_for_enemy_stat_fragments = info
			interpreter_for_heal_normal.display_body = true
			var ins_for_heal_normal = []
			ins_for_heal_normal.append(OutcomeTextFragment.new(EnemyStatTextFragment.STAT_TYPE.HEALTH, -1, "health per 0.25 seconds"))
			ins_for_heal_normal.append(NumericalTextFragment.new(0.5, false, -1))
			ins_for_heal_normal.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
			ins_for_heal_normal.append(EnemyStatTextFragment.new(null, info, EnemyStatTextFragment.STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY, EnemyStatTextFragment.STAT_BASIS.TOTAL, 1.0))
			interpreter_for_heal_normal.array_of_instructions = ins_for_heal_normal
			
			var interpreter_for_heal_emp = TextFragmentInterpreter.new()
			interpreter_for_heal_emp.enemy_info_to_use_for_enemy_stat_fragments = info
			interpreter_for_heal_emp.display_body = true
			var ins_for_heal_emp = []
			ins_for_heal_emp.append(OutcomeTextFragment.new(EnemyStatTextFragment.STAT_TYPE.HEALTH, -1, "health per 0.25 seconds"))
			ins_for_heal_emp.append(NumericalTextFragment.new(5, false, -1))
			ins_for_heal_emp.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
			ins_for_heal_emp.append(EnemyStatTextFragment.new(null, info, EnemyStatTextFragment.STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY, EnemyStatTextFragment.STAT_BASIS.TOTAL, 1.0))
			interpreter_for_heal_emp.array_of_instructions = ins_for_heal_emp
			
			
			info.enemy_name = "Blesser"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Blesser/Blesser_E.png"))
			info.descriptions = [
				["Upon reaching 80% health, Blesser heals the most injured enemy, but not itself, within 60 range for |0| every 0.25 seconds.", [interpreter_for_heal_normal]],
				["The healing increases to |0| for 1.3 seconds when Blesser's heal target reaches 25% health. This can only happen once", [interpreter_for_heal_emp]]
			]
		
	elif enemy_id == Enemies.ASCENDER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 48
		info.base_movement_speed = 55
		info.enemy_type = info.EnemyType.ELITE
		
		
		if arg_include_non_combat_info:
			
			var interpreter_for_armor_gain = TextFragmentInterpreter.new()
			interpreter_for_armor_gain.enemy_info_to_use_for_enemy_stat_fragments = info
			interpreter_for_armor_gain.display_body = true
			var ins_for_armor_gain = []
			ins_for_armor_gain.append(OutcomeTextFragment.new(EnemyStatTextFragment.STAT_TYPE.ARMOR, -1, "armor"))
			ins_for_armor_gain.append(NumericalTextFragment.new(4.0, false, -1))
			ins_for_armor_gain.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
			ins_for_armor_gain.append(EnemyStatTextFragment.new(null, info, EnemyStatTextFragment.STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY, EnemyStatTextFragment.STAT_BASIS.TOTAL, 1.0))
			interpreter_for_armor_gain.array_of_instructions = ins_for_armor_gain
			
			var interpreter_for_toughness_gain = TextFragmentInterpreter.new()
			interpreter_for_toughness_gain.enemy_info_to_use_for_enemy_stat_fragments = info
			interpreter_for_toughness_gain.display_body = true
			var ins_for_toughness_gain = []
			ins_for_toughness_gain.append(OutcomeTextFragment.new(EnemyStatTextFragment.STAT_TYPE.TOUGHNESS, -1, "armor"))
			ins_for_toughness_gain.append(NumericalTextFragment.new(5.0, false, -1))
			ins_for_toughness_gain.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
			ins_for_toughness_gain.append(EnemyStatTextFragment.new(null, info, EnemyStatTextFragment.STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY, EnemyStatTextFragment.STAT_BASIS.TOTAL, 1.0))
			interpreter_for_toughness_gain.array_of_instructions = ins_for_toughness_gain
			
			var interpreter_for_max_health_gain = TextFragmentInterpreter.new()
			interpreter_for_max_health_gain.enemy_info_to_use_for_enemy_stat_fragments = info
			interpreter_for_max_health_gain.display_body = true
			interpreter_for_max_health_gain.header_description = "max health"
			var ins_for_max_health_gain = []
			ins_for_max_health_gain.append(OutcomeTextFragment.new(EnemyStatTextFragment.STAT_TYPE.HEALTH, -1, "max health"))
			ins_for_max_health_gain.append(NumericalTextFragment.new(120, true, -1))
			ins_for_max_health_gain.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
			ins_for_max_health_gain.append(EnemyStatTextFragment.new(null, info, EnemyStatTextFragment.STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY, EnemyStatTextFragment.STAT_BASIS.TOTAL, 1.0))
			interpreter_for_max_health_gain.array_of_instructions = ins_for_max_health_gain
			
			var plain_fragment__mov_speed = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.MOV_SPEED, "15 mov speed")
			
			
			info.enemy_name = "Ascender"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Ascender/Ascender_BeforeAscend_E.png"))
			info.descriptions = [
				"Upon reaching 50% health, or traversing 50% of its path, Ascender Ascends.",
				["Ascend: Gain |0|, |1| and |2|, but loses |3|.", [interpreter_for_armor_gain, interpreter_for_toughness_gain, interpreter_for_max_health_gain, plain_fragment__mov_speed]]
			]
		
	elif enemy_id == Enemies.BLASTER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 35
		info.base_movement_speed = 50
		info.enemy_type = info.EnemyType.NORMAL
		
		if arg_include_non_combat_info:
			var plain_fragment__tower = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "tower")
			
			var num_of_bullets : int = 3
			var dmg : float = 0.65
			
			info.enemy_name = "Blaster"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Blaster/Blaster_E.png"))
			info.descriptions = [
				["Every 9 seconds, Blaster fires %s bullets that each deal %s damage to a |0| in range. Total: %s" % [num_of_bullets, dmg, (num_of_bullets * dmg)], [plain_fragment__tower]],
				"Most towers have 10 health."
			]
		
		
	elif enemy_id == Enemies.ARTILLERY:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 26
		info.base_movement_speed = 40
		info.enemy_type = info.EnemyType.NORMAL
		
		if arg_include_non_combat_info:
			var plain_fragment__towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "towers")
			
			var dmg : float = 3.5
			var stun_duration : float = 2.0
			
			var plain_fragment__stuns = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stuns")
			
			
			info.enemy_name = "Artillery"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Artillery/Artillery_E.png"))
			info.descriptions = [
				["Every 18 seconds, Artillery fires a shell at 1 of the 4 centermost |0|. The shell deals %s damage and |1| for %s seconds" % [dmg, stun_duration], [plain_fragment__towers, plain_fragment__stuns]],
				"Most towers have 10 health."
			]
		
		
	elif enemy_id == Enemies.DANSEUR:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 28
		info.base_movement_speed = 52
		info.enemy_type = info.EnemyType.NORMAL
		
		if arg_include_non_combat_info:
			var plain_fragment__towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "towers")
			
			var bullet_count : int = 8
			var dmg : float = 0.5
			var tower_detection_fire_range : float = 130.0
			
			var total_dmg = dmg * bullet_count
			
			info.enemy_name = "Danseur"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Danseur/Danseur_E.png"))
			info.descriptions = [
				"Danseur has a chance to dash through a tower placable and to cast Dance.",
				["Dance: Rapidly fire %s waves to random |0| within %s range, each dealing %s, totalling to %s. While Dancing, gain effect immunity." % [bullet_count, tower_detection_fire_range, dmg, total_dmg], [plain_fragment__towers]],
				"Most towers have 10 health.",
				"",
				"Danseur cannot dash to other paths. Danseur does not dash backwards, and can only dash 2 times. Danseur cannot use the same dash line twice."
			]
			
			info.simple_descriptions = [
				"Danseur has a chance to dash through a tower placable and to cast Dance.",
				["Dance: Rapidly fire %s waves to random |0| within %s range, each dealing %s, totalling to %s. While Dancing, gain effect immunity." % [bullet_count, tower_detection_fire_range, dmg, total_dmg], [plain_fragment__towers]],
				"Most towers have 10 health."
			]
		
	elif enemy_id == Enemies.FINISHER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 35
		info.base_movement_speed = 60
		info.enemy_type = info.EnemyType.ELITE
		
		if arg_include_non_combat_info:
			var plain_fragment__towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "towers")
			var plain_fragment__executes = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.EXECUTE, "executes")
			
			var dmg = 2.0
			var percent_execute_health_threshold : float = 35.0
			
			info.enemy_name = "Finisher"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Finisher/Finisher_E.png"))
			info.descriptions = [
				"Finisher has a chance to dash through a tower placable when a tower is present.",
				["While dashing, Finisher deals %s damage to all |0| it hits. If the tower has less than %s%% health, the dash |1| the tower." % [dmg, percent_execute_health_threshold], [plain_fragment__towers, plain_fragment__executes]],
				"Finisher always dashes to the tower if it can be executed by the dash.",
				"",
				"Finisher cannot dash to other paths. Finisher can only dash 10 times. Finisher cannot use the same dash line twice."
			]
			info.simple_descriptions = [
				"Finisher has a chance to dash through a tower placable when a tower is present.",
				["While dashing, Finisher deals %s damage to all |0| it hits. If the tower has less than %s%% health, the dash |1| the tower." % [dmg, percent_execute_health_threshold], [plain_fragment__towers, plain_fragment__executes]],
				"Finisher always dashes to the tower if it can be executed by the dash.",
			]
			
		
	elif enemy_id == Enemies.TOSSER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 24
		info.base_movement_speed = 55
		info.enemy_type = info.EnemyType.NORMAL
		
		if arg_include_non_combat_info:
			var plain_fragment__tower = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "tower")
			var plain_fragment__stunned = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stunned")
			var plain_fragment__knocked_up = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.KNOCK_UP, "knocked up")
			var plain_fragment__knocked_back = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.KNOCK_BACK, "knocked back")
			
			var knock_back_duration : float = 1.25
			var knock_up_stun_duration : float = 2.5
			
			info.enemy_name = "Tosser"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Tosser/Tosser_E.png"))
			info.descriptions = [
				["Every 14 seconds, Tosser fires a cluster of bombs to the closest |0|.", [plain_fragment__tower]],
				["If the tower has a vacant tower placable behind it (in the direction where Tosser threw the bombs), the tower is |0| to the vacant placable over %s seconds." % [knock_back_duration], [plain_fragment__knocked_back]],
				["Otherwise, the tower is |0| and |1| for %s seconds." % [knock_up_stun_duration], [plain_fragment__knocked_up, plain_fragment__stunned]]
			]
			
		
	elif enemy_id == Enemies.HOMERUNNER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 50
		info.base_movement_speed = 60
		info.enemy_type = info.EnemyType.ELITE
		
		if arg_include_non_combat_info:
			var plain_fragment__blue_skirmishers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "Blue Skirmishers")
			var plain_fragment__blue_ruffians = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "Blue Ruffians")
			var plain_fragment__x_ability_potency = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY_POTENCY, "1.5 Bonus Ability Potency")
			var plain_fragment__x_shield = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SHIELD, "20% health shield")
			
			var plain_fragment__red_skirmishers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "Red Skirmishers")
			var plain_fragment__x_health_on_rev = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.HEALTH, "15% health")
			
			
			info.enemy_name = "Home Runner"
			#info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Both/Homerunner/Homerunner_Blue_E.png"))
			info.enemy_atlased_images_list.append(_generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Both/Homerunner/Homerunner_Blue_E.png")))
			info.enemy_atlased_images_list.append(_generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Both/Homerunner/Homerunner_Red_E.png")))
			
			info.descriptions = [
				"Carries a flag that is deployed when Home Runner reaches 45% of its path. The deployment effect varies based on Home Runner's color.",
				"",
				["Blue Flag: Grant all |0| |1|. |2| instead gain |3|.", [plain_fragment__blue_skirmishers, plain_fragment__x_ability_potency, plain_fragment__blue_ruffians, plain_fragment__x_shield]],
				["Red Flag: Grant all |0| a revive effect. Killed Skirmishers are revived over 3 seconds with |1|.", [plain_fragment__red_skirmishers, plain_fragment__x_health_on_rev]]
			]
			
		
		
	elif enemy_id == Enemies.RUFFIAN:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 27
		info.base_movement_speed = 58
		info.enemy_type = info.EnemyType.NORMAL
		
		if arg_include_non_combat_info:
			info.enemy_name = "Ruffian"
			info.enemy_atlased_images_list.append(_generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Both/Ruffian/Ruffian_Blue_E.png")))
			info.enemy_atlased_images_list.append(_generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Both/Ruffian/Ruffian_Red_E.png")))
			
			info.descriptions = [
				"Standard issue Skirmisher."
			]
			
		
	############################# OTHERS
	elif enemy_id == Enemies.TRIASYN_OGV_SOUL:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.OTHERS)
		info.base_health = 35 #39 
		info.base_movement_speed = 40
		info.base_armor = 5
		info.base_toughness = 5
		info.enemy_type = info.EnemyType.ELITE
		
		if arg_include_non_combat_info:
			info.enemy_name = "OGV Soul"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://GameInfoRelated/ColorSynergyRelated/TriaSynergies/TriaSyn_OGV/Assets/EnemySoul/Soul_E.png"))
			info.descriptions = [
				"The enemy's soul. Kill this to deal damage to the enemy player and end the game early!"
			]
		
		
	elif enemy_id == Enemies.DOMSYN_RED_ORACLES_EYE_SHADOW:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.OTHERS)
		info.base_health = 45 #50
		info.base_movement_speed = 35
		#info.base_armor = 5
		#info.base_toughness = 5
		info.enemy_type = info.EnemyType.ELITE
		
		if arg_include_non_combat_info:
			info.enemy_name = "Oracle Eye Shadow"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Others/DomSyn_Red_Pact_OraclesEye_Shadow/DomSyn_Red_Pact_OraclesEye_Shadow_E.png"))
			info.descriptions = [
				"Visions of darkness. Destroy these to gain more range."
			]
		
	elif enemy_id == Enemies.MAP_ENCHANT_ANTI_MAGIK:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.OTHERS)
		info.base_health = 25
		info.base_movement_speed = 38
		#info.base_armor = 5
		#info.base_toughness = 5
		info.enemy_type = info.EnemyType.NORMAL
		
		if arg_include_non_combat_info:
			info.enemy_name = "Anti Magik"
			info.enemy_atlased_image = _generate_enemy_image_icon_atlas_texture(preload("res://EnemyRelated/EnemyTypes/Type_Others/MapEnchant_AntiMagik/MapEnchant_AntiMagik_E.png"))
			info.descriptions = [
				"Sucks the magic out of the Altar from the Map: Enchant."
			]
	
	
	return info


static func get_enemy_scene(enemy_id : int):
	# BASIC FACTION
	if enemy_id == Enemies.BASIC:
		return load("res://EnemyRelated/EnemyTypes/Type_Basic/Basic/Basic.tscn")
	elif enemy_id == Enemies.BRUTE:
		return load("res://EnemyRelated/EnemyTypes/Type_Basic/Brute/Brute.tscn")
	elif enemy_id == Enemies.DASH:
		return load("res://EnemyRelated/EnemyTypes/Type_Basic/Dash/Dash.tscn")
	elif enemy_id == Enemies.HEALER:
		return load("res://EnemyRelated/EnemyTypes/Type_Basic/Healer/Healer.tscn")
	elif enemy_id == Enemies.WIZARD:
		return load("res://EnemyRelated/EnemyTypes/Type_Basic/Wizard/Wizard.tscn")
	elif enemy_id == Enemies.PAIN:
		return load("res://EnemyRelated/EnemyTypes/Type_Basic/Pain/Pain.tscn")
		
	# EXPERT FACTION
	elif enemy_id == Enemies.EXPERIENCED:
		return load("res://EnemyRelated/EnemyTypes/Type_Expert/Experienced(Basic)/Experienced.tscn")
	elif enemy_id == Enemies.FIEND:
		return load("res://EnemyRelated/EnemyTypes/Type_Expert/Fiend(Brute)/Fiend.tscn")
	elif enemy_id == Enemies.CHARGE:
		return load("res://EnemyRelated/EnemyTypes/Type_Expert/Charge(Dash)/Charge.tscn")
	elif enemy_id == Enemies.ENCHANTRESS:
		return load("res://EnemyRelated/EnemyTypes/Type_Expert/Enchantress(Healer)/Enchantress.tscn")
	elif enemy_id == Enemies.MAGUS:
		return load("res://EnemyRelated/EnemyTypes/Type_Expert/Magus(Wizard)/Magus.tscn")
	elif enemy_id == Enemies.ASSASSIN:
		return load("res://EnemyRelated/EnemyTypes/Type_Expert/Assassin(Pain)/Assassin.tscn")
	elif enemy_id == Enemies.GRANDMASTER:
		return load("res://EnemyRelated/EnemyTypes/Type_Expert/Grandmaster/Grandmaster.tscn")
		
	# FAITHFUL FACTION
	elif enemy_id == Enemies.DEITY:
		return load("res://EnemyRelated/EnemyTypes/Type_Faithful/Deity/Deity.tscn")
	elif enemy_id == Enemies.BELIEVER:
		return load("res://EnemyRelated/EnemyTypes/Type_Faithful/Believer/Believer.tscn")
	elif enemy_id == Enemies.PRIEST:
		return load("res://EnemyRelated/EnemyTypes/Type_Faithful/Priest/Priest.tscn")
	elif enemy_id == Enemies.SACRIFICER:
		return load("res://EnemyRelated/EnemyTypes/Type_Faithful/Sacrificer/Sacrificer.tscn")
	elif enemy_id == Enemies.SEER:
		return load("res://EnemyRelated/EnemyTypes/Type_Faithful/Seer/Seer.tscn")
	elif enemy_id == Enemies.CROSS_BEARER:
		return load("res://EnemyRelated/EnemyTypes/Type_Faithful/CrossBearer/CrossBearer.tscn")
	elif enemy_id == Enemies.DVARAPALA:
		return load("res://EnemyRelated/EnemyTypes/Type_Faithful/Dvarapala/Dvarapala.tscn")
	elif enemy_id == Enemies.PROVIDENCE:
		return load("res://EnemyRelated/EnemyTypes/Type_Faithful/Providence/Providence.tscn")
		
	# SKIRMISHERS FACTION
	elif enemy_id == Enemies.COSMIC:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic.tscn")
	elif enemy_id == Enemies.SMOKE:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Smoke/Smoke.tscn")
	elif enemy_id == Enemies.RALLIER:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Rallier/Rallier.tscn")
	elif enemy_id == Enemies.PROXIMITY:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Proximity/Proximity.tscn")
	elif enemy_id == Enemies.BLESSER:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Blesser/Blesser.tscn")
	elif enemy_id == Enemies.ASCENDER:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Ascender/Ascender.tscn")
		
	elif enemy_id == Enemies.BLASTER:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Blaster/Blaster.tscn")
	elif enemy_id == Enemies.ARTILLERY:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Artillery/Artillery.tscn")
	elif enemy_id == Enemies.DANSEUR:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Danseur/Danseur.tscn")
	elif enemy_id == Enemies.FINISHER:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Finisher/Finisher.tscn")
	elif enemy_id == Enemies.TOSSER:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Tosser/Tosser.tscn")
		
	elif enemy_id == Enemies.HOMERUNNER:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Both/Homerunner/Homerunner.tscn") 
	elif enemy_id == Enemies.RUFFIAN:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Both/Ruffian/Ruffian.tscn")
		
	# OTHERS
	elif enemy_id == Enemies.TRIASYN_OGV_SOUL:
		return load("res://EnemyRelated/EnemyTypes/Type_Others/TriaSyn_OGV_Soul/TriaSyn_OGV_Soul.tscn")
	elif enemy_id == Enemies.DOMSYN_RED_ORACLES_EYE_SHADOW:
		return load("res://EnemyRelated/EnemyTypes/Type_Others/DomSyn_Red_Pact_OraclesEye_Shadow/DomSyn_Red_Pact_OraclesEye_Shadow.tscn")
	elif enemy_id == Enemies.MAP_ENCHANT_ANTI_MAGIK:
		return load("res://EnemyRelated/EnemyTypes/Type_Others/MapEnchant_AntiMagik/MapEnchant_AntiMagik.tscn")
	
