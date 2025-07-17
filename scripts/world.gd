extends Node2D

@onready var CaveSystem = $WorldTileMap/CaveSystem

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

var biome_id = 0

var time_remaining_Title_Timer
var time_remaining_HUD_Fade_In

var fade_in : float = 0.0
var fade_out : float = 0.0

var config_path : String = "user://game_settings.cfg"
var config_file : ConfigFile = ConfigFile.new()

var difficulty_path : String = str("user://save/", GetSaveFile.save_being_used, "/difficulty.cfg")
var difficulty_file : ConfigFile = ConfigFile.new()
var difficulty : String = ""

var statistics_path : String = str("user://save/", GetSaveFile.save_being_used, "/statistics.cfg")
var statistics_config : ConfigFile = ConfigFile.new()

var primary_objective : String = ""
var secundary_objective : String = ""

var current_goods_amount : int = 0
var max_goods_amount : int = 1
var current_kill_enemies_amount : int = 0
var max_kill_enemies_amount : int = 1
var current_fine_jewelry : int = 0
var max_fine_jewelry : int = 1

var current_more_infrastructure : int = 0
var max_more_infrastructure : int = 1
var current_power_future : int = 0
var max_power_future : int = 1
var current_heat_extraction : int = 0
var max_heat_extraction : int = 1
var current_cold_extraction : int = 0
var max_cold_extraction : int = 1
var current_fuel_company : int = 0
var max_fuel_company : int = 1
var current_build_future : int = 0
var max_build_future : int = 1

var primary_mission_completed : bool = false
var secondary_mission_completed : bool = false

# Função que dependendo da dificuldade, cria o mundo com as missões e objetivos e atualiza o DISCORD RPC
func _ready():
	difficulty_file.load(difficulty_path)
	difficulty = difficulty_file.get_value("difficulty", "current")
	
	match asteroid_biome:
		"Stony": biome_id = 0
		"Vulcanic": biome_id = 1
		"Frozen": biome_id = 2
		"Swamp": biome_id = 3
		"Desert": biome_id = 4
		"Radioactive": biome_id = 5
	
	match primary_objective:
		"Get Goods":
			match difficulty:
				"easy": max_goods_amount = randi_range(500, 800)
				"normal": max_goods_amount = randi_range(900, 1350)
				"hard": max_goods_amount = randi_range(1500, 2000)
		"Kill Enemies":
			match difficulty:
				"easy": max_kill_enemies_amount = randi_range(5, 12)
				"normal": max_kill_enemies_amount = randi_range(12, 18)
				"hard": max_kill_enemies_amount = randi_range(18, 22)
		"Fine Jewelry":
			match difficulty:
				"easy": max_fine_jewelry = randi_range(4, 8)
				"normal": max_fine_jewelry = randi_range(9, 12)
				"hard": max_fine_jewelry = randi_range(13, 18)
	
	match secundary_objective:
		"More Infrastructure":
			match difficulty:
				"easy": max_more_infrastructure = randi_range(35, 60)
				"normal": max_more_infrastructure = randi_range(60, 85)
				"hard": max_more_infrastructure = randi_range(85, 110)
		"Power the Future":
			match difficulty:
				"easy": max_power_future = randi_range(25, 50)
				"normal": max_power_future = randi_range(50, 75)
				"hard": max_power_future = randi_range(75, 100)
		"Heat Extraction":
			match difficulty:
				"easy": max_heat_extraction = randi_range(15, 25)
				"normal": max_heat_extraction = randi_range(25, 45)
				"hard": max_heat_extraction = randi_range(45, 60)
		"Cold Extraction":
			match difficulty:
				"easy": max_cold_extraction = randi_range(15, 25)
				"normal": max_cold_extraction = randi_range(25, 45)
				"hard": max_cold_extraction = randi_range(45, 60)
		"Fuel the Company":
			match difficulty:
				"easy": max_fuel_company = randi_range(25, 50)
				"normal": max_fuel_company = randi_range(50, 75)
				"hard": max_fuel_company = randi_range(75, 100)
		"Build the Future":
			match difficulty:
				"easy": max_build_future = randi_range(150, 250)
				"normal": max_build_future = randi_range(250, 400)
				"hard": max_build_future = randi_range(400, 600)
	
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
			CaveSystem.set_cell(Vector2i(x, y), biome_id, Vector2i(0, 0))
			var noise = floor(fnl.get_noise_2d(x, y) * 5)
			if noise == 0:
				CaveSystem.set_cell(Vector2i(x, y), biome_id, Vector2i(0, 1))
	
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
			put_copper()
			put_iron()
			put_ice()
			put_pitchblende()
			put_phosphorite()
			put_hematite()
			put_jeremejevite()
			put_gems()
			
	# Procedural code from: https://www.youtube.com/watch?v=MU3u00f3GqQ | SupercraftD | 04/10/2024

