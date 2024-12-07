extends Node

var cutsceneProgress = 0

var dialogues: Array[DialogueBox]

func _ready():
	$c/Island.modulate.a = 0.0
	$c/JustIsland.modulate.a = 0.0
	$c/Plane.modulate.a = 0.0
	var fadeTween1: Tween = create_tween()
	fadeTween1.tween_method(ChangeFadeIn, 1.0, 0.0, 3.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	var fadeTween2: Tween = create_tween()
	fadeTween2.tween_interval(2.0)
	fadeTween2.tween_method(ChangeFadeOut, 1.0, 0.0, 3.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	$PlaneSounds.play()
	var planeSoundsFade: Tween = create_tween()
	planeSoundsFade.tween_method(PlaneSoundsFade, 0.0, 2.0, 4.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	MusicPlayer.ins.MuffleMusic(true)
	var durationTween: Tween = create_tween()
	durationTween.tween_interval(5.0)
	durationTween.tween_callback(Limerick1)

func Limerick1():
	dialogues.append(DialogueMan.ins.NewDialogue(0, "There once was a man in a game, who sought joy, not money or fame"))
	var delayTween: Tween = create_tween()
	delayTween.tween_interval(0.5)
	delayTween.tween_callback(func(): cutsceneProgress += 1)

func Limerick2():
	dialogues.append(DialogueMan.ins.NewDialogue(1, "As he was passing the time, watching videos online,"))
	var delayTween: Tween = create_tween()
	delayTween.tween_interval(0.5)
	delayTween.tween_callback(func(): cutsceneProgress += 1)

func Limerick3():
	dialogues.append(DialogueMan.ins.NewDialogue(2, "He remembered he can't fly a plane"))
	var delayTween: Tween = create_tween()
	delayTween.tween_interval(0.5)
	delayTween.tween_callback(func(): cutsceneProgress += 1)

func Transition():
	var hideTween: Tween = create_tween()
	hideTween.tween_callback(dialogues[0].Hide)
	hideTween.tween_interval(0.1)
	hideTween.tween_callback(dialogues[1].Hide)
	hideTween.tween_interval(0.1)
	hideTween.tween_callback(dialogues[2].Hide)
	var planeSoundsFade: Tween = create_tween()
	planeSoundsFade.tween_method(PlaneSoundsFade, 2.0, 0.0, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	planeSoundsFade.tween_callback(PlaneCrash)
	var crossfadeTween: Tween = create_tween()
	crossfadeTween.parallel()
	crossfadeTween.tween_method(CrossFade, 1.0, 0.0, 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func CrossFade(val: float):
	$c/Background.modulate.a = val
	$c/Island.modulate.a = 1.0 - val
	$c/JustIsland.modulate.a = 1.0 - val
	$c/Plane.modulate.a = 1.0 - val

func PlaneCrash():
	MusicPlayer.ins.MuffleMusic(false)
	$PlaneCrash.play()
	$PlaneCrash.finished.connect(FadeToBlack)
	$c/PlaneAnimation.current_animation = "PlaneCrash"

func FadeToBlack():
	var fadeTween1: Tween = create_tween()
	fadeTween1.tween_method(ChangeFadeOut, 0.0, 1.0, 2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	var fadeTween2: Tween = create_tween()
	fadeTween2.tween_interval(1.0)
	fadeTween2.tween_method(ChangeFadeIn, 0.0, 1.0, 2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	fadeTween2.tween_callback(EndCutscene)

func SkipPressed():
	MusicPlayer.ins.MuffleMusic(false)
	Root.ins.ChangeScene(Root.Scene.GAME)

func EndCutscene():
	Root.ins.ChangeScene(Root.Scene.GAME)

func _process(_dt):
	if Input.is_action_just_pressed("MouseClick"):
		TryProgress()

func TryProgress():
	if cutsceneProgress == 1:
		cutsceneProgress += 1
		Limerick2()
	elif cutsceneProgress == 3:
		cutsceneProgress += 1
		Limerick3()
	elif cutsceneProgress == 5:
		cutsceneProgress += 1
		Transition()

func ChangeFadeIn(value: float):
	$c/Fade.texture.gradient.set_color(0, Color(0, 0, 0, value))

func ChangeFadeOut(value: float):
	$c/Fade.texture.gradient.set_color(1, Color(0, 0, 0, value))

func PlaneSoundsFade(value: float):
	$PlaneSounds.volume_db = linear_to_db(value)
