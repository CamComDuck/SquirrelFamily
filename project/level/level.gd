extends Node2D

@onready var game_lost_label: Label = $GameLostLabel
@onready var camera_2d: Camera2D = $Camera2D
@onready var squirrel: Squirrel = $Squirrel

func _physics_process(_delta: float) -> void:
	camera_2d.position.x = squirrel.position.x


func _on_owl_game_lost() -> void:
	game_lost_label.show()


func _on_squirrel_game_lost() -> void:
	game_lost_label.position.x = squirrel.position.x - (game_lost_label.position.x / 2)
	game_lost_label.show()