# Atualiza o HUD e as missões, verifica se as missões primárias e secundárias foram concluídas, 
# atualiza o tempo restante dos temporizadores para ajustar a opacidade dos elementos do HUD.
func _process(_delta: float) -> void:
	match primary_objective:
		"Get Goods":
			if current_goods_amount >= max_goods_amount: primary_mission_completed = true
			$Player/HUD/MissionList.set_item_text(0, str(primary_objective, ": ", current_goods_amount, "/", max_goods_amount))
		"Kill Enemies":
			if current_kill_enemies_amount >= max_kill_enemies_amount: primary_mission_completed = true
			$Player/HUD/MissionList.set_item_text(0, str(primary_objective, ": ", current_kill_enemies_amount, "/", max_kill_enemies_amount))
		"Fine Jewelry":
			if current_fine_jewelry >= max_fine_jewelry: primary_mission_completed = true
			$Player/HUD/MissionList.set_item_text(0, str(primary_objective, ": ", current_fine_jewelry, "/", max_fine_jewelry))
	
	match secundary_objective:
		"More Infrastructure":
			if current_more_infrastructure >= max_more_infrastructure: secondary_mission_completed = true
			$Player/HUD/MissionList.set_item_text(1, str(secundary_objective, ": ", current_more_infrastructure, "/", max_more_infrastructure))
		"Power the Future":
			if current_power_future >= max_power_future: secondary_mission_completed = true
			$Player/HUD/MissionList.set_item_text(1, str(secundary_objective, ": ", current_power_future, "/", max_power_future))
		"Heat Extraction":
			if current_heat_extraction >= max_heat_extraction: secondary_mission_completed = true
			$Player/HUD/MissionList.set_item_text(1, str(secundary_objective, ": ", current_heat_extraction, "/", max_heat_extraction))
		"Cold Extraction":
			if current_cold_extraction >= max_cold_extraction: secondary_mission_completed = true
			$Player/HUD/MissionList.set_item_text(1, str(secundary_objective, ": ", current_cold_extraction, "/", max_cold_extraction))
		"Fuel the Company":
			if current_fuel_company >= max_fuel_company: secondary_mission_completed = true
			$Player/HUD/MissionList.set_item_text(1, str(secundary_objective, ": ", current_fuel_company, "/", max_fuel_company))
		"Build the Future":
			if current_build_future >= max_build_future: secondary_mission_completed = true
			$Player/HUD/MissionList.set_item_text(1, str(secundary_objective, ": ", current_build_future, "/", max_build_future))
	
	if primary_mission_completed == true:
		$Player/HUD/MissionList.set_item_custom_fg_color(0, Color("00b54c"))
		$Player/Camera2D/HUD/Hotbar/TabBar/EndMissionLabel.visible = true
	if secondary_mission_completed == true:
		$Player/HUD/MissionList.set_item_custom_fg_color(1, Color("00b54c"))
	
	if Input.is_action_pressed("End_Mission") and primary_mission_completed == true:
		$PauseMenu._on_abort_mission_button_pressed()
	
	if $".".has_node("WorldMusic"):
		$WorldMusic.position = $Player.position
	update_radar_tool()
	
	time_remaining_Title_Timer = $TitleTimer.time_left
	time_remaining_HUD_Fade_In = $HUDFadeIn.time_left
	
	fade_out = time_remaining_Title_Timer / 10
	
	if $HUDFadeIn.time_left <= 5:
		fade_in += time_remaining_HUD_Fade_In
	
	$Player/HUD/AsteroidTitle.add_theme_color_override("default_color", Color(1, 1, 1, fade_out))
	$Player/HUD/FieldTitle.add_theme_color_override("default_color", Color(0.509, 0.509, 0.509, fade_out))
	
	$Player/Camera2D/HUD/FreezingOverlay.modulate.a8 = fade_in
	$Player/Camera2D/HUD/Hotbar/TabBar.modulate.a8 = fade_in
	
	$Player/HUD/RadarPanel.modulate.a8 = fade_in
	$Player/HUD/RadarPanelEnemies.modulate.a8 = fade_in
	
	$Player/HUD/MissionList.modulate.a8 = fade_in
	$Player/HUD/ItemList.modulate.a8 = fade_in
	
	$Player/Camera2D/HUD/Stats/UI/HealthPanel.modulate.a8 = fade_in
	$Player/Camera2D/HUD/Stats/UI/OxygenPanel.modulate.a8 = fade_in
	$Player/Camera2D/HUD/Stats/UI/BatteryPanel.modulate.a8 = fade_in
	
	$Player/Camera2D/HUD/ShowControls.modulate.a8 = fade_in

