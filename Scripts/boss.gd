extends Node2D

var damage = 0.0
@export var streng = 1
@export var life = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("Player"):
		damage = abs(body.velocity.y)
		take_damage(damage)
		body.take_damage(streng)

func take_damage(_damage):
	life -= _damage
	if life < 1:
		queue_free()
