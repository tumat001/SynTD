
const AttackSprite = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.gd")

enum TemplateIDs {
	COMMON_UPWARD_DECELERATING_PARTICLE = 1,
	
}

static func configure_properties_of_attk_sprite(attk_sprite : AttackSprite, template_id : int):
	if template_id == TemplateIDs.COMMON_UPWARD_DECELERATING_PARTICLE:
		attk_sprite.has_lifetime = true
		attk_sprite.lifetime = 0.5
		attk_sprite.frames_based_on_lifetime = true
		attk_sprite.y_displacement_per_sec = -40
		attk_sprite.inc_in_y_displacement_per_sec = 70
		attk_sprite.lifetime_to_start_transparency = 0.3
		attk_sprite.transparency_per_sec = 2
