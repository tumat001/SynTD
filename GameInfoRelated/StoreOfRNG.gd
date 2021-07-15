extends Node


var random_targeting_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var coin_type_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var inaccuracy_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var non_essential_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var fruit_tree_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var pestilence_spread : RandomNumberGenerator = RandomNumberGenerator.new()
var domsyn_red_pact_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var domsyn_red_pact_mag_rng : RandomNumberGenerator = RandomNumberGenerator.new()


# TODO MAKE SOME WAY TO SAVE SEED OF RNGS


enum RNGSource {
	RANDOM_TARGETING,
	
	COIN, # Choosing of whether bronze, silver or gold coin
	FRUIT_TREE,
	PESTILENCE_SPREAD,
	
	INACCURACY,
	
	DOMSYN_RED_PACT,
	DOMSYN_RED_PACT_MAGNITUDE,
	
	NON_ESSENTIAL,
}


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
	
	return null
