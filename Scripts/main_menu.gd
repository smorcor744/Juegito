extends Control


func _on_button_pressed() -> void:
	Global.change_scene("res://Scenes/mapa.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
