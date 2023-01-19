extends Node


var random_targeting_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var coin_type_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var inaccuracy_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var non_essential_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var fruit_tree_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var pestilence_spread : RandomNumberGenerator = RandomNumberGenerator.new()
var domsyn_red_pact_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var domsyn_red_pact_mag_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var second_half_faction_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var roll_towers_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var tier_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var black_buff_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var shackled_pull_position_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var faithful_mov_speed_delay_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var black_capacitor_nova_lightning_tower_or_enemy_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var random_tower_decider_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var chaos_events_to_play_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var chaos_events_rng_general_purpose := RandomNumberGenerator.new()
var iota_star_positioning_rng := RandomNumberGenerator.new()
var variance_state_rng := RandomNumberGenerator.new()
var sophist_crystal_positioning_rng := RandomNumberGenerator.new()
var enervate_orb_reposition_rng := RandomNumberGenerator.new()
var enervate_orb_choose_rng := RandomNumberGenerator.new()
var trapper_trap_pos_rng := RandomNumberGenerator.new()
var red_tower_randomizer_rng := RandomNumberGenerator.new()
var enemy_strength_value_rng := RandomNumberGenerator.new()
var skirmisher_general_purpose_rng := RandomNumberGenerator.new()
var skirmisher_random_cd_rng := RandomNumberGenerator.new()
var map_enchant_gen_purpose_rng := RandomNumberGenerator.new()


# TODO MAKE SOME WAY TO SAVE SEED OF RNGS

var _rng_id_to_rng_map : Dictionary

enum RNGSource {
	NON_ESSENTIAL = -10,
	RANDOM_TARGETING = 10,
	
	COIN = 100, # Choosing of whether bronze, silver or gold coin
	FRUIT_TREE = 101,
	PESTILENCE_SPREAD = 102,
	SHACKLED_PULL_POSITION = 103,
	CHAOS_EVENTS_TO_PLAY = 104,
	CHAOS_EVENTS_GENERAL_PURPOSE = 105,
	IOTA_STAR_POSITIONING = 106,
	VARIANCE_STATE = 107,
	SOPHIST_CRYSAL_POS = 108,
	ENERVATE_REPOSITION = 109,
	ENERVATE_ORB_CHOOSE = 110,
	TRAPPER_TRAP_POS = 111,
	
	INACCURACY = 1000,
	
	DOMSYN_RED_PACT = 1100,
	DOMSYN_RED_PACT_MAGNITUDE = 1101,
	
	SECOND_HALF_FACTION = 1200,
	
	ROLL_TOWERS = 2000,
	TIER = 2001,
	RANDOM_TOWER_DECIDER = 2002, # ex: gain 2 tier 5 towers.
	RED_TOWER_RANDOMIZER = 2003,
	
	BLACK_BUFF = 3000,
	BLACK_CAPACITOR_NOVA_LIGHTNING_TOWER_OR_ENEMY_RNG = 3001,
	
	#
	FAITHFUL_MOV_SPEED_DELAY = 10000
	SKIRMISHER_GEN_PURPOSE = 10001
	SKIRMISHER_RANDOM_CD = 10002
	
	
	#
	MAP_ENCHANT_GEN_PURPOSE = 20000
	
	#
	ENEMY_STRENGTH_VALUE_GENERATOR = -100
}

func _init():
	_rng_id_to_rng_map = {
		RNGSource.RANDOM_TARGETING : random_targeting_rng,
		RNGSource.COIN : coin_type_rng,
		RNGSource.INACCURACY : inaccuracy_rng,
		RNGSource.NON_ESSENTIAL : non_essential_rng,
		RNGSource.FRUIT_TREE : fruit_tree_rng,
		RNGSource.PESTILENCE_SPREAD : pestilence_spread,
		RNGSource.DOMSYN_RED_PACT : domsyn_red_pact_rng,
		RNGSource.DOMSYN_RED_PACT_MAGNITUDE : domsyn_red_pact_mag_rng,
		RNGSource.SECOND_HALF_FACTION : second_half_faction_rng,
		RNGSource.ROLL_TOWERS : roll_towers_rng,
		RNGSource.TIER : tier_rng,
		RNGSource.BLACK_BUFF : black_buff_rng,
		RNGSource.SHACKLED_PULL_POSITION : shackled_pull_position_rng,
		RNGSource.FAITHFUL_MOV_SPEED_DELAY : faithful_mov_speed_delay_rng,
		RNGSource.BLACK_CAPACITOR_NOVA_LIGHTNING_TOWER_OR_ENEMY_RNG : black_capacitor_nova_lightning_tower_or_enemy_rng,
		RNGSource.RANDOM_TOWER_DECIDER : random_tower_decider_rng,
		RNGSource.CHAOS_EVENTS_TO_PLAY : chaos_events_to_play_rng,
		RNGSource.CHAOS_EVENTS_GENERAL_PURPOSE : chaos_events_rng_general_purpose,
		RNGSource.IOTA_STAR_POSITIONING : iota_star_positioning_rng,
		RNGSource.VARIANCE_STATE : variance_state_rng,
		RNGSource.SOPHIST_CRYSAL_POS : sophist_crystal_positioning_rng,
		RNGSource.ENERVATE_REPOSITION : enervate_orb_reposition_rng,
		RNGSource.ENERVATE_ORB_CHOOSE : enervate_orb_choose_rng,
		RNGSource.TRAPPER_TRAP_POS : trapper_trap_pos_rng,
		RNGSource.RED_TOWER_RANDOMIZER : red_tower_randomizer_rng,
		RNGSource.ENEMY_STRENGTH_VALUE_GENERATOR : enemy_strength_value_rng,
		RNGSource.SKIRMISHER_GEN_PURPOSE : skirmisher_general_purpose_rng,
		RNGSource.SKIRMISHER_RANDOM_CD : skirmisher_random_cd_rng,
		RNGSource.MAP_ENCHANT_GEN_PURPOSE : map_enchant_gen_purpose_rng,
		
		
		
	}
	
	for rng_id in RNGSource.values():
		get_rng(rng_id).randomize()


