extends AnimatedSprite3D

var rng = RandomNumberGenerator.new()
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_animation_changed() -> void:
	if  $".".animation == "yes":
		SFXPlayer.ins.PlaySound(randi_range(6, 7))
	elif $".".animation == "no":
		SFXPlayer.ins.PlaySound(8)
