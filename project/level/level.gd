extends Node2D

var _max_x := 2250
var _min_x := -975

@onready var game_lost_label: Label = $GameLostLabel
@onready var camera_2d: Camera2D = $Camera2D
@onready var squirrel: Squirrel = $Squirrel
@onready var fish: Sprite2D = $Fish
@onready var pond_dirty: StaticBody2D = $PondDirty
@onready var pond_clean: StaticBody2D = $PondClean
@onready var rock: StaticBody2D = $Rock
@onready var snake: Area2D = $Snake
@onready var screen_scroll_bar: HScrollBar = $ScreenScrollBar


func _ready() -> void:
	
	# Spawn the dirty pond near the center.
	# Spawn the clean pond at least 1000 units away from dirty pond.
	
	var _pond_dirty_x = randf_range(_min_x + 1001, _max_x - 1001)
	pond_dirty.set_position(Vector2(_pond_dirty_x, 745))
	fish.position = pond_dirty.position
	
	var pond_random_1 = randf_range(_min_x, _pond_dirty_x - 1000)
	var pond_random_2 = randf_range(_pond_dirty_x + 1000, _max_x)
	var pond_random_3 = randi_range(0, 1)
	
	if pond_random_3 == 0:
		pond_clean.set_position(Vector2(pond_random_1, 745))
	else:
		pond_clean.set_position(Vector2(pond_random_2, 745))
		
	# Spawn the snake close to the center. 
	# Spawn the rock at least 1000 units away from the snake.
		
	var snake_x = randf_range(_min_x + 1001, _max_x - 1001)
	snake.position.x = snake_x
	
	var rock_random_1 = randf_range(_min_x, snake_x - 1000)
	var rock_random_2 = randf_range(snake_x + 1000, _max_x)
	var rock_random_3 = randi_range(0, 1)
	
	if rock_random_3 == 0:
		rock.set_position(Vector2(rock_random_1, 661))
	else:
		rock.set_position(Vector2(rock_random_2, 661))


func _physics_process(_delta: float) -> void:
	camera_2d.position.x = clampf(squirrel.position.x, -465, 1750)
	
	screen_scroll_bar.value = camera_2d.position.x
	screen_scroll_bar.position.x = camera_2d.position.x - (screen_scroll_bar.size.x / 2)

func _on_owl_game_lost() -> void:
	game_lost_label.show()


func _on_squirrel_game_lost() -> void:
	game_lost_label.position.x = squirrel.position.x - (game_lost_label.size.x / 2)
	game_lost_label.show()
