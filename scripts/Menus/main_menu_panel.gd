extends Panel

func _on_exit_button_pressed() -> void:
	print("[!] Autodestruction Activated - Duck Rule #134 // When using destructive weapons in simulations, make sure you're the one simulating!")
	get_tree().quit()

func _on_options_button_pressed() -> void:
	$".".visible = false
	$"../OptionsMenu".visible = true

func _on_new_game_button_pressed() -> void:
	# Carregar a Cena
	var new_game_scene = preload("res://scenes/world.tscn")
	
	# Buscar a Variavel
	var colorblindness_value = $"../../ColorblindnessColorRect".material.get_shader_parameter("mode")
	
	# Mudar de Cena
	get_tree().change_scene_to_packed(new_game_scene)
	
	# Mandar a variavel pa la
	var new_game_instance = new_game_scene.instantiate()
	new_game_instance.set_colorblindness_value(colorblindness_value)


func _on_credits_button_pressed() -> void:
	$".".visible = false
	$"../CreditsMenu".visible = true

func _on_back_button_pressed() -> void:
	$".".visible = true
	$"../CreditsMenu".visible = false
