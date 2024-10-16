extends Panel

func _on_exit_button_pressed() -> void:
	print("[!] Autodestruction Activated - Duck Rule #134 // When using destructive weapons in simulations, make sure you're the one simulating!")
	get_tree().quit()

func _on_options_button_pressed() -> void:
	$".".visible = false
	$"../OptionsMenu".visible = true

func _on_new_game_button_pressed() -> void:
	var new_game = preload("res://scenes/world.tscn")
	get_tree().change_scene_to_packed(new_game)
