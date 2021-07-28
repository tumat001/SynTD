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


# TODO MAKE SOME WAY TO SAVE SEED OF RNGS


enum RNGSource {
	NON_ESSENTIAL = -10,
	RANDOM_TARGETING = 10,
	
	COIN = 20, # Choosing of whether bronze, silver or gold coin
	FRUIT_TREE = 21,
	PESTILENCE_SPREAD = 22,
	
	INACCURACY = 30,
	
	DOMSYN_RED_PACT = 40,
	DOMSYN_RED_PACT_MAGNITUDE = 41,
	
	SECOND_HALF_FACTION = 42,
	
	ROLL_TOWERS = 43,
	TIER = 44,
}

func _ready():
	for rng_id in RNGSource.values():
		get_rng(rng_id).randomize()


func get_rng(rng_source : int) -> RandomNumberGenerator:
	
	if rng_source == RNGSource.RANDOM_TARGETING:
		return random_targeting_rng
	elif rng_source == RNGSource.COIN:
		return coin_type_rng
	elif rng_source == RNGSource.INACCURACY:
		return inaccuracy_rng
	elif rng_source == RNGSource.NON_ESSENTIAL:
		return non_essential_rng
	elif rng_source == RNGSource.FRUIT_TREE:
		return fruit_tree_rng
	elif rng_source == RNGSource.PESTILENCE_SPREAD:
		return pestilence_spread
	elif rng_source == RNGSource.DOMSYN_RED_PACT:
		return domsyn_red_pact_rng
	elif rng_source == RNGSource.DOMSYN_RED_PACT_MAGNITUDE:
		return domsyn_red_pact_mag_rng
	elif rng_source == RNGSource.SECOND_HALF_FACTION:
		return second_half_faction_rng
	elif rng_source == RNGSource.ROLL_TOWERS:
		return roll_towers_rng
	elif rng_source == RNGSource.TIER:
		return tier_rng
	
	return null
