extends "res://TowerRelated/Modules/AbstractAttackModule.gd"

const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")


func _attack_enemy(enemy : AbstractEnemy):
	if enemy != null:
		var damage_instance : DamageInstance = DamageInstance.new()
		damage_instance.on_hit_damages = _get_all_scaled_on_hit_damages()
		damage_instance.on_hit_effects = _get_all_scaled_on_hit_effects()
		
		_modify_attack(enemy)
		enemy.hit_by_damage_instance(damage_instance)

func _attack_enemies(enemies : Array):
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
