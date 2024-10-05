class_name Rabbit
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var _can_move := true
var _is_moving := true
var _direction : int

@onready var move_timer: Timer = $MoveTimer
@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D

func _ready() -> void:
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

	for i in shape_cast_2d.get_collision_count():
		var current_collision = shape_cast_2d.get_collider(i)
			
		if (current_collision.name == "Rock" or current_collision.name == "PondClean" or current_collision.name == "PondDirty") and is_on_floor():
			velocity.y = JUMP_VELOCITY

func _on_move_timer_timeout() -> void:
	move_timer.wait_time = randf_range(1, 3)
	_direction = randi_range(-1, 1)
	move_timer.start()
