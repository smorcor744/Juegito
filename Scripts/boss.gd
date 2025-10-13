extends Node2D

var damage = 0.0
@export var streng = 5
@export var life = 10000

@onready var numDamage = $DamageNumbers/damage

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("Player"):
		numDamage.text = null
		numDamage.visible = true
		damage = abs(body.velocity.y)
		numDamage.text = damage
		if life > damage:
			body.take_damage(streng)
		take_damage(damage)

func take_damage(_damage):
	life -= _damage
	print(life)
	if life < 1:
		queue_free()


func _on_timer_timeout() -> void:
	numDamage.visible = false
