extends Label

func _ready():
	var tween: Tween = create_tween().set_loops()
	tween.tween_interval(0.2)
	tween.tween_callback(SetText.bind("LOADING."))
	tween.tween_interval(0.2)
	tween.tween_callback(SetText.bind("LOADING.."))
	tween.tween_interval(0.2)
	tween.tween_callback(SetText.bind("LOADING..."))

func SetText(textChange: String):
	text = textChange
