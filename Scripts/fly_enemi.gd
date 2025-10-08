extends CharacterBody2D

@export var patrol_distance := 100
@export var patrol_speed := 30
@export var chase_speed := 40
@export var damage_amount := 1

var patrol_point_a: Vector2
var patrol_point_b: Vector2
var target_point: Vector2

var player: Node2D = null
var is_dead := false
var is_chasing := false


func _ready():
	# Define puntos de patrulla a partir de la posición actual
	patrol_point_a = global_position + Vector2(-patrol_distance, 0)
	patrol_point_b = global_position + Vector2(patrol_distance, 0)
	target_point = patrol_point_a

func _physics_process(_delta):
	handel_flip()
	if is_dead:
		return
	if player and is_chasing:
		move_to(player.global_position, chase_speed)
	elif not player:
		patrol()

	move_and_slide()

func patrol():
	if position.distance_to(target_point) < 5:
		target_point = patrol_point_b if target_point == patrol_point_a else patrol_point_a

	move_to(target_point, patrol_speed)

func move_to(target: Vector2, speed: float):
	var direction = (target - global_position).normalized()
	velocity = direction * speed


# -------------------
# ÁREAS DE DETECCIÓN
# -------------------

func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		is_chasing = true

func _on_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$AnimatedSprite2D.play("idle")
		player = null
		is_chasing = false

# -------------------
# ÁREA DE MUERTE
# -------------------

func _on_dead_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and abs(body.velocity.y) > 120 and not is_dead:
		is_dead = true
		$AnimatedSprite2D.play("dead")
		call_deferred("_disable_physics_and_collisions")

func _disable_physics_and_collisions():
	set_physics_process(false)
	$colision.disabled = true
	

# -------------------
# ÁREA DE ATAQUE
# -------------------

func _on_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and body.has_method("take_damage") and !is_dead:
		body.take_damage(damage_amount)

		# Determinar dirección: 1 si jugador está a la derecha, -1 si está a la izquierda
		var direction = sign(body.global_position.x - global_position.x)

		# Empuje hacia atrás y hacia arriba
		var knockback_force = Vector2(60 * direction, -100)

		# Aplicar empuje si el jugador tiene el método
		if body.has_method("apply_knockback"):
			body.apply_knockback(knockback_force)



func handel_flip():
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "dead":
		queue_free()
