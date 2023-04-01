extends Reference

####### SKILLSETS

enum MorpherSkillsetIds {
	BARE__PASSED_PLATE = 1,
	BARE__PROMOTION = 2,
	BARE__HORDE = 3,  # the health reduc porton
	BARE__FOOTWORK = 4,
	
	####
	
	MENDER__BASE_KIT_SKILLSET = 10,
	MENDER__POLY_TARGET = 11,
	MENDER__SACRED_GROUND = 12,
	MENDER__BATTLE_HEAL = 13,
	MENDER__FALLEN_ANGEL = 14,
	
	####
	
	FIGHTER__BASE_KIT_SKILLSET = 20,
	FIGHTER__GRAND_FIGHTER = 21, # the modification into grand fighter portion
	FIGHTER__KNOCK_UP = 22,
	FIGHTER__BLOODLUST = 23,
	FIGHTER__PERSERVERANCE = 24,
	
	#####
	
	CRIPPLER__BASE_KIT_SKILLSET = 30,
	CRIPPLER__TOXIC_EXPLOSION = 31,
	CRIPPLER__PERSISTENCE = 32,
	CRIPPLER__OBSCURE = 33,
	CRIPPLER__TARGETED_IMMUNITY = 34,
	
	#####
	
	SORCERER__BASE_KIT_SKILLSET = 40,
	SORCERER__GRAND_SORCERER = 41,
	SORCERER__CLOAK = 42,
	SORCERER__PORTAL_MAGE = 43,
	SORCERER__NECROMANCER = 44,
	
	#####
	
	SAVAGE__UNSTOPPABLE_MARCH = 51,
	SAVAGE__GIANTS = 52,
	SAVAGE__TAUNTING = 53,
	SAVAGE__SURMOUNT = 54,
	
}


const morph_skillset_id_to_path_name_map : Dictionary = {
	
	MorpherSkillsetIds.BARE__PASSED_PLATE : "res://EnemyRelated/EnemyFactionPassives/Type_Morphers/_Skillsets/Imps/MorphSkillset_Bare_PassedPlate.gd",
	
	
}


