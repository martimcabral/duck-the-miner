extends Panel

var config = ConfigFile.new()
var file_path = "user://game_settings.cfg"

var key_name
var previous_keybutton
var change_keybind_of

func _ready():
	previous_keybutton = $ControlsPanel/NextKeyHandler
	
	config.load(file_path)
	if config.get_value("version", "current", "ERROR:384") != str("beta." + ProjectSettings.get_setting("application/config/version")):
		GameSettings.create_config_file()
	else:
		############# Display #############
		$DisplayPanel/WindowsTypeDropDown.selected = config.get_value("display", "windows_type")
		if config.get_value("display", "windows_type") == 0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			print("[options_menu.gd] Window Mode changed to: ", DisplayServer.window_get_mode())
		
		else: # Bordeless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			print("[options_menu.gd] Window Mode changed to: ", DisplayServer.window_get_mode())
		
		$DisplayPanel/WindowsSizeDropDown.selected = config.get_value("display", "windows_size")
		change_resolution(config.get_value("display", "windows_size"))
		
		if config.get_value("display", "vsync") == false:
			$DisplayPanel/VsyncCheckButton.button_pressed = false
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			print("[options_menu.gd] Vsync Disabled")
		else:
			$DisplayPanel/VsyncCheckButton.button_pressed = true
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			print("[options_menu.gd] Vsync Enabled")
		
		$DisplayPanel/FPSType.selected = config.get_value("display", "fps_limiter")
		
		var monitors = DisplayServer.get_screen_count()
		print("[options_menu.gd] Number of screens found: ", monitors)
		
		for monitor in monitors:
			$DisplayPanel/MonitorSelectorDropdown.add_item(str("Monitor: ", monitor), monitor)
		
		var selected_monitor = config.get_value("display", "monitor", 0)
		DisplayServer.window_set_current_screen(selected_monitor)
		$DisplayPanel/MonitorSelectorDropdown.selected = selected_monitor

		$DisplayPanel/BloomCheckButton.button_pressed = config.get_value("display", "bloom", true)
		$DisplayPanel/BiomeVisualEffectsCheckButton.button_pressed = config.get_value("display", "biome_visual_effects", true)

		############# Audio #############
		
		$AudioPanel/MasterVolumeSlider.value = config.get_value("audio", "master")
		$AudioPanel/MusicVolumeSlider.value = config.get_value("audio", "music")
		$AudioPanel/AmbientVolumeSlider.value = config.get_value("audio", "ambient")
		$AudioPanel/PlayerVolumeSlider.value = config.get_value("audio", "player")
		$AudioPanel/MenusVolumeSlider.value = config.get_value("audio", "menus")
		
		$AudioPanel/CurrentVolume.text = str(int(config.get_value("audio", "master")))
		$AudioPanel/CurrentMusicVolume.text = str(int(config.get_value("audio", "music")))
		$AudioPanel/CurrentAmbientVolume.text = str(int(config.get_value("audio", "ambient")))
		$AudioPanel/CurrentPlayerVolume.text = str(int(config.get_value("audio", "player")))
		$AudioPanel/CurrentMenusVolume.text = str(int(config.get_value("audio", "menus")))
		
		if config.get_value("audio", "master") == 0.0:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80.0)
			$AudioPanel/CurrentVolume.text = "0"
		if config.get_value("audio", "music") == 0.0:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80.0)
			$AudioPanel/CurrentMusicVolume.text = "0"
		if config.get_value("audio", "ambient") == 0.0:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ambient"), -80.0)
			$AudioPanel/CurrentAmbientVolume.text = "0"
		if config.get_value("audio", "player") == 0.0:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Player"), -80.0)
			$AudioPanel/CurrentPlayerVolume.text = "0"
		if config.get_value("audio", "menus") == 0.0:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Menus"), -80.0)
			$AudioPanel/CurrentMenusVolume.text = "0"
		
		############# Controls #############
		$ControlsPanel/FlyUpButton.text = config.get_value("controls", "Fly_Up")
		$ControlsPanel/FlyDownButton.text = config.get_value("controls", "Fly_Down")
		$ControlsPanel/WalkLeftButton.text = config.get_value("controls", "Walk_Left") 
		$ControlsPanel/WalkRightButton.text = config.get_value("controls", "Walk_Right")
		$ControlsPanel/RunButton.text = config.get_value("controls", "Run")
		$ControlsPanel/AgacharButton.text = config.get_value("controls", "Agachar")
		$ControlsPanel/DestroyBlockButton.text = config.get_value("controls", "Destroy_Block")
		$ControlsPanel/PauseMenuButton.text = config.get_value("controls", "PauseMenu")
		$ControlsPanel/QuackButton.text = config.get_value("controls", "Quack")
		$ControlsPanel/HideShowInventoryButton.text = config.get_value("controls", "Hide_Show_Inventory")
		$ControlsPanel/OpenFeedbackButton.text = config.get_value("controls", "Open_Feedback_Page")
		$ControlsPanel/UniverseZoomInButton.text = config.get_value("controls", "Universe_Zoom_In")
		$ControlsPanel/UniverseZoomOutButton.text = config.get_value("controls", "Universe_Zoom_Out")
		$ControlsPanel/UseFlashlightButton.text = config.get_value("controls", "Use_Item")
		
		############# Accessibility #############
		$AccessibilityPanel/ColorblindnessDropDown.selected = config.get_value("accessibility", "colorblindness")
		$AccessibilityPanel/LanguageDropDown.selected = config.get_value("accessibility", "language")
		$AccessibilityPanel/SubtitlesCheckButton.button_pressed = config.get_value("accessibility", "subtitles")
		$"../../ColorblindFilter".material.set_shader_parameter("mode", config.get_value("accessibility", "colorblindness"))
		$AccessibilityPanel/HighlightBlockSelectionCheckbox.button_pressed = config.get_value("accessibility", "highlight_block_selection")
		$AccessibilityPanel/ShowControlsCheckbox.button_pressed = config.get_value("accessibility", "show_controls")
		$AccessibilityPanel/HideBloodCheckbox.button_pressed = config.get_value("accessibility", "hide_blood")

