extends Sprite


const Flag_Orange_Pic = preload("res://MiscRelated/MapRelated/EnemySpawnLocIndicator/Assets/EnemySpawnLoc_Flag_Orange.png")
const Flag_Blue_Pic = preload("res://MiscRelated/MapRelated/EnemySpawnLocIndicator/Assets/EnemySpawnLoc_Flag_Blue.png")
const Flag_Red_Pic = preload("res://MiscRelated/MapRelated/EnemySpawnLocIndicator/Assets/EnemySpawnLoc_Flag_Red.png")
const Flag_Pink_Pic__MapEnchant = preload("res://MiscRelated/MapRelated/EnemySpawnLocIndicator/Assets/EnemySpawnLoc_Flag_Pink__MapEnchant.png")


enum FlagTextureIds {
	ORANGE,
	BLUE,
	RED,
	PINK__MAP_ENCHANT,
}


var offset_from_path_start : float
var hide_if_path_is_not_used_for_natural_spawning : bool = true

var enemy_path_associated setget set_enemy_path_associated

var _is_mouse_inside_flag


func set_flag_texture_id(arg_id):
	if arg_id == FlagTextureIds.ORANGE:
		texture = Flag_Orange_Pic
	elif arg_id == FlagTextureIds.BLUE:
		texture = Flag_Blue_Pic
	elif arg_id == FlagTextureIds.RED:
		texture = Flag_Red_Pic
	elif arg_id == FlagTextureIds.PINK__MAP_ENCHANT:
		texture = Flag_Pink_Pic__MapEnchant

#

func set_enemy_path_associated(arg_path):
	enemy_path_associated = arg_path
	


#

func _on_MouseDetector_mouse_entered():
	if visible:
		enemy_path_associated.show_curve_conditional_clauses.attempt_insert_clause(enemy_path_associated.ShowCurveClauseIds.HOVERED_OVER_FLAG)
		_is_mouse_inside_flag = true
		modulate = Color(1.3, 1.3, 1.3)

func _on_MouseDetector_mouse_exited():
	enemy_path_associated.show_curve_conditional_clauses.remove_clause(enemy_path_associated.ShowCurveClauseIds.HOVERED_OVER_FLAG)
	_is_mouse_inside_flag = false
	modulate = Color(1, 1, 1)

func _on_EnemySpawnLocIndicator_Flat_tree_exiting():
	if _is_mouse_inside_flag:
		enemy_path_associated.show_curve_conditional_clauses.remove_clause(enemy_path_associated.ShowCurveClauseIds.HOVERED_OVER_FLAG)
		_is_mouse_inside_flag = false
		modulate = Color(1, 1, 1)

func _on_EnemySpawnLocIndicator_Flat_visibility_changed():
	if !visible:
		enemy_path_associated.show_curve_conditional_clauses.remove_clause(enemy_path_associated.ShowCurveClauseIds.HOVERED_OVER_FLAG)
		_is_mouse_inside_flag = false
		modulate = Color(1, 1, 1)

