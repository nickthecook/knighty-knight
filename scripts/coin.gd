extends Area2D

@onready var game_manager = %GameManager
@onready var animation_player = $AnimationPlayer

func _on_body_entered(body):
	print("Coin._on_body_entered: " + str(body))
	if body is CharacterBody2D:
		print("Coin get!")
		game_manager.add_score(1)
		animation_player.play("pickup")
