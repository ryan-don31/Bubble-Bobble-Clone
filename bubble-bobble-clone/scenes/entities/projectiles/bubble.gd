extends Area2D

enum BubbleState {
	MOVING,
	TRAPPED,
	POPPED
}

@export var speed: float = 300.0
@export var float_delay: float = 1.5

var dir: int = 0
var float_up: bool = false
var float_speed: float = 50.0
var state: BubbleState = BubbleState.MOVING

var anim_sprite: AnimatedSprite2D

var timer: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_sprite = $AnimatedSprite2D
	anim_sprite.play("moving")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		BubbleState.MOVING:
			if not float_up:
				position.x += speed * dir * delta
				timer += delta
				if timer >= float_delay:
					float_up = true
					$DisappearTimer.start()
			else:
				position.y -= float_speed * delta
				
		BubbleState.TRAPPED:
			anim_sprite.play("trapped")
			position.y -= float_speed * delta
			
		BubbleState.POPPED:
			pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and state != BubbleState.TRAPPED:
		state = BubbleState.TRAPPED
		body.queue_free()
		
	elif body.is_in_group("player") and state == BubbleState.TRAPPED:
		GameManager.add_score(100)
		state = BubbleState.POPPED
		anim_sprite.play("popping")

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim_sprite.animation == "popping":
		queue_free()


func _on_disappear_timer_timeout() -> void:
	queue_free()
