extends MarginContainer


onready var damage_label = $MarginContainer/HBoxContainer/MarginContainer/DamageLabel
onready var damage_bar = $MarginContainer/HBoxContainer/DamageBar


func set_damage_values(arg_total_dmg, arg_phy, arg_pure, arg_ele):
	damage_label.text = str(arg_total_dmg)
	
	damage_bar.set_total_damage_val(arg_total_dmg)
	damage_bar.set_physical_damage_val(arg_phy)
	damage_bar.set_pure_damage_val(arg_pure)
	damage_bar.set_elemental_damage_val(arg_ele)


