extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const COYOTE_TIME = 0.2  # Duration of coyote time in seconds
const MAX_JUMPS = 2  # Maximum number of jumps (1 for normal jump, 2 for double jump)

var coyote_time_left = 0.0  # Tracks remaining coyote time
var jump_count = 0  # Tracks how many times the player has jumped

func _physics_process(delta: float) -> void:
	# Update coyote time.
	if is_on_floor():
		coyote_time_left = COYOTE_TIME
		jump_count = 0  # Reset jump count when on the ground
	else:
		coyote_time_left -= delta

	# Add gravity if not on the floor.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump (check for double jump)
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor() or jump_count < MAX_JUMPS:
			velocity.y = JUMP_VELOCITY
			jump_count += 1  # Increment jump count after each jump
			coyote_time_left = 0.0  # Reset coyote time after jumping

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Flip the sprite based on movement direction
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true

	move_and_slide()
