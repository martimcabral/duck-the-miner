extends Node

var skin_selected = get_skin()

func get_skin(): # GetSaveFile.save_being_used
	var skin_path = str("user://save/1/skin.cfg")
	if FileAccess.file_exists(skin_path):
		var skin_file = ConfigFile.new()
		skin_file.load(skin_path)
		skin_selected = int(skin_file.get_value("skin", "selected", 0))
		return skin_selected

func _ready() -> void:
	DiscordRPC.app_id = 1306635163265929327
	if DiscordRPC.get_is_discord_working():
		DiscordRPC.details = "🎮 Just started playing!"
		DiscordRPC.state = "beta." + str(ProjectSettings.get_setting("application/config/version"))
		DiscordRPC.large_image = str(skin_selected) + "duck"
		DiscordRPC.large_image_text = "Get Duck the Miner at itch.io"
		DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
		DiscordRPC.refresh()
	else:
		print("[discordRP.gd] Discord isn't running or wasn't detected properly, skipping rich presence.")

func _process(_delta: float) -> void:
	DiscordRPC.run_callbacks()
