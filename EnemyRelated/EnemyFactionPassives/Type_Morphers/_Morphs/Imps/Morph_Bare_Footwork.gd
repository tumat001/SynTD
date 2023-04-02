extends "res://EnemyRelated/EnemyFactionPassives/Type_Morphers/_Morphs/AbstractMorph.gd"

const MorphSkillset_Bare_Footwork = preload("res://EnemyRelated/EnemyFactionPassives/Type_Morphers/_Skillsets/Imps/MorphSkillset_Bare_Footwork.gd")


const first_health_breakpoint : float = 0.7
const first_breakpoint_speed_percent : float = 15.0

const second_health_breakpoint : float = 0.2
const second_breakpoint_speed_percent : float = 30.0


#

func _init().(StoreOfEnemyMorphs.MorphIds.BARE__FOOTWORK):
	
	#todo
	icon #=
	
	var plain_fragment__bares = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "Bares")
	
	var plain_fragment__first_health_breakpoint = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY_STAT__HEALTH, "%s%% health" % (first_health_breakpoint * 100))
	var plain_fragment__first_breakpoint_speed = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY_STAT__MOV_SPEED, "%s%% mov speed" % (first_health_breakpoint * 100))
	
	var plain_fragment__second_health_breakpoint = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY_STAT__HEALTH, "%s%% health" % (second_health_breakpoint * 100))
	var plain_fragment__second_breakpoint_speed = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY_STAT__MOV_SPEED, "%s%% mov speed" % (second_health_breakpoint * 100))
	
	
	descriptions = [
		["Upon reaching |0|, |1| gain |2|.", [plain_fragment__first_health_breakpoint, plain_fragment__bares, plain_fragment__first_breakpoint_speed]],
		["Upon reaching |0|, |1| gain additional |2|.", [plain_fragment__second_health_breakpoint, plain_fragment__bares, plain_fragment__second_breakpoint_speed]]
	]
	
	

##

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
	var skillset = MorphSkillset_Bare_Footwork.new()
	
	skillset.first_breakpoint_speed_percent = first_breakpoint_speed_percent
	skillset.first_health_breakpoint = first_health_breakpoint
	
	skillset.second_breakpoint_speed_percent = second_breakpoint_speed_percent
	skillset.second_health_breakpoint = second_health_breakpoint
	
	return skillset

