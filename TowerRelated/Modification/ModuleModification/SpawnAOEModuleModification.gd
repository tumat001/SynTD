extends "res://TowerRelated/Modification/ModuleModification/BaseModuleModification.gd"

const SpawnAOETemplate = preload("res://TowerRelated/Templates/SpawnAOETemplate.gd")
const BulletSpawnAOEModification = preload("res://TowerRelated/Modification/BulletModification/SpawnAOEBulletModification.gd")

var template : SpawnAOETemplate


func _finalize_bullet(bullet : BaseBullet):
	
	if bullet.modifications == null:
		bullet.modifications = []
	var bullet_modification = BulletSpawnAOEModification.new()
	bullet_modification.spawn_aoe_template = template
	bullet_modification.trigger_on_death = template.spawn_aoe_at_death
	
	bullet.modifications.append(bullet_modification)

#

func _after_effect_to_enemy(enemy : AbstractEnemy):
	template._spawn_aoe(enemy.global_position)
