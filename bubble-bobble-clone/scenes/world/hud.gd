extends CanvasLayer

@onready var level_ind = $Level_Ind
@onready var score = $Score
@onready var health = $Health

func _ready():
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.health_changed.connect(_on_health_changed)

func _on_score_changed(new_score):
	$Score.text = str(new_score)

func _on_health_changed(new_health):
	$Health.text = "HEALTH: " + str(new_health)
