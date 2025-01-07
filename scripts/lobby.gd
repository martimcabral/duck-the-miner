extends Node2D

var selecting_mission = false
var mission_selected = false

var min_zoom = 0.15
var max_zoom = 2.5

var consoantes = ['b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z']
var vogais = ['a', 'e', 'i', 'o', 'u']

var delta_thumbnail = preload("res://assets/textures/universe/orbits_and_fields/thumbs/delta.png")
var gamma_thumbnail = preload("res://assets/textures/universe/orbits_and_fields/thumbs/gamma.png")
var omega_thumbnail = preload("res://assets/textures/universe/orbits_and_fields/thumbs/omega.png")
var koppa_thumbnail = preload("res://assets/textures/universe/orbits_and_fields/thumbs/koppa.png")

var json_path = "res://missions.json"
var current_page = 1
var current_asteroid_name : String
var current_asteroid_biome : String
var current_field : String
var asteroid_temperature

var delta_ammount
var gamma_ammount
var omega_ammount
var koppa_ammount

# Koppa is the older Yotta, caution when reading this file

func _ready() -> void:
	create_stock_market()
	
	$Camera2D/HUD/BackToLobbyButton.visible = false
	$Camera2D/HUD/InfoPanel.visible = false
	$Camera2D/HUD/SystemInfoPanel.visible = false
	
	save_asteroid_data()
	
	delta_ammount =  get_asteroids_per_field("Delta Belt")
	gamma_ammount =  get_asteroids_per_field("Gamma Field")
	omega_ammount =  get_asteroids_per_field("Omega Field")
	koppa_ammount =  get_asteroids_per_field("Koppa Belt")
	
	$Camera2D/HUD/InfoPanel/AsteroidGUIder/Numberization.text = "[center]%s[/center]" % "00/00"
	$Camera2D/HUD/InfoPanel/Description.text = ""
	$Camera2D/HUD/InfoPanel/AsteroidGUIder.visible = false
	$Camera2D/HUD/InfoPanel/FieldImage.visible = false
	$Camera2D/HUD/InfoPanel/FieldImage/ImageBorders.visible = false
	$Camera2D/HUD/InfoPanel/FieldBeltName.text = "[center]%s[/center]" % "[ ! ] Select an Asteroid Field"
	$Camera2D/HUD/InfoPanel.size = Vector2i(387, 146)
	
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
	match current_field:
		"Delta Belt":
			$Camera2D/HUD/InfoPanel/AsteroidGUIder/Numberization.text =  "[center]%s[/center]" % str(current_page) + "/" + str(delta_ammount)
			if current_page > delta_ammount:
				current_page = delta_ammount
		"Gamma Field":
			$Camera2D/HUD/InfoPanel/AsteroidGUIder/Numberization.text =  "[center]%s[/center]" % str(current_page) + "/" + str(gamma_ammount)
			if current_page > gamma_ammount:
				current_page = gamma_ammount
		"Omega Field":
			$Camera2D/HUD/InfoPanel/AsteroidGUIder/Numberization.text =  "[center]%s[/center]" % str(current_page) + "/" + str(omega_ammount)
			if current_page > omega_ammount:
				current_page = omega_ammount
		"Koppa Belt":
			$Camera2D/HUD/InfoPanel/AsteroidGUIder/Numberization.text =  "[center]%s[/center]" % str(current_page) + "/" + str(koppa_ammount)
			if current_page > koppa_ammount:
				current_page = koppa_ammount

	if current_page <= 0: current_page = 1
	
	if selecting_mission == true:
		if Input.is_action_just_pressed("Universe_Zoom_In") and $SolarSystem.scale.x <= max_zoom:
			$SolarSystem.scale += Vector2(0.05, 0.05)
		if Input.is_action_just_pressed("Universe_Zoom_Out") and $SolarSystem.scale.x >= min_zoom:
			$SolarSystem.scale -= Vector2(0.05, 0.05)
		$UniverseBackground.position = (get_global_mouse_position() * 0.008) + Vector2(-1200, -600)
	
	rotate_solar_system(delta)

