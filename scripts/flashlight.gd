extends PointLight2D

var flashlight : bool = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("Use_Flashlight"):
		match (flashlight):
			true:
				$".".energy = 0
				flashlight = false
			false:
				$".".energy = 1
				flashlight = true
