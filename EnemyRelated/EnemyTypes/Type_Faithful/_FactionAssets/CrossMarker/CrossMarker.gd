extends "res://MiscRelated/AttackSpriteRelated/AttackSprite.gd"


var enemy_path_associated setget set_enemy_path_associated

var _is_mouse_inside_flag : bool

func set_enemy_path_associated(arg_path):
	enemy_path_associated = arg_path


#

func _on_MouseDetector_mouse_entered():
	if visible:
		enemy_path_associated.show_curve_conditional_clauses.attempt_insert_clause(enemy_path_associated.ShowCurveClauseIds.HOVERED_OVER_CULTIST_CROSS)
		_is_mouse_inside_flag = true
		modulate = Color(1.3, 1.3, 1.3)

func _on_MouseDetector_mouse_exited():
	enemy_path_associated.show_curve_conditional_clauses.remove_clause(enemy_path_associated.ShowCurveClauseIds.HOVERED_OVER_CULTIST_CROSS)
	_is_mouse_inside_flag = false
	modulate = Color(1, 1, 1)


func _on_CrossMarker_tree_exiting():
	if _is_mouse_inside_flag:
		enemy_path_associated.show_curve_conditional_clauses.remove_clause(enemy_path_associated.ShowCurveClauseIds.HOVERED_OVER_CULTIST_CROSS)
		_is_mouse_inside_flag = false
		modulate = Color(1, 1, 1)


func _on_CrossMarker_visibility_changed():
	if !visible:
		enemy_path_associated.show_curve_conditional_clauses.remove_clause(enemy_path_associated.ShowCurveClauseIds.HOVERED_OVER_CULTIST_CROSS)
		_is_mouse_inside_flag = false
		modulate = Color(1, 1, 1)
