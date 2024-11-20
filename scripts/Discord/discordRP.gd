extends Node

func _ready() -> void:
	DiscordRPC.app_id = 1306635163265929327
	if DiscordRPC.get_is_discord_working():
		DiscordRPC.details = "🎮 Just started playing!"
		DiscordRPC.state = "alpha.1.7"
		DiscordRPC.large_image = "duck-1028"
		DiscordRPC.large_image_text = "Get Duck the Miner at itch.io"
		DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
		DiscordRPC.refresh()
	else:
		print("[discordRP.gd] Discord isn't running or wasn't detected properly, skipping rich presence.")

func _process(_delta: float) -> void:
	DiscordRPC.run_callbacks()
