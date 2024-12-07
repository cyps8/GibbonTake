extends Camera3D

@export var spawnPos: Vector3

@export var standPos: Vector3

func _ready():
	position = spawnPos

func Approach():
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", standPos, 1.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)