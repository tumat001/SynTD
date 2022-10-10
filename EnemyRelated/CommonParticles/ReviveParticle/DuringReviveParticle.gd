extends "res://MiscRelated/AttackSpriteRelated/AttackSprite.gd"

const AfterReviveParticle_Scene = preload("res://EnemyRelated/CommonParticles/ReviveParticle/AfterReviveAssets/AfterReviveParticle.tscn")


onready var revive_orb_sprite = $ReviveOrbSprite

const _initial_orb_y_displacement : float = -10.0
var _rate_of_y_orb_displacement : float


func _ready():
	_rate_of_y_orb_displacement = (_initial_orb_y_displacement - 6)/ lifetime
	revive_orb_sprite.position.y += _initial_orb_y_displacement
	
	connect("tree_exiting", self, "_in_exiting", [], CONNECT_ONESHOT)

func _process(delta):
	revive_orb_sprite.position.y -= _rate_of_y_orb_displacement * delta


func _in_exiting():
	var particle = AfterReviveParticle_Scene.instance()
	particle.position = global_position
	particle.position.y += 3
	
	#get_tree().get_root().call_deferred("add_child", particle)
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(particle)
