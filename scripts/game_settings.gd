extends Node

var file_path = "user://game_settings.cfg"
var config = ConfigFile.new()

func _ready():
	if FileAccess.file_exists(file_path):
		print("[game_settings.cfg] was detected successfully")
	else:
		print("[game_settings.cfg] not found. Creating a new one...")
		create_config_file()

func create_config_file():
	############# Default Settings ################
	# Display
	config.set_value("display", "windows_size", 2)
	config.set_value("display", "windows_type", 0)
	config.set_value("display", "vsync", false)
	config.set_value("display", "fps_limiter", 0)
	
	# Audio
	config.set_value("audio", "master", 100)
	config.set_value("audio", "music", 100)
	config.set_value("audio", "ambient", 100)
	config.set_value("audio", "player", 100)
	config.set_value("audio", "menus", 100)
	
	# Controls
	config.set_value("controls", "Fly_Up", "W")
	config.set_value("controls", "Fly_Down", "S")
	config.set_value("controls", "Walk_Left", "A")
	config.set_value("controls", "Walk_Right", "D")
	config.set_value("controls", "Run", "Shift")
	config.set_value("controls", "Agachar", "Crtl")
	config.set_value("controls", "Destroy_Block", "LMB")
	config.set_value("controls", "Place_Torch", "RMB")
	config.set_value("controls", "Place_Block", "MMB")
	config.set_value("controls", "Fullscreen", "F11")
	config.set_value("controls", "PauseMenu", "Escape")
	config.set_value("controls", "Quack", "E")
	config.set_value("controls", "Hide_Show_Inventory", "TAB")
	config.set_value("controls", "Open_Feedback_Page", "F9")
	config.set_value("controls", "Universe_Zoom_In", "MWU")
	config.set_value("controls", "Universe_Zoom_Out", "MWD")
	config.set_value("controls", "Use_Flashlight", "RMB")
	
	# Save the file
	var save_error = config.save(file_path)
	if save_error != OK:
		print("[ERROR] Could not save the configuration file: ", save_error)
	else:
		print("Configuration file created successfully.")
