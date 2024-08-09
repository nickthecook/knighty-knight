extends Node

var score = 0
var lives = 3
var checkpoint_x = -39
var checkpoint_y = 12

@onready var player = $"../Player"
@onready var killzone = $"../Killzone"

@onready var death_timer = $DeathTimer
@onready var sleep_timer = $SleepTimer
@onready var so_tired_timer = $SoTiredTimer
@onready var so_tired_start_timer = $SoTiredStartTimer

@onready var game_over_label = $UI/GameOverLabel
@onready var score_label = $UI/ScoreLabel
@onready var lives_label = $UI/LivesLabel
@onready var so_tired_label = $UI/SoTiredLabel

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
	so_tired_start_timer.start()

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
	death_timer.start()

func handle_death():
	print("You died.")
	Engine.time_scale = 0.5
	player.die()
	death_timer.start()

func _on_timer_timeout():
	Engine.time_scale = 1
	if lives == 0:
		get_tree().reload_current_scene()
	else:
		player.reset_at(checkpoint_x, checkpoint_y)

func _on_sleep_timer_timeout():
	player.wake()


func _on_so_tired_start_timer_timeout():
	so_tired_label.visible = true
	so_tired_timer.start()
	



func _on_so_tired_timer_timeout():
	so_tired_label.visible = false
