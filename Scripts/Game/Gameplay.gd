class_name Gameplay extends CanvasLayer

static var ins: Gameplay

func _init():
	ins = self

@export var itemIns: PackedScene

@export var itemList: Array[ItemData]

var wantedItem: ItemData

var submittedItem: ItemData

var currentDay: int

var camRef: Camera3D

var apeOrange: AnimatedSprite3D

var apeBlue: AnimatedSprite3D

var apePurple: AnimatedSprite3D

var apePink: AnimatedSprite3D

var introSequence: int = 0

var activeDialogue: Array[DialogueBox]

var intro: bool = true

var actualDay: int = 0

func _ready():
	camRef = $Camera

	apeOrange = $Apes/Orange
	apeBlue = $Apes/Blue
	apePurple = $Apes/Purple
	apePink = $Apes/Pink

	Inventory.ins.visible = false
	currentDay = 0
	FadeBlack(0, 1.5)
	Intro()

func AddIntroDialogue(id: int, text: String, dur: float = 0.0, dontHide: bool = false):
	if !dontHide:
		for box in activeDialogue:
			box.Hide()
		activeDialogue.clear()
	var newBox = DialogueMan.ins.NewDialogue(id, text, dur)
	activeDialogue.append(newBox)

func HideIntroDialogue():
	for box in activeDialogue:
		box.Hide()
	activeDialogue.clear()

func Intro():
	introSequence = 1
	var delayTween: Tween = create_tween()
	delayTween.tween_interval(1.0)
	delayTween.tween_callback(AddIntroDialogue.bind(5, "where am I? what the heck is going on???"))
	delayTween.tween_interval(0.5)
	delayTween.tween_callback(func (): introSequence += 1)

func _process(_dt):
	if Input.is_action_just_pressed("MouseClick"):
		ProgressIntro()

func ProgressIntro():
	if introSequence == 2:
		introSequence += 1
		var delayTween: Tween = create_tween()
		delayTween.tween_callback(AddIntroDialogue.bind(2, "Ugh my head…"))
		delayTween.tween_interval(0.5)
		delayTween.tween_callback(func (): introSequence += 1)
	if introSequence == 4:
		introSequence += 1
		var delayTween: Tween = create_tween()
		delayTween.tween_callback(AddIntroDialogue.bind(2, "ugh wha- what do you want? who are you?"))
		delayTween.tween_callback(SFXPlayer.ins.PlaySound.bind(2))
		delayTween.tween_callback(camRef.Approach)
		delayTween.tween_interval(1.5)
		delayTween.tween_callback(func (): introSequence += 1)
	if introSequence == 6:
		introSequence += 1
		var delayTween: Tween = create_tween()
		delayTween.tween_callback(AddIntroDialogue.bind(4, "I don't know whats going on, but it looks like these apes are pointing to my hat? I don't want to upset them… maybe i should give it to them?"))
		delayTween.tween_interval(0.5)
		delayTween.tween_callback(func (): introSequence += 1)
	if introSequence == 8:
		introSequence += 1
		HideIntroDialogue()
		var delayTween: Tween = create_tween()
		delayTween.tween_interval(0.5)
		delayTween.tween_callback(SpawnHat)
		delayTween.tween_callback(ShowInventory)
		delayTween.tween_callback(AddIntroDialogue.bind(2, "Pull the item into the circle and press the tick to confirm when youre ready"))
	if introSequence == 10:
		introSequence += 1
		var delayTween: Tween = create_tween()
		delayTween.tween_callback(AddIntroDialogue.bind(4, "Man i really loved that hat…. my great uncle, twice removed on my dad’s wife’s side, gave me that…."))
		delayTween.tween_interval(0.5)
		delayTween.tween_callback(func (): introSequence += 1)
	if introSequence == 12:
		introSequence += 1
		var delayTween: Tween = create_tween()
		delayTween.tween_callback(AddIntroDialogue.bind(3, "They ook and holler in excitement. They seem very pleased. The rest of them gesture for more."))
		delayTween.tween_interval(0.5)
		delayTween.tween_callback(func (): introSequence += 1)
	if introSequence == 14:
		introSequence += 1
		var delayTween: Tween = create_tween()
		delayTween.tween_callback(AddIntroDialogue.bind(6, "You rummage through the wreckage of your plane and come back with a pile of random crap that you hope they’ll find worth in"))
		delayTween.tween_interval(0.5)
		delayTween.tween_callback(func (): introSequence += 1)
	if introSequence == 16:
		introSequence += 1
		HideIntroDialogue()
		var delayTween: Tween = create_tween()
		delayTween.tween_interval(0.5)
		delayTween.tween_callback(SpawnItems.bind(3))
		delayTween.tween_callback(ShowInventory)
		delayTween.tween_callback(AddIntroDialogue.bind(1, "The differnt apes seem to judge different aspects of an item - color, shape, and material"))
		delayTween.tween_callback(AddIntroDialogue.bind(2, "You will record their responses here which you can use as clues to find the correct item for the council", 0.0, true))
	if introSequence == 18:
		introSequence += 1
		var delayTween: Tween = create_tween()
		delayTween.tween_callback(AddIntroDialogue.bind(4, "With every item you present, you narrow down the correct object which will satisfy the council for the day, but be careful, something tells me they won’t give you more than three chances"))
		delayTween.tween_interval(0.5)
		delayTween.tween_callback(func (): introSequence += 1)
	if introSequence == 20:
		introSequence += 1
		var delayTween: Tween = create_tween()
		delayTween.tween_callback(AddIntroDialogue.bind(3, "The monkeys nod. they seem to love the Stuff. they let you stay for the night, but you have the sneaking suspicion that they are going to want more tomorrow….."))
		delayTween.tween_interval(0.5)
		delayTween.tween_callback(func (): introSequence += 1)
	if introSequence == 22:
		introSequence += 1
		HideIntroDialogue()
		var delayTween: Tween = create_tween()
		delayTween.tween_interval(0.5)
		delayTween.tween_callback(FadeBlack.bind(1.0, 2.0))
		delayTween.tween_callback(func(): intro = false)
		delayTween.tween_interval(2.0)
		delayTween.tween_callback(NewDay)

