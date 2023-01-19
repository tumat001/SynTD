extends Node2D

#const ColorSplatterTexture_001 = preload("res://MiscRelated/ColorAestheticRelated/Assets/ColorSplatter/ColorSplatter_001.png")


signal fully_invisible_and_done() # if changing this name, change signal name in ColorFillCircleDrawer as well


const color_splatter_textures_arr : Array = []
const color_splatter_count_in_files : int = 10
const color_splatter_half_width_and_height : float = 100.0 / 2

#

var _texture : Texture
var _current_lifetime

var _is_displaying : bool

#

var current_color : Color

var initial_mod_a_val_at_start : float
var initial_mod_a_inc_per_sec_at_start : float
var initial_mod_a_inc_lifetime_to_start : float
var initial_mod_a_inc_lifetime_to_end : float

var mod_a_dec_lifetime_to_start : float
var mod_a_dec_per_sec : float


#

func _init():
	if color_splatter_textures_arr.empty():
		for i in color_splatter_count_in_files:
			color_splatter_textures_arr.append(load("res://MiscRelated/ColorAestheticRelated/Assets/ColorSplatter/ColorSplatter_%03d.png" % (i + 1)))


#

func _ready():
	z_as_relative = false
	z_index = ZIndexStore.ABOVE_ABOVE_MAP_ENVIRONMENT
	
	set_process(false)

#

func randomize_splatter_texture(rng_to_use : RandomNumberGenerator):
	_texture = StoreOfRNG.randomly_select_one_element(color_splatter_textures_arr, rng_to_use)

func start_display():
	modulate.a = initial_mod_a_val_at_start
	_current_lifetime = 0
	
	_is_displaying = true
	update()
	
	set_process(true)

func end_display():
	modulate.a = 0
	_is_displaying = false
	update()
	
	set_process(false)


#

func _process(delta):
	_current_lifetime += delta
	
	if initial_mod_a_inc_lifetime_to_start <= _current_lifetime and initial_mod_a_inc_lifetime_to_end >= _current_lifetime:
		modulate.a += initial_mod_a_inc_per_sec_at_start * delta
	
	if mod_a_dec_lifetime_to_start <= _current_lifetime:
		modulate.a -= mod_a_dec_per_sec * delta
		
		if modulate.a <= 0:
			end_display()
			emit_signal("fully_invisible_and_done")
	
	#print("lifetime: %s, mod_a: %s" % [_current_lifetime, modulate.a])
	
	#update()

func _draw():
	if _is_displaying:
		draw_texture(_texture, Vector2(-color_splatter_half_width_and_height, -color_splatter_half_width_and_height) * (scale / 2), current_color)
	
	#draw_circle(Vector2(0, 0), 50, current_color)


