extends Node

func _ready() -> void:
	DiscordRPC.app_id = 1306635163265929327
	DiscordRPC.state = "Playing Solo"
	DiscordRPC.details = "Just started playing!"
	DiscordRPC.large_image = "duck-1028"
	DiscordRPC.large_image_text = "Get Duck the Miner at itch.io"
	DiscordRPC.small_image = "diamond-512"
	DiscordRPC.small_image_text = "This is a Diamond"
	
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
	DiscordRPC.refresh()

func _process(_delta: float) -> void:
	DiscordRPC.run_callbacks()
	
