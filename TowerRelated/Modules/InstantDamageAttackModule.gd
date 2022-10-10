extends "res://TowerRelated/Modules/AbstractAttackModule.gd"



func _attack_enemy(enemy : AbstractEnemy):
	if is_instance_valid(enemy):
		var damage_instance : DamageInstance = construct_damage_instance()
		emit_signal("on_damage_instance_constructed", damage_instance, self)
		
		set_up_dmg_instance__hit_enemy_and_emit_signals(enemy, damage_instance)
		#enemy.hit_by_instant_damage(damage_instance, damage_register_id, self)

func set_up_dmg_instance__hit_enemy_and_emit_signals(arg_enemy, arg_dmg_instance):
	arg_enemy.hit_by_instant_damage(arg_dmg_instance, damage_register_id, self)



func _attack_enemies(enemies : Array):
	._attack_enemies(enemies)
	
	for enemy in enemies:
		_attack_enemy(enemy)


# Not applicable for here
func _attack_at_position(pos : Vector2):
	print("Trying to deal damage to position...")

# Not applicable for here
func _attack_at_positions(positions : Array):
	print("Trying to deal damage to position...")


# Disabling and Enabling

func disable_module(disabled_clause_id : int):
	.disable_module(disabled_clause_id)

func enable_module(disabled_clause_id : int):
	.enable_module(disabled_clause_id)
