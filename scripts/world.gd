extends Node2D

var register_logs = true

var world_width # Previous: 300
var world_height # Previous: 1000
var world_height_border # Always: world_height + 20

var world_seed = randi_range(0, 2147483646)

const world_border_up_and_down = 10
const world_border_sides = 12

var asteroid_name
var asteroid_field
var asteroid_biome
var asteroid_temperature

var time_remaining_Title_Timer
var time_remaining_HUD_Fade_In

var fade_in : float = 0.0
var fade_out : float = 0.0

@onready var CaveSystem = $WorldTileMap/CaveSystem

var config_path : String = "user://game_settings.cfg"
var config_file : ConfigFile = ConfigFile.new()

var difficulty_path : String = "user://game_settings.cfg"
var difficulty_file : ConfigFile = ConfigFile.new()

var statistics_path : String = str("user://save/", GetSaveFile.save_being_used, "/statistics.cfg")
var statistics_config : ConfigFile = ConfigFile.new()

var primary_objective : String = ""
var secundary_objective : String = ""

func _process(_delta: float) -> void:
	$WorldMusic.position = $Player.position
	update_radar_tool()
	
	time_remaining_Title_Timer = $TitleTimer.time_left
	time_remaining_HUD_Fade_In = $HUDFadeIn.time_left
	
	fade_out = time_remaining_Title_Timer / 10
	
	if $HUDFadeIn.time_left <= 5:
		fade_in += time_remaining_HUD_Fade_In
	
	$Player/HUD/AsteroidTitle.add_theme_color_override("default_color", Color(1, 1, 1, fade_out))
	$Player/HUD/FieldTitle.add_theme_color_override("default_color", Color(0.509, 0.509, 0.509, fade_out))
	$Player/Camera2D/HUD/VersionDisplay.modulate.a8 = fade_in
	
	$Player/Camera2D/HUD/FreezingOverlay.modulate.a8 = fade_in
	$Player/Camera2D/HUD/Hotbar/TabBar.modulate.a8 = fade_in
	
	$Player/HUD/RadarPanel.modulate.a8 = fade_in
	$Player/HUD/RadarPanelEnemies.modulate.a8 = fade_in
	
	$Player/HUD/MissionList.modulate.a8 = fade_in
	$Player/HUD/ItemList.modulate.a8 = fade_in
	
	$Player/Camera2D/HUD/Stats/UI/HealthPanel.modulate.a8 = fade_in
	$Player/Camera2D/HUD/Stats/UI/OxygenPanel.modulate.a8 = fade_in
	$Player/Camera2D/HUD/Stats/UI/BatteryPanel.modulate.a8 = fade_in
	
func start_music():
	var random_music = randi_range(1, 3)
	if asteroid_biome == "Stony":
		match random_music:
			1: $WorldMusic/Enter.play()
			2: $WorldMusic/Wave.play()
			3: $WorldMusic/Void.play()
	elif asteroid_biome == "Vulcanic":
		match random_music:
			1: $WorldMusic/Rift.play()
			2: $WorldMusic/Wave.play()
			3: $WorldMusic/Void.play()
	elif asteroid_biome == "Frozen":
		match random_music:
			1: $WorldMusic/Portal.play()
			2: $WorldMusic/Enter.play()
			3: $WorldMusic/Rift.play()
	elif asteroid_biome == "Swamp":
		match random_music:
			1: $WorldMusic/Void.play()
			2: $WorldMusic/Enter.play()
			3: $WorldMusic/Wave.play()
	elif asteroid_biome == "Desert":
		match random_music:
			1: $WorldMusic/Rift.play()
			2: $WorldMusic/Wave.play()
			3: $WorldMusic/Portal.play()

