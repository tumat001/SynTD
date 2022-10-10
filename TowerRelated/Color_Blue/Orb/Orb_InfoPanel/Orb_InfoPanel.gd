extends "res://MiscRelated/GUI_Category_Related/BaseTowerSpecificInfoPanel/BaseTowerSpecificInfoPanel.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")
const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")

const GameSettingsManager = preload("res://GameElementsRelated/GameSettingsManager.gd")

const not_active_modulate : Color = Color(0.3, 0.3, 0.3, 1)
const active_modulate : Color = Color(1, 1, 1, 1)


var orb_tower setget set_orb_tower
var attack_tooltip
var game_settings_manager : GameSettingsManager

onready var sticky_icon = $VBoxContainer/BodyMarginer/MarginContainer/HBoxContainer/StickyIcon
onready var star_icon = $VBoxContainer/BodyMarginer/MarginContainer/HBoxContainer/StarsIcon
onready var ray_icon = $VBoxContainer/BodyMarginer/MarginContainer/HBoxContainer/RayIcon


func _construct_about_tooltip():
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	a_tooltip.descriptions = [
		"Orb gains new attacks on different total ability potencies. Icons glow when they are active.",  
		"Right click on the icons to view their details."
	]
	a_tooltip.header_left_text = "Attacks"
	
	return a_tooltip

static func should_display_self_for(tower):
	return tower.tower_id == Towers.ORB


func set_orb_tower(tower):
	if is_instance_valid(orb_tower):
		orb_tower.disconnect("current_level_changed", self, "_orb_current_level_changed")
	
	orb_tower = tower
	
	if is_instance_valid(orb_tower):
		orb_tower.connect("current_level_changed", self, "_orb_current_level_changed")
		_orb_current_level_changed()


func _orb_current_level_changed():
	if orb_tower.sticky_attack_active:
		sticky_icon.modulate = active_modulate
	else:
		sticky_icon.modulate = not_active_modulate
	
	if orb_tower.sub_attack_active:
		star_icon.modulate = active_modulate
	else:
		star_icon.modulate = not_active_modulate
	
	if orb_tower.beam_attack_active:
		ray_icon.modulate = active_modulate
	else:
		ray_icon.modulate = not_active_modulate


# Buttons related
func _construct_tower_tooltip(button_owner : BaseButton):
	var tooltip = BaseTowerSpecificTooltip_Scene.instance()
	tooltip.tooltip_owner = button_owner
	
	attack_tooltip = tooltip


func _on_StickyIcon_pressed_mouse_event(event):
	if !is_instance_valid(attack_tooltip):
		_construct_tower_tooltip(sticky_icon)
#		attack_tooltip.descriptions = [
#			"Orb throws a cosmic bomb every 2.5 seconds that latches onto the first enemy it hits. The bomb explodes after 2 seconds, or when the enemy dies.",
#			"Attack speed increases the rate at which cosmic bomb is thrown.",
#			"",
#			"The explosion deals 6 elemental damage, and affects up to 3 enemies. The damage scales with Orb's ability potency.",
#			"The explosion benefits from base damage and on hit damage bufs. Does not benefit from on hit effects."
#		]
		
		var interpreter_for_bomb = TextFragmentInterpreter.new()
		interpreter_for_bomb.tower_to_use_for_tower_stat_fragments = orb_tower
		interpreter_for_bomb.display_body = true
		
		var outer_ins_for_bomb = []
		var inner_ins_for_bomb = []
		inner_ins_for_bomb.append(NumericalTextFragment.new(6, false, DamageType.ELEMENTAL))
		inner_ins_for_bomb.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		inner_ins_for_bomb.append(TowerStatTextFragment.new(orb_tower, null, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 1, DamageType.ELEMENTAL))
		inner_ins_for_bomb.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		inner_ins_for_bomb.append(TowerStatTextFragment.new(orb_tower, null, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 1)) # stat basis does not matter here
		
		outer_ins_for_bomb.append(inner_ins_for_bomb)
		
		outer_ins_for_bomb.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		outer_ins_for_bomb.append(TowerStatTextFragment.new(orb_tower, null, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		
		interpreter_for_bomb.array_of_instructions = outer_ins_for_bomb
		
		if game_settings_manager.descriptions_mode == GameSettingsManager.DescriptionsMode.COMPLEX:
			attack_tooltip.descriptions = [
				"Orb throws a cosmic bomb every 2.5 seconds that latches onto the first enemy it hits. The bomb explodes after 2 seconds, or when the enemy dies.",
				"Attack speed increases the rate at which cosmic bomb is thrown.",
				"",
				["The explosion deals |0|, and hits up to 3 enemies. Does not apply on hit effects.", [interpreter_for_bomb]],
			]
		elif game_settings_manager.descriptions_mode == GameSettingsManager.DescriptionsMode.SIMPLE:
			attack_tooltip.descriptions = [
				"Orb throws a cosmic bomb every 2.5 seconds that latches onto the first enemy it hits.",
				"Attack speed increases the rate at which cosmic bomb is thrown.",
				"",
				["The explosion deals |0|, and hits up to 3 enemies.", [interpreter_for_bomb]],
			]
		
		get_tree().get_root().add_child(attack_tooltip)
		
		attack_tooltip.header_left_text = "Cosmic Bomb"
		
		#
		
		var interpreter_for_ap = TextFragmentInterpreter.new()
		interpreter_for_ap.tower_to_use_for_tower_stat_fragments = orb_tower
		interpreter_for_ap.display_body = false
		
		var ins_for_ap = []
		ins_for_ap.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, -1, "ability potency", 0.25, false))
		
		interpreter_for_ap.array_of_instructions = ins_for_ap
		
		
		attack_tooltip.header_right_text = "Needs 1.5 ap"
		attack_tooltip.update_display()
		
	else:
		attack_tooltip.queue_free()
		attack_tooltip = null



