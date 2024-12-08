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

func _ready():
	camRef = $Camera

	apeOrange = $Apes/Orange
	apeBlue = $Apes/Blue
	apePurple = $Apes/Purple
	apePink = $Apes/Pink

	Inventory.ins.visible = false
	currentDay = 0
	camRef.Approach()
	var delayTween: Tween = create_tween()
	delayTween.tween_interval(2.0)
	delayTween.tween_callback(SpawnItems.bind(3))
	delayTween.tween_callback(ShowInventory)

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
	submittedItem = item
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
	timeTween.tween_callback(camRef.ZoomTo.bind(1.0, 1.0))
	timeTween.tween_callback(camRef.LookAt)
	timeTween.tween_interval(2.0)

	timeTween.tween_callback(WhatNext)

func WhatNext():
	apeOrange.animation = "default"
	apeBlue.animation = "default"
	apePurple.animation = "default"
	apePink.animation = "default"
	
	if submittedItem.color == wantedItem.color && submittedItem.shape == wantedItem.shape && submittedItem.material == wantedItem.material:
		currentDay = 0
		ResetInventory()
		SpawnItems(10)
		ShowInventory()
	elif currentDay == 3:
		return # Lose
	else:
		NextAttempt()

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
