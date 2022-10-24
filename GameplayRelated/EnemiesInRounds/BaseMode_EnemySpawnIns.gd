const BaseFactionPassive = preload("res://EnemyRelated/EnemyFactionPassives/BaseFactionPassive.gd")

const SingleEnemySpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/SingleEnemySpawnInstruction.gd")
const AbstractSpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/AbstractSpawnInstruction.gd")
const ChainSpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/ChainSpawnInstruction.gd")
const MultipleEnemySpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/MultipleEnemySpawnInstruction.gd")
const LinearEnemySpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/LinearEnemySpawnInstruction.gd")

const EnemyConstants = preload("res://EnemyRelated/EnemyConstants.gd")


var enemy_strength_value_to_use : int

func get_instructions_for_stageround(uuid : String):
	pass

func is_transition_time_in_stageround(uuid : String) -> bool:
	return false



func get_faction_passive(): #-> BaseFactionPassive:
	return null
