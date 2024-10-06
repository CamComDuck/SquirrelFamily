extends Node2D


func _on_button_pressed() -> void:
	AudioManager.play_menu_select()
	get_tree().change_scene_to_file("res://level/level.tscn")
