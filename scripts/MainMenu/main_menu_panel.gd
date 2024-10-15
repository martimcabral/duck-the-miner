extends Panel

var WHITE : Color = "ffffff"
var GOLD : Color = "F9B53F"

func _on_exit_button_pressed() -> void:
	print("[!] Autodestruction Activated - Duck Rule #134 // When using weapons of destruction of simulations, make sure you are the one who is simulating!")
	get_tree().quit()

func _on_exit_button_mouse_entered() -> void:
	$Exit.set("theme_override_colors/default_color", GOLD)

func _on_exit_button_mouse_exited() -> void:
	$Exit.set("theme_override_colors/default_color", WHITE)

func _on_new_game_button_pressed() -> void:
	var new_game = preload("res://scenes/world.tscn")
	get_tree().change_scene_to_packed(new_game)

func _on_new_game_button_mouse_entered() -> void:
	$NewGame.set("theme_override_colors/default_color", GOLD)

func _on_new_game_button_mouse_exited() -> void:
	$NewGame.set("theme_override_colors/default_color", WHITE)
