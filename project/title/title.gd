extends Node2D


@onready var tutorial: VBoxContainer = $Tutorial
@onready var color_rect: ColorRect = $ColorRect
@onready var exit_tutorial_button: Button = $ExitTutorialButton

func _ready() -> void:
	get_window().size = Vector2i(948, 533)


func _on_play_button_pressed() -> void:
	AudioManager.play_menu_select()
	get_tree().change_scene_to_file("res://level/level.tscn")


func _on_tutorial_button_pressed() -> void:
	AudioManager.play_menu_select()
	tutorial.show()
	color_rect.show()
	exit_tutorial_button.show()


func _on_exit_tutorial_button_pressed() -> void:
	AudioManager.play_menu_select()
	tutorial.hide()
	color_rect.hide()
	exit_tutorial_button.hide()
