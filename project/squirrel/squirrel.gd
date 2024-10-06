class_name Squirrel
extends CharacterBody2D

signal game_lost
signal game_won
signal rabbit_picked_up
signal rabbit_placed_in_tree

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var _can_move := true
var _is_hiding := false

var _fish_in_clean_pond := false
var _snake_on_rock := false
var _rabbit_in_tree = false
var _object_in_hand : String = "NONE"

var _facing_left : bool

@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D
@onready var fish: Sprite2D = $"../Fish"
@onready var pond_clean: StaticBody2D = $"../PondClean"
@onready var pond_dirty: StaticBody2D = $"../PondDirty"
@onready var rock: StaticBody2D = $"../Rock"
@onready var snake: Area2D = $"../Snake"
@onready var bite_progress_bar: ProgressBar = $"../Snake/BiteProgressBar"
@onready var bite_timer: Timer = $"../Snake/BiteTimer"
@onready var rabbit: Rabbit = $"../Rabbit"

func _physics_process(delta: float) -> void:
	if _can_move:
		if not is_on_floor() and not _is_hiding:
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			AudioManager.play_jump()

		var direction := Input.get_axis("move_left", "move_right")
		
		if direction > 0 and _facing_left:
			_facing_left = false
			scale.x = scale.x * -1
		elif direction < 0 and not _facing_left:
			_facing_left = true
			scale.x = scale.x * -1
		
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
	
	elif _is_hiding:
		velocity.x = 0
		if position.y > 300:
			velocity.y = JUMP_VELOCITY
		else:
			velocity.y = 0
		move_and_slide()
		
		if Input.is_action_just_pressed("action"):
			_is_hiding = false
			_can_move = true
		
	
	if _object_in_hand == "FISH":
		fish.position = Vector2(position.x + 50, position.y)
	elif _object_in_hand == "SNAKE":
		snake.position = Vector2(position.x + 50, position.y)
		bite_progress_bar.value = (bite_timer.time_left / bite_timer.wait_time) * 100
	elif _object_in_hand == "RABBIT":
		rabbit.position = Vector2(position.x + 65, position.y)
	
			
	# HANDLE COLLISIONS
	for i in shape_cast_2d.get_collision_count():
		
			
		if shape_cast_2d.get_collider(i).name == "Owl":
			
			game_lost.emit()
			_can_move = false
			
		elif shape_cast_2d.get_collider(i).has_method("is_tree"):
			
			if Input.is_action_just_pressed("action") and _object_in_hand == "RABBIT":
				_object_in_hand = "NONE"
				rabbit_placed_in_tree.emit()
				_rabbit_in_tree = true
				rabbit.scale = Vector2(1, 1)
				
			elif Input.is_action_just_pressed("action") and not _is_hiding:
				_is_hiding = true
				_can_move = false
				AudioManager.play_climbing()
			
		elif shape_cast_2d.get_collider(i).name == "PondDirty":
			
			if Input.is_action_just_pressed("action") and not _fish_in_clean_pond and _object_in_hand == "NONE":
				_object_in_hand = "FISH"
				fish.scale = Vector2(0.25, 0.25)
			elif Input.is_action_just_pressed("action") and not _fish_in_clean_pond and _object_in_hand == "FISH":
				_object_in_hand = "NONE"
				fish.position = Vector2(pond_dirty.position.x, pond_dirty.position.y - 20.615)
				fish.scale = Vector2(0.5, 0.5)
				
		elif shape_cast_2d.get_collider(i).name == "PondClean":
			
			if Input.is_action_just_pressed("action") and not _fish_in_clean_pond and _object_in_hand == "FISH":
				_fish_in_clean_pond = true
				_object_in_hand = "NONE"
				fish.position = Vector2(pond_clean.position.x, pond_clean.position.y - 20.615)
				fish.scale = Vector2(0.5, 0.5)
			elif Input.is_action_just_pressed("action") and _fish_in_clean_pond and _object_in_hand == "NONE":
				_fish_in_clean_pond = false
				_object_in_hand = "FISH"
				fish.scale = Vector2(0.25, 0.25)
				
		elif shape_cast_2d.get_collider(i).name == "Rock":
			
			if Input.is_action_just_pressed("action") and not _snake_on_rock and _object_in_hand == "SNAKE":
				_snake_on_rock = true
				_object_in_hand = "NONE"
				snake.position.x = rock.position.x + 4.08
				snake.position.y = rock.position.y - 55.92
				snake.scale = Vector2(1, 1)
				
				bite_timer.stop()
				bite_progress_bar.hide()
		
		elif shape_cast_2d.get_collider(i).name == "Snake":
			
			if Input.is_action_just_pressed("action") and _object_in_hand == "NONE" and not _snake_on_rock:
				_object_in_hand = "SNAKE"
				_snake_on_rock = false
				snake.scale = Vector2(0.25, 0.25)
				
				bite_timer.wait_time = randf_range(8, 10)
				bite_timer.start()
				bite_progress_bar.show()
				
		elif shape_cast_2d.get_collider(i).name == "Rabbit":
			
			if Input.is_action_just_pressed("action") and _object_in_hand == "NONE":
				_object_in_hand = "RABBIT"
				rabbit_picked_up.emit()
				rabbit.scale = Vector2(0.25, 0.25)

	
	if _fish_in_clean_pond and _snake_on_rock and _rabbit_in_tree:
		game_won.emit()
		_can_move = false


func _on_bite_timer_timeout() -> void:
	game_lost.emit()
	_can_move = false
	AudioManager.play_death_snake()


func _on_rabbit_escaped_tree() -> void:
	_rabbit_in_tree = false
