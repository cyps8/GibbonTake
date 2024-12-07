extends Sprite2D

func _ready():
	var tween: Tween = create_tween().set_loops()
	tween.tween_property(self, "position", position + Vector2(0.0, 20.0), 0.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", position - Vector2(0.0, 20.0), 0.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)