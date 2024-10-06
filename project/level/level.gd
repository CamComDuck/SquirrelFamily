extends Node2D

var _max_x := 2350
var _min_x := -1075

@onready var game_end_label: Label = $GameEndLabel
@onready var camera_2d: Camera2D = $Camera2D
@onready var squirrel: Squirrel = $Squirrel
@onready var fish: Sprite2D = $Fish
@onready var pond_dirty: StaticBody2D = $PondDirty
@onready var pond_clean: StaticBody2D = $PondClean
@onready var rock: StaticBody2D = $Rock
@onready var snake: Area2D = $Snake
@onready var screen_scroll_bar: HScrollBar = $ScreenScrollBar
@onready var tree: PackedScene = load("res://tree/tree.tscn")


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
		
	
	# Spawn hiding spot trees
	
	var last_tree : float = _max_x
	
	for i in 10:
		var _spawn : Area2D = tree.instantiate()
		add_child(_spawn)
		var tree_x = randf_range(last_tree - 350, last_tree - 500)
		_spawn.position = Vector2(tree_x, 655)
		last_tree = tree_x

func _physics_process(_delta: float) -> void:
	camera_2d.position.x = clampf(squirrel.position.x, -465, 1750)
	
	screen_scroll_bar.value = camera_2d.position.x
	screen_scroll_bar.position.x = camera_2d.position.x - (screen_scroll_bar.size.x / 2)

func _on_owl_game_lost() -> void:
	game_end_label.position.x = squirrel.position.x - (game_end_label.size.x / 2)
	game_end_label.text = "You lost!"
	game_end_label.show()


func _on_squirrel_game_lost() -> void:
	game_end_label.position.x = squirrel.position.x - (game_end_label.size.x / 2)
	game_end_label.text = "You lost!"
	game_end_label.show()


func _on_squirrel_game_won() -> void:
	game_end_label.position.x = squirrel.position.x - (game_end_label.size.x / 2)
	game_end_label.text = "You Win!"
	game_end_label.show()
