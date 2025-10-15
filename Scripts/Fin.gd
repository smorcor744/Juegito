extends Control


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		Global.change_scene("res://Scenes/MainMenu.tscn")
