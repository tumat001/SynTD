extends Reference


var stageround_id_when_bought : String

var descriptions : Array
var header_left_text : String

var texture_to_use : Texture


func _init(arg_stageround_id_when_bought : String,
		arg_descriptions : Array,
		arg_texture_to_use : Texture):
	
	stageround_id_when_bought = arg_stageround_id_when_bought
	descriptions = arg_descriptions
	texture_to_use = arg_texture_to_use
