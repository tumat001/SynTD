extends "res://TowerRelated/DamageAndSpawnables/BaseAOE.gd"

#const Reaper_SlashBeam_Pic = preload("res://TowerRelated/Color_Red/Reaper/Reaper_SlashAttk/Reaper_SlashHandleBeam.png")
#const BeamAesthetic = preload("res://MiscRelated/BeamRelated/BeamAesthetic.gd")
#const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

#var original_pos : Vector2
#var beam : BeamAesthetic
#var y_half_size : float
#var dest_pos : Vector2

#var duration

func _ready():
	anim_sprite.frame = 0
#	original_pos = attack_module_source.global_position
#
#	beam = BeamAesthetic_Scene.instance()
#	beam.queue_free_if_time_over = true
#	beam.time_visible = duration
#	beam.z_as_relative = true
#	beam.z_index = -1
#	beam.is_timebound = true
#
#	beam.frames = SpriteFrames.new()
#	beam.frames.add_frame("default", Reaper_SlashBeam_Pic)
#
#	y_half_size = anim_sprite.frames.get_frame("default", 0).get_size().y / 2
#	dest_pos = global_position
#	dest_pos.y -= y_half_size
#
#	beam.global_position = original_pos
#	beam.update_destination_position(dest_pos)

#
#func _process(delta):
#	var change = y_half_size * 2 * delta
#	dest_pos.y += change
#
#	beam.update_destination_position(dest_pos)
#
#
#func _queue_free():
#	if beam != null:
#		beam.queue_free()
