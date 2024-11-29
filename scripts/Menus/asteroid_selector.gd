extends Node2D

var min_zoom = 0.05
var max_zoom = 4

var consoantes = ['b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z']
var vogais = ['a', 'e', 'i', 'o', 'u']

var delta_location
var gamma_location
var omega_location
var lambda_location
var sigma_location
var yotta_location

var delta_thumbnail = preload("res://assets/textures/universe/orbits_and_fields/thumbs/delta.png")
var gamma_thumbnail = preload("res://assets/textures/universe/orbits_and_fields/thumbs/gamma.png")
var omega_thumbnail = preload("res://assets/textures/universe/orbits_and_fields/thumbs/omega.png")
var lambda_thumbnail = preload("res://assets/textures/universe/orbits_and_fields/thumbs/lambda.png")
var sigma_thumbnail = preload("res://assets/textures/universe/orbits_and_fields/thumbs/sigma.png")
var yotta_thumbnail = preload("res://assets/textures/universe/orbits_and_fields/thumbs/yotta.png")

var json_path = "res://missions.json"
var current_page = 0

func _ready() -> void:
	$Camera2D/HUD/InfoPanel/AsteroidGUIder/Numberization.text = "[center]%s[/center]" % "00/00"
	
	$Camera2D/HUD/InfoPanel/AsteroidGUIder.visible = false
	$Camera2D/HUD/InfoPanel/FieldImage.visible = false
	$Camera2D/HUD/InfoPanel/FieldImage/ImageBorders.visible = false
	$Camera2D/HUD/InfoPanel/FieldBeltName.text = "[center]%s[/center]" % "[ ! ] Select an Asteroid Field"
	$Camera2D/HUD/InfoPanel.size = Vector2i(387, 146)
	
	save_asteroid_data()
	
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
	delta_location = $SolarSystem/DeltaBelt.position
	gamma_location = $SolarSystem/GammaField.position
	omega_location = $SolarSystem/OmegaField.position
	lambda_location = $SolarSystem/LambdaField.position
	sigma_location = $SolarSystem/SigmaField.position
	yotta_location = $SolarSystem/YottaBelt.position
	
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
	
	$SolarSystem/DeltaBelt.rotation += delta * 0.05
	$SolarSystem/GammaField.rotation -= delta * 0.08
	$SolarSystem/OmegaField.rotation -= delta * 0.08
	$SolarSystem/LambdaField.rotation += delta * 0.1
	$SolarSystem/SigmaField.rotation += delta * 0.1
	$SolarSystem/YottaBelt.rotation += delta * 0.5

# This works by when clicking on an Asteroid Field it will put the world scene in this current scene and then after it will free the Universe from the Memory
func _on_delta_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		$Camera2D/HUD/InfoPanel/AsteroidGUIder.visible = true
		$Camera2D/HUD/InfoPanel/FieldImage.visible = true
		$Camera2D/HUD/InfoPanel/FieldImage/ImageBorders.visible = true
		$Camera2D/HUD/InfoPanel/FieldImage.texture = delta_thumbnail
		$Camera2D/HUD/InfoPanel/FieldBeltName.text = "[center]%s[/center]" % "Delta Belt"
		$Camera2D/HUD/InfoPanel/FieldBeltName.add_theme_color_override("font_shadow_color", Color(0.788, 0.161, 0.161, 1))
		$Camera2D/HUD/InfoPanel.size = Vector2i(387, 661)

func _on_gamma_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		$Camera2D/HUD/InfoPanel/AsteroidGUIder.visible = true
		$Camera2D/HUD/InfoPanel/FieldImage.visible = true
		$Camera2D/HUD/InfoPanel/FieldImage/ImageBorders.visible = true
		$Camera2D/HUD/InfoPanel/FieldImage.texture = gamma_thumbnail
		$Camera2D/HUD/InfoPanel/FieldBeltName.text = "[center]%s[/center]" % "Gamma Field"
		$Camera2D/HUD/InfoPanel/FieldBeltName.add_theme_color_override("font_shadow_color", Color(0.157, 0.349, 0.788, 1))
		$Camera2D/HUD/InfoPanel.size = Vector2i(387, 661)

