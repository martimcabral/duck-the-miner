extends Node

var settings_path : String = str("user://game_settings.cfg")
var settings_config := ConfigFile.new()

var version_path : String = str("user://version.cfg")
var version_config := ConfigFile.new()

# Este script serve para ler as configurações do jogo e usa-las ao abrir o jogo
# e garantir que o arquivo de configuração esteja atualizado com a versão atual do jogo.
func _ready():
	version_config.load(version_path)
	if version_config.get_value("version", "current") != str("beta." + ProjectSettings.get_setting("application/config/version")):
		print("[game_settings] Settings Config file updated!")
		create_config_file()
	else:
		print("[game_settings] Settings Config file already in current version!")

func create_config_file(): # Default Settings Configuration:
	# Display
	settings_config.set_value("display", "windows_size", 2)
	settings_config.set_value("display", "windows_type", 0)
	settings_config.set_value("display", "vsync", false)
	settings_config.set_value("display", "fps_limiter", 0)
	settings_config.set_value("display", "monitor", 0)
	settings_config.set_value("display", "bloom", true)
	settings_config.set_value("display", "biome_visual_effects", true)
	
	# Audio
	settings_config.set_value("audio", "master", 100)
	settings_config.set_value("audio", "music", 100)
	settings_config.set_value("audio", "ambient", 100)
	settings_config.set_value("audio", "player", 100)
	settings_config.set_value("audio", "menus", 50)
	
	# Controls
	settings_config.set_value("controls", "Fly_Up", "W")
	settings_config.set_value("controls", "Fly_Down", "S")
	settings_config.set_value("controls", "Walk_Left", "A")
	settings_config.set_value("controls", "Walk_Right", "D")
	settings_config.set_value("controls", "Run", "Shift")
	settings_config.set_value("controls", "Agachar", "Crtl")
	settings_config.set_value("controls", "Destroy_Block", "LMB")
	settings_config.set_value("controls", "Fullscreen", "F11")
	settings_config.set_value("controls", "PauseMenu", "Escape")
	settings_config.set_value("controls", "Quack", "E")
	settings_config.set_value("controls", "Hide_Show_Inventory", "TAB")
	settings_config.set_value("controls", "Open_Feedback_Page", "F9")
	settings_config.set_value("controls", "Universe_Zoom_In", "MWU")
	settings_config.set_value("controls", "Universe_Zoom_Out", "MWD")
	settings_config.set_value("controls", "Use_Item", "RMB")
	
	# Accessibility
	settings_config.set_value("accessibility", "colorblindness", 0)
	settings_config.set_value("accessibility", "language", 0)
	settings_config.set_value("accessibility", "subtitles", true)
	settings_config.set_value("accessibility", "highlight_block_selection", false)
	settings_config.set_value("accessibility", "show_controls", true)
	settings_config.set_value("accessibility", "hide_blood", false)
	
	# Save the file
	settings_config.save(settings_path)
