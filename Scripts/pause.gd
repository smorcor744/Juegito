extends ColorRect

var is_paused = false

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # tecla Esc
		toggle_pause()

func toggle_pause():
	is_paused = !is_paused
	$"../UI/Life".visible = !is_paused
	visible = is_paused
	get_tree().paused = is_paused
	
	if is_paused:
		print("Juego pausado")
	else:
		print("Juego reanudado")

func _on_restart_pressed() -> void:
	toggle_pause()


func _on_mainmenu_pressed() -> void:
	toggle_pause()
	Global.change_scene("res://Scenes/MainMenu.tscn")