func _on_back_button_pressed() -> void:
	$"../../../MouseSoundEffects".stream = load("res://sounds/effects/menus/back.ogg")
	$"../../../MouseSoundEffects".pitch_scale = 1
	$"../../../MouseSoundEffects".play()
	
	$DisplayPanel.visible = false
	$"../StartMenu".visible = true
	$".".visible = false
	$"../SplashTitleLabel".visible = true

func _on_windows_type_drop_down_item_selected(index: int) -> void:
	config.set_value("display", "windows_type", index)
	config.save(file_path)
	match index:
		0: # Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			print("[options_menu.gd] Window Mode changed to: ", DisplayServer.window_get_mode())
		1: # Bordeless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			print("[options_menu.gd] Window Mode changed to: ", DisplayServer.window_get_mode())
			
func _on_windows_size_drop_down_item_selected(index: int) -> void:
	config.set_value("display", "windows_size", index)
	config.save(file_path)
	change_resolution(index)

func _on_vsync_check_button_toggled(toggled_on: bool) -> void:
	match toggled_on:
		true:
			config.set_value("display", "vsync", toggled_on)
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			print("[options_menu.gd] Vsync Enabled")
		false:
			config.set_value("display", "vsync", toggled_on)
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			print("[options_menu.gd] Vsync Disabled")

func _on_fps_type_item_selected(index: int) -> void:
	config.set_value("display", "fps_limiter", index)
	config.save(file_path)
	match index:
		0: Engine.max_fps = -1
		1: Engine.max_fps = 360
		2: Engine.max_fps = 240
		3: Engine.max_fps = 165
		4: Engine.max_fps = 144
		5: Engine.max_fps = 120
		6: Engine.max_fps = 100
		7: Engine.max_fps = 75
		8: Engine.max_fps = 60
		9: Engine.max_fps = 45
		10: Engine.max_fps = 30
		11: Engine.max_fps = 15
		12: Engine.max_fps = 1

func _on_monitor_selector_dropdown_item_selected(index: int) -> void:
	DisplayServer.window_set_current_screen(index)
	config.set_value("display", "monitor", index)
	config.save(file_path)

func _on_display_button_pressed() -> void:
	$DisplayPanel.visible = true
	$AudioPanel.visible = false
	$ControlsPanel.visible = false
	$AccessibilityPanel.visible = false
	print("[options_menu.gd] ", get_viewport().get_visible_rect().size)
	if get_viewport().get_visible_rect().size == Vector2(1921, 1080):
		$DisplayPanel/WindowsSizeDropDown.selected = 2

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

