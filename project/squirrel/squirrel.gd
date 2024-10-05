class_name Squirrel
extends CharacterBody2D

signal game_lost

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var _can_move := true
var _hiding_spot_position : Vector2
var _is_hiding := false


func _physics_process(delta: float) -> void:
	if _can_move:
		if not is_on_floor():
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var direction := Input.get_axis("move_left", "move_right")
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		if Input.is_action_just_pressed("action") and _hiding_spot_position != Vector2.ZERO:
			visible = false
			position = _hiding_spot_position
			_hiding_spot_position = Vector2.ZERO
			_can_move = false
			_is_hiding = true

		move_and_slide()
		for i in get_slide_collision_count():
			if get_slide_collision(i).get_collider().name == "Owl":
				game_lost.emit()
				_can_move = false
			elif get_slide_collision(i).get_collider().name == "HidingSpot":
				_hiding_spot_position = get_slide_collision(i).get_position()
			else:
				_hiding_spot_position = Vector2.ZERO
	
	elif Input.is_action_just_pressed("action") and _is_hiding:
		position = Vector2(position.x, position.y + 10)
		visible = true
		_can_move = true


func _on_owl_game_lost() -> void:
	_can_move = false
