extends Node2D

# Dictionary to item names to their corresponding texture paths - Fake Atlas
var item_icons = {
	"Stone": "res://assets/textures/items/ores/rock_and_stone.png",
	"Coal": "res://assets/textures/items/ores/coal.png",
	"Copper": "res://assets/textures/items/ores/raw_copper.png",
	"Iron": "res://assets/textures/items/ores/raw_iron.png",
	"Raw Gold": "res://assets/textures/items/ores/raw_gold.png",
	"Emerald": "res://assets/textures/items/gems/emerald.png",
	"Ruby": "res://assets/textures/items/gems/ruby.png",
	"Sapphire": "res://assets/textures/items/gems/sapphire.png",
	"Diamond": "res://assets/textures/items/gems/diamond.png",
	"Ice": "res://assets/textures/items/ores/ice.png",
	"Magnetite": "res://assets/textures/items/ores/raw_magnetite.png",
	"Bauxite": "res://assets/textures/items/ores/raw_bauxite.png",
	"Topaz": "res://assets/textures/items/gems/topaz.png",
	"Garnet": "res://assets/textures/items/gems/garnet.png",
	"Tsavorite": "res://assets/textures/items/gems/tsavorite.png",
	"Lava Cluster": "res://assets/textures/items/ores/lava_cluster.png",
	"Dense Ice": "res://assets/textures/items/ores/dense_ice.png",
	"Amazonite": "res://assets/textures/items/gems/amazonite.png",
	"Ametrine": "res://assets/textures/items/gems/ametrine.png",
	"Apatite": "res://assets/textures/items/gems/apatite.png",
	"Frozen Diamond": "res://assets/textures/items/gems/frozen_diamond.png",
	"Raw Galena": "res://assets/textures/items/ores/raw_galena.png",
	"Raw Silver": "res://assets/textures/items/ores/raw_silver.png",
	"Raw Wolframite": "res://assets/textures/items/ores/raw_wolframite.png",
	"Raw Pyrolusite": "res://assets/textures/items/ores/raw_pyrolusite.png",
	"Raw Nickel": "res://assets/textures/items/ores/raw_nickel.png",
	"Raw Uranium": "res://assets/textures/items/ores/raw_uranium.png",
	"Raw Platinum": "res://assets/textures/items/ores/raw_platinum.png",
	"Raw Zirconium": "res://assets/textures/items/ores/raw_zirconium.png",
	"Raw Cobalt": "res://assets/textures/items/ores/raw_cobalt.png",
	"Sulfur": "res://assets/textures/items/ores/sulfur.png",
	"Graphite": "res://assets/textures/items/ores/graphite.png",
	"Charoite": "res://assets/textures/items/gems/charoite.png",
	"Sugilite": "res://assets/textures/items/gems/sugilite.png",
	"Peridot": "res://assets/textures/items/gems/peridot.png",
	"Sandstone": "res://assets/textures/items/ores/sandstone.png",
	"Gypsum": "res://assets/textures/items/ores/gypsum.png",
	"Kaolinite": "res://assets/textures/items/ores/kaolinite.png",
	"Raw Scheelite": "res://assets/textures/items/ores/raw_scheelite.png",
	"Vanadinite": "res://assets/textures/items/ores/vanadinite.png",
	"Oil Shale": "res://assets/textures/items/ores/oil_shale.png",
	"Azurite": "res://assets/textures/items/gems/azurite.png",
	"Bloodstone": "res://assets/textures/items/gems/bloodstone.png",
	"Chalcedony": "res://assets/textures/items/gems/chalcedony.png",
	"Biomass": "res://assets/textures/items/misc/biomass.png"
}

var selecting_mission = false
var mission_selected = false
var skin_selected : int = 0

var target_zoom: float = 1.0
const ZOOM_FACTOR: float = 25
var min_zoom = 0.15
var max_zoom = 2.5

var lobby_fade_in : float = 0

var consoantes = ['b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z']
var vogais = ['a', 'e', 'i', 'o', 'u']

var delta_thumbnail = preload("res://assets/textures/universe/orbits_and_fields/thumbs/delta.png")
var gamma_thumbnail = preload("res://assets/textures/universe/orbits_and_fields/thumbs/gamma.png")
var omega_thumbnail = preload("res://assets/textures/universe/orbits_and_fields/thumbs/omega.png")
var koppa_thumbnail = preload("res://assets/textures/universe/orbits_and_fields/thumbs/koppa.png")

