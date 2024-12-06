class_name Gameplay extends CanvasLayer

static var ins: Gameplay

func _init():
	ins = self

@export var itemIns: PackedScene

@export var itemList: Array[ItemData]

var wantedItem: ItemData

var submittedItem: ItemData

var currentDay: int

func _ready():
	currentDay = 0
	SpawnItems(10)

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
	var tween: Tween = create_tween()
	tween.tween_property(Inventory.ins, "position", Vector2(0, 0), 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func HideInventory():
	var tween: Tween = create_tween()
	tween.tween_property(Inventory.ins, "position", Vector2(0, Inventory.ins.size.y), 0.8).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)


func _on_clues_ready() -> void:
	$c/Music_Beach.play()
