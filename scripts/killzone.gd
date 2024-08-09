extends Area2D

@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer
@onready var game_manager = %GameManager

signal player_entered_killzone

func _on_body_entered(body):
	print("Killzone._on_body_entered")
	body.entered_killzone()