# Criar as bordas do mundo, que são as paredes que delimitam o espaço jogável.
func create_world_borders():
	# Above Map Border
	for y in range(world_border_up_and_down):
		y = -abs(y)
		for x in range(world_width):
			 
			CaveSystem.set_cell(Vector2i(x, y), biome_id, Vector2i(2, 2))
	
	# Below Map Border
	for y in range(world_border_up_and_down):
		y += world_height
		for x in range(world_width):
			CaveSystem.set_cell(Vector2i(x, y), biome_id, Vector2i(2, 2))
	
	# Left Map Border
	for x in range(world_border_sides):
		x += world_width
		for y in range(world_height_border):
			y -= 9
			CaveSystem.set_cell(Vector2i(x, y), biome_id, Vector2i(2, 2))
	
	# Right Map Border
	for x in range(world_border_sides):
		x = -abs(x)
		for y in range(world_height_border):
			y -= 9
			CaveSystem.set_cell(Vector2i(x, y), biome_id, Vector2i(2, 2))

# Meter os minerios do mundo usando os varios paramentros.
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

# Colocar os minerios de acordo com o bioma do asteroide.
func put_coal():
	if asteroid_biome == "Stony":
		put_ore(0, 200, 150, 0, Vector2i(1, 0), 20)
	elif asteroid_biome == "Vulcanic":
		put_ore(0, 200, 150, 1, Vector2i(1, 0), 20)

func put_copper():
	if asteroid_biome == "Stony":
		put_ore(0, 500, 175, 0, Vector2i(1, 2), 20)
	elif asteroid_biome == "Radioactive":
		put_ore(0, 375, 200, 5, Vector2i(1, 0), 20)

func put_magnetite():
	if asteroid_biome == "Vulcanic":
		put_ore(0, 500, 200, 1, Vector2i(1, 2), 20)

func put_iron():
	if asteroid_biome == "Stony":
		put_ore(200, 600, 200, 0, Vector2i(2, 0), 20)
	elif asteroid_biome == "Vulcanic":
		put_ore(200, 600, 200, 1, Vector2i(2, 0), 20)
	elif asteroid_biome == "Radioactive":
		put_ore(0, 750, 190, 5, Vector2i(2, 0), 20)

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

func put_ice():
	put_ore(0, 1600, 500, 5, Vector2i(3, 2), 20)

