extends Panel

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_options_button_pressed() -> void:
	$".".visible = false
	$"../OptionsMenu".visible = true

func _on_new_game_button_pressed() -> void: 
	$"../../../MouseSoundEffects".stream = load("res://sounds/sound_effects/play.ogg")
	$"../../../MouseSoundEffects".play()
	
	$NewGameButton.text = "Loading..."
	$OptionsButton.visible = false
	$CreditsButton.visible = false
	$ExitButton.visible = false
	$Line2D.visible = false
	$".".size = Vector2i(373, 127)
	$".".position = Vector2i(774, 500)
	
	$"../../../MouseSoundEffects/TimeToPlay".start()

func _on_credits_button_pressed() -> void:
	$".".visible = false
	$"../CreditsMenu".visible = true

func _on_back_button_pressed() -> void:
	$"../../../MouseSoundEffects".stream = load("res://sounds/sound_effects/back.ogg")
	$"../../../MouseSoundEffects".play()
	
	$".".visible = true
	$"../CreditsMenu".visible = false

func _on_time_to_play_timeout() -> void:
	get_tree().change_scene_to_packed(load("res://scenes/lobby.tscn"))