var skin_path : String = str("user://save/", GetSaveFile.save_being_used, "/skin.cfg")
var money_path : String = str("user://save/", GetSaveFile.save_being_used, "/money.cfg")
var missions_path : String = str("user://save/", GetSaveFile.save_being_used, "/missions.json")
var resources_path : String = str("user://save/", GetSaveFile.save_being_used, "/inventory_resources.cfg")
var crafted_path : String = str("user://save/", GetSaveFile.save_being_used, "/inventory_crafted.cfg")
var difficulty_path : String = str("user://save/", GetSaveFile.save_being_used, "/difficulty.cfg")
var pricing_path : String = str("user://pricing.cfg")

var selected_item_name : String = ""
var selected_item_quantity : int = 0

var current_page = 1
var current_asteroid_name : String
var current_asteroid_biome : String
var current_field : String
var asteroid_temperature

var delta_ammount : int = 0
var gamma_ammount : int = 0
var omega_ammount : int = 0
var koppa_ammount : int = 0

@onready var item_list = $Camera2D/HUD/Lobby/LobbyPanel/StoragePanel/ItemList
var item_selected : int = -1
var selected_inventory = 0

var difficulty : String

func _ready():
	var raw_config = ConfigFile.new()
	raw_config.load(str("user://save/", GetSaveFile.save_being_used, "/inventory_resources.cfg"))
	populate_inventory_tab(raw_config)
	
	$Camera2D/HUD/Lobby/LobbyPanel/MoneyPanel.visible = true
	$Camera2D/HUD/Lobby/LobbyPanel/CompanyLicensePanel.visible = true
	$Camera2D/HUD/Lobby/LobbyPanel/UniverseMapPanel.visible = true
	$Camera2D/HUD/Lobby/LobbyPanel/CraftingPanel.visible = true
	$Camera2D/HUD/Lobby/LobbyPanel/SkinSelectionPanel.visible = true
	$Camera2D/HUD/Lobby/LobbyPanel/StoragePanel.visible = true
	
	for button in get_tree().get_nodes_in_group("Buttons"):
		button.mouse_entered.connect(func(): _on_button_mouse_entered())
		
	var day_file = ConfigFile.new()
	day_file.load(str("user://save/", GetSaveFile.save_being_used, "/day.cfg"))
	var current_day = str(day_file.get_value("day", "current", "what"))
	$Camera2D/HUD/Lobby/LobbyPanel/MoneyPanel/DaysLabel.text = str("Day: ", current_day)
	
	var save_file = ConfigFile.new()
	save_file.load(str("user://save/", GetSaveFile.save_being_used, "/money.cfg"))
	var current_money = str(save_file.get_value("money", "current", 0))
	update_money(str(current_money))
	
	load_skin()
	
	if $Camera2D/HUD/Lobby/LobbyPanel/StoragePanel/ItemList.item_count == 0:
		$Camera2D/HUD/Lobby/LobbyPanel/StoragePanel/ItemList.visible = false
		$Camera2D/HUD/Lobby/LobbyPanel/StoragePanel/UnavailableLabel.visible = true
	else: 
		$Camera2D/HUD/Lobby/LobbyPanel/StoragePanel/ItemList.visible = true
		$Camera2D/HUD/Lobby/LobbyPanel/StoragePanel/UnavailableLabel.visible = false
	
	$Camera2D/HUD/Lobby/BackToLobbyButton.visible = false
	$Camera2D/HUD/Lobby/InfoPanel.visible = false
	$Camera2D/HUD/Lobby/SystemInfoPanel.visible = false
	$Camera2D/HUD/Lobby/InfoPanel/SelectMissionPanel.visible = false
	$Camera2D/HUD/Lobby/ZoomRuler.visible = false
	$Camera2D/HUD/Lobby/LoadingPanel.visible = false
	
	var file = FileAccess.open(missions_path, FileAccess.READ)
	if file:
		var result = file.get_as_text()
		if result == str(0):
			file.close()
			save_asteroid_data()
		else:
			print("[lobby.gd/missions.json] file is not empty!")
	else:
		print("[lobby.gd/missions.json] failed to open file!")
	
	get_pages()
	
	$Camera2D/HUD/Lobby/InfoPanel/AsteroidGUIder/Numberization.text = "[center]%s[/center]" % "00/00"
	$Camera2D/HUD/Lobby/InfoPanel/Description.text = ""
	$Camera2D/HUD/Lobby/InfoPanel/AsteroidGUIder.visible = false
	$Camera2D/HUD/Lobby/InfoPanel/FieldImage.visible = false
	$Camera2D/HUD/Lobby/InfoPanel/FieldImage/ImageBorders.visible = false
	$Camera2D/HUD/Lobby/InfoPanel/FieldBeltName.text = "[center]%s[/center]" % "[ ! ] Select an Asteroid Field"
	$Camera2D/HUD/Lobby/InfoPanel.size = Vector2i(387, 146)
	
	$FieldNameLabel.text = ""
	
	if DiscordRPC.get_is_discord_working():
		DiscordRPC.small_image = "diamond-512"
		DiscordRPC.small_image_text = "Debt: " + update_money(current_money) + " €" 
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

