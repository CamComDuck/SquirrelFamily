class_name Owl
extends RigidBody2D

var _moving_left : bool
var _max_x := 2350
var _min_x := -1075
var _max_y := 100
var _min_y := -100
var _move_speed := 50000
var _is_hunting := false
var _is_diving := false
var _dive_x : float
var _can_move : bool = false

@onready var _hunt_timer_object : Timer = $HuntTimer

func _ready() -> void:
	var starting_x : float = randf_range(_min_x, _max_x)
	position.x = starting_x
	var starting_dir : int = randi_range(0, 1)
	if starting_dir == 0:
		_moving_left = true
	else:
		_moving_left = false
		

func _physics_process(delta: float) -> void:
	if _can_move:
		if not _is_hunting and not _is_diving:
			_movement(delta, 0)
			var hunt_chance : float = randf_range(0, 1500)
			if hunt_chance < 2: # Starts hunt
				_is_hunting = true
				_is_diving = true
				
				var hunt_time : float = randf_range(10, 13)
				_hunt_timer_object.wait_time = hunt_time
				_hunt_timer_object.start()
				_dive_x = randf_range(_min_x, _max_x)
				
		elif _is_hunting and _is_diving:
			_movement(delta, _max_y)
			
		elif _is_hunting and not _is_diving:
			_movement(delta, 0)
			
		elif not _is_hunting and _is_diving:
			_movement(delta, _min_y)


func _movement(delta : float, y_dir : int) -> void:
	if position.x < _max_x and not _moving_left:
		linear_velocity = Vector2(_move_speed * delta, y_dir)
	elif position.x >= _max_x and not _moving_left:
		_moving_left = true
	elif position.x >= _min_x and _moving_left:
		linear_velocity = Vector2(-1 * _move_speed * delta, y_dir)
	elif position.x <= _min_x and _moving_left:
		_moving_left = false


func _on_hunt_timer_timeout() -> void:
	_is_hunting = false
	_is_diving = true


func _on_squirrel_game_lost() -> void:
	_can_move = false
	linear_velocity = Vector2.ZERO


func _on_body_entered(body: Node) -> void:
	if body.name != "WallRight" and body.name != "WallLeft":
		_is_diving = false
	
	if body.name == "Squirrel":
		_can_move = false
		linear_velocity = Vector2.ZERO
	
	elif body.name != "Floor" and body.name != "Ceiling" and body.name != "TileMapLayer":
		_moving_left = not _moving_left


func _on_squirrel_game_won() -> void:
	_can_move = false
	linear_velocity = Vector2.ZERO
