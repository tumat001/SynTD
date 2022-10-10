extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")


enum Stat {
	BASE,
	FINAL,
}

var tower : AbstractTower
var showing_stat : int = Stat.FINAL

onready var base_stat_button : TextureButton = $VBoxContainer/HBoxContainer/BaseContainer/BaseStatButton
onready var total_stat_button : TextureButton = $VBoxContainer/HBoxContainer/TotalContainer/TotalStatButton
onready var base_damage_label : Label = $VBoxContainer/BodyMarginer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/BaseDamagePanel/BaseDamageLabel
onready var attack_speed_label : Label = $VBoxContainer/BodyMarginer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/AttackSpeedPanel/AttackSpeedLabel
onready var range_label : Label = $VBoxContainer/BodyMarginer/VBoxContainer/HBoxContainer/MarginContainer2/VBoxContainer2/RangePanel/RangeLabel
onready var on_hit_multiplier_label : Label = $VBoxContainer/BodyMarginer/VBoxContainer/HBoxContainer/MarginContainer2/VBoxContainer2/OnHitMultiplierPanel/OnHitMultiplierLabel
onready var damage_type_label : Label = $VBoxContainer/BodyMarginer/VBoxContainer/MarginContainer/DamageTypePanel/DamageTypeLabel
onready var ability_potency_label : Label = $VBoxContainer/BodyMarginer/VBoxContainer/HBoxContainer/MarginContainer2/VBoxContainer2/AbilityPotencyPanel/AbilityPotencyLabel
onready var on_hit_flat_label = $VBoxContainer/BodyMarginer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/OnHitFlatPanel/OnHitFlatLabel


const color_equal_stat = Color(1, 1, 1, 1)
const color_higher_stat = Color("#fffdc008")
const color_lower_stat = Color("#ffe21A00")

const button_active_pic = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/TowerStatsPanel/Stats_ButtonActivated.png")
const button_inactive_pic = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/TowerStatsPanel/Stats_ButtonInactivated.png")

func update_display():
	if !is_instance_valid(tower) or !is_instance_valid(tower.main_attack_module):
		base_damage_label.text = ""
		attack_speed_label.text = ""
		range_label.text = ""
		on_hit_multiplier_label.text = ""
		damage_type_label.text = ""
		ability_potency_label.text = ""
		on_hit_flat_label.text = ""
		
		return
	
	if showing_stat == Stat.BASE:
		_update_base_stat_display()
	elif showing_stat == Stat.FINAL:
		_update_final_stat_display()
	


# Base

func _update_base_stat_display():
	base_stat_button.texture_normal = button_active_pic
	total_stat_button.texture_normal = button_inactive_pic
	
	base_damage_label.text = str(tower.main_attack_module.base_damage)
	attack_speed_label.text = str(tower.main_attack_module.base_attack_speed)
	range_label.text = str(tower.main_attack_module.range_module.base_range_radius)
	on_hit_multiplier_label.text = "x" + str(tower.main_attack_module.on_hit_damage_scale)
	damage_type_label.text = DamageType.get_name_of_damage_type(tower.main_attack_module.base_damage_type)
	ability_potency_label.text = str(tower.base_ability_potency)
	on_hit_flat_label.text = str(0)
	
	base_damage_label.set("custom_colors/font_color", color_equal_stat)
	attack_speed_label.set("custom_colors/font_color", color_equal_stat)
	range_label.set("custom_colors/font_color", color_equal_stat)
	ability_potency_label.set("custom_colors/font_color", color_equal_stat)
	on_hit_flat_label.set("custom_colors/font_color", color_equal_stat)


# Total

func _update_final_stat_display():
	base_stat_button.texture_normal = button_inactive_pic
	total_stat_button.texture_normal = button_active_pic
	
	# Base Damage
	update_final_base_damage()
	
	# Attk Speed
	update_final_attack_speed()
	
	# Range
	update_final_range()
	
	# On Hit mul
	on_hit_multiplier_label.text = "x" + str(tower.main_attack_module.on_hit_damage_scale)
	
	# Dmg Type
	damage_type_label.text = DamageType.get_name_of_damage_type(tower.main_attack_module.base_damage_type)
	
	# Ability potency
	update_ability_potency()
	
	# On hit dmg
	update_on_hit_flat_dmges()
	


func update_final_base_damage():
	if showing_stat == Stat.FINAL:
		if is_instance_valid(tower) and is_instance_valid(tower.main_attack_module):
			var base_damage = tower.main_attack_module.base_damage
			var final_base_damage = base_damage
			
			final_base_damage = tower.main_attack_module.last_calculated_final_damage
			
			base_damage_label.text = str(final_base_damage)
			base_damage_label.set("custom_colors/font_color", _get_color_for_stat(base_damage, final_base_damage))


func update_final_attack_speed():
	if showing_stat == Stat.FINAL:
		if is_instance_valid(tower) and is_instance_valid(tower.main_attack_module):
			var attk_speed = tower.main_attack_module.base_attack_speed
			var final_attk_speed = attk_speed
			
			final_attk_speed = tower.main_attack_module.last_calculated_final_attk_speed
			
			attack_speed_label.text = str(final_attk_speed)
			attack_speed_label.set("custom_colors/font_color", _get_color_for_stat(attk_speed, final_attk_speed))


func update_final_range():
	if showing_stat == Stat.FINAL:
		if is_instance_valid(tower) and is_instance_valid(tower.main_attack_module) and is_instance_valid(tower.main_attack_module.range_module):
			var base_range = tower.main_attack_module.range_module.base_range_radius
			var final_range = base_range
			
			final_range = tower.range_module.last_calculated_final_range
			
			range_label.text = str(final_range)
			range_label.set("custom_colors/font_color", _get_color_for_stat(base_range, final_range))


func update_ability_potency():
	if showing_stat == Stat.FINAL:
		if is_instance_valid(tower):
			var base_ap = tower.base_ability_potency
			var final_ap = tower.last_calculated_final_ability_potency
			
			ability_potency_label.text = str(final_ap)
			ability_potency_label.set("custom_colors/font_color", _get_color_for_stat(base_ap, final_ap))


func update_on_hit_flat_dmges():
	if showing_stat == Stat.FINAL:
		if is_instance_valid(tower):
			var base_on_hit_dmg = 0
			var final_dmg = tower.get_last_calculated_total_flat_on_hit_damages()
			
			on_hit_flat_label.text = str(final_dmg)
			on_hit_flat_label.set("custom_colors/font_color", _get_color_for_stat(base_on_hit_dmg, final_dmg))



func _get_color_for_stat(base : float, total : float) -> Color:
	if base == total:
		return color_equal_stat
	elif base > total:
		return color_lower_stat
	else:
		return color_higher_stat


# Button presses

func _on_BaseStatButton_pressed():
	showing_stat = Stat.BASE
	update_display()


func _on_TotalStatButton_pressed():
	showing_stat = Stat.FINAL
	update_display()

