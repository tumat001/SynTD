extends "res://TowerRelated/DamageAndSpawnables/ArcingBaseBullet.gd"

const BaseAOE = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.gd")

signal on_arm_time_timeout(me)
signal on_sensor_tripped(me)


var arm_timer : Timer
var sensor_aoe : BaseAOE


func arm_self_for_time(delta : float):
	arm_timer = Timer.new()
	arm_timer.one_shot = true
	add_child(arm_timer)
	
	arm_timer.connect("timeout", self, "_on_arm_timer_timeout", [], CONNECT_ONESHOT)
	arm_timer.start(delta)

func _on_arm_timer_timeout():
	emit_signal("on_arm_time_timeout", self)


#

func associate_sensor_trigger_with_aoe(aoe : BaseAOE):
	sensor_aoe = aoe
	
	aoe.connect("before_enemy_hit_aoe", self, "_before_enemy_hit_sensor_aoe", [], CONNECT_ONESHOT)
	get_tree().get_root().add_child(aoe)


func _before_enemy_hit_sensor_aoe(enemy):
	emit_signal("on_sensor_tripped", self)


#

func queue_free():
	if is_instance_valid(sensor_aoe):
		sensor_aoe.queue_free()
	
	.queue_free()

