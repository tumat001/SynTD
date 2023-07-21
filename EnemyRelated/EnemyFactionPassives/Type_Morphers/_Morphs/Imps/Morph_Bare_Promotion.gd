extends "res://EnemyRelated/EnemyFactionPassives/Type_Morphers/_Morphs/AbstractMorph.gd"

const StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/StageRound.gd")

const MorphSkillset_Bare_Promotion = preload("res://EnemyRelated/EnemyFactionPassives/Type_Morphers/_Skillsets/Imps/MorphSkillset_Bare_Promotion.gd")



const promotion_unit_offset : float = 0.7

const stage_num_to_bare_promote_count_map : Dictionary = {
	6 : 1,
	7 : 1,
	8 : 2,
	9 : 2,
	10 : 3,
}

var _current_bare_promote_count_per_round : int
var _current_bare_promote_count : int


#

func _init().(StoreOfEnemyMorphs.MorphIds.BARE__PROMOTION):
	
	#todo
	enemy_based_icon #=
	morph_based_icon #=
	
	main_enemy_morpher_id = EnemyConstants.Enemies.BARE
	morph_name = "Promotion"
	
	
	min_round_to_be_offerable_inc = "61"
	



func _configure_with_game_elements_and_fac_passive(arg_game_elements, arg_faction_passive):
	._configure_with_game_elements_and_fac_passive(arg_game_elements, arg_faction_passive)
	
	arg_game_elements.stage_round_manager.connect("round_ended", self, "_on_round_ended", [], CONNECT_PERSIST)
	_update_description()


func _update_description():
	var plain_fragment__x_bares = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "[u]%s[/u] Bare(s)" % _current_bare_promote_count_per_round)
	var plain_fragment__savages = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "Savage")
	
	
	descriptions = [
		["The first |0| (depends on stage number) that reach beyond %s%% of the path sacrifice themselves to summon a |1| on its place." % [(promotion_unit_offset * 100)], [plain_fragment__x_bares, plain_fragment__savages]],
	]
	
	emit_signal("description_changed")


func _on_round_ended(arg_stageround):
	var id = arg_stageround.id
	var curr_stage_num = StageRound.convert_stageround_id_to_stage_and_round_num(id)[0]
	
	for stage_num in stage_num_to_bare_promote_count_map.keys():
		if curr_stage_num == stage_num:
			_current_bare_promote_count_per_round = stage_num_to_bare_promote_count_map[stage_num]
			break
	
	_update_description()
	
	
	_current_bare_promote_count = _current_bare_promote_count_per_round

##

func _apply_morph(arg_game_elements):
	._apply_morph(arg_game_elements)
	
	_listen_for_enemy_before_enemy_spawned(arg_game_elements, "_on_enemy_before_spawned", null)
	

func _unapply_morph(arg_game_elements):
	._unapply_morph(arg_game_elements)
	
	_unlisten_for_enemy_before_enemy_spawned(arg_game_elements, "_on_enemy_before_spawned")
	

##

func _on_enemy_before_spawned(arg_enemy, arg_params):
	if _current_bare_promote_count != 0:
		if arg_enemy.enemy_id == EnemyConstants.Enemies.BARE:
			var skillset = _construct_skillset()
			skillset._apply_morph_skillset(arg_enemy)
			
		elif arg_enemy.enemy_id == EnemyConstants.Enemies.WILDCARD:
			var skillset = _construct_skillset()
			skillset._apply_morph_skillset__to_wildcard(arg_enemy)
			
	

func _construct_skillset():
	var skillset = MorphSkillset_Bare_Promotion.new()
	
	skillset.target_unit_offset = promotion_unit_offset
	skillset.connect("reached_unit_offset", self, "_on_enemy_reached_unit_offset")
	
	return skillset

#

func _on_enemy_reached_unit_offset(arg_enemy):
	
	if _current_bare_promote_count != 0:
		_current_bare_promote_count -= 1
		
		var health_ratio : float = 0.5 + ((arg_enemy.current_health / arg_enemy._last_calculated_max_health) / 2.0)
		
		
		# summon savage
		var savage = game_elements.enemy_manager.spawn_enemy(EnemyConstants.Enemies.SAVAGE)
		savage.shift_unit_offset(arg_enemy.unit_offset)
		savage._set_current_health_to(savage._last_calculated_max_health * health_ratio)
		
		# then destroy self
		arg_enemy._destroy_self()  # triggers revives
		