func _ready():
	config_file.load(config_path)
	$WorldEnvironment.environment.glow_enabled = config_file.get_value("display", "bloom")
	$Player/HUD/ColorblindnessColorRect.material.set_shader_parameter("mode", config_file.get_value("accessibility", "colorblindness", 0))
	
	$Player/HUD/AsteroidTitle.visible = true
	$Player/HUD/FieldTitle.visible = true
	
	$Player/HUD/AsteroidTitle.text = "[center]%s[/center]" % asteroid_name
	$Player/HUD/FieldTitle.text = "[center]%s[/center]" % asteroid_field + " | " + asteroid_biome
	
	if DiscordRPC.get_is_discord_working():
		if asteroid_field == null:
			DiscordRPC.details = "🌑: " + asteroid_name + " at Unknown Field"
		else:
			DiscordRPC.details = "🌑: " + asteroid_name + " at " + asteroid_field
		DiscordRPC.refresh()
	else:
		print("[world_generation.gd] Discord isn't running or wasn't detected properly, skipping rich presence.")
	
	start_music()
	create_radar_lines()
	create_radar_enemies_lines()
	
	match asteroid_field:
		"Delta Belt":
			world_width = randi_range(100, 150)
			world_height = randi_range(800, 950)
		"Gamma Field":
			world_width = randi_range(125, 200)
			world_height = randi_range(850, 1025)
		"Omega Field":
			world_width = randi_range(125, 225)
			world_height = randi_range(850, 1000)
		"Koppa Belt":
			world_width = randi_range(125, 175)
			world_height = randi_range(1050, 1250)
		_:
			world_width = 150
			world_height = 150
	
	world_height_border = world_height + 20
	create_world_borders()
	
	var asteroid_size = Vector2i(world_width, world_height)
	
	var fnl = FastNoiseLite.new()
	fnl.seed = world_seed
	fnl.noise_type = FastNoiseLite.TYPE_SIMPLEX
	fnl.fractal_octaves = 4 #4
	fnl.fractal_lacunarity = 2.25 #2.5
	fnl.fractal_gain = 0.5 #0.4
	
	if (register_logs == true):
		print("\n[world_generation.gd]")
		print("World Procedural Generation Logs:")
		print("Asteroid Name: ", asteroid_name)
		print("Asteroid Size: ", asteroid_size)
		print("Asteroid Biome: ", asteroid_biome)
		print("Asteroid Temperature: ", asteroid_temperature)
		print("Asteroid Field: ", asteroid_field, "\n")
		print("Seed: ", fnl.seed)
		print("Noise Type: ", fnl.noise_type)
		print("Octaves: ", fnl.fractal_octaves)
		print("Lacunarity: ", fnl.fractal_lacunarity)
		print("Gain: ", fnl.fractal_gain)
		print("[world_generation.gd]")
		
	# Make Caverns
	for x in range(world_width):
		for y in range(world_height):
			if asteroid_biome == "Stony":
				CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
			elif asteroid_biome == "Vulcanic":
				CaveSystem.set_cell(Vector2i(x, y), 1, Vector2i(0, 0))
			elif asteroid_biome == "Frozen":
				CaveSystem.set_cell(Vector2i(x, y), 2, Vector2i(0, 0))
			elif asteroid_biome == "Swamp":
				CaveSystem.set_cell(Vector2i(x, y), 3, Vector2i(0, 0))
			elif asteroid_biome == "Desert":
				CaveSystem.set_cell(Vector2i(x, y), 4, Vector2i(0, 0))
			elif asteroid_biome == "Radioactive":
				CaveSystem.set_cell(Vector2i(x, y), 5, Vector2i(0, 0))
			var noise = floor(fnl.get_noise_2d(x, y) * 5)
			if noise == 0 and asteroid_biome == "Stony":
				CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(0, 1))
			elif noise == 0 and asteroid_biome == "Vulcanic":
				CaveSystem.set_cell(Vector2i(x, y), 1, Vector2i(0, 1))
			elif noise == 0 and asteroid_biome == "Frozen":
				CaveSystem.set_cell(Vector2i(x, y), 2, Vector2i(0, 1))
			elif noise == 0 and asteroid_biome == "Swamp":
				CaveSystem.set_cell(Vector2i(x, y), 3, Vector2i(0, 1))
			elif noise == 0 and asteroid_biome == "Desert":
				CaveSystem.set_cell(Vector2i(x, y), 4, Vector2i(0, 1))
			elif noise == 0 and asteroid_biome == "Radioactive":
				CaveSystem.set_cell(Vector2i(x, y), 5, Vector2i(0, 1))
	
	#Create safe Cube
	start_position()
	
	# Put Ores:
	match asteroid_biome:
		"Stony":
			put_coal()
			put_copper()
			put_iron()
			put_gold()
			put_diamond()
			put_gems()
			
		"Vulcanic":
			put_coal()
			put_magnetite()
			put_iron()
			put_bauxite()
			put_gold()
			put_diamond()
			put_gems()
			put_lava_sockets()
			
		"Frozen":
			put_galena()
			put_silver()
			put_wolframite()
			put_pyrolustite()
			put_nickel()
			put_diamond()
			put_gems()
			put_dense_ice()
			
		"Swamp":
			put_graphite()
			put_cobalt()
			put_uranium()
			put_platinum()
			put_zirconium()
			put_sulfur()
			put_gems()
			
		"Desert":
			put_oil_shale()
			put_gypsum()
			put_kaolinite()
			put_scheelite()
			put_vanadite()
			put_gems()
		
		"Radioactive":
			pass
	# Procedural code from: https://www.youtube.com/watch?v=MU3u00f3GqQ | SupercraftD | 04/10/2024

