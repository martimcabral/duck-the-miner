extends Panel

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_options_button_pressed() -> void:
	$".".visible = false
	$"../OptionsMenu".visible = true

func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://scenes/lobby.tscn"))

func _on_credits_button_pressed() -> void:
	$".".visible = false
	$"../CreditsMenu".visible = true

func _on_back_button_pressed() -> void:
	$".".visible = true
	$"../CreditsMenu".visible = false
