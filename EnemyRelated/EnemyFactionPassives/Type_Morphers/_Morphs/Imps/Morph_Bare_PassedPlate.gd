extends "res://EnemyRelated/EnemyFactionPassives/Type_Morphers/_Morphs/AbstractMorph.gd"

const MorphSkillset_Bare_PassedPlate = preload("res://EnemyRelated/EnemyFactionPassives/Type_Morphers/_Skillsets/Imps/MorphSkillset_Bare_PassedPlate.gd")


const shield_health_ratio : float = 15.0
const pass_shield_range : float = 100.0


func _init().(StoreOfEnemyMorphs.MorphIds.BARE__PASSED_PLATE):
	
	#todo
	enemy_based_icon #=
	morph_based_icon #=
	
	main_enemy_morpher_id = EnemyConstants.Enemies.BARE
	morph_name = "Passed Plate"
	
	var plain_fragment__x_shield = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SHIELD, "%s%% shield based on Bare's max health" % shield_health_ratio)
	var plain_fragment__enemy = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "enemy")
	
	descriptions = [
		["On death, gives a |0| to the nearest |1| within %s range. Shields stack!" % [pass_shield_range], [plain_fragment__x_shield, plain_fragment__enemy]]
	]


######



func _apply_morph(arg_game_elements):
	._apply_morph(arg_game_elements)
	
	_listen_for_enemy_before_enemy_spawned(arg_game_elements, "_on_enemy_before_spawned", null)
	

func _unapply_morph(arg_game_elements):
	._unapply_morph(arg_game_elements)
	
	_unlisten_for_enemy_before_enemy_spawned(arg_game_elements, "_on_enemy_before_spawned")
	


###

func _on_enemy_before_spawned(arg_enemy, arg_params):
	if arg_enemy.enemy_id == EnemyConstants.Enemies.BARE:
		var skillset = _construct_skillset()
		skillset._apply_morph_skillset(arg_enemy)
		
	elif arg_enemy.enemy_id == EnemyConstants.Enemies.WILDCARD:
		var skillset = _construct_skillset()
		skillset._apply_morph_skillset__to_wildcard(arg_enemy)
		
	

func _construct_skillset():
	var skillset =  MorphSkillset_Bare_PassedPlate.new()
	
	skillset.pass_shield_range = pass_shield_range
	skillset.shield_health_ratio = shield_health_ratio
	
	return skillset



