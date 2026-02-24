extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var gravity: float = 1000.0
@export var bubble_scene: PackedScene

var anim_sprite: AnimatedSprite2D

var fire_timer: int = 20

var facing = 1 # right=1, left=-1

var inv_frames = false
var flicker_anim = false

func _ready():
	anim_sprite = $AnimatedSprite2D
	anim_sprite.play("idle")

func _physics_process(delta: float) -> void:
	if inv_frames:
		flicker_anim = !flicker_anim
		if flicker_anim:
			$AnimatedSprite2D.modulate.a = 0.0
		else:
			$AnimatedSprite2D.modulate.a = 1.0
	
	if fire_timer < 20:
		fire_timer += 1
		velocity = Vector2(0,0)
		
		if facing == 1:
			anim_sprite.play("fire_right")
		else:
			anim_sprite.play("fire_left")
	else:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
			
		var direction = Input.get_axis("move_left", "move_right")
		velocity.x = direction * speed
		if direction != 0:
			facing = direction
		 
		if not is_on_floor():
			if facing == 1:
				anim_sprite.play("jump_right")
			elif facing == -1:
				anim_sprite.play("jump_left")
			else:
				anim_sprite.play("jump_right")
		else:
			if direction == 1:
				anim_sprite.play("run_right")
			elif direction == -1:
				anim_sprite.play("run_left")
			else:
				anim_sprite.play("idle")
		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity
			
		if Input.is_action_just_pressed("fire"):
			var b = bubble_scene.instantiate()
			var offset = Vector2(20, 0)
			
			offset.x *= facing
			b.position = global_position + offset
			b.dir = facing
			
			fire_timer = 0
			
			get_parent().add_child(b)

	move_and_slide()

func take_damage():
	if inv_frames:
		return
		
	GameManager.take_damage()
	if(GameManager.health <= 0):
		get_tree().change_scene_to_file("res://scenes/screens/game_over.tscn")
	
	inv_frames = true
	$InvincibilityTimer.start()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemies"):
		take_damage()

func _on_invincibility_timer_timeout() -> void:
	inv_frames = false
