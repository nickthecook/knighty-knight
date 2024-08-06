extends Node

var score = 0

@onready var score_label = $UI/ScoreLabel

func add_score(amount):
	score += amount
	print("Score: " + str(score))
	score_label.text = str(score)
