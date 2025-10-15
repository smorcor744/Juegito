extends Node2D

var damage = 0.0
@export var streng = 5
@export var life = 10000

@onready var numDamage :Label

# Called when the node enters the scene tree for the first time.
func _ready():
	numDamage = get_parent().find_child("damage")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("Player"):
		numDamage.text = ""
		damage = abs(body.velocity.y)
		numDamage.text = str(int(damage))

		numDamage.visible = true

		if life > damage:
			body.take_damage(streng)
		take_damage(damage)

func take_damage(_damage):
	life -= _damage
	print(life)
	if life < 1:
		call_deferred("_disable_physics_and_collisions")
		$AnimatedSprite2D.play("dead")

func _disable_physics_and_collisions():
	set_physics_process(false)
	$CollisionShape2D.disabled = true

func _on_timer_timeout() -> void:
	numDamage.visible = false


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "dead":
		Global.change_scene("res://Scenes/control.tscn")
		queue_free()


func _on_enter() -> void:
	Global.change_scene("res://Scenes/final.tscn")