func rotate_solar_system(delta):
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
	$SolarSystem/KoppaBelt.rotation += delta * 0.03

# This works by when clicking on an Asteroid Field it will put the world scene in this current scene and then after it will free the Universe from the Memory
func _on_delta_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		current_page = 1
		current_field = "Delta Belt"
		get_asteroid_info()
		show_all_info()
		$Camera2D/HUD/InfoPanel/FieldImage.texture = delta_thumbnail
		$Camera2D/HUD/LobbyPanel/UniverseMapPanel/FieldLobbyThumbnail.texture = delta_thumbnail
		$Camera2D/HUD/LobbyPanel/UniverseMapPanel/FielName.text = "Delta Belt"
		$Camera2D/HUD/LobbyPanel/UniverseMapPanel/FielName.add_theme_color_override("font_shadow_color", Color(0.788, 0.161, 0.161, 1))
		$Camera2D/HUD/InfoPanel/FieldBeltName.text = "[center]%s[/center]" % "Delta Belt"
		$Camera2D/HUD/InfoPanel/FieldBeltName.add_theme_color_override("font_shadow_color", Color(0.788, 0.161, 0.161, 1))
		$Camera2D/HUD/InfoPanel.size = Vector2i(387, 661)

func _on_gamma_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		current_page = 1
		current_field = "Gamma Field"
		get_asteroid_info()
		show_all_info()
		$Camera2D/HUD/InfoPanel/FieldImage.texture = gamma_thumbnail
		$Camera2D/HUD/LobbyPanel/UniverseMapPanel/FieldLobbyThumbnail.texture = gamma_thumbnail
		$Camera2D/HUD/LobbyPanel/UniverseMapPanel/FielName.text = "Gamma Field"
		$Camera2D/HUD/LobbyPanel/UniverseMapPanel/FielName.add_theme_color_override("font_shadow_color", Color(0.157, 0.349, 0.788, 1))
		$Camera2D/HUD/InfoPanel/FieldBeltName.text = "[center]%s[/center]" % "Gamma Field"
		$Camera2D/HUD/InfoPanel/FieldBeltName.add_theme_color_override("font_shadow_color", Color(0.157, 0.349, 0.788, 1))
		$Camera2D/HUD/InfoPanel.size = Vector2i(387, 661)

func _on_omega_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		current_page = 1
		current_field = "Omega Field"
		get_asteroid_info()
		show_all_info()
		$Camera2D/HUD/InfoPanel/FieldImage.texture = omega_thumbnail
		$Camera2D/HUD/LobbyPanel/UniverseMapPanel/FieldLobbyThumbnail.texture = omega_thumbnail
		$Camera2D/HUD/LobbyPanel/UniverseMapPanel/FielName.text = "Omega Field"
		$Camera2D/HUD/LobbyPanel/UniverseMapPanel/FielName.add_theme_color_override("font_shadow_color", Color(0.157, 0.788, 0.549, 1))
		$Camera2D/HUD/InfoPanel/FieldBeltName.text = "[center]%s[/center]" % "Omega Field"
		$Camera2D/HUD/InfoPanel/FieldBeltName.add_theme_color_override("font_shadow_color", Color(0.157, 0.788, 0.549, 1))
		$Camera2D/HUD/InfoPanel.size = Vector2i(387, 661)

func _on_yotta_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		current_page = 1
		current_field = "Koppa Belt"
		get_asteroid_info()
		show_all_info()
		$Camera2D/HUD/InfoPanel/FieldImage.texture = koppa_thumbnail
		$Camera2D/HUD/LobbyPanel/UniverseMapPanel/FieldLobbyThumbnail.texture = koppa_thumbnail
		$Camera2D/HUD/LobbyPanel/UniverseMapPanel/FielName.text = "Koppa Belt"
		$Camera2D/HUD/LobbyPanel/UniverseMapPanel/FielName.add_theme_color_override("font_shadow_color", Color(0.659, 0.157, 0.788, 1))
		$Camera2D/HUD/InfoPanel/FieldBeltName.text = "[center]%s[/center]" % "Koppa Belt"
		$Camera2D/HUD/InfoPanel/FieldBeltName.add_theme_color_override("font_shadow_color", Color(0.659, 0.157, 0.788, 1))
		$Camera2D/HUD/InfoPanel.size = Vector2i(387, 661)

