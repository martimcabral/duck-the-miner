extends Panel

func _ready() -> void:
	$".".visible = true
	$"../SaveFilesMenu".visible = false
	$"../OptionsMenu".visible = false
	$"../CreditsMenu".visible = false

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_options_button_pressed() -> void:
	$".".visible = false
	$"../OptionsMenu".visible = true

func _on_new_game_button_pressed() -> void: 
	$"../../../MouseSoundEffects".stream = load("res://sounds/sound_effects/play.ogg")
	$"../../../MouseSoundEffects".pitch_scale = 1
	$"../../../MouseSoundEffects".play()
	$".".visible = false
	$"../SaveFilesMenu".visible = true

func _on_credits_button_pressed() -> void:
	$".".visible = false
	$"../CreditsMenu".visible = true

func _on_back_button_pressed() -> void:
	$"../../../MouseSoundEffects".stream = load("res://sounds/sound_effects/back.ogg")
	$"../../../MouseSoundEffects".pitch_scale = 1
	$"../../../MouseSoundEffects".play()
	
	$".".visible = true
	$"../CreditsMenu".visible = false


func _on_play_button_pressed() -> void:
	set_loading_screen()

func set_loading_screen():
	$".".visible = false 
	$"../SaveFilesMenu".visible = false
	$"../OptionsMenu".visible = false 
	$"../CreditsMenu".visible = false
	
	$"../LoadingPanel".visible = true
	
	$"../../../TimeToPlay".start()
	
func _on_time_to_play_timeout() -> void:
	get_tree().change_scene_to_packed(load("res://scenes/lobby.tscn"))