func get_rng(rng_source : int) -> RandomNumberGenerator:
	return _rng_id_to_rng_map[rng_source]

#	if rng_source == RNGSource.RANDOM_TARGETING:
#		return random_targeting_rng
#	elif rng_source == RNGSource.COIN:
#		return coin_type_rng
#	elif rng_source == RNGSource.INACCURACY:
#		return inaccuracy_rng
#	elif rng_source == RNGSource.NON_ESSENTIAL:
#		return non_essential_rng
#	elif rng_source == RNGSource.FRUIT_TREE:
#		return fruit_tree_rng
#	elif rng_source == RNGSource.PESTILENCE_SPREAD:
#		return pestilence_spread
#	elif rng_source == RNGSource.DOMSYN_RED_PACT:
#		return domsyn_red_pact_rng
#	elif rng_source == RNGSource.DOMSYN_RED_PACT_MAGNITUDE:
#		return domsyn_red_pact_mag_rng
#	elif rng_source == RNGSource.SECOND_HALF_FACTION:
#		return second_half_faction_rng
#	elif rng_source == RNGSource.ROLL_TOWERS:
#		return roll_towers_rng
#	elif rng_source == RNGSource.TIER:
#		return tier_rng
#	elif rng_source == RNGSource.BLACK_BUFF:
#		return black_buff_rng
#	elif rng_source == RNGSource.SHACKLED_PULL_POSITION:
#		return shackled_pull_position_rng
#	elif rng_source == RNGSource.FAITHFUL_MOV_SPEED_DELAY:
#		return faithful_mov_speed_delay_rng
#	elif rng_source == RNGSource.BLACK_CAPACITOR_NOVA_LIGHTNING_TOWER_OR_ENEMY_RNG:
#		return black_capacitor_nova_lightning_tower_or_enemy_rng
#	elif rng_source == RNGSource.RANDOM_TOWER_DECIDER:
#		return random_tower_decider_rng
#	elif rng_source == RNGSource.CHAOS_EVENTS_TO_PLAY:
#		return chaos_events_to_play_rng
#	elif rng_source == RNGSource.CHAOS_EVENTS_GENERAL_PURPOSE:
#		return chaos_events_rng_general_purpose
#	elif rng_source == RNGSource.IOTA_STAR_POSITIONING:
#		return iota_star_positioning_rng
#	elif rng_source == RNGSource.VARIANCE_STATE:
#		return variance_state_rng
#	elif rng_source == RNGSource.SOPHIST_CRYSAL_POS:
#		return sophist_crystal_positioning_rng
#	elif rng_source == RNGSource.ENERVATE_REPOSITION:
#		return enervate_orb_reposition_rng
#	elif rng_source == RNGSource.ENERVATE_ORB_CHOOSE:
#		return enervate_orb_choose_rng
#	elif rng_source == RNGSource.TRAPPER_TRAP_POS:
#		return trapper_trap_pos_rng
#	elif rng_source == RNGSource.RED_TOWER_RANDOMIZER:
#		return red_tower_randomizer_rng
#	elif rng_source == RNGSource.ENEMY_STRENGTH_VALUE_GENERATOR:
#		return enemy_strength_value_rng
#	elif rng_source == RNGSource.SKIRMISHER_GEN_PURPOSE:
#		return skirmisher_general_purpose_rng
#	elif rng_source == RNGSource.SKIRMISHER_RANDOM_CD:
#		return skirmisher_random_cd_rng
#	elif rng_source == RNGSource.MAP_ENCHANT_GEN_PURPOSE:
#		return map_enchant_gen_purpose_rng
#
#	return null



###### common funcs

static func randomly_select_one_element(arg_eles : Array, arg_rng : RandomNumberGenerator):
	var rand_i = arg_rng.randi_range(0, arg_eles.size() - 1)
	
	return arg_eles[rand_i]


