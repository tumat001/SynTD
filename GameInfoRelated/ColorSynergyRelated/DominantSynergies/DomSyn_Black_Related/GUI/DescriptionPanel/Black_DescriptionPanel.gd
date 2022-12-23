extends MarginContainer


onready var tooltip_body = $HBoxContainer/VBoxContainer/ContentMargin/VBoxContainer/TooltipBody
onready var path_label = $HBoxContainer/VBoxContainer/ContentMargin/VBoxContainer/PathName

var dom_syn_black setget set_dom_syn_black

func set_dom_syn_black(arg_syn):
	dom_syn_black = arg_syn


func display_description_and_name_of_path(arg_black_path, arg_tier : int = dom_syn_black.curr_tier):
	var is_tier_met : bool = true
	if arg_tier > dom_syn_black.SYN_TIER_PATH_BASIC_LEVEL:
		arg_tier = dom_syn_black.SYN_TIER_PATH_BASIC_LEVEL
		is_tier_met = false
	
	if arg_black_path != null:
		tooltip_body.descriptions = arg_black_path.black_path_tier_to_descriptions_map[arg_tier].duplicate(true)
		
		if !is_tier_met:
			tooltip_body.descriptions.append("")
			tooltip_body.descriptions.append("Effects are not active due to unmet tier requirement.")
		
		tooltip_body.update_display()
		
		path_label.text = arg_black_path.black_path_name
	else:
		tooltip_body.descriptions = []
		tooltip_body.update_display()
		
		path_label.text = ""
