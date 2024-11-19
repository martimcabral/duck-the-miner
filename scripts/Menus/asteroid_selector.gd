extends Node2D

var min_zoom = 0.05
var max_zoom = 4

func _ready() -> void:
	if DiscordRPC.get_is_discord_working():
		var random = randi_range(1, 2)
		match random:
			1:
				DiscordRPC.details = "🌌 Choosing where to go"
				DiscordRPC.refresh()
			2:
				DiscordRPC.details = "🔎 Choosing next Adventure"
				DiscordRPC.refresh()
	else:
		print("[discordRP.gd] Discord isn't running or wasn't detected properly, skipping rich presence.") 

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Universe_Zoom_In") and $SolarSystem.scale.x <= max_zoom:
		$SolarSystem.scale += Vector2(0.05, 0.05)
		
	if Input.is_action_just_pressed("Universe_Zoom_Out") and $SolarSystem.scale.x >= min_zoom:
		$SolarSystem.scale -= Vector2(0.05, 0.05)
	
	$UniverseBackground.position = (get_global_mouse_position() * 0.008) + Vector2(-1200, -600)
	$SolarSystem/Sun.rotation += delta * 0.1
	$SolarSystem/Mercury.rotation += delta * 0.05
	$SolarSystem/Venus.rotation += delta * 0.075
	
	$SolarSystem/Earth.rotation += delta * 0.1
	$SolarSystem/Earth/Moon.rotation += delta * 0.25
	
	$SolarSystem/Mars.rotation += delta * 0.125
	$SolarSystem/Mars/Phobos.rotation += delta * 0.3
	$SolarSystem/Mars/Deimos.rotation += delta * 0.5
	
	$SolarSystem/Jupiter.rotation += delta * 0.15
	$SolarSystem/Jupiter/Io.rotation += delta * 0.15
	$SolarSystem/Jupiter/Europa.rotation += delta * 0.25
	$SolarSystem/Jupiter/Ganymede.rotation += delta * 0.5
	$SolarSystem/Jupiter/Callisto.rotation += delta * 0.22
	
	$SolarSystem/Saturn.rotation += delta * 0.25
	$SolarSystem/Uranus.rotation += delta * 0.35
	$SolarSystem/Neptune.rotation += delta * 0.33
	
	$SolarSystem/DeltaField.rotation += delta * 0.05
	$SolarSystem/GammaField.rotation += delta * 0.15
	$SolarSystem/OmegaField.rotation += delta * 0.15
	$SolarSystem/LambdaSigmaField.rotation += delta * 0.1
	$SolarSystem/YottaField.rotation += delta * 0.2
