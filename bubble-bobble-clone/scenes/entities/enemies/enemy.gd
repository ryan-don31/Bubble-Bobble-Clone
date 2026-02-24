extends CharacterBody2D

@export var speed: float = 200.0
@export var direction: int = 1
@export var gravity: float = 1000.0

var anim_sprite: AnimatedSprite2D

func _ready():
	anim_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	velocity.x = speed * direction
	
	if not is_on_floor():
		velocity.y += gravity * delta
		if direction == 1:
			anim_sprite.play("fall_right")
		elif direction == -1:
			anim_sprite.play("fall_left")
	else:
		if direction == 1:
			anim_sprite.play("move_right")
		elif direction == -1:
			anim_sprite.play("move_left")

	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("Walls"):
			direction *= -1
			
