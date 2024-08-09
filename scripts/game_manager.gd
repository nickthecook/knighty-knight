extends Node

var score = 0
var lives = 3
var checkpoint_x = -39
var checkpoint_y = 12

@onready var score_label = $UI/ScoreLabel
@onready var game_over_label = $UI/GameOverLabel
@onready var player = $"../Player"
@onready var timer = $Timer
@onready var sleep_timer = $SleepTimer
@onready var killzone = $"../Killzone"
@onready var lives_label = $UI/LivesLabel
@onready var bed = $"../Checkpoints/Bed"
@onready var bed_2 = $"../Checkpoints/Bed2"
@onready var bed_3 = $"../Checkpoints/Bed3"
@onready var bed_4 = $"../Checkpoints/Bed4"

func _ready():
	print("CONNECT" )
	player.died.connect(player_died)
	bed.player_sleeping.connect(player_sleeping)
	bed_2.player_sleeping.connect(player_sleeping)
	bed_3.player_sleeping.connect(player_sleeping)
	bed_4.player_sleeping.connect(player_sleeping)

func player_sleeping(checkpoint):
	if checkpoint_x == checkpoint.position.x and checkpoint_y == checkpoint.position.y:
		return

	checkpoint_x = checkpoint.position.x
	checkpoint_y = checkpoint.position.y
	player.sleep(checkpoint.position.x, checkpoint.position.y)
	sleep_timer.start()

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

func _on_sleep_timer_timeout():
	player.wake()
