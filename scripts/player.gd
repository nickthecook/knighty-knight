extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = default_gravity
var alive = true
var can_jump = true
var was_on_floor = true
var reset = false
var just_woke = false
var awake = true

signal died

@onready var player = $"."
@onready var animated_sprite = $AnimatedSprite2D
@onready var audio_stream_player = $AudioStreamPlayer2D
@onready var jump_timer = $JumpTimer
@onready var collision_shape = $CollisionShape2D

func entered_killzone():
	# TODO: why is this necessary? Killzone triggers after the player respawns for some reason.
	if reset:
		print("Resetting instead of dying...")
		reset = false
	else:
		if alive:
			died.emit()

func sleep(x, y):
	print("Player.sleep")
	position.x = x
	position.y = y
	animated_sprite.play("sleep")
	animated_sprite.flip_h = true
	awake = false

func wake():
	print("Player.wake")
	animated_sprite.play("idle")
	animated_sprite.flip_h = false
	awake = true
	just_woke = true

func die():
	print("Player.die")
	animated_sprite.play("die")
	collision_shape.call_deferred("set", "disabled", true)
	alive = false

func reset_at(x, y):
	print("Player.reset_at(" + str(x) + "," + str("y") + ")")
	position.x = x
	position.y = y
	alive = true
	reset = true
	collision_shape.disabled = false
	velocity.y = 0
	animated_sprite.play("idle")

func jump():
	velocity.y = JUMP_VELOCITY
	audio_stream_player.play()
	can_jump = false

func _on_jump_timer_timeout():
	can_jump = false

func _physics_process(delta):
	if not awake:
		return

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


func _on_space_body_entered(body):
	if body is CharacterBody2D:
		print("In space")
		gravity = (default_gravity / 2)

func _on_space_body_exited(body):
	if body is CharacterBody2D:
		print("Not in space")
		gravity = default_gravity
