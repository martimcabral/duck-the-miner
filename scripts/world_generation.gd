extends Node2D

var register_logs = true

var world_width # Default: 300
var world_height # Default:  1000
var world_height_border # Always: world_height + 20

const world_border_up_and_down = 10
const world_border_sides = 12

var consoantes = ['b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z']
var vogais = ['a', 'e', 'i', 'o', 'u']

var asteroid_name
var asteroid_field
var asteroid_biome

var time_remaining_Title_Timer
var time_remaining_HUD_Fade_In

var fade_in : float = 0.0
var fade_out : float = 0.0

@onready var CaveSystem = $WorldTileMap/CaveSystem

func _process(_delta: float) -> void:
	$WorldMusic.position = $Player.position
	
	time_remaining_Title_Timer = $TitleTimer.time_left
	time_remaining_HUD_Fade_In = $HUDFadeIn.time_left
	
	fade_out = time_remaining_Title_Timer / 10
	
	if $HUDFadeIn.time_left <= 5:
		fade_in += time_remaining_HUD_Fade_In / 5
	
	$Player/HUD/AsteroidTitle.add_theme_color_override("default_color", Color(1, 1, 1, fade_out))
	$Player/HUD/FieldTitle.add_theme_color_override("default_color", Color(0.509, 0.509, 0.509, fade_out))
	$Player/HUD/WorldMissionInventory.modulate.a8 = fade_in
	$Player/Camera2D/HUD/VersionDisplay.modulate.a8 = fade_in
	$Player/Camera2D/HUD/PlayerPosition.modulate.a8 = fade_in
	$Player/Camera2D/HUD/Stats/HealthStat.modulate.a8 = fade_in
	$Player/Camera2D/HUD/Stats/TemperatureStat.modulate.a8 = fade_in
	$Player/Camera2D/HUD/Stats/OxygenStat.modulate.a8 = fade_in
	$Player/Camera2D/HUD/Stats/uvStat.modulate.a8 = fade_in
	$Player/Camera2D/HUD/Stats/HungerStat.modulate.a8 = fade_in
	$Player/Camera2D/HUD/Stats/ThirstStat.modulate.a8 = fade_in
	
func start_music():
	var random_music = randi_range(1, 3)
	match random_music:
		1:
			$WorldMusic/Enter.play()
		2:
			$WorldMusic/Wave.play()
		3:
			$WorldMusic/Void.play()

func _ready():
	asteroid_biome = randi_range(1, 2)
	match asteroid_biome:
		1:
			asteroid_biome = "Stony"
		2:
			asteroid_biome = "Vulcanic"
		3:
			asteroid_biome = "Frozen"
	
	$Player/HUD/AsteroidTitle.visible = true
	$Player/HUD/FieldTitle.visible = true
	
	asteroid_name = create_asteroid_name()
	
	$Player/HUD/AsteroidTitle.text = "[center]%s[/center]" % asteroid_name
	$Player/HUD/FieldTitle.text = "[center]%s[/center]" % asteroid_field + " Field | " + asteroid_biome
	
	if DiscordRPC.get_is_discord_working():
		DiscordRPC.small_image = "diamond-512"
		DiscordRPC.small_image_text = "Debt: 4 528 913 301 674$"
		if asteroid_field == null:
			DiscordRPC.details = "🌑: " + asteroid_name + " at Unknown Field"
		else:
			DiscordRPC.details = "🌑: " + asteroid_name + " at " + asteroid_field + " Field"
		DiscordRPC.refresh()
	else:
		print("[world_generation.gd] Discord isn't running or wasn't detected properly, skipping rich presence.")
	
	start_music()
	
	var fnl = FastNoiseLite.new()
	
	match asteroid_field:
		"Delta":
			world_width = randi_range(200, 300)
			world_height = randi_range(300, 600)
		"Gamma":
			world_width = randi_range(250, 400)
			world_height = randi_range(500, 900)
		"Omega":
			world_width = randi_range(250, 400)
			world_height = randi_range(750, 1000)
		"Lambda":
			world_width = randi_range(250, 400)
			world_height = randi_range(850, 1100)
		"Sigma":
			world_width = randi_range(300, 400)
			world_height = randi_range(1000, 1200)
		"Yotta":
			world_width = randi_range(150, 250)
			world_height = randi_range(1250, 1500)
		_:
			world_width = 300
			world_height = 300
	
	world_height_border = world_height + 20
	create_world_borders()
	
	var asteroid_size = Vector2i(world_width, world_height)
	
	fnl.seed = randi_range(0, 2147483646)
	fnl.noise_type = FastNoiseLite.TYPE_SIMPLEX
	fnl.fractal_octaves = 4 #4
	fnl.fractal_lacunarity = 2.25 #2.5
	fnl.fractal_gain = 0.5 #0.4
	
	if (register_logs == true):
		print("\nWorld Procedural Generation Logs:")
		print("Asteroid Name: ", asteroid_name)
		print("Asteroid Size: ", asteroid_size)
		print("Asteroid Biome: ", asteroid_biome)
		print("Asteroid Field: ", asteroid_field, "\n")
		print("Seed: ", fnl.seed)
		print("Noise Type: ", fnl.noise_type)
		print("Octaves: ", fnl.fractal_octaves)
		print("Lacunarity: ", fnl.fractal_lacunarity)
		print("Gain: ", fnl.fractal_gain)
	
	# Make Caverns
	for x in range(world_width):
		for y in range(world_height):
			if asteroid_biome == "Stony":
				CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
			elif asteroid_biome == "Vulcanic":
				CaveSystem.set_cell(Vector2i(x, y), 1, Vector2i(0, 0))
			var noise = floor(fnl.get_noise_2d(x, y) * 5)
			if noise == 0 and asteroid_biome == "Stony":
				CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(0, 1))
			elif noise == 0 and asteroid_biome == "Vulcanic":
				CaveSystem.set_cell(Vector2i(x, y), 1, Vector2i(0, 1))
	
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
			put_ice()

		"Vulcanic":
			put_coal()
			put_magnetite()
			put_iron()
			put_bauxite()
			put_gold()
			put_diamond()
			put_gems()
			put_lava_sockets()
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

