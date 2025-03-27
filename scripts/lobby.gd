extends Node2D

# Dictionary to map item names to their corresponding texture paths - Fake Atlas
var item_icons = {
	"Stone": "res://assets/textures/items/ores/rock_and_stone.png",
	"Coal": "res://assets/textures/items/ores/coal.png",
	"Copper": "res://assets/textures/items/ores/raw_copper.png",
	"Iron": "res://assets/textures/items/ores/raw_iron.png",
	"Raw Gold": "res://assets/textures/items/ores/raw_gold.png",
	"Emerald": "res://assets/textures/items/ores/emerald.png",
	"Ruby": "res://assets/textures/items/ores/ruby.png",
	"Sapphire": "res://assets/textures/items/ores/sapphire.png",
	"Diamond": "res://assets/textures/items/ores/diamond.png",
	"Ice": "res://assets/textures/items/ores/ice.png",
	"Magnetite": "res://assets/textures/items/ores/raw_magnetite.png",
	"Bauxite": "res://assets/textures/items/ores/raw_bauxite.png",
	"Topaz": "res://assets/textures/items/ores/topaz.png",
	"Garnet": "res://assets/textures/items/ores/garnet.png",
	"Tsavorite": "res://assets/textures/items/ores/tsavorite.png",
	"Lava Cluster": "res://assets/textures/items/ores/lava_cluster.png",
	"Dense Ice": "res://assets/textures/items/ores/dense_ice.png",
	"Amazonite": "res://assets/textures/items/ores/amazonite.png",
	"Ametrine": "res://assets/textures/items/ores/ametrine.png",
	"Apatite": "res://assets/textures/items/ores/apatite.png",
	"Frozen Diamond": "res://assets/textures/items/ores/frozen_diamond.png",
	"Raw Galena": "res://assets/textures/items/ores/raw_galena.png",
	"Raw Silver": "res://assets/textures/items/ores/raw_silver.png",
	"Raw Wolframite": "res://assets/textures/items/ores/raw_wolframite.png",
	"Raw Pyrolusite": "res://assets/textures/items/ores/raw_pyrolusite.png",
	"Raw Nickel": "res://assets/textures/items/ores/raw_nickel.png",
	"Raw Uranium": "res://assets/textures/items/ores/raw_uranium.png",
	"Raw Platinum": "res://assets/textures/items/ores/raw_nickel.png",
	"Raw Zirconium": "res://assets/textures/items/ores/raw_zirconium.png",
	"Raw Cobalt": "res://assets/textures/items/ores/raw_cobalt.png",
	"Sulfur": "res://assets/textures/items/ores/sulfur.png",
	"Graphite": "res://assets/textures/items/ores/graphite.png",
	"Charoite": "res://assets/textures/items/gems/charoite.png",
	"Sugilite": "res://assets/textures/items/gems/sugilite.png",
	"Peridot": "res://assets/textures/items/gems/peridot.png"
}

var selecting_mission = false
var mission_selected = false
var skin_selected : int = 0

var min_zoom = 0.15
var max_zoom = 2.5

var consoantes = ['b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z']
var vogais = ['a', 'e', 'i', 'o', 'u']

var delta_thumbnail = preload("res://assets/textures/universe/orbits_and_fields/thumbs/delta.png")
var gamma_thumbnail = preload("res://assets/textures/universe/orbits_and_fields/thumbs/gamma.png")
var omega_thumbnail = preload("res://assets/textures/universe/orbits_and_fields/thumbs/omega.png")
var koppa_thumbnail = preload("res://assets/textures/universe/orbits_and_fields/thumbs/koppa.png")

var skin_path : String = "res://save/skin.cfg"

var json_path = "res://save/missions.json"
var current_page = 1
var current_asteroid_name : String
var current_asteroid_biome : String
var current_field : String
var asteroid_temperature