func _enter_tree() -> void:
	$Camera2D/HUD/Lobby/LobbyPanel/MoneyPanel.modulate.a8 = 0
	$Camera2D/HUD/Lobby/LobbyPanel/CompanyLicensePanel.modulate.a8 = 0
	$Camera2D/HUD/Lobby/LobbyPanel/UniverseMapPanel.modulate.a8 = 0
	$Camera2D/HUD/Lobby/LobbyPanel/CraftingPanel.modulate.a8 = 0
	$Camera2D/HUD/Lobby/LobbyPanel/SkinSelectionPanel.modulate.a8 = 0
	$Camera2D/HUD/Lobby/LobbyPanel/StoragePanel.modulate.a8 = 0
	target_zoom = $SolarSystem.scale.x

func _process(delta: float) -> void:
	if selecting_mission:
		$UniverseBackground.position = get_global_mouse_position() * 0.01 - Vector2(1500, 1500)
	
	if selecting_mission:
		$Camera2D/HUD/Lobby/ZoomRuler.visible = true
		if Input.is_action_just_pressed("Universe_Zoom_In"):
			target_zoom = clamp(target_zoom + 0.05, min_zoom, max_zoom)
		if Input.is_action_just_pressed("Universe_Zoom_Out"):
			target_zoom = clamp(target_zoom - 0.05, min_zoom, max_zoom)
		$SolarSystem.scale = lerp($SolarSystem.scale, Vector2(target_zoom, target_zoom), 5 * delta)
	$Camera2D/HUD/Lobby/ZoomRuler/ZoomLabel.text = "Zoom: " + str(snapped(target_zoom * ZOOM_FACTOR, 0) / 4) + "x"
	
	lobby_fade_in = 255 * (1 - clamp($FadeInLobby.time_left, 0.0, 1.0))
	$Camera2D/HUD/Lobby/LobbyPanel/MoneyPanel.modulate.a8 = lobby_fade_in
	$Camera2D/HUD/Lobby/LobbyPanel/CompanyLicensePanel.modulate.a8 = lobby_fade_in
	$Camera2D/HUD/Lobby/LobbyPanel/UniverseMapPanel.modulate.a8 = lobby_fade_in
	$Camera2D/HUD/Lobby/LobbyPanel/CraftingPanel.modulate.a8 = lobby_fade_in
	$Camera2D/HUD/Lobby/LobbyPanel/SkinSelectionPanel.modulate.a8 = lobby_fade_in
	$Camera2D/HUD/Lobby/LobbyPanel/StoragePanel.modulate.a8 = lobby_fade_in
	
	if mission_selected : $Camera2D/HUD/Lobby/InfoPanel/SelectMissionPanel.visible = true
	
	if current_page >= 1 :
		match current_field:
			"Delta Belt":
				if current_page > delta_ammount:
					current_page = delta_ammount
				$Camera2D/HUD/Lobby/InfoPanel/AsteroidGUIder/Numberization.text =  "[center]%s[/center]" % str(current_page) + "/" + str(delta_ammount)
			"Gamma Field":
				if current_page > gamma_ammount:
					current_page = gamma_ammount
				$Camera2D/HUD/Lobby/InfoPanel/AsteroidGUIder/Numberization.text =  "[center]%s[/center]" % str(current_page) + "/" + str(gamma_ammount)
			"Omega Field":
				if current_page > omega_ammount:
					current_page = omega_ammount
				$Camera2D/HUD/Lobby/InfoPanel/AsteroidGUIder/Numberization.text =  "[center]%s[/center]" % str(current_page) + "/" + str(omega_ammount)
			"Koppa Belt":
				if current_page > koppa_ammount:
					current_page = koppa_ammount
				$Camera2D/HUD/Lobby/InfoPanel/AsteroidGUIder/Numberization.text =  "[center]%s[/center]" % str(current_page) + "/" + str(koppa_ammount)
	else: 
		current_page = 1

