class_name Rabbit
extends CharacterBody2D

signal escaped_tree

const SPEED = 200.0
const JUMP_VELOCITY = -500.0

var _can_move := true
var _is_moving := true
var _direction : int
var _in_tree := false

@onready var move_timer: Timer = $MoveTimer
@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D
@onready var escape_timer: Timer = $EscapeTimer

func _ready() -> void:
	position.x = randf_range(-1075, 2350)
	move_timer.wait_time = randf_range(1, 4)
	_direction = randi_range(-1, 1)
	move_timer.start()


func _physics_process(delta: float) -> void:
	if _can_move:
		if not is_on_floor():
			velocity += get_gravity() * delta

		var jump_chance := randf_range(0, 400)

		if jump_chance < 2 and is_on_floor():
			velocity.y = JUMP_VELOCITY

		if _is_moving:
			if _direction != 0:
				velocity.x = _direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
	
	elif _in_tree:
		velocity.x = 0
		if position.y > 300:
			velocity.y = JUMP_VELOCITY
		else:
			velocity.y = 0
		move_and_slide()

	for i in shape_cast_2d.get_collision_count():
		var collision = shape_cast_2d.get_collider(i).name
			
		if (collision == "Rock" or collision == "PondClean" or collision == "PondDirty") and is_on_floor():
			velocity.y = JUMP_VELOCITY

func _on_move_timer_timeout() -> void:
	move_timer.wait_time = randf_range(1, 3)
	_direction = randi_range(-1, 1)
	move_timer.start()


func _on_squirrel_rabbit_picked_up() -> void:
	velocity = Vector2.ZERO
	_can_move = not _can_move
	shape_cast_2d.enabled = not shape_cast_2d.enabled


func _on_squirrel_rabbit_placed_in_tree() -> void:
	escape_timer.wait_time = randf_range(5, 10)
	escape_timer.start()
	_in_tree = true


func _on_escape_timer_timeout() -> void:
	velocity = Vector2.ZERO
	_can_move = not _can_move
	shape_cast_2d.enabled = not shape_cast_2d.enabled
	
	move_timer.wait_time = randf_range(1, 3)
	_direction = randi_range(-1, 1)
	move_timer.start()
	escaped_tree.emit()
	_in_tree = false


func _on_squirrel_game_lost() -> void:
	_can_move = false
	velocity = Vector2.ZERO
	move_timer.stop()
	escape_timer.stop()


func _on_squirrel_game_won() -> void:
	_can_move = false
	velocity = Vector2.ZERO
	move_timer.stop()
	escape_timer.stop()
