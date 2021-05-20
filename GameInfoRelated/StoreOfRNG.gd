extends Node


var random_targeting_rng : RandomNumberGenerator = RandomNumberGenerator.new()

# TODO MAKE SOME WAY TO SAVE SEED OF RNGS


enum RNGSource {
	RANDOM_TARGETING,
}


func get_rng(rng_source : int) -> RandomNumberGenerator:
	
	if rng_source == RNGSource.RANDOM_TARGETING:
		return random_targeting_rng
	
	return null
