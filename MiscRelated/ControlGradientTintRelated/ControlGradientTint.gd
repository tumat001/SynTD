extends TextureRect



func get_rect_gradient_texture__radial(arg_size : Vector2) -> GradientTexture2D:
	var texture = GradientTexture2D.new()
	
	texture.fill = GradientTexture2D.FILL_RADIAL
	texture.fill_from = Vector2(0.5, 0.5)
	texture.fill_to = Vector2(1.2, 1.2)
	
	texture.flags = GradientTexture2D.FLAG_MIPMAPS | GradientTexture2D.FLAG_FILTER
	
	texture.width = arg_size.x
	texture.height = arg_size.y
	
	return texture

func get_rect_gradient_texture__0_to_1__topdown(arg_size : Vector2) -> GradientTexture2D:
	var texture = GradientTexture2D.new()
	
	texture.fill = GradientTexture2D.FILL_LINEAR
	texture.fill_from = Vector2(0, 0)
	texture.fill_to = Vector2(0, 1)
	
	texture.flags = GradientTexture2D.FLAG_MIPMAPS | GradientTexture2D.FLAG_FILTER
	
	texture.width = arg_size.x
	texture.height = arg_size.y
	
	return texture


#######

func construct_gradient_two_color(arg_color_01, arg_color_02):
	var gradient = Gradient.new()
	# we use set_color because default starts with two colors
	gradient.set_color(0, arg_color_01)
	gradient.set_color(1, arg_color_02)
	
	gradient.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_LINEAR
	
	return gradient



