extends Panel

func _process(_delta: float) -> void:
	$AudioPanel/CurrentVolume.text = str($AudioPanel/VolumeSlider.ratio * 100)

func _on_back_button_pressed() -> void:
	$DisplayPanel.visible = false
	$"../StartMenu".visible = true
	$".".visible = false

func _on_display_button_pressed() -> void:
	$DisplayPanel.visible = true
	$AudioPanel.visible = false
	$ControlsPanel.visible = false
	$AccessibilityPanel.visible = false
	print(get_viewport().get_visible_rect().size)
	if get_viewport().get_visible_rect().size == Vector2(1921, 1080):
		$DisplayPanel/WindowsSizeDropDown.selected = 2

func _on_windows_type_drop_down_item_selected(index: int) -> void:
	match index:
		0: # Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			print("Window Mode changed to: ", DisplayServer.window_get_mode())
		1: # Bordeless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
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
			

func _on_vsync_check_button_toggled(toggled_on: bool) -> void:
	match toggled_on:
		true:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			print("Vsync Enabled")
		false:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			print("Vsync Disabled")


func _on_fps_type_item_selected(index: int) -> void:
	match index:
		0:
			Engine.max_fps = -1
		1:
			Engine.max_fps = 360
		2:
			Engine.max_fps = 240
		3:
			Engine.max_fps = 165
		4:
			Engine.max_fps = 144
		5: 
			Engine.max_fps = 120
		6:
			Engine.max_fps = 100
		7:
			Engine.max_fps = 75
		8:
			Engine.max_fps = 60
		9:
			Engine.max_fps = 45
		10:
			Engine.max_fps = 30
		11:
			Engine.max_fps = 15
		12:
			Engine.max_fps = 1
	

func _on_audio_button_pressed() -> void:
	$DisplayPanel.visible = false
	$AudioPanel.visible = true
	$ControlsPanel.visible = false
	$AccessibilityPanel.visible = false

func _on_controls_button_pressed() -> void:
	$DisplayPanel.visible = false
	$AudioPanel.visible = false
	$ControlsPanel.visible = true
	$AccessibilityPanel.visible = false

func _on_accessibility_button_pressed() -> void:
	$DisplayPanel.visible = false
	$AudioPanel.visible = false
	$ControlsPanel.visible = false
	$AccessibilityPanel.visible = true