func create_world_borders():
# Above Map Border
	for y in range(world_border_up_and_down):
		y = -abs(y)
		for x in range(world_width):
			CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(2, 2))
	
	# Below Map Border
	for y in range(world_border_up_and_down):
		y += world_height
		for x in range(world_width):
			CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(2, 2))
	
	# Left Map Border
	for x in range(world_border_sides):
		x += world_width
		for y in range(world_height_border):
			y -= 9
			CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(2, 2))
	
	# Right Map Border
	for x in range(world_border_sides):
		x = -abs(x)
		for y in range(world_height_border):
			y -= 9
			CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(2, 2))

func put_ore(ore_height_min, ore_height_max, spawn_chance, biome, atlas_coords, clustering):
	for x in range(world_width):
		for y in range(ore_height_min, ore_height_max):
			if randi_range(0, spawn_chance) == 1:
				var tile_pos = Vector2i(x, y)
				if CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 0):
					CaveSystem.set_cell(tile_pos, biome, atlas_coords)
					for dx in range(-1, 2):
						for dy in range(-1, 2):
							if not (dx == 0 and dy == 0) and randi_range(0, 100) < clustering:
								var neighbor_pos = Vector2i(x + dx, y + dy)
								if CaveSystem.get_cell_atlas_coords(neighbor_pos) == Vector2i(0, 0):
									CaveSystem.set_cell(neighbor_pos, biome, atlas_coords)

func put_coal():
	if asteroid_biome == "Stony":
		put_ore(0, 200, 150, 0, Vector2i(1, 0), 20)
	elif asteroid_biome == "Vulcanic":
		put_ore(0, 200, 150, 1, Vector2i(1, 0), 20)

func put_copper():
	if asteroid_biome == "Stony":
		put_ore(0, 500, 175, 0, Vector2i(1, 2), 20)

func put_magnetite():
	if asteroid_biome == "Vulcanic":
		put_ore(0, 500, 200, 1, Vector2i(1, 2), 20)

func put_iron():
	if asteroid_biome == "Stony":
		put_ore(200, 600, 200, 0, Vector2i(2, 0), 20)
	elif asteroid_biome == "Vulcanic":
		put_ore(200, 600, 200, 1, Vector2i(2, 0), 20)

func put_bauxite():
	if asteroid_biome == "Vulcanic":
		put_ore(200, 600, 200, 1, Vector2i(0, 3), 20)