func put_pitchblende():
	put_ore(450, 1600, 375, 5, Vector2i(1, 2), 20)

func put_phosphorite():
	put_ore(525, 1600, 400, 5, Vector2i(0, 2), 20)

func put_hematite():
	put_ore(325, 750, 325, 5, Vector2i(0, 3), 20)

func put_jeremejevite():
	put_ore(850, 1600, 500, 5, Vector2i(3, 0), 20)

# Colocar gemas no mundo.
func put_gems():
	for x in range(world_width):
		for y in range(0, 1600):
			if randi_range(0, 625) == 1:
				var tile_pos = Vector2i(x, y)
				if CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 0):
					match randi_range(1, 3):
						1: CaveSystem.set_cell(tile_pos, biome_id, Vector2i(1, 1))
						2: CaveSystem.set_cell(tile_pos, biome_id, Vector2i(2, 1))
						3: CaveSystem.set_cell(tile_pos, biome_id, Vector2i(3, 1))

# Função para definir a posição inicial do jogador.
func start_position():
	var spawn_cube_size = 3
	
	var player_position = Vector2((world_width * 16) / 2, randi_range(10 * 16, 100 * 16))
	
	$Player.position = player_position
	
	var player_at_tilemap_position = $WorldTileMap.local_to_map(player_position)
	
	for x in range(spawn_cube_size):
		x += player_at_tilemap_position.x -1
		for y in range(spawn_cube_size):
			y += player_at_tilemap_position.y -2
			CaveSystem.set_cell(Vector2i(x, y), biome_id, Vector2i(0, 1))

# Criar as linhas do radar, que são as linhas que ajudam a visualizar o mapa no HUD.
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

# Criar as linhas do radar de inimigos, que são as linhas que ajudam a visualizar o mapa de inimigos no HUD.
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

# Função que é chamada quando o temporizador de spawn de inimigos atinge o tempo limite.
func _on_spawn_enemies_timeout() -> void:
	if $PauseMenu/GUI_Pause.visible == false:
		print("[world.gd] Enemy Spawned")
		match difficulty:
			"easy": $SpawnEnemies.wait_time = randi_range(30, 40)
			"normal": $SpawnEnemies.wait_time = randi_range(20, 30)
			"hard": $SpawnEnemies.wait_time = randi_range(15, 25)
		var EnemyScene = preload("res://scenes/misc/enemy.tscn")
		var enemy = EnemyScene.instantiate()
		enemy.set_meta("Enemy", "Enemy")
		enemy.add_to_group("Enemy")
		enemy.position = Vector2($Player.position.x + randi_range(-240, 240), $Player.position.y + randi_range(-240, 240))
		add_child(enemy)

# Atualiza a posição do radar do jogador, que é a posição do jogador no mundo, mas em um tamanho reduzido.
func update_radar_tool():
	var radar_width : float = $Player/HUD/RadarPanel/WorldPanel.size.x - $Player/HUD/RadarPanel/WorldPanel/PatinhoEstaAqui.size.x
	var radar_height : float = $Player/HUD/RadarPanel/WorldPanel.size.y - $Player/HUD/RadarPanel/WorldPanel/PatinhoEstaAqui.size.y
	
	var player_world_pos : Vector2 = $Player.position / 16
	
	var radar_pos_x = clamp(player_world_pos.x / world_width * radar_width, 0, radar_width)
	var radar_pos_y = clamp(player_world_pos.y / world_height * radar_height, 0, radar_height)
	$Player/HUD/RadarPanel/WorldPanel/PatinhoEstaAqui.position = Vector2(radar_pos_x, radar_pos_y)

# Atualiza o radar de inimigos, que é a posição dos inimigos no mundo, mas em um tamanho reduzido.
func _on_update_enemy_radar_timer_timeout() -> void:
	update_enemies_radar_tool()

