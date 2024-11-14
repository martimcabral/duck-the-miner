extends Node2D

var register_logs = true

const world_width = 300
const world_height = 1000
const world_height_border = 1020 # Always +20

const world_border_up_and_down = 10
const world_border_sides = 12

var consoantes = ['b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z']
var vogais = ['a', 'e', 'i', 'o', 'u']
var AsteroidField = ["Delta", "Gamma", "Omega", "Lambda", "Sigma", "Yotta"]

@onready var CaveSystem = $WorldTileMap/CaveSystem

func _process(_delta: float) -> void:
	$WorldMusic.position = $Player.position

func start_music():
	var random_music = randi_range(1, 3)
	match random_music:
		1:
			$WorldMusic/Enter.play()
		2:
			$WorldMusic/Wave.play()
		3:
			$WorldMusic/Void.play()

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

func _ready():
	start_music()
	create_world_borders()
	
	var asteroid_name = create_asteroid()
	var asteroid_field = AsteroidField[randi() % AsteroidField.size()]
	
	var fnl = FastNoiseLite.new()
	
	var asteroid_type = "Unknown"
	var asteroid_biome = "Unknown"
	
	fnl.seed = randi_range(0, 2147483646)
	fnl.noise_type = FastNoiseLite.TYPE_SIMPLEX   
	fnl.fractal_octaves = 4 #4
	fnl.fractal_lacunarity = 2.25 #2.5
	fnl.fractal_gain = 0.5 #0.4
	
	if (register_logs == true):
		print("World Procedural Generation Logs: ")
		print("Asteroid Type: ", asteroid_type)
		print("Asteroid Biome: ", asteroid_biome)
		print("Asteroid Name: ", asteroid_name)
		print("Asteroid Field: ", asteroid_field, "\n")
		print("Seed: ", fnl.seed)
		print("Noise Type: ", fnl.noise_type)
		print("Octaves: ", fnl.fractal_octaves)
		print("Lacunarity: ", fnl.fractal_lacunarity)
		print("Gain: ", fnl.fractal_gain)
	
	DiscordRPC.details = "☄️: " + asteroid_name + " at " + asteroid_field + " Field"
	DiscordRPC.refresh()
	
	# Make Caverns
	for x in range(world_width):
		for y in range(world_height):
			CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
			var noise = floor(fnl.get_noise_2d(x, y) * 5)
			if noise == 0:
				CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(0, 1))
	
	#Create safe Cube	
	start_position()
	
	# Put Ores:
	put_ice()
	put_coal()
	put_copper()
	put_iron()
	put_gold()
	put_diamond()
	put_gems()
	
	# Procedural code from: https://www.youtube.com/watch?v=MU3u00f3GqQ | SupercraftD | 04/10/2024
	
func set_colorblindness_value(colorblindness_value): # Pega-se na Variável e faz-se shenanigans
	match colorblindness_value:
		0:
			$Player/HUD/ColorblindnessColorRect.material.set_shader_parameter("mode", 0)
		1:
			$Player/HUD/ColorblindnessColorRect.material.set_shader_parameter("mode", 1)
		2:
			$Player/HUD/ColorblindnessColorRect.material.set_shader_parameter("mode", 2)
		3:
			$Player/HUD/ColorblindnessColorRect.material.set_shader_parameter("mode", 3)
		4:
			$Player/HUD/ColorblindnessColorRect.material.set_shader_parameter("mode", 4)
	

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
			CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(0, 1))
			

func put_ore(ore_height_min, ore_height_max, spawn_chance, atlas_coords):
	for x in range(world_width):
		for y in range(ore_height_min, ore_height_max):
			if randi_range(0, spawn_chance) == 1:
				var tile_pos = Vector2i(x, y)
				if CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 0):
					CaveSystem.set_cell(tile_pos, 0, atlas_coords)

func put_coal():
	put_ore(0, 200, 35, Vector2i(1, 0))
func put_copper():
	put_ore(0, 500, 35, Vector2i(1, 2))
func put_iron():
	put_ore(200, 600, 60, Vector2i(2, 0))
func put_gold():
	put_ore(500, 800, 200, Vector2i(0, 2))
func put_diamond():
	put_ore(900, 1000, 425, Vector2i(3, 0))
func put_ice():
	put_ore(0, 1000, 300, Vector2i(3, 2))

func put_gems():
	for x in range(world_width):
		for y in range(500, 1000):
			if randi_range(0, 750) == 1:
				var tile_pos = Vector2i(x, y)
				if CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 0):
					var random_gem = randi_range(1, 3)
					match random_gem:
						1: CaveSystem.set_cell(tile_pos, 0, Vector2i(1, 1))
						2: CaveSystem.set_cell(tile_pos, 0, Vector2i(2, 1))
						3: CaveSystem.set_cell(tile_pos, 0, Vector2i(3, 1))

func create_asteroid():
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
