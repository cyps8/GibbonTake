extends CanvasLayer

var creditsRef: Credits

var fading: bool

func _ready():
	fading = false

	creditsRef = $Credits
	creditsRef.visible = false

	MusicPlayer.ins.ChangeMusic(1)

func StartPressed():
	if fading:
		return
	var tween: Tween = create_tween()
	tween.tween_property($FadeToBlack, "modulate:a", 1, 1)
	tween.tween_callback(Root.ins.ChangeScene.bind(Root.Scene.CUTSCENE))

func CreditsPressed():
	if fading:
		return
	creditsRef.visible = true

func OptionsPressed():
	if fading:
		return
	Root.ins.OpenOptionsMenu()

func ExitPressed():
	if fading:
		return
	get_tree().quit()
