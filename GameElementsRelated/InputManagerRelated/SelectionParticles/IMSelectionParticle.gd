extends "res://MiscRelated/AttackSpriteRelated/SizeAdaptingAttackSprite.gd"


# does not take into account the mod a
var modulate_x : Color
var modulate_y : Color


var _current_following_tower

var duration_of_half_full_transition : float = 3.0
var is_loop : bool = false

#####

func _ready():
	z_index = ZIndexStore.PARTICLE_EFFECTS
	z_as_relative = false
	
	has_lifetime = false
	lifetime = 1
	
	#start_loop_tween_between_mod_a_and_b()
	

func start_loop_tween_between_mod_a_and_b():
	modulate = modulate_x
	
	var tweener = create_tween()
	
	if is_loop:
		tweener.set_loops()
	
	tweener.tween_property(self, "modulate:r", modulate_y.r, duration_of_half_full_transition)
	tweener.parallel().tween_property(self, "modulate:g", modulate_y.g, duration_of_half_full_transition)
	tweener.parallel().tween_property(self, "modulate:b", modulate_y.b, duration_of_half_full_transition)
	
	if is_loop:
		tweener.tween_property(self, "modulate:r", modulate_x.r, duration_of_half_full_transition)
		tweener.parallel().tween_property(self, "modulate:g", modulate_x.g, duration_of_half_full_transition)
		tweener.parallel().tween_property(self, "modulate:b", modulate_x.b, duration_of_half_full_transition)
	

##

func set_anim_to__circle():
	var circle_sprite = preload("res://GameElementsRelated/InputManagerRelated/SelectionParticles/Assets/InputManager_CircleSelectionPic.png")
	
	frames = SpriteFrames.new()
	frames.add_frame("default", circle_sprite)
	



func set_pos_to_node(arg_node):
	global_position = arg_node.global_position


func follow_and_config_to_tower(arg_tower):
	if is_instance_valid(_current_following_tower):
		if arg_tower.is_connected("global_position_changed", self, "_on_following_tower_global_pos_changed"):
			arg_tower.disconnect("global_position_changed", self, "_on_following_tower_global_pos_changed")
	
	if is_instance_valid(arg_tower):
		_current_following_tower = arg_tower
		
		set_pos_to_node(arg_tower)
		set_size_adapting_to(arg_tower)
		
		arg_tower.connect("global_position_changed", self, "_on_following_tower_global_pos_changed")


func _on_following_tower_global_pos_changed(arg_old_pos, arg_new_pos):
	global_position = arg_new_pos
	


