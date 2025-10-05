extends Area2D

signal interactuar

@onready var label: Label = $Label
var puede_interactuar := false

func _ready() -> void:
	label.visible = false

func _on_area_entered(area: Area2D) -> void:
	# Solo mostramos el label si el jugador entra
	if area.is_in_group("Player"): 
		label.visible = true
		puede_interactuar = true

func _on_area_exited(area: Area2D) -> void:
	# Lo ocultamos cuando el jugador se va
	print(area.get_groups())
	if area.is_in_group("Player"):
		label.visible = false
		puede_interactuar = false

func _process(_delta: float) -> void:
	# Si está dentro y presiona E
	if puede_interactuar and Input.is_action_just_pressed("interactuar"):
		emit_signal("interactuar")
