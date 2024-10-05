extends Node2D

@onready var game_lost_label: Label = $GameLostLabel

func _on_squirrel_game_lost() -> void:
	game_lost_label.show()
