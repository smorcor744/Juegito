extends Area2D

@warning_ignore("unused_signal")
signal unlock_attack
@warning_ignore("unused_signal")
signal enter
@warning_ignore("unused_signal")
signal heal

@export var _signal: String = ""
@onready var label: Label = $Label
var puede_interactuar := false


func _ready() -> void:
	label.visible = false

func _on_body_entered(body: Node2D) -> void:
	# Solo mostramos el label si el jugador entraç
	if body.is_in_group("Player"): 
		label.visible = true
		puede_interactuar = true

func _on_body_exited(body: Node2D) -> void:
	# Lo ocultamos cuando el jugador se va
	if body.is_in_group("Player"):
		label.visible = false
		puede_interactuar = false

func _process(_delta: float) -> void:
	# Si está dentro y presiona E
	if puede_interactuar and Input.is_action_just_pressed("interactuar"):
		emit_signal(_signal)


func _on_enter() -> void:
	Global.change_scene("res://Scenes/final.tscn")
