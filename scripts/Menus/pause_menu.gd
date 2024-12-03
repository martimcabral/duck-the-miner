extends Node2D

var pause_menu_visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("PauseMenu"):
		match pause_menu_visible:
			false:
				pause_menu_visible = true
				$GUI_Pause.visible = pause_menu_visible
			true:
				pause_menu_visible = false
				$GUI_Pause.visible = pause_menu_visible

func _on_continue_pressed() -> void:
	$GUI_Pause.visible = false
	pause_menu_visible = false

func _on_go_to_main_menu_button_pressed() -> void:
	Input.set_custom_mouse_cursor(null)
	var new_game_scene = load("res://scenes/lobby.tscn")
	get_tree().change_scene_to_packed(new_game_scene)
	new_game_scene.instantiate()

func _on_go_to_desktop_button_pressed() -> void:
	get_tree().quit()

func _on_feedback_button_pressed() -> void:
	OS.shell_open("https://sr-patinho.itch.io/duck-the-miner")
