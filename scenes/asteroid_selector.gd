extends Node2D

func _ready() -> void:
	
	if DiscordRPC.get_is_discord_working():
		var random = randi_range(1, 2)
		match random:
			1:
				DiscordRPC.details = "🌌 Choosing where to go"
				DiscordRPC.refresh()
			2:
				DiscordRPC.details = "🔎 Choosing the next Adventure"
				DiscordRPC.refresh()
	else:
		print("[discordRP.gd] Discord isn't running or wasn't detected properly, skipping rich presence.") 
