extends "res://MiscRelated/GUI_Category_Related/BaseTowerSpecificInfoPanel/BaseTowerSpecificInfoPanel.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")


const not_active_modulate : Color = Color(0.3, 0.3, 0.3, 1)
const active_modulate : Color = Color(1, 1, 1, 1)


var orb_tower setget set_orb_tower
var attack_tooltip

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
	if orb_tower != null:
		orb_tower.disconnect("current_level_changed", self, "_orb_current_level_changed")
	
	orb_tower = tower
	
	if orb_tower != null:
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
	if attack_tooltip == null:
		_construct_tower_tooltip(sticky_icon)
		attack_tooltip.descriptions = [
			"Orb throws a cosmic bomb every 2.5 seconds that latches onto the first enemy it hits. The bomb explodes after 2 seconds, or when the enemy dies.",
			"Attack speed increases the rate at which cosmic bomb is thrown.",
			"",
			"The explosion deals 6 elemental damage, and affects up to 3 enemies. The damage scales with Orb's ability potency.",
			"The explosion benefits from base damage and on hit damage bufs. Does not benefit from on hit effects."
		]
		
		get_tree().get_root().add_child(attack_tooltip)
		
		attack_tooltip.header_left_text = "Cosmic Bomb"
		attack_tooltip.header_right_text = "Needs 1.25 ap"
		attack_tooltip.update_display()
		
	else:
		attack_tooltip.queue_free()
		attack_tooltip = null



func _on_StarsIcon_pressed_mouse_event(event):
	if attack_tooltip == null:
		_construct_tower_tooltip(star_icon)
		attack_tooltip.descriptions = [
			"Main attacks on hit causes Orb to follow up the attack with 3 stars.",
			"",
			"Each star deals 1.5 elemental damage. Stars benefit from base damage buffs and on hit damages at 50% efficiency, and scale with ability potency. Does not benefit from on hit effects.",
		]
		
		get_tree().get_root().add_child(attack_tooltip)
		
		attack_tooltip.header_left_text = "Stars"
		attack_tooltip.header_right_text = "Needs 1.50 ap"
		attack_tooltip.update_display()
		
	else:
		attack_tooltip.queue_free()
		attack_tooltip = null



func _on_RayIcon_pressed_mouse_event(event):
	if attack_tooltip == null:
		_construct_tower_tooltip(ray_icon)
		attack_tooltip.descriptions = [
			"Orb channels a constant cosmic ray at its target.",
			"",
			"The ray deals 1.5 elemental damage 6 times per second. Benefits from bonus attack speed. Benefits from base damage buffs at 50% effectiveness. The damage scales with Orb's ability potency. Does not benefit from on hit damages and effects."
		]
		
		get_tree().get_root().add_child(attack_tooltip)
		
		attack_tooltip.header_left_text = "Cosmic Ray"
		attack_tooltip.header_right_text = "Needs 2.00 ap"
		attack_tooltip.update_display()
		
	else:
		attack_tooltip.queue_free()
		attack_tooltip = null

