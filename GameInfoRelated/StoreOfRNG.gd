extends Node


var random_targeting_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var coin_type_rng : RandomNumberGenerator = RandomNumberGenerator.new()

# TODO MAKE SOME WAY TO SAVE SEED OF RNGS


enum RNGSource {
	RANDOM_TARGETING,
	
	COIN, # Choosing of whether bronze, silver or gold coin
}


func get_rng(rng_source : int) -> RandomNumberGenerator:
	
	if rng_source == RNGSource.RANDOM_TARGETING:
		return random_targeting_rng
	elif rng_source == RNGSource.COIN:
		return coin_type_rng
	
	return null
