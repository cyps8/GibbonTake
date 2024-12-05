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
	for i in amount:
		var item = itemIns.instantiate() as Item
		item.SetData(itemList[randi_range(0, itemList.size() - 1)])
		item.global_position = Inventory.ins.GetRandomBagPos() - (item.size / 2)
		Inventory.ins.add_child(item)
		wantedItem = item.data

func SubmitItem(item: ItemData):
	submittedItem = item
	currentDay += 1
	if currentDay > 3:
		return
	Inventory.ins.AddClue(currentDay, item, item.color == wantedItem.color, item.shape == wantedItem.shape, item.material == wantedItem.material)


func _on_clues_ready() -> void:
	$c/Music_Beach.play()
