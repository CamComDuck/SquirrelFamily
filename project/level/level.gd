extends Node2D

var _max_x := 2350
var _min_x := -1075
var _spawn

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
	
	var last_tree : float = _max_x
	var item : int
	var picked = []
	
	for i in 12:
		
		item = randi_range(0, 4)
		
		while picked.has(item):
			item = randi_range(0, 4)
			
		var tree_x = clampf(randf_range(last_tree - 200, last_tree - 350), _min_x, _max_x)
		last_tree = tree_x
		
		if item == 0: # Tree
			_spawn = tree.instantiate()
			add_child(_spawn)
			_spawn.position = Vector2(tree_x, 655)
			
		elif item == 1: # Rock
			picked.push_back(1)
			rock.set_position(Vector2(tree_x, 661))
			
		elif item == 2: # Dirty pond
			picked.push_back(2)
			pond_dirty.set_position(Vector2(tree_x, 745))
			fish.position = pond_dirty.position
			
		elif item == 3: # Clean pond
			picked.push_back(3)
			pond_clean.set_position(Vector2(tree_x, 745))
			
		elif item == 4: # Snake
			picked.push_back(4)
			snake.position.x = tree_x
		
		item = 5


func _physics_process(_delta: float) -> void:
	camera_2d.position.x = clampf(squirrel.position.x, -465, 1750)
	
	screen_scroll_bar.value = camera_2d.position.x
	screen_scroll_bar.position.x = camera_2d.position.x - (screen_scroll_bar.size.x / 2)

func _on_squirrel_game_lost() -> void:
	game_end_label.position.x = camera_2d.position.x - (game_end_label.size.x / 2)
	game_end_label.text = "You lost!"
	game_end_label.show()


func _on_squirrel_game_won() -> void:
	game_end_label.position.x = camera_2d.position.x - (game_end_label.size.x / 2)
	game_end_label.text = "You Win!"
	game_end_label.show()
