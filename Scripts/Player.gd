extends CharacterBody2D

@export var max_lifes = 5
@export var damage = velocity.y
@onready var animations_player = $AnimatedSprite2D

const SPEED = 200.0
const JUMP_VELOCITY = -350.0
var jumping = false
var coyote_frames = 6  # How many in-air frames to allow jumping
var coyote = false  # Track whether we're in coyote time or not
var last_floor = false  # Last frame's on-floor state
var lifes = max_lifes
var invulnerable = false

var knockback_timer := 0.0
var knockback_vector := Vector2.ZERO

var last_checkpoint_position: Vector2

signal life_changed(lifes)
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	var life_node = $UI/Life
	if life_node:
		connect("life_changed", Callable(life_node, "on_player_life_changed"))
		emit_signal("life_changed", lifes)
		
	$CoyoteTimer.wait_time = coyote_frames / 60.0

func _physics_process(delta):
	# Verifica si estás en el suelo antes de procesar física
	var on_floor_now = is_on_floor()

	# Detecta si acabamos de dejar el suelo
	if !on_floor_now and last_floor and !jumping:
		coyote = true
		$CoyoteTimer.start()

	# Si tocamos el suelo, reiniciamos coyote y jumping
	if on_floor_now:
		coyote = false
		jumping = false

	# Añadir gravedad si estás en el aire
	if not on_floor_now:
		velocity.y += gravity * delta

	# Manejo de salto
	if Input.is_action_just_pressed("jump") and (on_floor_now or coyote):
		jumping = true
		animations_player.play("Jump")
		velocity.y = JUMP_VELOCITY
		coyote = false  # Cancelamos coyote al saltar

	# Animaciones de movimiento vertical
	if !on_floor_now and velocity.y < 0:
		animations_player.play("Up")
	elif !on_floor_now and velocity.y > 0:
		animations_player.play("Down")
	elif velocity.x == 0 and velocity.y == 0:
		animations_player.play("Idle")

	# Movimiento horizontal
	var direction = Input.get_axis("left", "right")
	if direction:
		animations_player.play("Run")
		handel_flip()
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("Down"):
		position.y += 3
	
	# Aplica knockback si está activo
	if knockback_timer > 0:
		velocity = knockback_vector
		knockback_timer -= delta

	move_and_slide()


	# Actualizamos last_floor al final, después de todo el procesamiento
	last_floor = on_floor_now



func handel_flip():
	if velocity.x > 0:
		animations_player.flip_h = false
	if velocity.x < 0:
		animations_player.flip_h = true

func take_damage(amount):
	if invulnerable:
		return
	if !invulnerable:
		$DamageTimer.start()
		invulnerable = true
		lifes -= amount
		lifes = clamp(lifes, 0, max_lifes)
		emit_signal("life_changed", lifes)
	if lifes <= 0:
		die()

func die():
	animations_player.play("dead")
	set_physics_process(false)  

func apply_knockback(force: Vector2):
	knockback_vector = force
	knockback_timer = 0.2  # Duración del empuje (en segundos)

func respawn():
	if last_checkpoint_position != Vector2.ZERO:
		global_position = last_checkpoint_position
		lifes = max_lifes
		invulnerable = false
		set_physics_process(true)
		animations_player.play("Idle")
		emit_signal("life_changed", lifes)

	else:
		get_tree().reload_current_scene()  # si no hay checkpoint, reinicia



func _on_coyote_timer_timeout():
	coyote = false


func _on_animation_finished():
	if animations_player.animation == "dead":
		respawn()


func _on_damage_timer_timeout() -> void:
	invulnerable = false


func _on_checkpoint_checkpoint_activated(_position: Vector2) -> void:
	last_checkpoint_position = _position


func _on_heal_heal() -> void:
	lifes = max_lifes
	emit_signal("life_changed", lifes)
