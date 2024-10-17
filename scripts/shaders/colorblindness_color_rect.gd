extends ColorRect

func _on_colorblindness_dropdown_item_selected(index: int) -> void:
	self.color = Color(1, 1, 1, 0)
	var shader_material = self.material as ShaderMaterial
	# Set mode (0 = Normal, 1 = Deuteranopia, 2 = Protanopia, 3 = Tritanopia, 4 = Achromatopsia)
	
	match index:
		0:
			shader_material.set_shader_parameter("mode", 0)
		1:
			shader_material.set_shader_parameter("mode", 1)
		2:
			shader_material.set_shader_parameter("mode", 2)
		3:
			shader_material.set_shader_parameter("mode", 3)
		4:
			shader_material.set_shader_parameter("mode", 4)
