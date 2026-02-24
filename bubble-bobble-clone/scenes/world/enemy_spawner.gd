extends Node2D

@export var enemy_scene: PackedScene
@export var max_enemies: int = 6

var spawn_count := 0

func _ready():
	$Timer.timeout.connect(_on_timer_timeout)
	
func _on_timer_timeout():
	if spawn_count >= max_enemies:
		$Timer.stop()
		return
	
	spawn_enemy()
	spawn_count += 1
	
func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
