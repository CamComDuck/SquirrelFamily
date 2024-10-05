extends Node2D

var _max_x := 2250
var _min_x := -975

@onready var game_lost_label: Label = $GameLostLabel
@onready var camera_2d: Camera2D = $Camera2D
@onready var squirrel: Squirrel = $Squirrel
@onready var fish: Sprite2D = $Fish
@onready var pond_dirty: StaticBody2D = $PondDirty
@onready var pond_clean: StaticBody2D = $PondClean



func _ready() -> void:
	var _pond_dirty_x = randf_range(_min_x + 1001, _max_x - 1001)
	pond_dirty.set_position(Vector2(_pond_dirty_x, 745))
	fish.position = pond_dirty.position
	
	var random_1 = randf_range(_min_x, _pond_dirty_x - 1000)
	var random_2 = randf_range(_pond_dirty_x + 1000, _max_x)
	var random_3 = randi_range(0, 1)
	
	if random_3 == 0:
		pond_clean.set_position(Vector2(random_1, 745))
	else:
		pond_clean.set_position(Vector2(random_2, 745))


func _physics_process(_delta: float) -> void:
	camera_2d.position.x = clampf(squirrel.position.x, -465, 1750)


func _on_owl_game_lost() -> void:
	game_lost_label.show()


func _on_squirrel_game_lost() -> void:
	game_lost_label.position.x = squirrel.position.x - (game_lost_label.position.x / 2)
	game_lost_label.show()
