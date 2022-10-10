extends "res://GameHUDRelated/Tooltips/BaseTooltip.gd"

const GoldManager = preload("res://GameElementsRelated/GoldManager.gd")

onready var income_name_descs = $VBoxContainer/BodyContainer/ContentMarginer/VBoxContainer/HBoxContainer/IncomeNameDescs
onready var income_values_descs = $VBoxContainer/BodyContainer/ContentMarginer/VBoxContainer/HBoxContainer/IncomeValuesDescs

onready var total_income_name_descs = $VBoxContainer/BodyContainer/ContentMarginer/VBoxContainer/HBoxContainer2/TotalIncomeNameDescs
onready var total_income_value_descs = $VBoxContainer/BodyContainer/ContentMarginer/VBoxContainer/HBoxContainer2/TotalIncomeValueDescs

var gold_manager : GoldManager setget set_gold_manager


# setter

func set_gold_manager(arg_manager):
	gold_manager = arg_manager
	
	gold_manager.connect("gold_income_changed", self, "update_display", [], CONNECT_PERSIST)
	
	if is_instance_valid(income_name_descs):
		update_display()


#

func _ready():
	update_display()


func update_display():
	income_name_descs.clear_descriptions_in_array()
	income_values_descs.clear_descriptions_in_array()
	total_income_name_descs.clear_descriptions_in_array()
	total_income_value_descs.clear_descriptions_in_array()
	
	income_name_descs.descriptions.clear()
	income_values_descs.descriptions.clear()
	total_income_name_descs.descriptions.clear()
	total_income_value_descs.descriptions.clear()
	
	var total_income : int = 0
	for income_id in gold_manager._gold_income_id_amount_map.keys():
		total_income += _append_name_and_value_to_income_descs(gold_manager.get_display_name_of_income_id(income_id), gold_manager._gold_income_id_amount_map[income_id], income_id)
	
	total_income_name_descs.descriptions.append("Total")
	total_income_value_descs.descriptions.append(str(total_income))
	
	income_name_descs.update_display()
	income_values_descs.update_display()
	total_income_name_descs.update_display()
	total_income_value_descs.update_display()


func _append_name_and_value_to_income_descs(income_name : String, income_amount : int, income_id : int) -> int:
	var gold_amount : int = 0
	
	if income_id == GoldManager.GoldIncomeIds.WIN_STREAK:
		#income_name_descs.descriptions.append(income_name + " (if won)")
		income_name_descs.descriptions.append(income_name)
		gold_amount = gold_manager.get_gold_amount_from_next_win_streak()
		income_values_descs.descriptions.append(str(gold_amount))
	elif income_id == GoldManager.GoldIncomeIds.LOSE_STREAK:
		#income_name_descs.descriptions.append(income_name + " (if lost)")
		income_name_descs.descriptions.append(income_name)
		gold_amount = gold_manager.get_gold_amount_from_next_lose_streak()
		income_values_descs.descriptions.append(str(gold_amount))
	else:
		income_name_descs.descriptions.append(income_name)
		gold_amount = income_amount
		income_values_descs.descriptions.append(str(income_amount))
	
	return gold_amount


