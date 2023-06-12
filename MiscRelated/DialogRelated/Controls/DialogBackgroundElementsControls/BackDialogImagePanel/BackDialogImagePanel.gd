extends "res://MiscRelated/DialogRelated/Controls/DialogBackgroundElementsControls/BaseDialogBackgroundElement.gd"



var _last_used_texture_shown_at_display : Texture
var texture_to_use : Texture setget set_texture_to_use


var _mod_a_and_texture_tween : SceneTreeTween

var instant_transition_and_ignore_tween_procedure : bool

#

onready var texture_rect = $TextureRect


func _ready():
	texture_rect.texture = texture_to_use

func set_texture_to_use(arg_texture):
	texture_to_use = arg_texture
	
	if is_inside_tree() and (texture_rect.texture == null or instant_transition_and_ignore_tween_procedure):
		texture_rect.texture = texture_to_use
		

######

func _start_display():
	
	if can_start_display():
		._start_display()
		
		
		if !instant_transition_and_ignore_tween_procedure:
			if _last_used_texture_shown_at_display != null and (_last_used_texture_shown_at_display != texture_to_use):
				_mod_a_and_texture_tween = create_tween()
				
				_mod_a_and_texture_tween.connect("step_finished", self, "_on_mod_a_first_step_finished", [], CONNECT_ONESHOT)
				_mod_a_and_texture_tween.tween_property(self, "modulate:a", 0.8, 0.2)
				_mod_a_and_texture_tween.tween_property(self, "modulate:a", 1.0, 0.2)
		
		_last_used_texture_shown_at_display = texture_to_use


func _on_mod_a_first_step_finished(arg_idx):
	texture_rect.texture = texture_to_use
	
		#_mod_a_and_texture_tween.disconnect("step_finished", self, "_on_mod_a_first_step_finished")

####