func put_gold():
	if asteroid_biome == "Stony":
		put_ore(500, 800, 500, 0, Vector2i(0, 2), 20)
	elif asteroid_biome == "Vulcanic":
		put_ore(500, 800, 500, 1, Vector2i(0, 2), 20)

func put_diamond():
	if asteroid_biome == "Stony":
		put_ore(900, 2000, 750, 0, Vector2i(3, 0), 20)
	elif asteroid_biome == "Vulcanic":
		put_ore(900, 2000, 750, 1, Vector2i(3, 0), 20)
	elif asteroid_biome == "Frozen":
		put_ore(900, 2000, 750, 2, Vector2i(3, 0), 20)

func put_dense_ice():
	put_ore(0, 1000, 350, 2, Vector2i(3, 2), 20)

func put_lava_sockets():
	put_ore(0, 1000, 500, 1, Vector2i(3, 2), 20)

func put_galena():
	put_ore(500, 800, 400, 2, Vector2i(1, 0), 20)

func put_silver():
	put_ore(150, 1200, 250, 2, Vector2i(2, 0), 20)

func put_wolframite():
	put_ore(0, 400, 300, 2, Vector2i(0, 2), 20)

func put_pyrolustite():
	put_ore(600, 1000, 250, 2, Vector2i(1, 2), 20)

func put_nickel():
	put_ore(350, 650, 350, 2, Vector2i(0, 3), 20)

func put_graphite():
	put_ore(0, 1500, 350, 3, Vector2i(1, 0), 20)

func put_cobalt():
	put_ore(0, 425, 275, 3, Vector2i(2, 0), 20)

func put_uranium():
	put_ore(750, 950, 425, 3, Vector2i(3, 0), 20)

func put_platinum():
	put_ore(250, 550, 550, 3, Vector2i(0, 2), 20)

func put_zirconium():
	put_ore(0, 1100, 250, 3, Vector2i(1, 2), 20)

func put_sulfur():
	put_ore(350, 625, 450, 3, Vector2i(3, 2), 20)

func put_oil_shale():
	put_ore(0, 2000, 600, 4, Vector2i(1, 0), 20)
	
func put_gypsum():
	put_ore(0, 450, 300, 4, Vector2i(0, 2), 20)

func put_kaolinite():
	put_ore(0, 725, 300, 4, Vector2i(1, 2), 20)

func put_scheelite():
	put_ore(0, 500, 475, 4, Vector2i(2, 0), 20)

func put_vanadite():
	put_ore(600, 1200, 475, 4, Vector2i(3, 0), 20)

func put_gems():
	for x in range(world_width):
		for y in range(700, 1600):
			if randi_range(0, 625) == 1:
				var tile_pos = Vector2i(x, y)
				if CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 0):
					var random_gem = randi_range(1, 3)
					if asteroid_biome == "Stony":
						match random_gem:
							1: CaveSystem.set_cell(tile_pos, 0, Vector2i(1, 1))
							2: CaveSystem.set_cell(tile_pos, 0, Vector2i(2, 1))
							3: CaveSystem.set_cell(tile_pos, 0, Vector2i(3, 1))
					if asteroid_biome == "Vulcanic":
						match random_gem:
							1: CaveSystem.set_cell(tile_pos, 1, Vector2i(1, 1))
							2: CaveSystem.set_cell(tile_pos, 1, Vector2i(2, 1))
							3: CaveSystem.set_cell(tile_pos, 1, Vector2i(3, 1))
					if asteroid_biome == "Frozen":
						match random_gem:
							1: CaveSystem.set_cell(tile_pos, 2, Vector2i(1, 1))
							2: CaveSystem.set_cell(tile_pos, 2, Vector2i(2, 1))
							3: CaveSystem.set_cell(tile_pos, 2, Vector2i(3, 1))
					if asteroid_biome == "Swamp":
						match random_gem:
							1: CaveSystem.set_cell(tile_pos, 3, Vector2i(1, 1))
							2: CaveSystem.set_cell(tile_pos, 3, Vector2i(2, 1))
							3: CaveSystem.set_cell(tile_pos, 3, Vector2i(3, 1))
					if asteroid_biome == "Desert":
						match random_gem:
							1: CaveSystem.set_cell(tile_pos, 4, Vector2i(1, 1))
							2: CaveSystem.set_cell(tile_pos, 4, Vector2i(2, 1))
							3: CaveSystem.set_cell(tile_pos, 4, Vector2i(3, 1))
					if asteroid_biome == "Radioactive":
						match random_gem:
							1: CaveSystem.set_cell(tile_pos, 5, Vector2i(1, 1))
							2: CaveSystem.set_cell(tile_pos, 5, Vector2i(2, 1))
							3: CaveSystem.set_cell(tile_pos, 5, Vector2i(3, 1))

