extends Area2D

signal player_sleeping

@onready var sleep_sound_player = $SleepSoundPlayer

func _on_body_entered(body):
	print("Bed._on_body_entered: " + str(body) )
	if body is CharacterBody2D:
		sleep_sound_player.play()
		player_sleeping.emit(self)
