extends Reference


var border_texture_normal : Texture
var border_texture_highlighted : Texture

var icon : Texture

var descriptions : Array

var choice_name : String

var wr_obj_method_source : WeakRef
var on_chosen_method_name : String

#

func _init(arg_obj_method_source : Object):
	wr_obj_method_source = weakref(arg_obj_method_source)


func choice_selected():
	var obj = wr_obj_method_source.get_ref()
	if obj != null:
		obj.call(on_chosen_method_name)

