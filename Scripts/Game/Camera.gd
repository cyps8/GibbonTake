extends Camera3D

@export var spawnPos: Vector3

@export var standPos: Vector3

var forward: Vector3 = Vector3(0, 90, 0)

var forwardNode: Node3D

var lookingAt: Node3D

var dt: float

var currentRotation: Vector3

var headBob: Tween

var currentZoom: float = 1.0

func _ready():
	forwardNode = $Forward
	lookingAt = forwardNode
	position = spawnPos
	currentRotation = forward

func BackToStart():
	position = spawnPos

func _process(_dt):
	dt = _dt
	rotation_degrees = currentRotation
	LookTowards(lookingAt, 1.0)
	currentRotation = rotation_degrees
	var mousePos: Vector2 = get_viewport().get_mouse_position()
	var xoff: float = (mousePos.x - get_viewport().size.x/2)/get_viewport().size.x
	var yoff: float = (mousePos.y - get_viewport().size.y/2)/get_viewport().size.y
	rotation_degrees = currentRotation + Vector3(-5 * yoff * currentZoom, -5 * xoff * currentZoom, 0)

func ZoomTo(zoomLevel: float, zoomTime: float):
	var newFOV: float = zoomLevel * 75.0
	var tween: Tween = create_tween()
	tween.tween_property(self, "fov", newFOV, zoomTime).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel()
	tween.tween_method(func(val: float): currentZoom = val, currentZoom, zoomLevel, zoomTime).set_trans(Tween.TRANS_LINEAR)

func Approach():
	var animdDur: float = 1.5
	var tween: Tween = create_tween()
	tween.tween_property(self, "position:x", standPos.x, animdDur).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	if headBob != null:
		headBob.kill()
	var bounce: Tween = create_tween()
	bounce.tween_property(self, "position:y", position.y + 0.2, animdDur/4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	bounce.tween_property(self, "position:y", standPos.y, animdDur/4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	bounce.tween_property(self, "position:y", position.y + 0.2, animdDur/4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	bounce.tween_property(self, "position:y", standPos.y, animdDur/4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	bounce.tween_callback(HeadBob)

func HeadBob():
	headBob = create_tween().set_loops()
	headBob.tween_property(self, "position:y", position.y + 0.1, 1.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	headBob.tween_property(self, "position:y", standPos.y, 1.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

func LookAt(node: Node3D = null):
	lookingAt = node
	if node == null:
		forward = Vector3(0, 90, 0)
		lookingAt = forwardNode
	else:
		forward = LookTowards(node, 0, true)

func LookTowards(vector, smoothSpeed = 1.5, returnOnly = false):
	var smooth = smoothSpeed != 0
	if vector is Object:
		vector = vector.global_transform.origin
	var looker = Node3D.new()
	add_child(looker)
	looker.look_at(vector, Vector3.UP)
	var finalRot = rotation_degrees + looker.rotation_degrees
	if returnOnly == true:
		return finalRot
	elif smooth == false:
		rotation_degrees = finalRot
	else:
		looker.look_at(vector, Vector3.UP)
		finalRot = rotation_degrees + looker.rotation_degrees
		rotation_degrees = lerp(rotation_degrees, finalRot, dt * smoothSpeed)
	looker.queue_free()