func _on_music_timer_timeout() -> void:
	start_music()

func start_position():
	var spawn_cube_size = 3
	
	# Random Position to the player Spawn
	var player_position = Vector2(randi_range(2250,2750), 1500)
	
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
			

func put_ore(ore_height_min, ore_height_max, spawn_chance, biome, atlas_coords):
	for x in range(world_width):
		for y in range(ore_height_min, ore_height_max):
			if randi_range(0, spawn_chance) == 1:
				var tile_pos = Vector2i(x, y)
				if CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 0):
					CaveSystem.set_cell(tile_pos, biome, atlas_coords)

func put_coal():
	if asteroid_biome == "Stony":
		put_ore(0, 200, 35, 0, Vector2i(1, 0))
	elif asteroid_biome == "Vulcanic":
		put_ore(0, 200, 35, 1, Vector2i(1, 0))

func put_copper():
	if asteroid_biome == "Stony":
		put_ore(0, 500, 35, 0, Vector2i(1, 2))

func put_magnetite():
	if asteroid_biome == "Vulcanic":
		put_ore(0, 500, 35, 1, Vector2i(1, 2))

func put_iron():
	if asteroid_biome == "Stony":
		put_ore(200, 600, 60, 0, Vector2i(2, 0))
	elif asteroid_biome == "Vulcanic":
		put_ore(200, 600, 60, 1, Vector2i(2, 0))

func put_bauxite():
	if asteroid_biome == "Vulcanic":
		put_ore(200, 600, 60, 1, Vector2i(0, 3))

func put_gold():
	if asteroid_biome == "Stony":
		put_ore(500, 800, 200, 0, Vector2i(0, 2))
	elif asteroid_biome == "Vulcanic":
		put_ore(500, 800, 200, 1, Vector2i(0, 2))

func put_diamond():
	if asteroid_biome == "Stony":
		put_ore(900, 1000, 425, 0, Vector2i(3, 0))
	elif asteroid_biome == "Vulcanic":
		put_ore(900, 1000, 425, 1, Vector2i(3, 0))

func put_ice():
	put_ore(0, 1000, 300, 0, Vector2i(3, 2))

func put_lava_sockets():
	put_ore(0, 1000, 300, 1, Vector2i(3, 2))

func put_gems():
	for x in range(world_width):
		for y in range(500, 1000):
			if randi_range(0, 750) == 1:
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

	match variante: # 398,779,605
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
