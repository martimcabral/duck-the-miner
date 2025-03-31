extends Label

var speed: float = 40.0 
var direction: int = -1  # -1 = Left, 1 = Right
var min_x: float = 0.0
var max_x: float = 0.0

func _process(delta):
	max_x = get_parent().size.x - size.x
	position.x += direction * speed * delta
	if position.x <= max_x or position.x >= 0: direction *= -1
