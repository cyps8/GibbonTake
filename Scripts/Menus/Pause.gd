extends CanvasLayer

func ResumePressed():
	GameManager.ins.TogglePause()

func _process(_dt):
	$c/Panel/SkipTutorial.disabled = !Gameplay.ins.intro

func SkipTutorialPressed():
	GameManager.ins.TogglePause()
	Gameplay.ins.SkipTutorial()

func OptionsPressed():
	Root.ins.OpenOptionsMenu()

func MainMenuPressed():
	GameManager.ins.TogglePause()
	Root.ins.ChangeScene(Root.Scene.MAINMENU)
