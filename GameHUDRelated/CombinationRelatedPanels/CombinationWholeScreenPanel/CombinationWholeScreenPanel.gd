extends MarginContainer

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")


var original_tier_apply_desc_text : String
var original_selected_tier_desc_text : String
var original_tower_amount_for_combi_desc_text : String
var original_tier_not_apply_desc_text : String

var combination_manager setget set_combination_manager


onready var tower_amount_for_combi_desc_label = $ContentContainer/VBoxContainer/TowerAmountForCombiDescLabel
onready var tier_apply_desc_label = $ContentContainer/VBoxContainer/TierApplyDescLabel
onready var selected_tier_desc_label = $ContentContainer/VBoxContainer/SelectedTierDescLabel
onready var selected_tier_not_apply_desc_label = $ContentContainer/VBoxContainer/SelectedTierDescNotApplyLevel
onready var tier_selection_panel = $ContentContainer/VBoxContainer/TierSelectionPanel
onready var tower_icon_collection_panel_of_applied_effect = $ContentContainer/VBoxContainer/TowerIconCollectionPanelForApplied
onready var tower_icon_collection_panel_of_unapplied_effect = $ContentContainer/VBoxContainer/TowerIconCollectionPanelForNotApplied

onready var combinable_tiers_tooltip_body = $ContentContainer/VBoxContainer/VBoxContainer/CombinableTierTooltipBody

#

func set_combination_manager(arg_manager):
	combination_manager = arg_manager
	
	combination_manager.connect("on_tiers_affected_changed", self, "_on_combination_tiers_affected_changed", [], CONNECT_PERSIST)
	combination_manager.connect("on_combination_amount_needed_changed", self, "_on_combination_amount_needed_changed", [], CONNECT_PERSIST)
	combination_manager.connect("on_combination_effect_added", self, "_on_combination_effect_added", [], CONNECT_PERSIST)
	combination_manager.connect("is_any_tier_combinable_changed", self, "_on_is_any_tier_combinable_changed", [], CONNECT_PERSIST)

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
	
	combinable_tiers_tooltip_body.use_custom_size_flags_for_descs = true
	combinable_tiers_tooltip_body.custom_horizontal_size_flags_for_descs = SIZE_EXPAND_FILL | SIZE_SHRINK_CENTER
	
	_update_all()


func _on_tier_selected(arg_tier):
	_update_displays_based_on_selected_tier()

func _on_is_any_tier_combinable_changed():
	_update_displays_based_on_combinable_tiers()

# UPDATE DISP related

func _update_all():
	_update_amount_for_combi_desc()
	_update_tiers_affected_desc()
	_update_displays_based_on_selected_tier()
	_update_displays_based_on_combinable_tiers()


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


###

func _update_displays_based_on_combinable_tiers():
	var base_string : String = ""
	var base_arr_of_plain_fragments : Array = []
	var has_before : bool
	var counter : int = 0
	
	if combination_manager.last_calculated_is_tier_1_combinable:
		base_string += "|%s|" % counter
		base_arr_of_plain_fragments.append(PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER_TIER_01, "tier 1 towers"))
		has_before = true
		counter += 1
	
	if combination_manager.last_calculated_is_tier_2_combinable:
		if has_before:
			base_string += ", |%s|" % counter
		else:
			base_string += "|%s|" % counter
		base_arr_of_plain_fragments.append(PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER_TIER_02, "tier 2 towers"))
		has_before = true
		counter += 1
	
	if combination_manager.last_calculated_is_tier_3_combinable:
		if has_before:
			base_string += ", |%s|" % counter
		else:
			base_string += "|%s|" % counter
		base_arr_of_plain_fragments.append(PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER_TIER_03, "tier 3 towers"))
		has_before = true
		counter += 1
	
	if combination_manager.last_calculated_is_tier_4_combinable:
		if has_before:
			base_string += ", |%s|" % counter
		else:
			base_string += "|%s|" % counter
		base_arr_of_plain_fragments.append(PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER_TIER_04, "tier 4 towers"))
		has_before = true
		counter += 1
	
	if combination_manager.last_calculated_is_tier_5_combinable:
		if has_before:
			base_string += ", |%s|" % counter
		else:
			base_string += "|%s|" % counter
		base_arr_of_plain_fragments.append(PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER_TIER_05, "tier 5 towers"))
		has_before = true
		counter += 1
	
	if combination_manager.last_calculated_is_tier_6_combinable:
		if has_before:
			base_string += ", |%s|" % counter
		else:
			base_string += "|%s|" % counter
		base_arr_of_plain_fragments.append(PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER_TIER_06, "tier 6 towers"))
		has_before = true
		counter += 1
	
	combinable_tiers_tooltip_body.descriptions = [[base_string, base_arr_of_plain_fragments]]
	combinable_tiers_tooltip_body.update_display()

