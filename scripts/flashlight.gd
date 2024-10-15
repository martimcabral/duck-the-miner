extends PointLight2D

@onready var player = $".."

var flashlight : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("Place_Torch") and $"..".current_item == 4:
		match (flashlight):
			true:
				$".".energy = 0
				flashlight = false
			false:
				$".".energy = 1.75
				flashlight = true
