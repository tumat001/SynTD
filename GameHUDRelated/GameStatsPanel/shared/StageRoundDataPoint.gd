
var stage_num
var round_num

var line_label_to_val_maps : Dictionary #ex, { health : {health : 100}, gold : {gold: 35}]

func get_col_label():
	#return "%s-%s" % [stage_num, round_num]
	return "%s\n%s" % [stage_num, round_num]

func get_tooltip_label():
	return "%s-%s" % [stage_num, round_num]

