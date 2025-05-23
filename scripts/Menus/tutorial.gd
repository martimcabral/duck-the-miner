extends Control

var speed : float = 70.0

func _process(delta: float) -> void:
	$"WallPattern1-1".position.y += speed * delta
	$"WallPattern2-1".position.y += speed * delta