# Event functions for each area
func _on_delta_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		update_field_ui("Delta Belt", delta_thumbnail, Color(0.788, 0.161, 0.161, 1))

func _on_gamma_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		update_field_ui("Gamma Field", gamma_thumbnail, Color(0.157, 0.349, 0.788, 1))

func _on_omega_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		update_field_ui("Omega Field", omega_thumbnail, Color(0.157, 0.788, 0.549, 1))

func _on_yotta_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		update_field_ui("Koppa Belt", koppa_thumbnail, Color(0.659, 0.157, 0.788, 1))

func update_field_ui(field_name: String, thumbnail: Texture, shadow_color: Color) -> void:
	current_page = 1
	current_field = field_name
	get_asteroid_info()
	
	# Mostrar toda a info:
	$Camera2D/HUD/Lobby/InfoPanel/AsteroidGUIder.visible = true
	$Camera2D/HUD/Lobby/InfoPanel/FieldImage.visible = true
	$Camera2D/HUD/Lobby/InfoPanel/FieldImage/ImageBorders.visible = true
	$Camera2D/HUD/Lobby/InfoPanel/SelectMissionPanel/SelectMissionButton.visible = true

	# Atualizar Imagem, Texto, Cores e o InfoPanel
	$Camera2D/HUD/Lobby/InfoPanel/FieldImage.texture = thumbnail
	$Camera2D/HUD/Lobby/LobbyPanel/UniverseMapPanel/FieldLobbyThumbnail.texture = thumbnail
	$Camera2D/HUD/Lobby/LobbyPanel/UniverseMapPanel/FielName.text = field_name
	$Camera2D/HUD/Lobby/LobbyPanel/UniverseMapPanel/FielName.add_theme_color_override("font_shadow_color", shadow_color)
	$Camera2D/HUD/Lobby/InfoPanel/FieldBeltName.text = "[center]%s[/center]" % field_name
	$Camera2D/HUD/Lobby/InfoPanel/FieldBeltName.add_theme_color_override("font_shadow_color", shadow_color)
	$Camera2D/HUD/Lobby/InfoPanel.size = Vector2i(387, 661)
	$Camera2D/HUD/Lobby/LobbyPanel/UniverseMapPanel/ControlPanel/StartButton.disabled = false

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

func change_to_world(field):
	var new_world = preload("res://scenes/world.tscn").instantiate()
	new_world.asteroid_field = field
	get_tree().root.add_child(new_world)
	get_tree().current_scene.call_deferred("free")
	get_tree().current_scene = new_world

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
	var biomes = ["Stony", "Vulcanic", "Frozen", "Swamp", "Desert"]
	var objectives_primary = ["n/a"]
	var objectives_secondary = ["n/a"]
	
	for field_name in field_names:
		var asteroids = {}  # Dictionary to store asteroids in the current field
		var asteroid_id = 1  # Reset asteroid ID counter for each field
			
		for asteroid_num in range(1, randi_range(4, 10) + 1):
			var as_name = create_asteroid_name()
			var biome = biomes[randi() % biomes.size()]
			match biome:
				"Stony": asteroid_temperature = randi_range(15, 30)
				"Vulcanic": asteroid_temperature = randi_range(75, 90)
				"Frozen": asteroid_temperature = randi_range(-45, -65)
				"Swamp": asteroid_temperature = randi_range(-5, 12)
				"Desert": asteroid_temperature = randi_range(50, 65)
			var primary_objective = objectives_primary[randi() % objectives_primary.size()]
			var secondary_objective = objectives_secondary[randi() % objectives_secondary.size()]
			
			# Create asteroid entry
			asteroids[asteroid_id] = {
				"Name": as_name,
				"Biome": biome,
				"Temperature": asteroid_temperature,
				"Objectives": {
					"Primary": primary_objective,
					"Secondary": secondary_objective
				}
			}
			asteroid_id += 1  # Increment the ID for the next asteroid
		
		fields[field_name] = asteroids  # Add the field with its asteroids to the fields dictionary
	
	return fields