var delta_ammount : int = 0
var gamma_ammount : int = 0
var omega_ammount : int = 0
var koppa_ammount : int = 0

@onready var item_list = $Camera2D/HUD/LobbyPanel/InventoryPanel/ItemList

func _ready():
	var save_file = ConfigFile.new()
	save_file.load("res://save/money.cfg")
	var current_money = str(save_file.get_value("money", "current", null))
	var number_str = str(current_money)
	# Create an empty list to store the parts of the formatted number
	var formatted_number = ""
	var counter = 0
	
	# Loop through the string representation of the number backwards
	for i in range(number_str.length() - 1, -1, -1):
		formatted_number = number_str[i] + formatted_number
		counter += 1
		
		# Add a space after every 3 digits, but not after the last group
		if counter % 3 == 0 and i != 0:
			formatted_number = " " + formatted_number
	$Camera2D/HUD/LobbyPanel/MoneyPanel/MoneyLabel.text = "€ " + formatted_number
	# Path to the CFG file
	var inv_path = "res://save/inventory_resources.cfg"
	
	# Load the CFG file
	var config = ConfigFile.new()
	var load_result = config.load(inv_path)
	
	# Check if the file was successfully loaded
	if load_result == OK:
		# Get all items from the "inventory" section
		var inventory_data = config.get_section_keys("inventory")
		
		# Populate the ItemList with items and their icons
		for item_name in inventory_data:
			var quantity = config.get_value("inventory", item_name, 0)  # Default quantity is 0
			var item_text = "%s: %d" % [item_name, quantity]
			
			# Add the item to the ItemList
			var icon = load(item_icons.get(item_name, "res://assets/textures/items/no_texture.png"))  # Default icon if not found
			var item_index = item_list.add_item(item_text)  # Add item text to the list
			
			# Set the icon for the item
			item_list.set_item_icon(item_index, icon)
	else:
		print("Failed to load CFG file: ", inv_path)
	
	load_skin()
	
	if $Camera2D/HUD/LobbyPanel/InventoryPanel/ItemList.item_count == 0:
		$Camera2D/HUD/LobbyPanel/InventoryPanel/ItemList.visible = false
		$Camera2D/HUD/LobbyPanel/InventoryPanel/UnavailableLabel.visible = true
	else: 
		$Camera2D/HUD/LobbyPanel/InventoryPanel/ItemList.visible = true
		$Camera2D/HUD/LobbyPanel/InventoryPanel/UnavailableLabel.visible = false
	
	$Camera2D/HUD/BackToLobbyButton.visible = false
	$Camera2D/HUD/InfoPanel.visible = false
	$Camera2D/HUD/SystemInfoPanel.visible = false
	$Camera2D/HUD/InfoPanel/SelectMissionPanel.visible = false
	$Camera2D/HUD/ZoomRuler.visible = false
	
	var file = FileAccess.open("res://save/missions.json", FileAccess.READ)
	if file:
		var result = file.get_as_text()
		if result == str(0):
			file.close()
			save_asteroid_data()
		else:
			print("[lobby.gd/missions.json] file is not empty!")
	else:
		print("[lobby.gd/missions.json] failed to open file!")
	
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
		DiscordRPC.small_image = "diamond-512"
		DiscordRPC.small_image_text = "Money: " + formatted_number + " €" 
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

