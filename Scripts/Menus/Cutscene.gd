extends Node

func _ready():
	var fadeTween1: Tween = create_tween()
	fadeTween1.tween_method(ChangeFadeIn, 1.0, 0.0, 4.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	var fadeTween2: Tween = create_tween()
	fadeTween2.tween_interval(3.0)
	fadeTween2.tween_method(ChangeFadeOut, 1.0, 0.0, 3.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	$PlaneSounds.play()
	var planeSoundsFade: Tween = create_tween()
	planeSoundsFade.tween_method(PlaneSoundsFade, 0.0, 2.0, 4.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	MusicPlayer.ins.MuffleMusic(true)
	var durationTween: Tween = create_tween()
	durationTween.tween_interval(7.0)
	durationTween.tween_callback(MusicPlayer.ins.MuffleMusic.bind(false))
	durationTween.tween_callback(Root.ins.ChangeScene.bind(Root.Scene.GAME))

func ChangeFadeIn(value: float):
	$c/Fade.texture.gradient.set_color(0, Color(0, 0, 0, value))

func ChangeFadeOut(value: float):
	$c/Fade.texture.gradient.set_color(1, Color(0, 0, 0, value))

func PlaneSoundsFade(value: float):
	$PlaneSounds.volume_db = linear_to_db(value)