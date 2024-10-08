extends Node2D

var _max_x := 2350
var _min_x := -1075
var _spawn

@onready var game_end_box: VBoxContainer = $GameEndBox
@onready var game_end_label: Label = $GameEndBox/GameEndLabel
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
	var picked := []
	
	var snake_rock_first := -1
	var pond_first := -1
	var total_spawns := 15
	
	for i in total_spawns:
		
		if picked.size() < 4 and i > total_spawns - 4:
			item = randi_range(1, 4)
			while picked.has(item):
				item = randi_range(1, 4)
		elif picked.size() < 4:
			item = randi_range(0, 4)
			while picked.has(item) or ((item == 1 or item == 4) and (snake_rock_first != -1 and (snake_rock_first + 6 > i))) or ((item == 2 or item == 3) and (pond_first != -1 and (pond_first + 6 > i))):
				item = randi_range(0, 4)
		else:
			item = 0
			
		var tree_x = clampf(randf_range(last_tree - 200, last_tree - 350), _min_x, _max_x)
		last_tree = tree_x
		
		if tree_x != _min_x:
			if item == 0: # Tree
				_spawn = tree.instantiate()
				add_child(_spawn)
				_spawn.position = Vector2(tree_x, 400)
				
			elif item == 1: # Rock
				picked.push_back(1)
				rock.set_position(Vector2(tree_x, 461))
				if snake_rock_first == -1:
					snake_rock_first = i
				else:
					snake_rock_first = -1
				
			elif item == 2: # Dirty pond
				picked.push_back(2)
				pond_dirty.set_position(Vector2(tree_x, 551))
				fish.position = Vector2(pond_dirty.position.x, pond_dirty.position.y - 20.615)
				if pond_first == -1:
					pond_first = i
				else:
					pond_first = -1
				
			elif item == 3: # Clean pond
				picked.push_back(3)
				pond_clean.set_position(Vector2(tree_x, 551))
				if pond_first == -1:
					pond_first = i
				else:
					pond_first = -1
				
			elif item == 4: # Snake
				picked.push_back(4)
				snake.position.x = tree_x
				if snake_rock_first == -1:
					snake_rock_first = i
				else:
					snake_rock_first = -1
			
			item = 5


func _physics_process(_delta: float) -> void:
	camera_2d.position.x = clampf(squirrel.position.x, -455, 1750)
	
	screen_scroll_bar.value = camera_2d.position.x
	screen_scroll_bar.position.x = camera_2d.position.x - (screen_scroll_bar.size.x / 2)

func _on_squirrel_game_lost() -> void:
	game_end_box.position.x = camera_2d.position.x - (game_end_box.size.x / 2)
	game_end_box.position.y = camera_2d.position.y - (game_end_box.size.y / 2)
	game_end_label.text = "You lost!"
	game_end_box.show()


func _on_squirrel_game_won() -> void:
	game_end_box.position.x = camera_2d.position.x - (game_end_box.size.x / 2)
	game_end_box.position.y = camera_2d.position.y - (game_end_box.size.y / 2)
	game_end_label.text = "You Win!"
	game_end_box.show()


func _on_restart_button_pressed() -> void:
	AudioManager.play_menu_select()
	get_tree().reload_current_scene()


func _on_main_menu_button_pressed() -> void:
	AudioManager.play_menu_select()
	get_tree().change_scene_to_file("res://title/title.tscn")