# Save data to a JSON file
func save_asteroid_data():
	var asteroid_data = generate_asteroid_data()
	
	var result = JSON.stringify(asteroid_data, "\t")
	
	var file = FileAccess.open(str("user://save/", GetSaveFile.save_being_used, "/missions.json"), FileAccess.WRITE)
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
		var file = FileAccess.open(missions_path, FileAccess.READ)
		var parse_result = JSON.parse_string(file.get_as_text())
		file.close()
		
		if current_field == "Delta Belt" and current_page <= delta_ammount \
			or current_field == "Gamma Field" and current_page <= gamma_ammount \
			or current_field == "Omega Field" and current_page <= omega_ammount \
			or current_field == "Koppa Belt" and current_page <= koppa_ammount:
			
			var asteroid_info = parse_result[current_field][str(current_page)]
			current_asteroid_name = asteroid_info["Name"]
			$Camera2D/HUD/Lobby/LobbyPanel/UniverseMapPanel/AsteroidName.text = "Going to: " + current_asteroid_name
			current_asteroid_biome = asteroid_info["Biome"]
			var temperature = asteroid_info["Temperature"]
			asteroid_temperature = temperature
			var primary = asteroid_info["Objectives"]["Primary"]
			var secondary = asteroid_info["Objectives"]["Secondary"]
			$Camera2D/HUD/Lobby/LobbyPanel/UniverseMapPanel/AsteroidDescription.text = "\nMission Review:\n\nBiome: " + str(current_asteroid_biome) + "\nTemperature: " + str(temperature) + "ᵒC\n\nPrimary: " + str(primary) +  "\nSecundary: " + str(secondary)
			$Camera2D/HUD/Lobby/InfoPanel/Description.text = "Name: " + str(current_asteroid_name) + "\nBiome: " + str(current_asteroid_biome) + "\nTemperature: " + str(temperature) + "ᵒC\nPrimary: " + str(primary) +  "\nSecundary: " + str(secondary)
		else:
			print("An error ocurred trying to parse asteroid content, if early pages of the asteroid content appeared, it's all ok, maybe the issue it's because you haven't drinked enough water, you never know.")

func get_asteroids_per_field(field : String):
	# This Code in the Second Half was completly remade due to a error of impossibility of reading the asteroid data on the JSON File
	# Ensure the file is opened and read correctly
	var file = FileAccess.open(missions_path, FileAccess.READ)
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
		print("Failed to open file: ", missions_path)
		return 0

func _on_select_mission_button_pressed() -> void:
	selecting_mission = true
	$Camera2D/HUD/Lobby/LobbyPanel.visible = false
	$Camera2D/HUD/Lobby/BackToLobbyButton.visible = true
	$Camera2D/HUD/Lobby/InfoPanel.visible = true
	$Camera2D/HUD/Lobby/SystemInfoPanel.visible = true
	$Camera2D/HUD/Lobby/ZoomRuler.visible = false
	$Camera2D/HUD/Lobby/SystemInfoPanel/SystemName.text = "[center]%s[/center]" % "Solar System"
	$Camera2D/HUD/Lobby/LobbyPanel/UniverseMapPanel/ControlPanel/StartButton.disabled = false

func _on_back_button_pressed() -> void:
	Input.set_custom_mouse_cursor(load("res://assets/textures/player/main_cursor.png"))
	var new_game_scene = load("res://scenes/main_menu.tscn")
	get_tree().change_scene_to_packed(new_game_scene)
	new_game_scene.instantiate()

func _on_start_button_pressed() -> void:
	if mission_selected == true:
		$Camera2D/HUD/Lobby/LobbyPanel/MoneyPanel.visible = false
		$Camera2D/HUD/Lobby/LobbyPanel/CompanyLicensePanel.visible = false
		$Camera2D/HUD/Lobby/LobbyPanel/UniverseMapPanel.visible = false
		$Camera2D/HUD/Lobby/LobbyPanel/CraftingPanel.visible = false
		$Camera2D/HUD/Lobby/LobbyPanel/SkinSelectionPanel.visible = false
		$Camera2D/HUD/Lobby/LobbyPanel/StoragePanel.visible = false
		$Camera2D/HUD/Lobby/LoadingPanel.visible = true
		$Camera2D/HUD/Lobby/BackToLobbyButton.text = "Loading ..."
		$Camera2D/HUD/Lobby/BackToLobbyButton.position = Vector2(858, 510)
		$Camera2D/HUD/Lobby/BackToLobbyButton.scale = Vector2(1.5, 1.5)
		$TimeToStart.start()

