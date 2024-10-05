class_name Squirrel
extends CharacterBody2D

signal game_lost

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var _can_move := true
var _hiding_spot_position : Vector2
var _is_hiding := false

var _fish_in_hand := false
var _fish_in_dirty_pond := true

@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D
@onready var fish: Sprite2D = $"../Fish"
@onready var pond_clean: StaticBody2D = $"../PondClean"
@onready var pond_dirty: StaticBody2D = $"../PondDirty"

func _physics_process(delta: float) -> void:
	if _can_move:
		if not is_on_floor():
			velocity += get_gravity() * delta
			
		if _fish_in_hand:
			fish.position = position

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
		
		
		for i in shape_cast_2d.get_collision_count():
			
			if shape_cast_2d.get_collider(i).name == "Owl":
				
				game_lost.emit()
				_can_move = false
				
			elif shape_cast_2d.get_collider(i).name == "HidingSpot":
				
				_hiding_spot_position = shape_cast_2d.target_position
				# Fix later :)
				
			elif shape_cast_2d.get_collider(i).name == "PondDirty":
				
				if Input.is_action_just_pressed("action") and _fish_in_dirty_pond:
					_fish_in_dirty_pond = false
					_fish_in_hand = true
				elif Input.is_action_just_pressed("action") and not _fish_in_dirty_pond and _fish_in_hand:
					_fish_in_dirty_pond = true
					_fish_in_hand = false
					fish.position = pond_dirty.position
					
			elif shape_cast_2d.get_collider(i).name == "PondClean":
				
				if Input.is_action_just_pressed("action") and not _fish_in_dirty_pond and _fish_in_hand:
					_fish_in_dirty_pond = false
					_fish_in_hand = false
					fish.position = pond_clean.position
				elif Input.is_action_just_pressed("action") and not _fish_in_dirty_pond and not _fish_in_hand:
					_fish_in_dirty_pond = false
					_fish_in_hand = true
					
			else:
				_hiding_spot_position = Vector2.ZERO
	
	elif Input.is_action_just_pressed("action") and _is_hiding:
		position = Vector2(position.x, position.y + 10)
		visible = true
		_can_move = true


func _on_owl_game_lost() -> void:
	_can_move = false
