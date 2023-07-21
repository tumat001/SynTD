extends "res://EnemyRelated/AbstractEnemy.gd"

const Morphers_FactionPassive = preload("res://EnemyRelated/EnemyFactionPassives/Type_Morphers/Morphers_FactionPassive.gd")


var all_active_morph_skillset_id_to_skillset : Dictionary

##


# USED merely for tracking. for now.
func apply_skillset(arg_skillset):
	all_active_morph_skillset_id_to_skillset[arg_skillset.id] = arg_skillset

func unapply_skillset(arg_skillset):
	all_active_morph_skillset_id_to_skillset.erase(arg_skillset.id)

