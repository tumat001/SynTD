extends Node

const AbstractTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/AbstractTextFragment.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")


enum STAT_OPERATION {
	ADDITION = 1,
	MULTIPLICATION = 2,
}

#


const operation_to_text_map : Dictionary = {
	STAT_OPERATION.ADDITION : "+",
	STAT_OPERATION.MULTIPLICATION : "x"
}

#

var array_of_instructions : Array
var display_body : bool
var header_description : String = ""

var tower_to_use_for_tower_stat_fragments
var tower_info_to_use_for_tower_stat_fragments

var use_color_for_dark_background : bool

#

func interpret_array_of_instructions_to_final_text():
	return interpret_arr_to_final_text(array_of_instructions, header_description, display_body, tower_to_use_for_tower_stat_fragments, use_color_for_dark_background)


#

# the array contains: AbstractTextFragment (ATF), STAT_OPERATION (SO), ATF, SO, ... , ATF
# returns a string with BBCode encoding
#
# Ex: 50 [icon] physical damage (200% [icon] total base damage [phy dmg icon] * 1 [icon] total ability potency)
# [TowerStatTextFragment(x, x, base dmg, total, 2, DamageType.PHYSICAL), STAT_OPERATION_MULTIPLY, TowerStatTextFragment(x, x, ability potency, total)]
#
# -----
# Ex: 75 [mixed dmg icon] mixed damage ((5 [phy dmg icon] + 150% [icon] bonus base damage [phy dmg icon] + 100% [icon] on hit damages [ele dmg icon]) * (2 * [icon] total ability potency))
# [[NumericalTextFragment(5, false, DamageType.PHY), STAT_OPERATION.ADDITION, TowerStatTextFragment(x, x, base dmg, bonus, 1.5, DamageType.ELEMENTAL), STAT_OPERATION.ADDITION, TowerStatTextFragment(x, x, on_hit_dmg, total)], STAT_OPERATION_MULTIPLY, TowerStatTextFragment(x, x, ability potency, total, 2)]
#
# -----
# Ex: 50% of max health [icon] elemental damage (25% [ele dmg icon] * [icon] total ability potency)
# [NumericalTextFragment(25, true, DamageType.PHY), STAT_OPERATION.MULTIPLICATION, TowerStatTextFragment(x, x, ability potency, total)]
# "of max health" comes from header_desc argument
#
static func interpret_arr_to_final_text(arg_arr : Array, arg_header_desc : String = "", arg_display_body : bool = true, arg_tower_to_use_for_tower_stat_fragments = null, arg_use_color_for_dark_background = false) -> String:
	var portions = _interpret_arr_to_portions(arg_arr, arg_header_desc, arg_tower_to_use_for_tower_stat_fragments, arg_use_color_for_dark_background)
	
	if arg_display_body:
		return "%s (%s)" % [portions[1], portions[2]]
	else:
		return "%s" % [portions[1]]
	


# returns an array with [(num_val in header), (header), (body)]
static func _interpret_arr_to_portions(arg_arr : Array, arg_header_desc : String = "", arg_tower_to_use_for_tower_stat_fragments = null, arg_use_color_for_dark_background : bool = false) -> Array:
	var base_string = ""
	var num_val : float = 0.0
	var is_percent : int = -1 # -1 = unset, 1 = yes, 0 = no
	var previous_operation : int = -1
	
	var curr_damage_type : int = -1
	
	for item in arg_arr:
		if item is AbstractTextFragment:
			if arg_use_color_for_dark_background:
				item.color_mode = AbstractTextFragment.ColorMode.FOR_DARK_BACKGROUND
			else:
				item.color_mode = AbstractTextFragment.ColorMode.FOR_LIGHT_BACKGROUND
			
			base_string += " %s" % _interpret_AFT_to_text(item)
			
			if item is TowerStatTextFragment:
				if arg_tower_to_use_for_tower_stat_fragments != null:
					item._tower = arg_tower_to_use_for_tower_stat_fragments
					item.update_damage_type_based_on_args()
			
			if item is NumericalTextFragment or item is TowerStatTextFragment:
				if is_percent == -1:
					if item._is_percent == true:
						is_percent = 1
					else:
						is_percent = 0
			
			
			if item.has_numerical_value:
				if previous_operation == -1 or previous_operation == STAT_OPERATION.ADDITION:
					num_val += _interpret_AFT_to_num(item)
				elif previous_operation == STAT_OPERATION.MULTIPLICATION:
					num_val *= _interpret_AFT_to_num(item)
			
			if item is NumericalTextFragment or item is TowerStatTextFragment:
				if curr_damage_type == -1:
					curr_damage_type = item._damage_type
				else:
					if curr_damage_type != item._damage_type and item._get_as_numerical_value() != 0:
						curr_damage_type = DamageType.MIXED
			
		elif typeof(item) == TYPE_STRING: # just a string
			base_string += " %s" % item
			
		elif typeof(item) == TYPE_ARRAY:
			var portions = _interpret_arr_to_portions(item)
			
			base_string += "(%s)" % portions[2]
			
			if previous_operation == -1 or previous_operation == STAT_OPERATION.ADDITION:
				num_val += portions[0]
			elif previous_operation == STAT_OPERATION.MULTIPLICATION:
				num_val *= portions[0]
			
		elif typeof(item) == TYPE_INT: # Stat operation
			base_string += " %s " % operation_to_text_map[item]
			previous_operation = item
	
	#
	
	var num_text_frag_as_header = NumericalTextFragment.new(num_val, is_percent, curr_damage_type, arg_header_desc, true)
	num_text_frag_as_header.color_mode = arg_use_color_for_dark_background
	
	return [num_val, _interpret_AFT_to_text(num_text_frag_as_header), base_string]



#

static func _interpret_AFT_to_text(arg_aft : AbstractTextFragment) -> String:
	return arg_aft._get_as_text()

static func _interpret_AFT_to_num(arg_aft : AbstractTextFragment) -> float:
	return arg_aft._get_as_numerical_value()



#