func show_all_info():
		$Camera2D/HUD/InfoPanel/AsteroidGUIder.visible = true
		$Camera2D/HUD/InfoPanel/FieldImage.visible = true
		$Camera2D/HUD/InfoPanel/FieldImage/ImageBorders.visible = true

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

func _on_yotta_area_2d_mouse_entered() -> void:
	$FieldNameLabel.text = "[center]%s[/center]" % "Koppa Belt"
	$FieldNameLabel.add_theme_color_override("font_shadow_color", Color(0.659, 0.157, 0.788, 1))

func _on_delta_area_2d_mouse_exited() -> void:
	$FieldNameLabel.text = ""

func _on_gamma_area_2d_mouse_exited() -> void:
	$FieldNameLabel.text = ""

func _on_omega_area_2d_mouse_exited() -> void:
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

	var variante = randi_range(1, 9)

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
	var field_names = ["Delta Belt", "Gamma Field", "Omega Field", "Koppa Belt"]
	var biomes = ["Stony", "Vulcanic", "Frozen"]
	var objectites_primary = ["n/a"]
	var objectites_secondary = ["n/a"]
	
	for field_name in field_names:
		var asteroids = {}  # Dictionary to store asteroids in the current field
		var asteroid_id = 1  # Reset asteroid ID counter for each field
			
		for asteroid_num in range(1, randi_range(3, 8) + 1):
			var as_name = create_asteroid_name()
			var biome = biomes[randi() % biomes.size()]
			match biome:
				"Stony": asteroid_temperature = randi_range(15, 30)
				"Vulcanic": asteroid_temperature = randi_range(75, 90)
				"Frozen": asteroid_temperature = randi_range(-45, -65)
			var primary_objectite = objectites_primary[randi() % objectites_primary.size()]
			var secondary_objectite = objectites_secondary[randi() % objectites_secondary.size()]
			
			# Create asteroid entry
			asteroids[asteroid_id] = {
				"Name": as_name,
				"Biome": biome,
				"Temperature": asteroid_temperature,
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
	current_page += 1
	get_asteroid_info()

func _on_previous_button_pressed() -> void:
	current_page -= 1
	get_asteroid_info()

func get_asteroid_info():
	if current_page >= 1:
		mission_selected = true
		var file = FileAccess.open(json_path, FileAccess.READ)
		var parse_result = JSON.parse_string(file.get_as_text())
		file.close()
		if current_field == "Delta Belt" and current_page <= delta_ammount \
			or current_field == "Gamma Field" and current_page <= gamma_ammount \
			or current_field == "Omega Field" and current_page <= omega_ammount \
			or current_field == "Koppa Belt" and current_page <= koppa_ammount:
			
			var asteroid_info = parse_result[current_field][str(current_page)]
			current_asteroid_name = asteroid_info["Name"]
			$Camera2D/HUD/LobbyPanel/UniverseMapPanel/AsteroidName.text = "Going to: " + current_asteroid_name
			current_asteroid_biome = asteroid_info["Biome"]
			var temperature = asteroid_info["Temperature"]
			asteroid_temperature = temperature
			var primary = asteroid_info["Objectites"]["Primary"]
			var secondary = asteroid_info["Objectites"]["Secondary"]
			$Camera2D/HUD/LobbyPanel/UniverseMapPanel/AsteroidDescription.text = "\nBiome: " + str(current_asteroid_biome) + "\nTemperature: " + str(temperature) + "ᵒC\n\nPrimary: " + str(primary) +  "\nSecundary: " + str(secondary)
			$Camera2D/HUD/InfoPanel/Description.text = "Name: " + str(current_asteroid_name) + "\nBiome: " + str(current_asteroid_biome) + "\nTemperature: " + str(temperature) + "ᵒC\nPrimary: " + str(primary) +  "\nSecundary: " + str(secondary)

func get_asteroids_per_field(field : String):
	var file = FileAccess.open(json_path, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	
	var json_parser = JSON.new()
	json_parser.parse(json_string)
	
	var asteroid_data = json_parser.get_data()
	var asteroid_count = asteroid_data[field].keys().size()
	print("[asteroid_selector.gd] ", field , " has ", asteroid_count, " Asteroids")
	return asteroid_count

func _on_select_mission_button_pressed() -> void:
	$Camera2D/HUD/SystemInfoPanel/SystemName.text = "[center]%s[/center]" % "Solar System"
	selecting_mission = true
	$Camera2D/HUD/LobbyPanel.visible = false
	$Camera2D/HUD/BackToLobbyButton.visible = true
	$Camera2D/HUD/InfoPanel.visible = true
	$Camera2D/HUD/SystemInfoPanel.visible = true

func _on_back_to_lobby_button_pressed() -> void:
	selecting_mission = false
	$Camera2D/HUD/LobbyPanel.visible = true
	$Camera2D/HUD/BackToLobbyButton.visible = false
	$Camera2D/HUD/InfoPanel.visible = false
	$Camera2D/HUD/SystemInfoPanel.visible = false

func _on_back_button_pressed() -> void:
	Input.set_custom_mouse_cursor(load("res://assets/textures/players/main_cursor.png"))
	var new_game_scene = load("res://scenes/main_menu.tscn")
	get_tree().change_scene_to_packed(new_game_scene)
	new_game_scene.instantiate()

func _on_start_button_pressed() -> void:
	if mission_selected == true:
		var new_world = preload("res://scenes/world.tscn").instantiate()
		new_world.asteroid_field = current_field
		new_world.asteroid_name = current_asteroid_name
		new_world.asteroid_biome = current_asteroid_biome
		new_world.asteroid_temperature = asteroid_temperature
		get_tree().root.add_child(new_world)
		get_tree().current_scene.call_deferred("free")
		get_tree().current_scene = new_world

func create_stock_market():
	var consoante1 = consoantes[randi() % consoantes.size()]
	var consoante2 = consoantes[randi() % consoantes.size()]
	var vogal1 = vogais[randi() % vogais.size()]
	var vogal2 = vogais[randi() % vogais.size()]
	
	var variante = randi_range(1, 4)
	
	var money_word : String
	match variante: # 4 935 Variações
		1:
			money_word = vogal1 + consoante1 + consoante2
		2:
			money_word = consoante1 + vogal1 + consoante2
		3:
			money_word = vogal1 + vogal2 + consoante1
		4:
			money_word = consoante1 + vogal1 + vogal2
	
	var random_percentage = round(randf_range(0, 2) * 100) / 100.0
	
	match randi_range(1,2):
		1: 
			$Camera2D/HUD/LobbyPanel/MoneyPanel/StockMarketLabel.add_theme_color_override("default_color", Color(0, 0.92, 0))
			$Camera2D/HUD/LobbyPanel/MoneyPanel/StockMarketLabel.text = "[center]%s[/center]" % money_word.to_upper() + " +" + str(random_percentage) + "%"
		2: 
			$Camera2D/HUD/LobbyPanel/MoneyPanel/StockMarketLabel.add_theme_color_override("default_color", Color(0.92, 0, 0))
			$Camera2D/HUD/LobbyPanel/MoneyPanel/StockMarketLabel.text = "[center]%s[/center]" % money_word.to_upper() + " -" + str(random_percentage) + "%"

func _on_stock_market_timer_timeout() -> void:
	create_stock_market()