func _on_accessebility_pressed() -> void:
	$DisplayPanel.visible = false
	$AudioPanel.visible = false
	$ControlsPanel.visible = false
	$AccessibilityPanel.visible = true

func change_resolution(index):
	match index:
		1: DisplayServer.window_set_size(Vector2i(2560, 1440))
		2: DisplayServer.window_set_size(Vector2i(1920, 1080))
		3: DisplayServer.window_set_size(Vector2i(1600, 900))
		4: DisplayServer.window_set_size(Vector2i(1360, 768))
		5: DisplayServer.window_set_size(Vector2i(1280, 720))
		6: DisplayServer.window_set_size(Vector2i(1024, 576))
		8: DisplayServer.window_set_size(Vector2i(2048, 1536))
		9: DisplayServer.window_set_size(Vector2i(1920, 1440))
		10: DisplayServer.window_set_size(Vector2i(1600, 1200))
		11: DisplayServer.window_set_size(Vector2i(1280, 960))
		12: DisplayServer.window_set_size(Vector2i(1024, 768))

func _on_master_volume_slider_value_changed(value: float) -> void:
	var db_value = convert_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db_value)
	$AudioPanel/CurrentVolume.text = str(int(value))
	config.set_value("audio", "master", value)
	config.save(file_path)

func _on_music_volume_slider_value_changed(value: float) -> void:
	var db_value = convert_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db_value)
	$AudioPanel/CurrentMusicVolume.text = str(int(value))
	config.set_value("audio", "music", value)
	config.save(file_path)

func _on_ambient_volume_slider_value_changed(value: float) -> void:
	var db_value = convert_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ambient"), db_value)
	$AudioPanel/CurrentAmbientVolume.text = str(int(value))
	config.set_value("audio", "ambient", value)
	config.save(file_path)

func _on_player_volume_slider_value_changed(value: float) -> void:
	var db_value = convert_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Player"), db_value)
	$AudioPanel/CurrentPlayerVolume.text = str(int(value))
	config.set_value("audio", "player", value)
	config.save(file_path)

func _on_menus_volume_slider_value_changed(value: float) -> void:
	var db_value = convert_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Menus"), db_value)
	$AudioPanel/CurrentMenusVolume.text = str(int(value))
	config.set_value("audio", "menus", value)
	config.save(file_path)

func convert_to_db(value: float) -> float:
	if value <= 0.0:
		return -80.0 # efetivamente silent
	return 20.0 * (log(value / 100.0) / log(10.0))

func _input(event):
	if (event is InputEventKey or event is InputEventJoypadButton) and event.pressed:
		key_name = event
		if change_keybind_of != null:
			InputMap.action_erase_events(change_keybind_of)
			InputMap.action_add_event(change_keybind_of, key_name)
			previous_keybutton.text = key_name.as_text()
			config.set_value("controls", change_keybind_of, key_name.as_text())
			config.save(file_path)
			change_keybind_of = null
			previous_keybutton = $ControlsPanel/NextKeyHandler
		
	elif event is InputEventMouseButton and event.pressed:
		var button_name = event
		if change_keybind_of != null:
			InputMap.action_erase_events(change_keybind_of)
			InputMap.action_add_event(change_keybind_of, button_name)
			
			match button_name.as_text():
				"Right Mouse Button": 
					previous_keybutton.text = "RMB"
					button_name = "RMB"
				"Left Mouse Button": 
					previous_keybutton.text = "LMB"
					button_name = "LMB"
				"Middle Mouse Button": 
					previous_keybutton.text = "MMB"
					button_name = "MMB"
				"Mouse Wheel Down": 
					previous_keybutton.text = "MWD"
					button_name = "MWD"
				"Mouse Wheel Up": 
					previous_keybutton.text = "MWU"
					button_name = "MWU"
			
			config.set_value("controls", change_keybind_of, button_name)
			config.save(file_path)
			change_keybind_of = null
			previous_keybutton = $ControlsPanel/NextKeyHandler

func _on_fly_up_button_pressed() -> void:
	previous_keybutton = $ControlsPanel/FlyUpButton
	change_keybind_of = "Fly_Up"
	previous_keybutton.text = "..."

func _on_fly_down_button_pressed() -> void:
	previous_keybutton = $ControlsPanel/FlyDownButton
	change_keybind_of = "Fly_Down"
	previous_keybutton.text = "..."