func _on_omega_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		$Camera2D/HUD/InfoPanel/AsteroidGUIder.visible = true
		$Camera2D/HUD/InfoPanel/FieldImage.visible = true
		$Camera2D/HUD/InfoPanel/FieldImage/ImageBorders.visible = true
		$Camera2D/HUD/InfoPanel/FieldImage.texture = omega_thumbnail
		$Camera2D/HUD/InfoPanel/FieldBeltName.text = "[center]%s[/center]" % "Omega Field"
		$Camera2D/HUD/InfoPanel/FieldBeltName.add_theme_color_override("font_shadow_color", Color(0.157, 0.788, 0.549, 1))
		$Camera2D/HUD/InfoPanel.size = Vector2i(387, 661)

func _on_lamdba_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		$Camera2D/HUD/InfoPanel/AsteroidGUIder.visible = true
		$Camera2D/HUD/InfoPanel/FieldImage.visible = true
		$Camera2D/HUD/InfoPanel/FieldImage/ImageBorders.visible = true
		$Camera2D/HUD/InfoPanel/FieldImage.texture = lambda_thumbnail
		$Camera2D/HUD/InfoPanel/FieldBeltName.text = "[center]%s[/center]" % "Lambda Field"
		$Camera2D/HUD/InfoPanel.size = Vector2i(387, 661)

func _on_sigma_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		$Camera2D/HUD/InfoPanel/AsteroidGUIder.visible = true
		$Camera2D/HUD/InfoPanel/FieldImage.visible = true
		$Camera2D/HUD/InfoPanel/FieldImage/ImageBorders.visible = true
		$Camera2D/HUD/InfoPanel/FieldImage.texture = sigma_thumbnail
		$Camera2D/HUD/InfoPanel/FieldBeltName.text = "[center]%s[/center]" % "Sigma Field"
		$Camera2D/HUD/InfoPanel.size = Vector2i(387, 661)

func _on_yotta_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		$Camera2D/HUD/InfoPanel/AsteroidGUIder.visible = true
		$Camera2D/HUD/InfoPanel/FieldImage.visible = true
		$Camera2D/HUD/InfoPanel/FieldImage/ImageBorders.visible = true
		$Camera2D/HUD/InfoPanel/FieldImage.texture = yotta_thumbnail
		$Camera2D/HUD/InfoPanel/FieldBeltName.text = "[center]%s[/center]" % "Yotta Field"
		$Camera2D/HUD/InfoPanel.size = Vector2i(387, 661)

func change_to_world(field):
	var new_world = preload("res://scenes/world.tscn").instantiate()
	new_world.asteroid_field = field
	get_tree().root.add_child(new_world)
	get_tree().current_scene.call_deferred("free")
	get_tree().current_scene = new_world

func _on_delta_area_2d_mouse_entered() -> void:
	$FieldNameLabel.text = "[center]%s[/center]" % "Delta Belt"
	$FieldNameLabel.add_theme_color_override("font_shadow_color", Color(0.788, 0.161, 0.161, 1))

func _on_gamma_area_2d_mouse_entered() -> void:
	$FieldNameLabel.text = "[center]%s[/center]" % "Gamma Field"
	$FieldNameLabel.add_theme_color_override("font_shadow_color", Color(0.157, 0.349, 0.788, 1))

func _on_omega_area_2d_mouse_entered() -> void:
	$FieldNameLabel.text = "[center]%s[/center]" % "Omega Field"
	$FieldNameLabel.add_theme_color_override("font_shadow_color", Color(0.157, 0.788, 0.549, 1))

func _on_lamdba_area_2d_mouse_entered() -> void:
	$FieldNameLabel.text = "[center]%s[/center]" % "Lamdba Field"
	$FieldNameLabel.add_theme_color_override("font_shadow_color", Color(0.788, 0.38, 0.157, 1))

func _on_sigma_area_2d_mouse_entered() -> void:
	$FieldNameLabel.text = "[center]%s[/center]" % "Sigma Field"
	$FieldNameLabel.add_theme_color_override("font_shadow_color", Color(0.537, 0.788, 0.157, 1))

func _on_yotta_area_2d_mouse_entered() -> void:
	$FieldNameLabel.text = "[center]%s[/center]" % "Yotta Belt"
	$FieldNameLabel.add_theme_color_override("font_shadow_color", Color(0.659, 0.157, 0.788, 1))

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

