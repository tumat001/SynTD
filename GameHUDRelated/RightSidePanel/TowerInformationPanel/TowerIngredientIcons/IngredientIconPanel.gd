extends MarginContainer


onready var additional_border_modi = $AdditionalBorderModi
onready var ingredient_icon = $IngIcon

var tower_base_effect


func update_display():
	if tower_base_effect != null:
		ingredient_icon.texture = tower_base_effect.effect_icon
		
		var texture_rect_borders = additional_border_modi.get_children()
		for texture_rect in texture_rect_borders:
			texture_rect.visible = false
		
		for i in tower_base_effect.border_modi_textures.size():
			var tex_rect : TextureRect
			if i >= texture_rect_borders.size():
				tex_rect = TextureRect.new()
				additional_border_modi.add_child(tex_rect)
			else:
				tex_rect = texture_rect_borders[i]
			
			tex_rect.texture = tower_base_effect.border_modi_textures[i]
			tex_rect.visible = true
	else:
		ingredient_icon.texture = null
		
		for tex_rect in additional_border_modi.get_children():
			#var tex_rect : TextureRect = additional_border_modi.get_children()[i]
			tex_rect.visible = false