func _on_music_timer_timeout() -> void:
	start_music()

func start_position():
	var spawn_cube_size = 3
	
	# Random Position to the player Spawn
	var player_position = Vector2((world_width * 16) / 2, randi_range(10 * 16, 100 * 16))
	
	$Player.position = player_position
	
	# Sets the tilemap position by getting player.P 
	var player_at_tilemap_position = $WorldTileMap.local_to_map(player_position)
	
	# Makes the cube and offeset' it to the center the plater location
	for x in range(spawn_cube_size):
		x += player_at_tilemap_position.x -1
		for y in range(spawn_cube_size):
			y += player_at_tilemap_position.y -2
			if asteroid_biome == "Stony":
				CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(0, 1))
			elif asteroid_biome == "Vulcanic":
				CaveSystem.set_cell(Vector2i(x,y), 1, Vector2i(0, 1))
			elif asteroid_biome == "Frozen":
				CaveSystem.set_cell(Vector2i(x,y), 2, Vector2i(0, 1))
			elif asteroid_biome == "Swamp":
				CaveSystem.set_cell(Vector2i(x,y), 3, Vector2i(0, 1))
			elif asteroid_biome == "Desert":
				CaveSystem.set_cell(Vector2i(x,y), 4, Vector2i(0, 1))
			elif asteroid_biome == "Radioactive":
				CaveSystem.set_cell(Vector2i(x,y), 5, Vector2i(0, 1))

func create_radar_lines():
	var radar_width: float = $Player/HUD/RadarPanel/WorldPanel.size.x
	var radar_height: float = $Player/HUD/RadarPanel/WorldPanel.size.y

	for x in range(0, int(radar_width), 35):
		var vertical_line := Line2D.new()
		vertical_line.points = [Vector2(x, 0), Vector2(x, radar_height)]
		vertical_line.default_color = Color("515151")
		vertical_line.z_index = -1
		vertical_line.width = 4
		vertical_line.position += Vector2(2, 0)
		$Player/HUD/RadarPanel/WorldPanel.add_child(vertical_line)

	for y in range(0, int(radar_height), 35):
		var horizontal_line := Line2D.new()
		horizontal_line.points = [Vector2(0, y), Vector2(radar_width, y)]
		horizontal_line.default_color = Color("515151")
		horizontal_line.z_index = -1
		horizontal_line.width = 4
		horizontal_line.position += Vector2(0, 5)
		$Player/HUD/RadarPanel/WorldPanel.add_child(horizontal_line)

func create_radar_enemies_lines():
	var radar_width: float = $Player/HUD/RadarPanelEnemies/RadarPanel.size.x
	var radar_height: float = $Player/HUD/RadarPanelEnemies/RadarPanel.size.y
	
	for x in range(0, int(radar_width), 40):
		var vertical_line := Line2D.new()
		vertical_line.points = [Vector2(x, 0), Vector2(x, radar_height)]
		vertical_line.default_color = Color("515151")
		vertical_line.z_index = -1
		vertical_line.width = 4
		vertical_line.position += Vector2(2, 0)
		$Player/HUD/RadarPanelEnemies/RadarPanel.add_child(vertical_line)
	
	for y in range(0, int(radar_height), 40):
		var horizontal_line := Line2D.new()
		horizontal_line.points = [Vector2(0, y), Vector2(radar_width, y)]
		horizontal_line.default_color = Color("515151")
		horizontal_line.z_index = -1
		horizontal_line.width = 4
		horizontal_line.position += Vector2(0, 5)
		$Player/HUD/RadarPanelEnemies/RadarPanel.add_child(horizontal_line)

