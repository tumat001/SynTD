extends MarginContainer


var original_tier_apply_desc_text : String
var original_selected_tier_desc_text : String
var original_tower_amount_for_combi_desc_text : String
var original_tier_not_apply_desc_text : String

var combination_manager setget set_combination_manager


onready var tower_amount_for_combi_desc_label = $VBoxContainer/TowerAmountForCombiDescLabel
onready var tier_apply_desc_label = $VBoxContainer/TierApplyDescLabel
onready var selected_tier_desc_label = $VBoxContainer/SelectedTierDescLabel
onready var selected_tier_not_apply_desc_label = $VBoxContainer/SelectedTierDescNotApplyLevel
onready var tier_selection_panel = $VBoxContainer/TierSelectionPanel
onready var tower_icon_collection_panel_of_applied_effect = $VBoxContainer/TowerIconCollectionPanelForApplied
onready var tower_icon_collection_panel_of_unapplied_effect = $VBoxContainer/TowerIconCollectionPanelForNotApplied

#

func set_combination_manager(arg_manager):
	combination_manager = arg_manager
	
	combination_manager.connect("on_tiers_affected_changed", self, "_on_combination_tiers_affected_changed", [], CONNECT_PERSIST)
	combination_manager.connect("on_combination_amount_needed_changed", self, "_on_combination_amount_needed_changed", [], CONNECT_PERSIST)
	combination_manager.connect("on_combination_effect_added", self, "_on_combination_effect_added", [], CONNECT_PERSIST)

func _on_combination_tiers_affected_changed():
	_update_tiers_affected_desc()

func _on_combination_amount_needed_changed(arg_val):
	_update_amount_for_combi_desc()

func _on_combination_effect_added(arg_new_effect_id):
	_update_displays_based_on_selected_tier()

#

func _ready():
	original_tier_apply_desc_text = tier_apply_desc_label.text
	original_selected_tier_desc_text = selected_tier_desc_label.text
	original_tower_amount_for_combi_desc_text = tower_amount_for_combi_desc_label.text
	original_tier_not_apply_desc_text = selected_tier_not_apply_desc_label.text
	
	tier_selection_panel.connect("on_tier_selected", self, "_on_tier_selected", [], CONNECT_PERSIST)
	
	_update_all()


func _on_tier_selected(arg_tier):
	_update_displays_based_on_selected_tier()



# UPDATE DISP related

func _update_all():
	_update_amount_for_combi_desc()
	_update_tiers_affected_desc()
	_update_displays_based_on_selected_tier()


func _update_amount_for_combi_desc():
	var final_desc = original_tower_amount_for_combi_desc_text % combination_manager.last_calculated_combination_amount
	tower_amount_for_combi_desc_label.text = final_desc

func _update_tiers_affected_desc():
	var tier_affected_amount = combination_manager.last_calculated_tier_level_affected_amount
	var is_positive = tier_affected_amount >= 0
	var sign_desc : String
	if is_positive:
		sign_desc = "+"
	else:
		sign_desc = ""
	
	var appended_desc = "%s%s" % [sign_desc, str(tier_affected_amount)]
	
	var final_desc = original_tier_apply_desc_text % [appended_desc]
	tier_apply_desc_label.text = final_desc

func _update_displays_based_on_selected_tier():
	# desc
	var tier = tier_selection_panel.selected_tier
	selected_tier_desc_label.text = original_selected_tier_desc_text % str(tier)
	
	selected_tier_not_apply_desc_label.text = original_tier_not_apply_desc_text % str(tier)
	
	# icons
	
	var applicable_and_not_appli_combi_effects : Array = combination_manager.get_all_combination_effects_applicable_and_not_to_tier(tier)
	var applicable_effects : Array = applicable_and_not_appli_combi_effects[0]
	var not_applicable_effects : Array = applicable_and_not_appli_combi_effects[1]
	
	tower_icon_collection_panel_of_applied_effect.set_combination_effect_array(applicable_effects)
	tower_icon_collection_panel_of_unapplied_effect.set_combination_effect_array(not_applicable_effects)

