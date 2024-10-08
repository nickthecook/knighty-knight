extends Node

var score = 0
var lives = 3
var checkpoint_x = -39
var checkpoint_y = 12
var game_finished = false
var start_time
var finish_time

@onready var player = $"../Player"
@onready var killzone = $"../Killzone"

@onready var death_timer = $DeathTimer
@onready var sleep_timer = $SleepTimer
@onready var so_tired_timer = $SoTiredTimer
@onready var so_tired_start_timer = $SoTiredStartTimer
@onready var too_bright_timer = $TooBrightTimer
@onready var just_right_timer = $JustRightTimer
@onready var snore_timer = $SnoreTimer
@onready var restart_timer = $RestartTimer

@onready var game_over_label = $UI/GameOverLabel
@onready var score_label = $UI/ScoreLabel
@onready var lives_label = $UI/LivesLabel
@onready var so_tired_label = $UI/SoTiredLabel
@onready var ahhh_label = $UI/AhhhLabel
@onready var too_bright_label = $UI/TooBrightLabel
@onready var just_right_label = $UI/JustRightLabel
@onready var snore_label = $UI/SnoreLabel
@onready var snore_animation_player = $UI/SnoreLabel/AnimationPlayer
@onready var restart_label = $UI/RestartLabel
@onready var timer_label = $UI/TimerLabel

@onready var bed = $"../Checkpoints/Bed"
@onready var bed_2 = $"../Checkpoints/Bed2"
@onready var bed_3 = $"../Checkpoints/Bed3"
@onready var bed_4 = $"../Checkpoints/Bed4"
@onready var bed_5 = $"../Checkpoints/Bed5"

func _ready():
	print("CONNECT" )
	player.died.connect(player_died)
	player.entered_space.connect(player_entered_space)
	player.exited_space.connect(player_exited_space)

	bed.player_sleeping.connect(player_sleeping)
	bed_2.player_sleeping.connect(player_sleeping)
	bed_3.player_sleeping.connect(player_sleeping)
	bed_4.player_sleeping.connect(player_sleeping)
	bed_5.player_sleeping.connect(player_won)

	so_tired_start_timer.start()

	start_time = Time.get_unix_time_from_system()

func _process(delta: float):
	if game_finished:
		if Input.is_anything_pressed():
			get_tree().reload_current_scene()
	else:
		update_time()

func update_time():
	var elapsed_time

	if finish_time:
		elapsed_time = finish_time - start_time
	else:
		elapsed_time = Time.get_unix_time_from_system() - start_time
	timer_label.text = "%0.3f" % elapsed_time
	
func player_sleeping(checkpoint):
	if checkpoint_x == checkpoint.position.x and checkpoint_y == checkpoint.position.y:
		return

	checkpoint_x = checkpoint.position.x
	checkpoint_y = checkpoint.position.y
	player.sleep(checkpoint.position.x, checkpoint.position.y)
	sleep_timer.start()
	ahhh_label.visible = true

func player_won(checkpoint):
	finish_time = Time.get_unix_time_from_system()
	player.sleep(checkpoint.position.x, checkpoint.position.y)
	just_right_label.visible = true
	just_right_timer.start()
	player.process_mode = Node.PROCESS_MODE_DISABLED

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
	ahhh_label.visible = false
	too_bright_label.visible = true
	too_bright_timer.start()

func _on_so_tired_start_timer_timeout():
	so_tired_label.visible = true
	so_tired_timer.start()

func _on_so_tired_timer_timeout():
	so_tired_label.visible = false


func _on_too_bright_timer_timeout():
	too_bright_label.visible = false


func _on_just_right_timer_timeout():
	just_right_label.visible = false
	snore_timer.start()
	restart_timer.start()

func _on_snore_timer_timeout():
	snore_animation_player.play("snoring")
	snore_label.visible = true
	player.snore()

func _on_restart_timer_timeout():
	restart_label.visible = true
	game_finished = true

func player_entered_space():
	print("GameManager.player_entered_space")
	%Music.stop()
	%SpaceMusic.play()

func player_exited_space():
	print("GameManager.player_exited_space")
	%SpaceMusic.stop()
	%Music.play()


func _on_space_music_finished():
	%SpaceMusic.play()
