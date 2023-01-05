extends MarginContainer

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

const Enchant_Altar_Pic_00 = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_Altar/Enchant_Altar_01.png")
const Enchant_Altar_Pic_01 = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_Altar/Enchant_Altar_02.png")
const Enchant_Altar_Pic_02 = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_Altar/Enchant_Altar_03.png")
const Enchant_Altar_Pic_03 = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_Altar/Enchant_Altar_04.png")

const StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/StageRound.gd")

onready var main_tooltip_body = $HBoxContainer/Middle/VBoxContainer/MarginContainer/MainTooltipBody
onready var altar_icon_texture_rect = $HBoxContainer/Middle/VBoxContainer/AltarIcon

onready var vbox_container_of_left_side = $HBoxContainer/Left/VBoxContainer

onready var current_upgrade_label = $HBoxContainer/Left/VBoxContainer/CurrUpgradePanel/VBoxContainer/CurrentUpgradeLabel
onready var current_purple_bolt_count_label = $HBoxContainer/Left/VBoxContainer/CurrPurpleBoltAmountPanel/VBoxContainer/CurrentPurpleBoltAmountLabel
onready var current_purple_bolt_dmg_tooltip_body = $HBoxContainer/Left/VBoxContainer/CurrPurpleBoltDamagePanel/VBoxContainer/CurrentPurpleBoltDamageTooltipBody
onready var current_blue_pillar_stats_tooltip_body = $HBoxContainer/Left/VBoxContainer/CurrBluePillarStatsPanel/VBoxContainer/CurrentBluePillarStatsTooltipBody
onready var current_yellow_pillar_stats_tooltip_body = $HBoxContainer/Left/VBoxContainer/CurrYellowPillarStatsPanel/VBoxContainer/CurrentYellowPillarStatsTooltipBody
onready var current_red_pillar_stats_tooltip_body = $HBoxContainer/Left/VBoxContainer/CurrRedPillarStatsPanel/VBoxContainer/CurrentRedPillarStatsTooltipBody
onready var current_green_pillar_stats_tooltip_body = $HBoxContainer/Left/VBoxContainer/CurrGreenPillarStatsPanel/VBoxContainer/CurrentGreenPillarStatsTooltipBody

onready var next_special_stage_round_panel = $HBoxContainer/Right/VBoxContainer/NextSpecialStageRoundPanel
onready var next_special_stage_round_label = $HBoxContainer/Right/VBoxContainer/NextSpecialStageRoundPanel/VBoxContainer/NextSpecialStageroundLabel

#

var _curr_descriptions_for_main_tooltip_body : Array

#

var map_enchant setget set_map_enchant

#

func set_map_enchant(arg_map):
	map_enchant = arg_map
	
	map_enchant.connect("current_upgrade_phase_changed", self, "_on_current_upgrade_phase_changed", [], CONNECT_PERSIST)
	map_enchant.connect("next_special_round_id_changed", self, "_on_next_special_round_id_changed", [], CONNECT_PERSIST)
	map_enchant.connect("round_count_before_next_special_round_changed", self, "_on_round_count_before_next_special_round_changed", [], CONNECT_PERSIST)

func initialize():
	_update_descriptions_of_main_tooltip_body()
	_update_altar_icon()
	_update_current_upgrade_displays()
	_update_next_special_stage_round_number()

#

func _on_current_upgrade_phase_changed(arg_phase_val):
	_update_descriptions_of_main_tooltip_body()
	_update_altar_icon()
	_update_current_upgrade_displays()

func _on_next_special_round_id_changed(arg_val):
	_update_descriptions_of_main_tooltip_body()
	

#######

func _update_descriptions_of_main_tooltip_body():
	main_tooltip_body.descriptions = _generate_description_for_main_tooltip_body_based_on_states()
	main_tooltip_body.update_display()