func _process(_delta: float) -> void:
	if mission_selected : $Camera2D/HUD/InfoPanel/SelectMissionPanel.visible = true
	
	if current_page >= 1 :
		match current_field:
			"Delta Belt":
				if current_page > delta_ammount:
					current_page = delta_ammount
				$Camera2D/HUD/InfoPanel/AsteroidGUIder/Numberization.text =  "[center]%s[/center]" % str(current_page) + "/" + str(delta_ammount)
			"Gamma Field":
				if current_page > gamma_ammount:
					current_page = gamma_ammount
				$Camera2D/HUD/InfoPanel/AsteroidGUIder/Numberization.text =  "[center]%s[/center]" % str(current_page) + "/" + str(gamma_ammount)
			"Omega Field":
				if current_page > omega_ammount:
					current_page = omega_ammount
				$Camera2D/HUD/InfoPanel/AsteroidGUIder/Numberization.text =  "[center]%s[/center]" % str(current_page) + "/" + str(omega_ammount)
			"Koppa Belt":
				if current_page > koppa_ammount:
					current_page = koppa_ammount
				$Camera2D/HUD/InfoPanel/AsteroidGUIder/Numberization.text =  "[center]%s[/center]" % str(current_page) + "/" + str(koppa_ammount)
	else: 
		current_page = 1
	
	if selecting_mission == true:
		$Camera2D/HUD/ZoomRuler.visible = true
		if Input.is_action_just_pressed("Universe_Zoom_In") and $SolarSystem.scale.x <= max_zoom:
			$SolarSystem.scale += Vector2(0.05, 0.05)
			$Camera2D/HUD/ZoomRuler/ZoomLabel.text = str(snapped($SolarSystem.scale.x * 39.215, 0) / 5) + 'x'
			$Camera2D/HUD/ZoomRuler/ZoomSlider.value = int(round($SolarSystem.scale.x * 39.215))
		if Input.is_action_just_pressed("Universe_Zoom_Out") and $SolarSystem.scale.x >= min_zoom:
			$SolarSystem.scale -= Vector2(0.05, 0.05)
			$Camera2D/HUD/ZoomRuler/ZoomLabel.text = str(snapped($SolarSystem.scale.x * 39.215, 0) / 4) + 'x'
			$Camera2D/HUD/ZoomRuler/ZoomSlider.value = int(round($SolarSystem.scale.x * 39.215))
		$UniverseBackground.position = (get_global_mouse_position() * 0.008) + Vector2(-1200, -600)

func _on_ZoomSlider_value_changed(value: float) -> void:
	$SolarSystem.scale = Vector2(value / 39.215, value / 39.215)
	$Camera2D/HUD/ZoomRuler/ZoomLabel.text = str(snapped($SolarSystem.scale.x * 39.215, 0) / 4) + 'x'

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
		$Camera2D/HUD/InfoPanel/SelectMissionPanel/SelectMissionButton.visible = true

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
	var biomes = ["Stony", "Vulcanic", "Frozen", "Swamp"]
	var objectites_primary = ["n/a"]
	var objectites_secondary = ["n/a"]
	
	for field_name in field_names:
		var asteroids = {}  # Dictionary to store asteroids in the current field
		var asteroid_id = 1  # Reset asteroid ID counter for each field
			
		for asteroid_num in range(1, randi_range(4, 9) + 1):
			var as_name = create_asteroid_name()
			var biome = biomes[randi() % biomes.size()]
			match biome:
				"Stony": asteroid_temperature = randi_range(15, 30)
				"Vulcanic": asteroid_temperature = randi_range(75, 90)
				"Frozen": asteroid_temperature = randi_range(-45, -65)
				"Swamp": asteroid_temperature = randi_range(-5, 12)
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
	
	var file = FileAccess.open("res://save/missions.json", FileAccess.WRITE)
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
		else:
			print("An error ocurred trying to parse asteroid content, if early pages of the asteroid content appeared, it's all ok, maybe the issue it's because you haven't drinked enough water, you never know.")

