extends Control

@export var full_heart_texture: Texture
@export var empty_heart_texture: Texture
@export var heart_count := 5
@export var heart_size := Vector2(50, 50)

func _ready():
	for i in heart_count:
		var heart = TextureRect.new()
		heart.texture = full_heart_texture
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		heart.custom_minimum_size = heart_size
		$Hearts.add_child(heart)

func on_player_life_changed(player_lifes):
	for i in $Hearts.get_child_count():
		var heart = $Hearts.get_child(i)
		if i < player_lifes:
			heart.texture = full_heart_texture
		else:
			heart.texture = empty_heart_texture
