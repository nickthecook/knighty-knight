extends Area2D

@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer

func _on_body_entered(body):
	print("You died.")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	body.alive = false
	body.get_node("AnimatedSprite2D").play("die")
	animation_player.play("player_death")
	timer.start()


func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