func update_enemies_radar_tool():
	var radar_panel = $Player/HUD/RadarPanelEnemies/RadarPanel
	var radar_size = radar_panel.size - Vector2(14, 14)
	var max_distance := 360.0  # corresponde ao alcance de spawn
	var player_pos = $Player.position
	
	# Limpa apenas os pontos anteriores do radar, mantendo a UI estática intacta
	for child in radar_panel.get_children():
		if child.has_meta("is_enemy_dot"):
			child.queue_free()
	
	# Carrega a textura do ponto de radar do inimigo
	var enemy_dot_texture = preload("res://assets/textures/items/equipment/others/enemy_dot.png")
	
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		var rel_pos = enemy.position - player_pos
		
		# Normaliza a posição relativa para [-1, 1]
		var norm_x = rel_pos.x / max_distance
		var norm_y = rel_pos.y / max_distance
		
		# Ignora se estiver fora do intervalo [-1, 1] (ou seja, além do max_distance em qualquer eixo)
		if abs(norm_x) > 1.0 or abs(norm_y) > 1.0:
			continue
		
		# Converte para coordenadas do radar
		var radar_x = radar_size.x / 2 + norm_x * (radar_size.x / 2)
		var radar_y = radar_size.y / 2 + norm_y * (radar_size.y / 2)
		
		# Checagem adicional opcional: ignora se estiver fora dos limites do painel
		if radar_x < 0 or radar_x > radar_size.x or radar_y < 0 or radar_y > radar_size.y:
			continue
		
		# Cria e posiciona o ponto do inimigo
		var dot = TextureRect.new()
		dot.texture = enemy_dot_texture
		dot.z_index = 1
		dot.size = Vector2(8, 8)
		dot.position = Vector2(radar_x, radar_y)
		dot.pivot_offset = dot.size / 2
		dot.set_meta("is_enemy_dot", true)  # marca para que só esses sejam removidos depois
		
		radar_panel.add_child(dot)

# Atualiza o tempo de trabalho nas estatísticas
func _on_more_working_time_timeout() -> void:
	statistics_config.load(statistics_path)
	statistics_config.set_value("statistics", "time_working", \
	statistics_config.get_value("statistics", "time_working") + 1)
	statistics_config.save(statistics_path)

# Função que é chamada quando a música do mundo termina, reinicia o cooldown da música.
func _on_world_music_finished() -> void:
	$WorldMusic/MusicCooldown.wait_time = 20
	$WorldMusic/MusicCooldown.start()

# Função que é chamada quando o temporizador de música atinge o tempo limite,
# que escolhe uma música aleatória do mundo e a toca.
func _on_music_timer_timeout() -> void:
	match randi_range(1, 14):
		1: $WorldMusic.stream = load("res://sounds/musics/aside.ogg"); $WorldMusic.play()
		2: $WorldMusic.stream = load("res://sounds/musics/enter.ogg"); $WorldMusic.play()
		4: $WorldMusic.stream = load("res://sounds/musics/play.ogg"); $WorldMusic.play()
		5: $WorldMusic.stream = load("res://sounds/musics/portal.ogg"); $WorldMusic.play()
		6: $WorldMusic.stream = load("res://sounds/musics/puzzle.ogg"); $WorldMusic.play()
		7: $WorldMusic.stream = load("res://sounds/musics/rift.ogg"); $WorldMusic.play()
		8: $WorldMusic.stream = load("res://sounds/musics/trace.ogg"); $WorldMusic.play()
		9: $WorldMusic.stream = load("res://sounds/musics/void.ogg"); $WorldMusic.play()
		10: $WorldMusic.stream = load("res://sounds/musics/wave.ogg"); $WorldMusic.play()
		11: $WorldMusic.stream = load("res://sounds/musics/few_jumps_away.ogg"); $WorldMusic.play()
		12: $WorldMusic.stream = load("res://sounds/musics/adrift.ogg"); $WorldMusic.play()
		13: $WorldMusic.stream = load("res://sounds/musics/space_mystery.ogg"); $WorldMusic.play()
		14: $WorldMusic.stream = load("res://sounds/musics/under_the_stars.ogg"); $WorldMusic.play()
