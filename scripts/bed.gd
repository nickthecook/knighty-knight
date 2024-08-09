extends Area2D

signal player_sleeping

func _on_body_entered(body):
	print("Bed._on_body_entered: " + str(body) )
	if body is CharacterBody2D:
		player_sleeping.emit(self)