func _on_time_to_start_timeout() -> void:
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
	$Camera2D/HUD/Lobby/LobbyPanel.visible = true
	$Camera2D/HUD/Lobby/BackToLobbyButton.visible = false
	$Camera2D/HUD/Lobby/InfoPanel.visible = false
	$Camera2D/HUD/Lobby/SystemInfoPanel.visible = false
	$Camera2D/HUD/Lobby/ZoomRuler.visible = false

func _select_mission_button_info_panel_pressed() -> void:
	selecting_mission = false
	$Camera2D/HUD/Lobby/LobbyPanel.visible = true
	$Camera2D/HUD/Lobby/BackToLobbyButton.visible = false
	$Camera2D/HUD/Lobby/InfoPanel.visible = false
	$Camera2D/HUD/Lobby/SystemInfoPanel.visible = false
	$Camera2D/HUD/Lobby/InfoPanel/SelectMissionPanel.visible = false
	$Camera2D/HUD/Lobby/ZoomRuler.visible = false
	$Camera2D/HUD/Lobby/LobbyPanel/UniverseMapPanel/ControlPanel/StartButton.disabled = false

func load_skin():
	if FileAccess.file_exists(skin_path):
		var skin_file = ConfigFile.new()
		skin_file.load(skin_path)
		skin_selected = int(skin_file.get_value("skin", "selected", 0))
	$Camera2D/HUD/Lobby/LobbyPanel/SkinSelectionPanel/SkinDisplay.texture = load("res://assets/textures/player/skins/" + str(skin_selected) + "/duck.png")
	DiscordRPC.large_image = str(skin_selected) + "duck"
	print("[lobby.gd] Changed Discord Large Image to: ", DiscordRPC.large_image)
	DiscordRPC.refresh()

func _on_skin_previous_button_pressed() -> void:
	skin_selected -= 1
	if skin_selected < 1 : skin_selected = 1
	
	$Camera2D/HUD/Lobby/LobbyPanel/SkinSelectionPanel/SkinDisplay.texture = load("res://assets/textures/player/skins/" + str(skin_selected) + "/duck.png")
	DiscordRPC.large_image = str(skin_selected) + "duck"
	print(DiscordRPC.large_image)
	DiscordRPC.refresh()
	
	if FileAccess.file_exists(skin_path):
		var skin_file = ConfigFile.new()
		skin_file.load(skin_path)
		skin_file.set_value("skin", "selected", skin_selected)
		skin_file.save(skin_path)

func _on_skin_next_button_pressed() -> void:
	skin_selected += 1
	if skin_selected >= 6 : skin_selected = 6
	
	$Camera2D/HUD/Lobby/LobbyPanel/SkinSelectionPanel/SkinDisplay.texture = load("res://assets/textures/player/skins/" + str(skin_selected) + "/duck.png")
	DiscordRPC.large_image = str(skin_selected) + "duck"
	DiscordRPC.refresh()
	
	if FileAccess.file_exists(skin_path):
		var skin_file = ConfigFile.new()
		skin_file.load(skin_path)
		skin_file.set_value("skin", "selected", skin_selected)
		skin_file.save(skin_path)

func get_pages():
	delta_ammount =  get_asteroids_per_field("Delta Belt")
	gamma_ammount =  get_asteroids_per_field("Gamma Field")
	omega_ammount =  get_asteroids_per_field("Omega Field")
	koppa_ammount =  get_asteroids_per_field("Koppa Belt")

func _on_button_mouse_entered() -> void:
	var mouse_sound = $MouseSoundEffects
	if mouse_sound:
		mouse_sound.stream = load("res://sounds/sound_effects/mining1.ogg")
		mouse_sound.pitch_scale = 1
		mouse_sound.play()

func _on_stock_market_label_pressed() -> void:
	$Camera2D/HUD/StockTheMarket/AnimationPlayer.play("stock_the_up")