func get_asteroids_per_field(field : String):
	# This Code in the Second Half was completly remade due to a error of impossibility of reading the asteroid data on the JSON File
	# Ensure the file is opened and read correctly
	var file = FileAccess.open(json_path, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		
		var json_parser = JSON.new()
		var error = json_parser.parse(json_string)
		if error != OK:
			print("Error parsing JSON: ", error)
			return 0
		
		# Get the parsed data (should be a dictionary)
		var asteroid_data = json_parser.get_data()
		
		# Ensure asteroid_data is a dictionary
		if typeof(asteroid_data) == TYPE_DICTIONARY:
			# Check if the field exists in asteroid_data
			if asteroid_data.has(field):
				var field_data = asteroid_data[field]
				var asteroid_count = field_data.keys().size()
				print("[asteroid_selector.gd] ", field, " has ", asteroid_count, " Asteroids")
				return asteroid_count
			else:
				print("Field '", field, "' not found in asteroid data.")
				return 0
		else:
			print("Parsed data is not a dictionary!")
			return 0
	else:
		print("Failed to open file: ", json_path)
		return 0

func _on_select_mission_button_pressed() -> void:
	selecting_mission = true
	$Camera2D/HUD/LobbyPanel.visible = false
	$Camera2D/HUD/BackToLobbyButton.visible = true
	$Camera2D/HUD/InfoPanel.visible = true
	$Camera2D/HUD/SystemInfoPanel.visible = true
	$Camera2D/HUD/ZoomRuler.visible = false
	$Camera2D/HUD/SystemInfoPanel/SystemName.text = "[center]%s[/center]" % "Solar System"

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

func _on_back_to_lobby_button_pressed() -> void:
	$MouseSoundEffects.stream = load("res://sounds/sound_effects/back.ogg")
	$MouseSoundEffects.play()
	
	selecting_mission = false
	$Camera2D/HUD/LobbyPanel.visible = true
	$Camera2D/HUD/BackToLobbyButton.visible = false
	$Camera2D/HUD/InfoPanel.visible = false
	$Camera2D/HUD/SystemInfoPanel.visible = false
	$Camera2D/HUD/ZoomRuler.visible = false

func _select_mission_button_info_panel_pressed() -> void:
	selecting_mission = false
	$Camera2D/HUD/LobbyPanel.visible = true
	$Camera2D/HUD/BackToLobbyButton.visible = false
	$Camera2D/HUD/InfoPanel.visible = false
	$Camera2D/HUD/SystemInfoPanel.visible = false
	$Camera2D/HUD/InfoPanel/SelectMissionPanel.visible = false
	$Camera2D/HUD/ZoomRuler.visible = false

func load_skin():
	if FileAccess.file_exists(skin_path):
		var skin_file = ConfigFile.new()
		skin_file.load(skin_path)
		skin_selected = int(skin_file.get_value("skin", "selected", 0))
		print("Current Skin: " + str(skin_selected))
		
	$Camera2D/HUD/LobbyPanel/SkinSelectionPanel/SkinDisplay.texture = load("res://assets/textures/players/skins/" + str(skin_selected) + "/duck.png")

func _on_skin_previous_button_pressed() -> void:
	skin_selected -= 1
	if skin_selected < 1 : skin_selected = 1
	
	$Camera2D/HUD/LobbyPanel/SkinSelectionPanel/SkinDisplay.texture = load("res://assets/textures/players/skins/" + str(skin_selected) + "/duck.png")

	if FileAccess.file_exists(skin_path):
		var skin_file = ConfigFile.new()
		skin_file.load(skin_path)
		skin_file.set_value("skin", "selected", skin_selected)
		print("[lobby.gd] Current Skin: " + str(skin_selected))
		skin_file.save(skin_path)

func _on_skin_next_button_pressed() -> void:
	skin_selected += 1
	if skin_selected >= 4 : skin_selected = 4
	
	$Camera2D/HUD/LobbyPanel/SkinSelectionPanel/SkinDisplay.texture = load("res://assets/textures/players/skins/" + str(skin_selected) + "/duck.png")

	if FileAccess.file_exists(skin_path):
		var skin_file = ConfigFile.new()
		skin_file.load(skin_path)
		skin_file.set_value("skin", "selected", skin_selected)
		print("Current Skin: " + str(skin_selected))
		skin_file.save(skin_path)
