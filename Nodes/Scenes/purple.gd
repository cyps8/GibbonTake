extends AnimatedSprite3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_changed() -> void:
	if  $".".animation == "yes":
		SFXPlayer.ins.PlaySound(randi_range(9, 10))
	elif $".".animation == "no":
		SFXPlayer.ins.PlaySound(randi_range(11, 12))
