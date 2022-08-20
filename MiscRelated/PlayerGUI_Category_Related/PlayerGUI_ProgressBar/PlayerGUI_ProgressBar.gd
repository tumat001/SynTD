extends MarginContainer


export(float) var progress_ratio : float = 0 setget set_progress_ratio
export(bool) var yield_before_update : bool = false


export(Texture) var bar_background_pic : Texture setget set_bar_background_pic
export(Texture) var fill_foreground_pic : Texture setget set_fill_foreground_pic
export(float) var fill_foreground_margin_top : float
export(float) var fill_foreground_margin_left : float

onready var bar_backround = $BodyBackground
onready var fill_foreground = $MarginContainer/FillForeground
onready var bar_fill_foreground_marginer : MarginContainer = $MarginContainer


#

func set_bar_background_pic(value : Texture):
	bar_background_pic = value
	
	if is_inside_tree():
		bar_backround.texture = value


func set_fill_foreground_pic(value : Texture):
	fill_foreground_pic = value
	
	if is_inside_tree():
		fill_foreground.texture = value

#

func _ready():
	if bar_background_pic != null:
		bar_backround.texture = bar_background_pic
	elif bar_backround.texture != null:
		bar_background_pic = bar_backround.texture
	
	if fill_foreground_pic != null:
		fill_foreground.texture = fill_foreground_pic
	elif fill_foreground.texture != null:
		fill_foreground_pic = fill_foreground.texture
	
	bar_fill_foreground_marginer.add_constant_override("margin_top", fill_foreground_margin_top) 
	bar_fill_foreground_marginer.add_constant_override("margin_left", fill_foreground_margin_left)
	
	set_progress_ratio(progress_ratio)
	
	#connect("visibility_changed", self, "_on_visibility_changed", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	
	connect("resized", self, "_on_resized", [], CONNECT_PERSIST)

#

func set_progress_ratio(arg_ratio : float): # 0 to 1
	progress_ratio = arg_ratio
	
	if is_inside_tree():
		_update_fill_foreground_size()


func _update_fill_foreground_size():
	fill_foreground.rect_size.x = (progress_ratio * bar_fill_foreground_marginer.rect_size.x)

#

func _on_resized():
	_update_fill_foreground_size()


