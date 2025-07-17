extends PointLight2D

# Este script é responsável por fazer a luz rodar em um item caso ele seja raro.
func _process(delta: float) -> void:
	self.rotation += delta * 0.5