func _on_StarsIcon_pressed_mouse_event(event):
	if !is_instance_valid(attack_tooltip):
		_construct_tower_tooltip(star_icon)
#		attack_tooltip.descriptions = [
#			"Main attacks on hit causes Orb to follow up the attack with 3 stars.",
#			"",
#			"Each star deals 1.5 elemental damage. Stars benefit from base damage buffs and on hit damages at 50% efficiency, and scale with ability potency. Does not benefit from on hit effects.",
#		]
		
		
		var interpreter_for_sub_ab = TextFragmentInterpreter.new()
		interpreter_for_sub_ab.tower_to_use_for_tower_stat_fragments = orb_tower
		interpreter_for_sub_ab.display_body = true
		
		var outer_ins_for_sub_ab = []
		var inner_ins_for_bomb = []
		inner_ins_for_bomb.append(NumericalTextFragment.new(1, false, DamageType.ELEMENTAL))
		inner_ins_for_bomb.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		inner_ins_for_bomb.append(TowerStatTextFragment.new(orb_tower, null, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 0.4, DamageType.ELEMENTAL))
		inner_ins_for_bomb.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		inner_ins_for_bomb.append(TowerStatTextFragment.new(orb_tower, null, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 0.4)) # stat basis does not matter here
		
		outer_ins_for_sub_ab.append(inner_ins_for_bomb)
		
		outer_ins_for_sub_ab.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		outer_ins_for_sub_ab.append(TowerStatTextFragment.new(orb_tower, null, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		
		interpreter_for_sub_ab.array_of_instructions = outer_ins_for_sub_ab
		
		
		attack_tooltip.descriptions = [
			"Main attacks on hit causes Orb to follow up the attack with 3 stars.",
			"",
			["Each star deals |0|. Does not apply on hit effects.", [interpreter_for_sub_ab]],
		]
		
		get_tree().get_root().add_child(attack_tooltip)
		
		attack_tooltip.header_left_text = "Stars"
		attack_tooltip.header_right_text = "Needs 2.0 ap"
		attack_tooltip.update_display()
		
	else:
		attack_tooltip.queue_free()
		attack_tooltip = null



func _on_RayIcon_pressed_mouse_event(event):
	if !is_instance_valid(attack_tooltip):
		_construct_tower_tooltip(ray_icon)
#		attack_tooltip.descriptions = [
#			"Orb channels a constant cosmic ray at its target.",
#			"",
#			"The ray deals 1.5 elemental damage 6 times per second. Benefits from bonus attack speed. Benefits from base damage buffs at 50% effectiveness. The damage scales with Orb's ability potency. Does not benefit from on hit damages and effects."
#		]
		
		#
		
		var interpreter_for_sub_ab = TextFragmentInterpreter.new()
		interpreter_for_sub_ab.tower_to_use_for_tower_stat_fragments = orb_tower
		interpreter_for_sub_ab.display_body = true
		
		var outer_ins_for_sub_ab = []
		var inner_ins_for_bomb = []
		inner_ins_for_bomb.append(NumericalTextFragment.new(0.5, false, DamageType.ELEMENTAL))
		inner_ins_for_bomb.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		inner_ins_for_bomb.append(TowerStatTextFragment.new(orb_tower, null, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 0.4, DamageType.ELEMENTAL))
		
		outer_ins_for_sub_ab.append(inner_ins_for_bomb)
		
		outer_ins_for_sub_ab.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		outer_ins_for_sub_ab.append(TowerStatTextFragment.new(orb_tower, null, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		
		interpreter_for_sub_ab.array_of_instructions = outer_ins_for_sub_ab
		
		#
		
#		var interpreter_for_attk_speed = TextFragmentInterpreter.new()
#		interpreter_for_attk_speed.tower_to_use_for_tower_stat_fragments = orb_tower
#		interpreter_for_attk_speed.display_body = true
#		interpreter_for_attk_speed.header_description = "times per second"
#
#		var ins_for_attk_speed = []
#		ins_for_attk_speed.append(OutcomeTextFragment.new(-1, -1))
#		ins_for_attk_speed.append(NumericalTextFragment.new(6, false))
#		ins_for_attk_speed.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
#		ins_for_attk_speed.append(TowerStatTextFragment.new(orb_tower, null, TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, TowerStatTextFragment.STAT_BASIS.BONUS, 1))
#
#		interpreter_for_attk_speed.array_of_instructions = ins_for_attk_speed
#
		
		#
		
		attack_tooltip.descriptions = [
			"Orb channels a constant cosmic ray at its target.",
			"",
			["The ray deals |0| 6 times per second. Benefits from bonus attack speed.", [interpreter_for_sub_ab]]
			#Does not apply on hit effects.
		]
		
		get_tree().get_root().add_child(attack_tooltip)
		
		attack_tooltip.header_left_text = "Cosmic Ray"
		attack_tooltip.header_right_text = "Needs 2.5 ap"
		attack_tooltip.update_display()
		
	else:
		attack_tooltip.queue_free()
		attack_tooltip = null

