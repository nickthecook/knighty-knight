extends Node2D

const SPEED = 120

var direction = 1

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
@onready var ray_cast_ground_right = $RayCastGroundRight
@onready var ray_cast_ground_left = $RayCastGroundLeft

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ray_cast_right.is_colliding() or not ray_cast_ground_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	elif ray_cast_left.is_colliding() or not ray_cast_ground_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	
	position.x += 1 * direction * SPEED * delta