func _on_walk_left_button_pressed() -> void:
	previous_keybutton = $ControlsPanel/WalkLeftButton
	change_keybind_of = "Walk_Left"
	previous_keybutton.text = "..."

func _on_walk_right_button_pressed() -> void:
	previous_keybutton = $ControlsPanel/WalkRightButton
	change_keybind_of = "Walk_Right"
	previous_keybutton.text = "..."

func _on_run_button_pressed() -> void:
	previous_keybutton = $ControlsPanel/RunButton
	change_keybind_of = "Run"
	previous_keybutton.text = "..."

func _on_agachar_button_pressed() -> void:
	previous_keybutton = $ControlsPanel/AgacharButton
	change_keybind_of = "Agachar"
	previous_keybutton.text = "..."

func _on_destroy_block_button_pressed() -> void:
	previous_keybutton = $ControlsPanel/DestroyBlockButton
	change_keybind_of = "Destroy_Block"
	previous_keybutton.text = "..."

func _on_place_torch_button_pressed() -> void:
	previous_keybutton = $ControlsPanel/PlaceTorchButton
	change_keybind_of = "Place_Torch"
	previous_keybutton.text = "..."

func _on_place_block_button_pressed() -> void:
	previous_keybutton = $ControlsPanel/PlaceBlockButton
	change_keybind_of = "Place_Block"
	previous_keybutton.text = "..."

func _on_pause_menu_button_pressed() -> void:
	previous_keybutton = $ControlsPanel/PauseMenuButton
	change_keybind_of = "PauseMenu"
	previous_keybutton.text = "..."

func _on_quack_button_pressed() -> void:
	previous_keybutton = $ControlsPanel/QuackButton
	change_keybind_of = "Quack"
	previous_keybutton.text = "..."

func _on_hide_show_inventory_button_pressed() -> void:
	previous_keybutton = $ControlsPanel/HideShowInventoryButton
	change_keybind_of = "Hide_Show_Inventory"
	previous_keybutton.text = "..."

func _on_open_feedback_button_pressed() -> void:
	previous_keybutton = $ControlsPanel/OpenFeedbackButton
	change_keybind_of = "Open_Feedback_Page"
	previous_keybutton.text = "..."

func _on_universe_zoom_in_button_pressed() -> void:
	previous_keybutton = $ControlsPanel/UniverseZoomInButton
	change_keybind_of = "Universe_Zoom_In"
	previous_keybutton.text = "..."

func _on_universe_zoom_out_button_pressed() -> void:
	previous_keybutton = $ControlsPanel/UniverseZoomOutButton
	change_keybind_of = "Universe_Zoom_Out"
	previous_keybutton.text = "..."

func _on_use_flashlight_button_pressed() -> void:
	previous_keybutton = $ControlsPanel/UseFlashlightButton
	change_keybind_of = "Use_Item"
	previous_keybutton.text = "..."

func _on_bloom_check_button_toggled(toggled_on: bool) -> void:
		config.set_value("display", "bloom", toggled_on)
		config.save(file_path)
		print("[options_menu.gd] Bloom Enabled")

func _on_colorblindness_drop_down_item_selected(index: int) -> void:
	$"../../ColorblindFilter".material.set_shader_parameter("mode", index)
	config.set_value("accessibility", "colorblindness", index)
	config.save(file_path)

func _on_language_drop_down_item_selected(index: int) -> void:
	config.set_value("accessibility", "language", index)
	config.save(file_path)

func _on_subtitles_check_button_toggled(toggled_on: bool) -> void:
	config.set_value("accessibility", "subtitles", toggled_on)
	config.save(file_path)

func _on_highlight_block_selection_checkbox_toggled(toggled_on: bool) -> void:
	config.set_value("accessibility", "highlight_block_selection", toggled_on)
	config.save(file_path)

func _on_biome_visual_effects_check_button_toggled(toggled_on: bool) -> void:
	config.set_value("display", "biome_visual_effects", toggled_on)
	config.save(file_path)

func _on_show_controls_checkbox_toggled(toggled_on: bool) -> void:
	config.set_value("accessibility", "show_controls", toggled_on)
	config.save(file_path)

func _on_hide_blood_checkbox_toggled(toggled_on: bool) -> void:
	config.set_value("accessibility", "hide_blood", toggled_on)
	config.save(file_path)
