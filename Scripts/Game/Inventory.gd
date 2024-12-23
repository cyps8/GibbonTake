class_name Inventory extends Panel

static var ins: Inventory

func _init():
	ins = self

var originalPos: Vector2

var grabbedItem: Item

var bagZone: Panel

var spawnZone: Panel

var selectedCircle: Panel

var itemSelected: Item

var giveItemButton: Button

var description: Control
var descriptionName: Label
var descriptionDesc: Label

var items: Array[TextureButton]

@export var ticks: Array[Texture2D]
@export var crosses: Array[Texture2D]

var clueStuff: Array[Node]

var active: bool

func _ready():
	bagZone = $Bag
	spawnZone = $SpawnZone
	selectedCircle = $SelectedCircle
	giveItemButton = $GiveItem
	description = $Description
	descriptionName = $Description/Name
	descriptionDesc = $Description/Desc

	clueStuff = $Clues.get_children()

func AddItem(item: Item):
	items.append(item)
	add_child(item)

func ItemGrabbed(item: Node):
	grabbedItem = item
	if HasPoint(bagZone, item.global_position + (item.size / 2)) || HasPoint(selectedCircle, item.global_position + (item.size / 2)):
		originalPos = item.global_position
		print ("new original pos: " + str(originalPos))
	move_child(grabbedItem, get_child_count() - 1)

func ItemDropped(_item: Node):
	if !grabbedItem:
		return
	var dropPos: Vector2 = get_global_mouse_position()
	if bagZone.get_global_rect().has_point(dropPos):
		if grabbedItem == itemSelected:
			itemSelected = null
	elif selectedCircle.get_global_rect().has_point(dropPos):
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
		SFXPlayer.ins.PlaySound(1)
	items.erase(itemSelected)
	itemSelected.queue_free()
	itemSelected = null

func _process(_dt):
	if grabbedItem:
		grabbedItem.MoveTo(get_global_mouse_position() - (grabbedItem.size / 2))
	giveItemButton.disabled = itemSelected == null
	description.visible = itemSelected != null
	if itemSelected:
		descriptionName.text = itemSelected.data.name
		descriptionDesc.text = itemSelected.data.description

func GetRandomBagPos():
	return Vector2(randf_range(0, spawnZone.size.x) + spawnZone.global_position.x, randf_range(0, spawnZone.size.y) + spawnZone.global_position.y)

func HasPoint(zone: Control, pos: Vector2):
	print(zone.get_global_rect())
	if pos.x < zone.global_position.x || pos.x > zone.global_position.x + zone.size.x || pos.y < zone.global_position.y || pos.y > zone.global_position.y + zone.size.y:
		return false
	return true

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

func ClearItems():
	while items.size() > 0:
		items[0].queue_free()
		items.remove_at(0)

func ResetClues():
	for clue in clueStuff:
		clue.texture = null
