extends Node2D

var min_zoom = 0.05
var max_zoom = 4

func _ready() -> void:
	$FieldNameLabel.text = ""
	
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
	$SolarSystem/Sun.rotation -= delta * 0.1
	$SolarSystem/Mercury.rotation -= delta * 0.05
	$SolarSystem/Venus.rotation -= delta * 0.075
	
	$SolarSystem/Earth.rotation -= delta * 0.1
	$SolarSystem/Earth/Moon.rotation -= delta * 0.25
	
	$SolarSystem/Mars.rotation -= delta * 0.125
	$SolarSystem/Mars/Phobos.rotation -= delta * 0.3
	$SolarSystem/Mars/Deimos.rotation -= delta * 0.5
	
	$SolarSystem/Jupiter.rotation -= delta * 0.08
	$SolarSystem/Jupiter/Io.rotation -= delta * 0.15
	$SolarSystem/Jupiter/Europa.rotation -= delta * 0.25
	$SolarSystem/Jupiter/Ganymede.rotation -= delta * 0.5
	$SolarSystem/Jupiter/Callisto.rotation -= delta * 0.2
	
	$SolarSystem/Saturn.rotation -= delta * 0.04
	$SolarSystem/Saturn/Mimas.rotation -= delta * 0.4
	$SolarSystem/Saturn/Rhea.rotation -= delta * 0.75
	$SolarSystem/Saturn/Titan.rotation -= delta * 0.1
	
	$SolarSystem/Uranus.rotation -= delta * 0.07
	$SolarSystem/Uranus/Miranda.rotation -= delta * 0.33
	$SolarSystem/Uranus/Titania.rotation -= delta * 0.25
	
	$SolarSystem/Neptune.rotation -= delta * 0.01
	$SolarSystem/Neptune/Proteus.rotation -= delta * 0.33
	$SolarSystem/Neptune/Tritan.rotation += delta * 0.5
	
	$SolarSystem/DeltaField.rotation += delta * 0.05
	$SolarSystem/GammaField.rotation -= delta * 0.08
	$SolarSystem/OmegaField.rotation -= delta * 0.08
	$SolarSystem/LambdaSigmaField.rotation += delta * 0.1
	$SolarSystem/YottaField.rotation += delta * 0.2

# This works by when clicking on an Asteroid Field it will put the world scene in this current scene and then after it will free the Universe from the Memory
func _on_delta_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		change_to_world("Delta")

func _on_gamma_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		change_to_world("Gamma")

func _on_omega_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		change_to_world("Omega")

func _on_lamdba_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		change_to_world("Lamdba")

func _on_sigma_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		change_to_world("Sigma")

func _on_yotta_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		change_to_world("Yotta")

func change_to_world(field):
	print("Clicked on " + field + "Field")
	var new_world = preload("res://scenes/world.tscn").instantiate()
	new_world.asteroid_field = field
	get_tree().root.add_child(new_world)
	get_tree().current_scene.call_deferred("free")
	get_tree().current_scene = new_world

func _on_delta_area_2d_mouse_entered() -> void:
	$FieldNameLabel.text = "[center]%s[/center]" % "Delta Field"

func _on_gamma_area_2d_mouse_entered() -> void:
	$FieldNameLabel.text = "[center]%s[/center]" % "Gamma Field"

func _on_omega_area_2d_mouse_entered() -> void:
	$FieldNameLabel.text = "[center]%s[/center]" % "Omega Field"

func _on_lamdba_area_2d_mouse_entered() -> void:
	$FieldNameLabel.text = "[center]%s[/center]" % "Lamdba Field"

func _on_sigma_area_2d_mouse_entered() -> void:
	$FieldNameLabel.text = "[center]%s[/center]" % "Sigma Field"

func _on_yotta_area_2d_mouse_entered() -> void:
	$FieldNameLabel.text = "[center]%s[/center]" % "Yotta Field"
	
func _on_delta_area_2d_mouse_exited() -> void:
	$FieldNameLabel.text = ""

func _on_gamma_area_2d_mouse_exited() -> void:
	$FieldNameLabel.text = ""

func _on_omega_area_2d_mouse_exited() -> void:
	$FieldNameLabel.text = ""

func _on_lamdba_area_2d_mouse_exited() -> void:
	$FieldNameLabel.text = ""

func _on_sigma_area_2d_mouse_exited() -> void:
	$FieldNameLabel.text = ""

func _on_yotta_area_2d_mouse_exited() -> void:
	$FieldNameLabel.text = ""
