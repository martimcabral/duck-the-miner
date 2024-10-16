extends Panel

func _on_back_button_pressed() -> void:
	$DisplayPanel.visible = false
	$"../StartMenu".visible = true
	$".".visible = false

func _on_display_button_pressed() -> void:
	$DisplayPanel.visible = true
	if get_viewport().get_visible_rect().size == Vector2(1920, 1080):
		$DisplayPanel/WindowsSizeDropDown.selected = 2

func _on_windows_type_drop_down_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			print("Window Mode changed to: ", DisplayServer.window_get_mode())
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			print("Window Mode changed to: ", DisplayServer.window_get_mode())

func _on_windows_size_drop_down_item_selected(index: int) -> void:
	match index:
		1:
			DisplayServer.window_set_size(Vector2i(2560, 1440))
			print("Resolution Changed to: ", DisplayServer.window_get_size())

		2:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
			print("Resolution Changed to: ", DisplayServer.window_get_size())

		3:
			DisplayServer.window_set_size(Vector2i(1600, 900))
			print("Resolution Changed to: ", DisplayServer.window_get_size())
		4:
			DisplayServer.window_set_size(Vector2i(1360, 768))
			print("Resolution Changed to: ", DisplayServer.window_get_size())
		5:
			DisplayServer.window_set_size(Vector2i(1280, 720))
			print("Resolution Changed to: ", DisplayServer.window_get_size())
		6:
			DisplayServer.window_set_size(Vector2i(1024, 576))
			print("Resolution Changed to: ", DisplayServer.window_get_size())
		8:
			DisplayServer.window_set_size(Vector2i(2048, 1536))
			print("Resolution Changed to: ", DisplayServer.window_get_size())
		9:
			DisplayServer.window_set_size(Vector2i(1920, 1440))
			print("Resolution Changed to: ", DisplayServer.window_get_size())
		10:
			DisplayServer.window_set_size(Vector2i(1600, 1200))
			print("Resolution Changed to: ", DisplayServer.window_get_size())
		11:
			DisplayServer.window_set_size(Vector2i(1280, 960))
			print("Resolution Changed to: ", DisplayServer.window_get_size())
		12:
			DisplayServer.window_set_size(Vector2i(1024, 768))
			print("Resolution Changed to: ", DisplayServer.window_get_size())
			