func _on_spawn_enemies_timeout() -> void:
	print("[world.gd] Enemy Spawned")
	var EnemyScene = preload("res://scenes/misc/enemy.tscn")
	var enemy = EnemyScene.instantiate()
	enemy.set_meta("Enemy", "Enemy")
	enemy.add_to_group("Enemy")
	enemy.position = Vector2($Player.position.x + randi_range(-240, 240), $Player.position.y + randi_range(-240, 240))
	var scale_factor = randf_range(0.8, 1.2)
	enemy.scale = Vector2(scale_factor, scale_factor)
	add_child(enemy)

func update_radar_tool():
	var radar_width : float = $Player/HUD/RadarPanel/WorldPanel.size.x - $Player/HUD/RadarPanel/WorldPanel/PatinhoEstaAqui.size.x
	var radar_height : float = $Player/HUD/RadarPanel/WorldPanel.size.y - $Player/HUD/RadarPanel/WorldPanel/PatinhoEstaAqui.size.y
	
	var player_world_pos : Vector2 = $Player.position / 16
	
	var radar_pos_x = clamp(player_world_pos.x / world_width * radar_width, 0, radar_width)
	var radar_pos_y = clamp(player_world_pos.y / world_height * radar_height, 0, radar_height)
	$Player/HUD/RadarPanel/WorldPanel/PatinhoEstaAqui.position = Vector2(radar_pos_x, radar_pos_y)

func _on_update_enemy_radar_timer_timeout() -> void:
	update_enemies_radar_tool()

func update_enemies_radar_tool():
	var radar_panel = $Player/HUD/RadarPanelEnemies/RadarPanel
	var radar_size = radar_panel.size - Vector2(14, 14)
	var max_distance := 360.0  # match the spawn range
	var player_pos = $Player.position
	
	# Clear only previous radar dots, leave static UI intact
	for child in radar_panel.get_children():
		if child.has_meta("is_enemy_dot"):
			child.queue_free()
	
	# Load enemy radar dot texture
	var enemy_dot_texture = preload("res://assets/textures/equipment/others/enemy_dot.png")
	
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		var rel_pos = enemy.position - player_pos
		
		# Normalize relative position to [-1, 1]
		var norm_x = rel_pos.x / max_distance
		var norm_y = rel_pos.y / max_distance
		
		# Skip if outside [-1, 1] range (i.e. beyond max_distance in either axis)
		if abs(norm_x) > 1.0 or abs(norm_y) > 1.0:
			continue
		
		# Convert to radar coordinates
		var radar_x = radar_size.x / 2 + norm_x * (radar_size.x / 2)
		var radar_y = radar_size.y / 2 + norm_y * (radar_size.y / 2)
		
		# Additional optional safety check: skip if outside panel bounds
		if radar_x < 0 or radar_x > radar_size.x or radar_y < 0 or radar_y > radar_size.y:
			continue
		
		# Create and place enemy dot
		var dot = TextureRect.new()
		dot.texture = enemy_dot_texture
		dot.z_index = 1
		dot.size = Vector2(8, 8)
		dot.position = Vector2(radar_x, radar_y)
		dot.pivot_offset = dot.size / 2
		dot.set_meta("is_enemy_dot", true)  # tag so we only remove these later
		
		radar_panel.add_child(dot)

func _on_more_working_time_timeout() -> void:
	statistics_config.load(statistics_path)
	statistics_config.set_value("statistics", "time_working", \
	statistics_config.get_value("statistics", "time_working") + 1)
	statistics_config.save(statistics_path)
