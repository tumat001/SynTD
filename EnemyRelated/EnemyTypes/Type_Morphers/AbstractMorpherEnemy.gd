extends "res://EnemyRelated/AbstractEnemy.gd"

const Morphers_FactionPassive = preload("res://EnemyRelated/EnemyFactionPassives/Type_Morphers/Morphers_FactionPassive.gd")



var _all_skillset_id_to_params_map : Dictionary

#####

# Skillsets = abilities & special funcs of Morpher enemies.
# EX: Healing per x seconds of Mender
# FOR use of Wildcard, and for standardization/customizable effects.
#
# MUST be called before _ready
func add_skillset__before_ready(arg_skillset_id : int, arg_params):
	_all_skillset_id_to_params_map[arg_skillset_id] = arg_params

# MUST be called before _ready
func remove_skillset__before_ready(arg_skillset_id : int):
	_all_skillset_id_to_params_map.erase(arg_skillset_id)


#####

func _ready():
	_activate_all_skillsets()
	

func _activate_all_skillsets():
	for id in _all_skillset_id_to_params_map.keys():
		if Morphers_FactionPassive.skillset_id_to_morpher_enemy_apply_method_name.has(id):
			var method_name = Morphers_FactionPassive.skillset_id_to_morpher_enemy_apply_method_name[id]
			call(method_name)
		



#############################

#func _apply__bare__passed_plate():
#	pass
#
#
#func _apply__bare__promotion():
#	pass
#
#
#func _apply__bare__horde():
#	pass
#
#
#func _apply__bare__footwork():
#	pass
#
#
#
#func _apply__mender__base_kit_skillset():
#	pass
#
#
#func _apply__mender__poly_target():
#	pass
#
#
#func _apply__mender__sacred_ground():
#	pass
#
#
#func _apply__mender__battle_heal():
#	pass
#
#
#func _apply__mender__fallen_angel():
#	pass
#
#
#
#
#func _apply__fighter__base_kit_skillset():
#	pass
#
#
#func _apply__fighter__grand_fighter():
#	pass
#
#
#func _apply__fighter__knock_up():
#	pass
#
#
#func _apply__fighter__bloodlust():
#	pass
#
#
#
#func _apply__crippler__base_kit_skillset():
#	pass
#
#
#func _apply__crippler__toxic_explosion():
#	pass
#
#
#func _apply__crippler__persistence():
#	pass
#
#
#func _apply__crippler__obscure():
#	pass
#
#
#func _apply__crippler__targeted_immunity():
#	pass
#
#
#
#
#func _apply__sorcerer__base_kit_skillset():
#	pass
#
#
#func _apply__sorcerer__grand_sorcerer():
#	pass
#
#
#func _apply__sorcerer_cloak():
#	pass
#
#
#func _apply__sorcerer__portal_mage():
#	pass
#
#
#func _apply__sorcerer__necromancer():
#	pass
#
#
#
#
#func _apply__savage__unstoppable_march():
#	pass
#
#
#func _apply__savage__giants():
#	pass
#
#
#func _apply__savage__taunting():
#	pass
#
#
#func _apply__savage__surmount():
#	pass
#

