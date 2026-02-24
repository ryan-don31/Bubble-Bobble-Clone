extends Node

var score: int = 0
var health: int = 3

signal score_changed(new_score)
signal health_changed(new_health)

func take_damage():
	health -= 1
	health_changed.emit(health)

func reset_health():
	health = 3
	health_changed.emit(health)

func add_score(amount: int):
	score += amount
	score_changed.emit(score)
	
func reset_score():
	score = 0
	score_changed.emit(score)
