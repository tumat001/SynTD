extends "res://EnemyRelated/EnemyFactionPassives/BaseFactionPassive.gd"

const StoreOfEnemyMorphs = preload("res://EnemyRelated/EnemyFactionPassives/Type_Morphers/_Morphs/StoreOfEnemyMorphs.gd")
const AbstractMorph = preload("res://EnemyRelated/EnemyFactionPassives/Type_Morphers/_Morphs/AbstractMorph.gd")

#const skillset_id_to_morpher_enemy_apply_method_name : Dictionary = {
#	MorpherSkillsetIds.BARE__PASSED_PLATE : "_apply__bare__passed_plate",
#	MorpherSkillsetIds.BARE__PROMOTION : "_apply__bare__promotion",
#	MorpherSkillsetIds.BARE__HORDE : "_apply__bare__horde",
#	MorpherSkillsetIds.BARE__FOOTWORK : "_apply__bare__footwork",
#
#	MorpherSkillsetIds.MENDER__BASE_KIT_SKILLSET : "_apply__mender__base_kit_skillset",
#	MorpherSkillsetIds.MENDER__POLY_TARGET : "_apply__mender__poly_target",
#	MorpherSkillsetIds.MENDER__SACRED_GROUND : "_apply__mender__sacred_ground",
#	MorpherSkillsetIds.MENDER__BATTLE_HEAL : "_apply__mender__battle_heal",
#	MorpherSkillsetIds.MENDER__FALLEN_ANGEL : "_apply__mender__fallen_angel",
#
#	MorpherSkillsetIds.FIGHTER__BASE_KIT_SKILLSET : "_apply__fighter__base_kit_skillset",
#	MorpherSkillsetIds.FIGHTER__GRAND_FIGHTER : "_apply__fighter__grand_fighter",
#	MorpherSkillsetIds.FIGHTER__KNOCK_UP : "_apply__fighter__knock_up",
#	MorpherSkillsetIds.FIGHTER__BLOODLUST : "_apply__fighter__bloodlust",
#	MorpherSkillsetIds.FIGHTER__PERSERVERANCE : "_apply__fighter__perserverance",
#
#	MorpherSkillsetIds.CRIPPLER__BASE_KIT_SKILLSET : "_apply__crippler__base_kit_skillset",
#	MorpherSkillsetIds.CRIPPLER__TOXIC_EXPLOSION : "_apply__crippler__toxic_explosion",
#	MorpherSkillsetIds.CRIPPLER__PERSISTENCE : "_apply__crippler__persistence",
#	MorpherSkillsetIds.CRIPPLER__OBSCURE : "_apply__crippler__obscure",
#	MorpherSkillsetIds.CRIPPLER__TARGETED_IMMUNITY : "_apply__crippler__targeted_immunity",
#
#	MorpherSkillsetIds.SORCERER__BASE_KIT_SKILLSET : "_apply__sorcerer__base_kit_skillset",
#	MorpherSkillsetIds.SORCERER__GRAND_SORCERER : "_apply__sorcerer__grand_sorcerer",
#	MorpherSkillsetIds.SORCERER__CLOAK : "_apply__sorcerer_cloak",
#	MorpherSkillsetIds.SORCERER__PORTAL_MAGE : "_apply__sorcerer__portal_mage",
#	MorpherSkillsetIds.SORCERER__NECROMANCER : "_apply__sorcerer__necromancer",
#
#	MorpherSkillsetIds.SAVAGE__UNSTOPPABLE_MARCH : "_apply__savage__unstoppable_march",
#	MorpherSkillsetIds.SAVAGE__GIANTS : "_apply__savage__giants",
#	MorpherSkillsetIds.SAVAGE__TAUNTING : "_apply__savage__taunting",
#	MorpherSkillsetIds.SAVAGE__SURMOUNT : "_apply__savage__surmount",
#
#}


var morph_id_to_info_singleton_map : Dictionary = {}


var _current_morpher_skill_set_ids_active__for_wildcards_only : Array = []  # ex: base kit skillset of sorcerer (if at least 1 sorcerer morph is selected)
var _current_morpher_skill_set_ids_active : Array = []

#

const rounds_to_offer_morph : Array = [
	"41",
	"51",
	"61",
	"71",
	"81",
	"91",
]

#

var active_morph_id_to_morph_map : Dictionary

#

var game_elements

#############

func _apply_faction_to_game_elements(arg_game_elements):
	if game_elements == null:
		game_elements = arg_game_elements
	
	if morph_id_to_info_singleton_map.size() == 0:
		_initialize_morph_infos_and_singletons()


func _initialize_morph_infos_and_singletons():
	for id in StoreOfEnemyMorphs.morph_id_to_morph_path_name.keys():
		var morph = load(StoreOfEnemyMorphs.morph_id_to_morph_path_name[id]).new()
		morph._configure_with_game_elements_and_fac_passive(game_elements)
		morph_id_to_info_singleton_map[id] = morph
	
	

#

func activate_morph(arg_morph : AbstractMorph):
	if !active_morph_id_to_morph_map.has(arg_morph.id):
		active_morph_id_to_morph_map[arg_morph.id] = arg_morph
		
		arg_morph._apply_morph(game_elements)
	
	