func NewDay():
	actualDay += 1
	DisplayDay()
	camRef.BackToStart()
	var delayTween: Tween = create_tween()
	delayTween.tween_interval(3.0)
	delayTween.tween_callback(FadeBlack.bind(0.0, 2.0))
	delayTween.tween_interval(2.0)
	delayTween.tween_callback(camRef.Approach)
	delayTween.tween_callback(DialogueMan.ins.NewDialogue.bind(5, "You find yourself in front of the Banana Republic yet again", 2.0))
	delayTween.tween_interval(3.5)
	delayTween.tween_callback(StartGame)

func StartGame():
	SpawnItems(5)
	ShowInventory()

func SpawnHat():
	var item = itemIns.instantiate() as Item
	item.SetData(itemList[7])
	Inventory.ins.AddItem(item)
	item.global_position = Inventory.ins.GetRandomBagPos() - (item.size / 2)
	wantedItem = item.data

func SpawnItems(amount: int):
	var noRepeat: Array[int]
	for i in amount:
		var item = itemIns.instantiate() as Item
		var rand = randi_range(0, itemList.size() - 1)
		while noRepeat.has(rand):
			rand = randi_range(0, itemList.size() - 1)
		noRepeat.append(rand)
		item.SetData(itemList[rand])
		Inventory.ins.AddItem(item)
		item.global_position = Inventory.ins.GetRandomBagPos() - (item.size / 2)
		wantedItem = item.data

func ResetInventory():
	Inventory.ins.ClearItems()
	Inventory.ins.ResetClues()

func SubmitItem(item: ItemData):
	HideIntroDialogue()
	submittedItem = item
	if intro && item == wantedItem && introSequence == 17 && currentDay == 0:
		if item == Inventory.ins.items[0].data:
			wantedItem = Inventory.ins.items[1].data
		else:
			wantedItem = Inventory.ins.items[0].data	
	HideInventory()
	currentDay += 1
	if currentDay > 3:
		return
	MonkeyScene()

