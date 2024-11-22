extends PointLight2D

func _process(delta: float) -> void:
	self.rotation += delta * 0.5
