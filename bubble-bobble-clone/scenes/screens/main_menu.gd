extends Node2D

func _ready():
	$AnimatedSprite2D.play("default")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		get_tree().change_scene_to_file("res://scenes/main/main.tscn")
