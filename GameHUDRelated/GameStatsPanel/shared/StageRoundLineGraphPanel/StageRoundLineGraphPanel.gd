extends MarginContainer

const BaseMode_StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/BaseMode_StageRounds.gd")

signal point_on_graph_hovered(key, val, other_data, sprite_node)
signal point_on_graph_unhovered(key, val, other_data, sprite_node)

onready var graph = $Graph

func _ready():
	graph.connect("point_hovered", self, "_on_point_on_graph_hovered", [], CONNECT_PERSIST)
	graph.connect("point_unhovered", self, "_on_point_on_graph_unhovered", [], CONNECT_PERSIST)

func set_stage_rounds_col_label_to_point_val_map(line_label_to_line_color_map : Dictionary, stage_round_data_point_arr : Array, total_data_points_count : int, max_val : int):
	graph.limit_x_count = total_data_points_count - 1
	graph.max_value = max_val
	
	call_deferred("_set_stage_rounds_coll_deferred", line_label_to_line_color_map, stage_round_data_point_arr)

func _set_stage_rounds_coll_deferred(line_label_to_line_color_map : Dictionary, stage_round_data_point_arr : Array):
	graph.initialize(graph.LABELS_TO_SHOW.X_LABEL | graph.LABELS_TO_SHOW.Y_LABEL,
		line_label_to_line_color_map
	)
	
	for data_point in stage_round_data_point_arr:
		var data_point_col_label = data_point.get_col_label()
		
		graph.create_new_point({
			label = data_point_col_label,
			values = data_point.line_label_to_val_maps[line_label_to_line_color_map.keys()[0]]
		},
		[data_point_col_label, data_point.get_tooltip_label()] # other_data. can be anything
		)

#

func _on_point_on_graph_hovered(key, val, other_data, sprite_node):
	emit_signal("point_on_graph_hovered", key, val, other_data, sprite_node)

func _on_point_on_graph_unhovered(key, val, other_data, sprite_node):
	emit_signal("point_on_graph_unhovered", key, val, other_data, sprite_node)



