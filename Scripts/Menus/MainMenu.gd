extends CanvasLayer

func _ready():
	MusicPlayer.ins.ChangeMusic(1)

func StartPressed():
	Root.ins.ChangeScene(Root.Scene.CUTSCENE)

func CreditsPressed():
	pass

func OptionsPressed():
	Root.ins.OpenOptionsMenu()

func ExitPressed():
	get_tree().quit()
