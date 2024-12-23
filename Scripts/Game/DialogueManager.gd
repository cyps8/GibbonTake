class_name DialogueMan extends CanvasLayer

static var ins: DialogueMan

func _init():
	ins = self

@export var dialogueTextures: Array[Texture2D]

@export var dialogueOffScreen: Array[Vector2]

@export var diaBoxIns: PackedScene

var activeBoxes: Array[DialogueBox]

func NewDialogue(index: int, text: String, dur: float = 0.0) -> DialogueBox:
	var newBox = diaBoxIns.instantiate()
	newBox.Show(index, text, dur)
	get_child(0).add_child(newBox)
	activeBoxes.append(newBox)
	return newBox

func HideAllDialogue():
	for box in activeBoxes:
		box.Hide()