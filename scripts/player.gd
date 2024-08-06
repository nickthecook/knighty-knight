extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var alive = true
var can_jump = true
var was_on_floor = true

@onready var player = $"."
@onready var animated_sprite = $AnimatedSprite2D
@onready var audio_stream_player = $AudioStreamPlayer2D
@onready var jump_timer = $JumpTimer

func jump():
	velocity.y = JUMP_VELOCITY
	audio_stream_player.play()
	can_jump = false

func _on_jump_timer_timeout():
	can_jump = false

func _physics_process(delta):
	# Add the gravity.
	if is_on_floor():
		can_jump = true
		was_on_floor = true
	elif was_on_floor:
		was_on_floor = false
		jump_timer.start()

	if not can_jump:
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and can_jump:
		jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	
	# flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# play animations
	if alive:
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()	
