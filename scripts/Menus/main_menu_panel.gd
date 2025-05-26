extends Panel

var tutorial_path : String = "user://tutorial.cfg"
var tutorial_config : ConfigFile = ConfigFile.new()

func _ready() -> void:
	$".".visible = true
	$"../SaveFilesMenu".visible = false
	$"../OptionsMenu".visible = false
	$"../CreditsMenu".visible = false

func _process(_delta: float) -> void:
	tutorial_config.load(tutorial_path)
	if tutorial_config.get_value("tutorial", "done") == true:
		$TutorialRichLabel.text = "[center]Tutorial[/center]"
		$NewGameButton.text = "[wave amp=35.0 freq=5.0 connected=1][center]Play[/center]"
	else:
		$TutorialRichLabel.text = "[wave amp=35.0 freq=5.0 connected=1][center]Tutorial[/center]"
		$NewGameButton.text = "[center]Play[/center]"

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT):
			if $TutorialRichLabel.get_theme_color("default_color") == Color("f9b53f"): $"../TutorialPlayer".play("start")
			if $NewGameButton.get_theme_color("default_color") == Color("f9b53f"): new_game_button_pressed()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_options_button_pressed() -> void:
	$".".visible = false
	$"../OptionsMenu".visible = true
	$"../SplashTitleLabel".visible = false

func new_game_button_pressed(): 
	$"../../../MouseSoundEffects".stream = load("res://sounds/effects/menus/play.ogg")
	$"../../../MouseSoundEffects".pitch_scale = 1
	$"../../../MouseSoundEffects".play()
	$".".visible = false
	$"../SaveFilesMenu".visible = true
	$"../SplashTitleLabel".visible = false

func _on_credits_button_pressed() -> void:
	$".".visible = false
	$"../CreditsMenu".visible = true
	$"../SplashTitleLabel".visible = false

func _on_back_button_pressed() -> void:
	$"../../../MouseSoundEffects".stream = load("res://sounds/effects/menus/back.ogg")
	$"../../../MouseSoundEffects".pitch_scale = 1
	$"../../../MouseSoundEffects".play()
	
	$".".visible = true
	$"../CreditsMenu".visible = false
	$"../SplashTitleLabel".visible = true

func _on_play_button_pressed() -> void:
	$".".visible = false 
	$"../SaveFilesMenu".visible = false
	$"../OptionsMenu".visible = false 
	$"../CreditsMenu".visible = false
	
	$"../LoadingPanel".visible = true
	$"../../../TimeToPlay".start()

func _on_time_to_play_timeout() -> void:
	if DirAccess.dir_exists_absolute(str("user://save/", GetSaveFile.save_being_used, "/new")):
		DirAccess.remove_absolute(str("user://save/", GetSaveFile.save_being_used, "/new"))
		get_tree().change_scene_to_packed(load("res://scenes/cutscenes/intro.tscn"))
	else:
		get_tree().change_scene_to_packed(load("res://scenes/lobby.tscn"))

func _on_rich_text_label_mouse_entered() -> void:
	$TutorialRichLabel.add_theme_color_override("default_color", Color("f9b53f"))

func _on_rich_text_label_mouse_exited() -> void:
	$TutorialRichLabel.add_theme_color_override("default_color", Color.WHITE)

func _on_new_game_button_mouse_entered() -> void:
	$NewGameButton.add_theme_color_override("default_color", Color("f9b53f"))

func _on_new_game_button_mouse_exited() -> void:
	$NewGameButton.add_theme_color_override("default_color", Color.WHITE)

func _on_button_pressed() -> void:
	$"../TutorialPlayer".play("go_away")
	tutorial_config.set_value("tutorial", "done", true)
	tutorial_config.save(tutorial_path)
