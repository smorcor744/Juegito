extends Area2D

@export var active_texture: Texture2D
@export var inactive_texture: Texture2D
var active = false

@onready var sprite = $AnimatedSprite2D

signal checkpoint_activated(position: Vector2)

func _ready():
	if active:
		sprite.play("on")
	else:
		sprite.play("off")

func _on_body_entered(body):
	if body.is_in_group("Player") and not active:
		active = true
		sprite.play("trancision")
		emit_signal("checkpoint_activated", global_position)
