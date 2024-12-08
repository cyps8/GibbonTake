class_name DialogueBox extends TextureRect

var current = 0

func Show(index: int, text: String, dur: float = 0.0):
	current = index
	texture = DialogueMan.ins.dialogueTextures[index]
	get_child(index).text = text

	position = DialogueMan.ins.dialogueOffScreen[index]
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", Vector2.ZERO, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	if dur > 0.0:
		tween.tween_interval(dur)
		tween.tween_callback(Hide)

func Hide():
	DialogueMan.ins.activeBoxes.erase(self)
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", DialogueMan.ins.dialogueOffScreen[current], 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(queue_free)