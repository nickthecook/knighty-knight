extends Node

var score = 0
var lives = 3
var checkpoint_x = -39
var checkpoint_y = 12

@onready var score_label = $UI/ScoreLabel
@onready var game_over_label = $UI/GameOverLabel
@onready var player = $"../Player"
@onready var timer = $Timer
@onready var killzone = $"../Killzone"
@onready var lives_label = $UI/LivesLabel

func _ready():
	print("CONNECT" )
	player.died.connect(player_died)

func add_score(amount):
	score += amount
	print("Score: " + str(score))
	score_label.text = str(score)

func player_died():
	lives -= 1
	lives_label.text = str(lives)	
	print("Lives: " + str(lives))
	if lives <= 0:
		handle_game_over()
	else:
		handle_death()

func handle_game_over():
	game_over_label.visible = true
	print("Game over.")
	Engine.time_scale = 0.5
	player.die()
	timer.start()

func handle_death():
	print("You died.")
	Engine.time_scale = 0.5
	player.die()
	timer.start()

func _on_timer_timeout():
	Engine.time_scale = 1
	if lives == 0:
		get_tree().reload_current_scene()
	else:
		player.reset_at(checkpoint_x, checkpoint_y)
