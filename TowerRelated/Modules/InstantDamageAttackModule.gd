extends "res://TowerRelated/Modules/AbstractAttackModule.gd"

func _attack_enemy(enemy : AbstractEnemy):
	if enemy != null:
		var damage_instance : DamageInstance = construct_damage_instance()
		emit_signal("on_damage_instance_constructed", damage_instance, self)
		
		enemy.connect("on_hit", self, "on_enemy_hit", [damage_register_id, damage_instance], CONNECT_ONESHOT)
		enemy.connect("on_post_mitigated_damage_taken", self, "on_post_mitigation_damage_dealt", [damage_register_id], CONNECT_ONESHOT)
		
		enemy.hit_by_damage_instance(damage_instance)


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

func disable_module():
	.disable_module()

func enable_module():
	.enable_module()
