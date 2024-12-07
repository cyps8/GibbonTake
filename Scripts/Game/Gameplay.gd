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

var apeOrange: Sprite3D

var apeBlue: Sprite3D

var apePurple: Sprite3D

var apePink: Sprite3D

func _ready():
	camRef = $Camera

	apeOrange = $Apes/Orange
	apeBlue = $Apes/Blue
	apePurple = $Apes/Purple
	apePink = $Apes/Pink

	Inventory.ins.visible = false
	currentDay = 0
	camRef.Approach()
	var delayTween: Tween = create_tween().set_loops()
	delayTween.tween_interval(2.0)
	delayTween.tween_callback(camRef.ZoomTo.bind(0.6))
	delayTween.tween_callback(camRef.LookAt.bind(apeOrange))
	delayTween.tween_interval(2.0)
	delayTween.tween_callback(camRef.LookAt.bind(apeBlue))
	delayTween.tween_interval(2.0)
	delayTween.tween_callback(camRef.LookAt.bind(apePurple))
	delayTween.tween_interval(2.0)
	delayTween.tween_callback(camRef.LookAt.bind(apePink))
	#SpawnItems(10)

func SpawnItems(amount: int):
	var noRepeat: Array[int]
	for i in amount:
		var item = itemIns.instantiate() as Item
		var rand = randi_range(0, itemList.size() - 1)
		while noRepeat.has(rand):
			rand = randi_range(0, itemList.size() - 1)
		noRepeat.append(rand)
		item.SetData(itemList[rand])
		item.global_position = Inventory.ins.GetRandomBagPos() - (item.size / 2)
		Inventory.ins.add_child(item)
		wantedItem = item.data

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
	timeTween.tween_interval(5.0)
	timeTween.tween_callback(AddClue)
	timeTween.tween_callback(ShowInventory)

func AddClue():
	Inventory.ins.AddClue(currentDay, submittedItem, submittedItem.color == wantedItem.color, submittedItem.shape == wantedItem.shape, submittedItem.material == wantedItem.material)

func ShowInventory():
	Inventory.ins.position = Vector2(0, Inventory.ins.size.y)
	var tween: Tween = create_tween()
	tween.tween_property(Inventory.ins, "position", Vector2(0, 0), 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func HideInventory():
	Inventory.ins.position = Vector2.ZERO
	var tween: Tween = create_tween()
	tween.tween_property(Inventory.ins, "position", Vector2(0, Inventory.ins.size.y), 0.8).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)