func _generate_description_for_main_tooltip_body_based_on_states():
	var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "ability")
	
	if map_enchant.get_upgrade_phase() == 0:
		
		_curr_descriptions_for_main_tooltip_body = [
			["The Altar provides strength via an |0| that damages enemies and buffs towers by activating Pillars.", [plain_fragment__ability]],
			"On certain rounds, the Altar gains the chance to activate or upgrade itself, but only when defended from the enemies going to it.",
			"Protect the Upgrader to gain the Altar's power!",
			"",
			"Pillars serve as the medium for the Altar to enchant your towers with effects. Towers placed on an Activated Pillar's sector gain effects.",
		]
		
	else:
		
		if map_enchant.get_next_special_round_id().length() != 0:
			_curr_descriptions_for_main_tooltip_body = [
				["The Altar provides strength via an |0| that damages enemies and buffs towers by activating Pillars.", [plain_fragment__ability]],
				"On certain rounds, the Altar gains the chance to upgrade itself, but only when defended from the enemies going to it.",
				"",
				"Pillars serve as the medium for the Altar to enchant your towers with effects. Towers placed on an Activated Pillar's sector gain effects.",
			]
			
		else:
			_curr_descriptions_for_main_tooltip_body = [
				["The Altar provides strength via an |0| that damages enemies and buffs towers by activating Pillars.", [plain_fragment__ability]],
				"",
				"Pillars serve as the medium for the Altar to enchant your towers with effects. Towers placed on an Activated Pillar's sector gain effects.",
			]
	
	return _curr_descriptions_for_main_tooltip_body

#

func _update_altar_icon():
	altar_icon_texture_rect.texture = map_enchant.enchant_altar.texture

#

func _update_current_upgrade_displays():
	
	if map_enchant.get_upgrade_phase() > 0:
		vbox_container_of_left_side.modulate.a = 1
		
		current_upgrade_label.text = "%s / %s" % [map_enchant.get_upgrade_phase(), map_enchant.max_upgrade_phase]
		
		current_purple_bolt_count_label.text = str(map_enchant._current_purple_bolt_amount)
		
		current_purple_bolt_dmg_tooltip_body.descriptions = _construct_descs_from_text_fragment_interpreter(map_enchant.last_calculated_enchant_ability_purple_bolt_damage_stat_fragment)
		current_purple_bolt_dmg_tooltip_body.update_display()
		
		current_blue_pillar_stats_tooltip_body.descriptions = _construct_descs_from_text_fragment_interpreter(map_enchant.last_calculated_enchant_ability_blue_stat_fragment)
		current_blue_pillar_stats_tooltip_body.update_display()
		
		current_yellow_pillar_stats_tooltip_body.descriptions = _construct_descs_from_text_fragment_interpreter(map_enchant.last_calculated_enchant_ability_yellow_stat_fragment)
		current_yellow_pillar_stats_tooltip_body.update_display()
		
		current_red_pillar_stats_tooltip_body.descriptions = _construct_descs_from_text_fragment_interpreter(map_enchant.last_calculated_enchant_ability_red_stat_fragment)
		current_red_pillar_stats_tooltip_body.update_display()
		
		current_green_pillar_stats_tooltip_body.descriptions = _construct_descs_from_text_fragment_interpreter(map_enchant.last_calculated_enchant_ability_green_stat_fragment)
		current_green_pillar_stats_tooltip_body.update_display()
		
	else:
		vbox_container_of_left_side.modulate.a = 0

func _construct_descs_from_text_fragment_interpreter(arg_interpreter):
	return [
		["|0|", [arg_interpreter]]
	]


#

func _on_round_count_before_next_special_round_changed(arg_round_count, arg_next_special_round):
	_update_next_special_stage_round_number()

func _update_next_special_stage_round_number():
	if map_enchant._next_special_round_id.length() > 0:
		var text = "%s-%s" % StageRound.convert_stageround_id_to_stage_and_round_num(map_enchant._next_special_round_id)
		
		var round_count_from_next_special = map_enchant._rounds_before_next_special_round_id
		if round_count_from_next_special == 0:
			text += " (this round)"
		elif round_count_from_next_special == 1:
			text += " (%s round from now)" % round_count_from_next_special
		elif round_count_from_next_special > 1:
			text += " (%s rounds from now)" % round_count_from_next_special
		else:
			text = "-- none --"  # not +=, since we are replacing
		
		next_special_stage_round_label.text = text
		next_special_stage_round_panel.visible = true
		
	else:
		next_special_stage_round_panel.visible = false
	