func _on_tab_bar_item_selected(index: int) -> void:
	print("[lobby.gd] Inventory Selected: ", index)
	selected_inventory = index
	
	var raw_inv_path = str("user://save/", GetSaveFile.save_being_used, "/inventory_resources.cfg")
	var raw_config = ConfigFile.new()
	var raw_load_result = raw_config.load(raw_inv_path)
	
	var crafted_inv_path = str("user://save/", GetSaveFile.save_being_used, "/inventory_crafted.cfg")
	var crafted_config = ConfigFile.new()
	var crafted_load_result = crafted_config.load(crafted_inv_path)
	
	if raw_load_result == OK and crafted_load_result == OK:
		print("Detected both Inventories Successfully")
		item_list.clear()
		match index:
			0: populate_inventory_tab(raw_config)
			1: populate_inventory_tab(crafted_config)
	else:
		print("[lobby.gd] Failed to load CFG file: ", raw_inv_path)
		print("[lobby.gd] or")
		print("[lobby.gd] Failed to load CFG file: ", crafted_inv_path)

func populate_inventory_tab(config: ConfigFile) -> void:
	if config.has_section("inventory"):
		var inventory_data = config.get_section_keys("inventory")
		if inventory_data and inventory_data.size() > 0:
			for item_name in inventory_data:
				var quantity = config.get_value("inventory", item_name, 0)
				var item_text = "%s: %d" % [item_name, quantity]
				
				var icon = load(item_icons.get(item_name, "res://assets/textures/items/no_texture.png"))
				var item_index = item_list.add_item(item_text)
				item_list.set_item_icon(item_index, icon)
			
			item_list.visible = true
			$Camera2D/HUD/Lobby/LobbyPanel/StoragePanel/UnavailableLabel.visible = false
	else:
		item_list.visible = false
		$Camera2D/HUD/Lobby/LobbyPanel/StoragePanel/UnavailableLabel.visible = true
		print("[lobby.gd] Config: ", config, " does not have section Inventory.")

func _on_item_list_item_selected(index: int) -> void:
	item_selected = index
	var item_selected_string = item_list.get_item_text(index)
	var parts = item_selected_string.split(":")
	selected_item_name = parts[0].strip_edges()
	selected_item_quantity = int(parts[1].strip_edges())
	print("\nItem Name: ", selected_item_name)
	print("Item Quantity: ", selected_item_quantity)

func _on_sell_button_pressed() -> void:
	item_list.remove_item(item_selected)
	var price = get_price(selected_item_name)
	remove_item_from_inventory(selected_item_name)
	var money_earned = price * selected_item_quantity
	
	var difficulty_file = ConfigFile.new()
	difficulty_file.load(difficulty_path)
	difficulty = difficulty_file.get_value("difficulty", "current")
	print("[lobby.gd/_on_sell_button_pressed] Current Difficulty: ", difficulty)
	match difficulty:
		"easy": money_earned *= 1.10
		"hard": money_earned *= 0.9
	
	money_earned = round(money_earned)
	
	print("Item Price: ", price)
	print("Money Earned: ", money_earned)
	
	var money = ConfigFile.new()
	money.load(money_path)
	var current_money = money.get_value("money", "current")
	var new_money = current_money + money_earned
	money.set_value("money", "current", new_money)
	money.save(money_path)
	
	update_money(str(new_money))
	item_selected = -1
	selected_item_name = ""
	selected_item_quantity = 0

func get_price(item_name):
	var pricing = ConfigFile.new()
	pricing.load(pricing_path)
	var price = pricing.get_value("pricing", item_name, 1)
	return price

func remove_item_from_inventory(item_name):
	if selected_inventory == 0:
		var resources = ConfigFile.new()
		resources.load(resources_path)
		resources.erase_section_key("inventory", item_name)
		resources.save(resources_path)
	elif selected_inventory == 1:
		var crafted = ConfigFile.new()
		crafted.load(crafted_path)
		crafted.erase_section_key("inventory", item_name)
		crafted.save(crafted_path)

func update_money(strinfied_money):
	var formatted_number = ""
	var counter = 0
	
	for i in range(strinfied_money.length() - 1, -1, -1):
		formatted_number = strinfied_money[i] + formatted_number
		counter += 1
		
		if counter % 3 == 0 and i != 0:
			formatted_number = " " + formatted_number
		
	$Camera2D/HUD/Lobby/LobbyPanel/MoneyPanel/MoneyLabel.text = "Debt: " + formatted_number + " €"
	return formatted_number
