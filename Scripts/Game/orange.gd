extends AnimatedSprite3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_animation_changed() -> void:
	if  $".".animation == "yes":
		SFXPlayer.ins.PlaySound(4)
	elif $".".animation == "no":
		SFXPlayer.ins.PlaySound(5)
	