func MonkeyScene():
	SFXPlayer.ins.PlaySound(2)
	var timeTween: Tween = create_tween()
	timeTween.tween_interval(4.0)
	timeTween.tween_callback(camRef.ZoomTo.bind(0.4, 2.0))
	timeTween.tween_callback(camRef.LookAt.bind(apePurple))
	timeTween.tween_interval(2.0)
	timeTween.tween_callback(SetApeYesNo.bind(apePurple, submittedItem.color == wantedItem.color))
	timeTween.tween_interval(1.0)
	timeTween.tween_callback(camRef.LookAt.bind(apePink))
	timeTween.tween_interval(2.0)
	timeTween.tween_callback(SetApeYesNo.bind(apePink, submittedItem.shape == wantedItem.shape))
	timeTween.tween_interval(1.0)
	timeTween.tween_callback(camRef.LookAt.bind(apeBlue))
	timeTween.tween_interval(2.0)
	timeTween.tween_callback(SetApeYesNo.bind(apeBlue, submittedItem.material == wantedItem.material))
	timeTween.tween_interval(1.0)
	timeTween.tween_callback(camRef.LookAt.bind(apeOrange))
	timeTween.tween_interval(2.0)
	timeTween.tween_callback(SetApeYesNo.bind(apeOrange, submittedItem.color == wantedItem.color && submittedItem.shape == wantedItem.shape && submittedItem.material == wantedItem.material))
	timeTween.tween_interval(1.0)
	timeTween.tween_callback(ApeDialogue)
	timeTween.tween_callback(camRef.ZoomTo.bind(1.0, 1.0))
	timeTween.tween_callback(camRef.LookAt)
	timeTween.tween_interval(2.0)

	timeTween.tween_callback(WhatNext)

func ApeDialogue():
	if submittedItem.color == wantedItem.color && submittedItem.shape == wantedItem.shape && submittedItem.material == wantedItem.material:
		DialogueMan.ins.NewDialogue(3, "The apes are happy", 1.0)
	else:
		DialogueMan.ins.NewDialogue(3, "The apes are angry", 1.0)

func WhatNext():
	apeOrange.animation = "default"
	apeBlue.animation = "default"
	apePurple.animation = "default"
	apePink.animation = "default"
	
	if submittedItem.color == wantedItem.color && submittedItem.shape == wantedItem.shape && submittedItem.material == wantedItem.material:
		currentDay = 0
		ResetInventory()
		if intro:
			introSequence += 1
			currentDay = 0
			ProgressIntro()
			return
		var delayTween: Tween = create_tween()
		delayTween.tween_interval(0.5)
		delayTween.tween_callback(FadeBlack.bind(1.0, 2.0))
		delayTween.tween_callback(NewDay)
	elif currentDay == 3:
		Lose()
	else:
		NextAttempt()

func Lose():
	pass

func NextAttempt():
	AddClue()
	ShowInventory()

func SetApeYesNo(ape: AnimatedSprite3D, yes: bool):
	if yes:
		ape.animation = "yes"
	else:
		ape.animation = "no"

func AddClue():
	Inventory.ins.AddClue(currentDay, submittedItem, submittedItem.color == wantedItem.color, submittedItem.shape == wantedItem.shape, submittedItem.material == wantedItem.material)

func ShowInventory():
	Inventory.ins.visible = true
	Inventory.ins.position = Vector2(0, Inventory.ins.size.y)
	var tween: Tween = create_tween()
	tween.tween_property(Inventory.ins, "position", Vector2(0, 0), 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_callback(func(): Inventory.ins.active = true)

func HideInventory():
	Inventory.ins.position = Vector2.ZERO
	Inventory.ins.active = false
	var tween: Tween = create_tween()
	tween.tween_property(Inventory.ins, "position", Vector2(0, Inventory.ins.size.y), 1.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)

func FadeBlack(value: float, dur: float):
	var tween: Tween = create_tween()
	tween.tween_property($Black, "modulate:a", value, dur)

func DisplayDay():
	$Black/Label.text = "Day " + str(actualDay)
	var tween: Tween = create_tween()
	tween.tween_property($Black/Label, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_interval(1.0)
	tween.tween_property($Black/Label, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)