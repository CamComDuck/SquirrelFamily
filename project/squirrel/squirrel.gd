class_name Squirrel
extends CharacterBody2D

signal game_lost

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var _can_move := true
var _is_hiding := false

var _fish_in_dirty_pond := true
var _snake_on_rock := false
var _object_in_hand : String = "NONE"

@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D
@onready var fish: Sprite2D = $"../Fish"
@onready var pond_clean: StaticBody2D = $"../PondClean"
@onready var pond_dirty: StaticBody2D = $"../PondDirty"
@onready var rock: StaticBody2D = $"../Rock"
@onready var snake: Area2D = $"../Snake"
@onready var bite_progress_bar: ProgressBar = $"../Snake/BiteProgressBar"
@onready var bite_timer: Timer = $"../Snake/BiteTimer"

func _physics_process(delta: float) -> void:
	if _can_move:
		if not is_on_floor() and not _is_hiding:
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var direction := Input.get_axis("move_left", "move_right")
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
	
	elif _is_hiding:
		velocity.x = 0
		if position.y > 500:
			velocity.y = JUMP_VELOCITY
		else:
			velocity.y = 0
		move_and_slide()
		
		if Input.is_action_just_pressed("action"):
			_is_hiding = false
			_can_move = true
		
	
	if _object_in_hand == "FISH":
		fish.position = position
	elif _object_in_hand == "SNAKE":
		snake.position = position
		bite_progress_bar.value = (bite_timer.time_left / bite_timer.wait_time) * 100
			
	# HANDLE COLLISIONS
	for i in shape_cast_2d.get_collision_count():
			
		if shape_cast_2d.get_collider(i).name == "Owl":
			
			game_lost.emit()
			_can_move = false
			
		elif shape_cast_2d.get_collider(i).has_method("is_tree"):
			
			if Input.is_action_just_pressed("action") and not _is_hiding:
				_is_hiding = true
				_can_move = false
			
		elif shape_cast_2d.get_collider(i).name == "PondDirty":
			
			if Input.is_action_just_pressed("action") and _fish_in_dirty_pond and _object_in_hand == "NONE":
				_fish_in_dirty_pond = false
				_object_in_hand = "FISH"
			elif Input.is_action_just_pressed("action") and not _fish_in_dirty_pond and _object_in_hand == "FISH":
				_fish_in_dirty_pond = true
				_object_in_hand = "NONE"
				fish.position = pond_dirty.position
				
		elif shape_cast_2d.get_collider(i).name == "PondClean":
			
			if Input.is_action_just_pressed("action") and not _fish_in_dirty_pond and _object_in_hand == "FISH":
				_fish_in_dirty_pond = false
				_object_in_hand = "NONE"
				fish.position = pond_clean.position
			elif Input.is_action_just_pressed("action") and not _fish_in_dirty_pond and _object_in_hand == "NONE":
				_fish_in_dirty_pond = false
				_object_in_hand = "FISH"
				
		elif shape_cast_2d.get_collider(i).name == "Rock":
			
			if Input.is_action_just_pressed("action") and not _snake_on_rock and _object_in_hand == "SNAKE":
				_snake_on_rock = true
				_object_in_hand = "NONE"
				snake.position = rock.position
				
				bite_timer.stop()
				bite_progress_bar.hide()
		
		elif shape_cast_2d.get_collider(i).name == "Snake":
			
			if Input.is_action_just_pressed("action") and _object_in_hand == "NONE":
				_object_in_hand = "SNAKE"
				_snake_on_rock = false
				
				bite_timer.wait_time = randf_range(10, 15)
				bite_timer.start()
				bite_progress_bar.show()


func _on_owl_game_lost() -> void:
	_can_move = false


func _on_bite_timer_timeout() -> void:
	game_lost.emit()
	_can_move = false
