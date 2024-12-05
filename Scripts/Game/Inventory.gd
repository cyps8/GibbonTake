class_name Inventory extends Panel

static var ins: Inventory

func _init():
	ins = self

var originalPos: Vector2

var grabbedItem: Item

var bagZone: Panel

var selectedCircle: Panel

var itemSelected: Item

var giveItemButton: Button

var description: Control
var descriptionName: Label
var descriptionDesc: Label

@export var ticks: Array[Texture2D]
@export var crosses: Array[Texture2D]

var clueStuff: Array[Node]

func _ready():
	bagZone = $Bag
	selectedCircle = $SelectedCircle
	giveItemButton = $GiveItem
	description = $Description
	descriptionName = $Description/Name
	descriptionDesc = $Description/Desc

	clueStuff = $Clues.get_children()

func ItemGrabbed(item: Node):
	grabbedItem = item
	originalPos = item.global_position
	move_child(grabbedItem, get_child_count() - 1)

func ItemDropped(_item: Node):
	var dropPos: Vector2 = get_global_mouse_position()
	if bagZone.get_rect().has_point(dropPos):
		if grabbedItem == itemSelected:
			itemSelected = null
	elif selectedCircle.get_rect().has_point(dropPos):
		grabbedItem.MoveTo(selectedCircle.global_position + (selectedCircle.size / 2) - (grabbedItem.size / 2))
		if itemSelected:
			itemSelected.MoveTo(originalPos)
		itemSelected = grabbedItem
	else:
		grabbedItem.MoveTo(originalPos)
	grabbedItem = null
		
func GiveItem():
	if itemSelected:
		Gameplay.ins.SubmitItem(itemSelected.data)
	itemSelected.queue_free()
	itemSelected = null
	$GiveItem/Confirm_Item.play()
func _process(_dt):
	if grabbedItem:
		grabbedItem.MoveTo(get_global_mouse_position() - (grabbedItem.size / 2))
	giveItemButton.disabled = itemSelected == null
	description.visible = itemSelected != null
	if itemSelected:
		descriptionName.text = itemSelected.data.name
		descriptionDesc.text = itemSelected.data.description

func GetRandomBagPos():
	return Vector2(randf_range(0, bagZone.size.x) + bagZone.global_position.x, randf_range(0, bagZone.size.y) + bagZone.global_position.y)

func AddClue(day: int, item: ItemData, color: bool, shape: bool, mat: bool):
	var offset: int = 0
	if day == 1:
		offset = 0
	elif day == 2:
		offset = 4
	elif day == 3:
		offset = 8

	clueStuff[offset].texture = item.icon
	if color:
		clueStuff[offset + 1].texture = ticks[randi_range(0, ticks.size() - 1)]
	else:
		clueStuff[offset + 1].texture = crosses[randi_range(0, crosses.size() - 1)]
	if shape:
		clueStuff[offset + 2].texture = ticks[randi_range(0, ticks.size() - 1)]
	else:
		clueStuff[offset + 2].texture = crosses[randi_range(0, crosses.size() - 1)]
	if mat:
		clueStuff[offset + 3].texture = ticks[randi_range(0, ticks.size() - 1)]
	else:
		clueStuff[offset + 3].texture = crosses[randi_range(0, crosses.size() - 1)]

func ResetClues():
	pass
