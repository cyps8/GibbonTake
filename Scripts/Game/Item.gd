class_name Item extends TextureButton

@export var data: ItemData

var moveTween: Tween

func Grab():
	if moveTween != null:
		moveTween.kill()
	Inventory.ins.ItemGrabbed(self)

func Drop():
	Inventory.ins.ItemDropped(self)

func SetData(setData: ItemData):
	data = setData
	texture_normal = data.icon
	tooltip_text = data.name
	GenerateClickMask()

func GenerateClickMask():
	var img = texture_normal.get_image()
	var imgData = img
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(imgData)
	texture_click_mask = bitmap

func MoveTo(pos: Vector2):
	if moveTween != null:
		moveTween.kill()
	moveTween = create_tween()
	moveTween.tween_property(self, "global_position", pos, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
