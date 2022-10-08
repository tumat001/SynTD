extends "res://MiscRelated/AttackSpriteRelated/AttackSprite.gd"

const CommonAttackSpriteTemplater = preload("res://MiscRelated/AttackSpriteRelated/CommonTemplates/CommonAttackSpriteTemplater.gd")


const coin_lifetime : float = 0.65
const coin_fps : int = 20

var frame_count : int

static func create_coin_particle():
	var coin = load("res://MiscRelated/CommonTextures/CommonTexture_GoldCoin/CommonTexture_GoldCoin.tscn").instance()
	CommonAttackSpriteTemplater.configure_properties_of_attk_sprite(coin, CommonAttackSpriteTemplater.TemplateIDs.COMMON_UPWARD_DECELERATING_PARTICLE)
	coin.frames_based_on_lifetime = false
	coin.frames.set_animation_speed("default", coin_fps)
	coin.lifetime = coin_lifetime
	
	return coin

func reset_for_another_use():
	CommonAttackSpriteTemplater.configure_properties_of_attk_sprite(self, CommonAttackSpriteTemplater.TemplateIDs.COMMON_UPWARD_DECELERATING_PARTICLE)
	frames_based_on_lifetime = false
	frames.set_animation_speed("default", coin_fps)
	frame = 0
	visible = true
	modulate.a = 1
	lifetime = coin_lifetime
	
	play("default", false)


#

func _ready():
	frame_count = frames.get_frame_count("default") - 1
	connect("animation_finished", self, "_on_anim_finished")


func _on_anim_finished():
	if frame == frame_count:
		play("default", true)
		frame = frame_count
		flip_h = true
	else:
		play("default", false)
		frame = 0
		flip_h = false