func create_asteroid_name():
	var consoante1 = consoantes[randi() % consoantes.size()]
	var consoante2 = consoantes[randi() % consoantes.size()]
	var consoante3 = consoantes[randi() % consoantes.size()]
	var consoante4 = consoantes[randi() % consoantes.size()]
	var vogal1 = vogais[randi() % vogais.size()]
	var vogal2 = vogais[randi() % vogais.size()]
	var vogal3 = vogais[randi() % vogais.size()]
	var vogal4 = vogais[randi() % vogais.size()]
	var vogal5 = vogais[randi() % vogais.size()]
	var vogal6 = vogais[randi() % vogais.size()]

	var variante = randi() % 9 + 1

	match variante: # 398,779,605 Combinações
		1:
			return consoante1.to_upper() + vogal1 + vogal2 + consoante2 + vogal3
		2:
			return consoante1.to_upper() + vogal1 + vogal2 + consoante2 + vogal3 + consoante3 + vogal4
		3:
			return consoante1.to_upper() + vogal1 + consoante2
		4:
			return consoante1.to_upper() + consoante2 + vogal1 + consoante3 + vogal2 + vogal3
		5:
			return vogal1.to_upper() + consoante1 + consoante2 + vogal2 + "-" + consoante3.to_upper() + vogal3 + consoante4 + vogal4
		6:
			return vogal1.to_upper() + consoante1 + consoante2 + vogal3 + vogal3
		7:
			return consoante1.to_upper() + vogal1 + vogal2 + consoante2 + vogal3 + vogal4 + consoante3 + consoante4 + vogal5
		8:
			return consoante1.to_upper() + vogal1 + consoante2 + vogal2 + consoante3 + vogal3 + consoante3 + vogal4 + vogal5 + consoante4 + vogal6
		9:
			return consoante1.to_upper() + vogal1 + consoante2 + consoante3 + vogal2 + consoante4

# Function to generate asteroid data
func generate_asteroid_data() -> Dictionary:
	var fields = {}  # Dictionary to store asteroid fields
	var field_names = ["Delta Belt", "Gamma Field", "Omega Field", "Lambda Field", "Sigma Field", "Yotta Belt"]
	var biomes = ["Stony", "Volcanic", "Frozen"]
	var objectites_primary = ["No Missions Available"]
	var objectites_secondary = ["No Missions Available"]
	
	for field_name in field_names:
		var asteroids = {}  # Dictionary to store asteroids in the current field
		var asteroid_id = 1  # Reset asteroid ID counter for each field
			
		for asteroid_num in range(1, randi_range(3, 8) + 1):
			var as_name = create_asteroid_name()
			var biome = biomes[randi() % biomes.size()]
			var temperature = randi_range(-75, 120)
			var primary_objectite = objectites_primary[randi() % objectites_primary.size()]
			var secondary_objectite = objectites_secondary[randi() % objectites_secondary.size()]
			
			# Create asteroid entry
			asteroids[asteroid_id] = {
				"Name": as_name,
				"Biome": biome,
				"Temperature": temperature,
				"Objectites": {
					"Primary": primary_objectite,
					"Secondary": secondary_objectite
				}
			}
			asteroid_id += 1  # Increment the ID for the next asteroid
		
		fields[field_name] = asteroids  # Add the field with its asteroids to the fields dictionary
	
	return fields

# Save data to a JSON file
func save_asteroid_data():
	var asteroid_data = generate_asteroid_data()
	
	var result = JSON.stringify(asteroid_data, "\t")
	
	var file = FileAccess.open("res://missions.json", FileAccess.WRITE)
	if file:
		file.store_string(result)
		file.close()
		print("[asteroid_selector.gd/missions.json] Asteroid data saved")
	else:
		print("[asteroid_selector.gd/missions.json] Failed to open file for saving.")

func _on_next_button_pressed() -> void:
	var file = FileAccess.open(json_path, FileAccess.READ)
	var parse_result = JSON.parse_string(file.get_as_text())
	file.close()
	var data = parse_result.data
	
	var delta_belt = data["Delta Belt"]["ID1"]
	var page_asteroid_name = delta_belt["Name"]
	var biome = delta_belt["Biome"]
	var temperature = delta_belt["Temperature"]
	var primary = delta_belt["Objectites"]["Primary"]
	var secondary = delta_belt["Objectites"]["Secondary"]
	
