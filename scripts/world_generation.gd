extends Node2D

var register_logs = true

const world_width = 300
const world_height = 1000
const world_height_border = 1020 # Always +20

const world_border_up_and_down = 10
const world_border_sides = 12

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
			%CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(2, 2))
	
	# Below Map Border
	for y in range(world_border_up_and_down):
		y += world_height
		for x in range(world_width):
			%CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(2, 2))
	
	# Left Map Border
	for x in range(world_border_sides):
		x += world_width
		for y in range(world_height_border):
			y -= 9
			%CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(2, 2))
	
	# Right Map Border
	for x in range(world_border_sides):
		x = -abs(x)
		for y in range(world_height_border):
			y -= 9
			%CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(2, 2))

func _ready():
	start_music()
	create_world_borders()
	
	var fnl = FastNoiseLite.new()
	
	var asteroid_type = "Unknown"
	var asteroid_biome = "Unknown"
	
	fnl.noise_type = FastNoiseLite.TYPE_SIMPLEX   
	fnl.fractal_octaves = 4 #4
	fnl.fractal_lacunarity = 2.25 #2.5
	fnl.fractal_gain = 0.5 #0.4
	
	if (register_logs == true):
		print("World Procedural Generation Logs: ")
		print("Asteroid Type: ", asteroid_type)
		print("Asteroid Biome: ", asteroid_biome)
		print("Noise Type: ", fnl.noise_type)
		print("Octaves: ", fnl.fractal_octaves)
		print("Lacunarity: ", fnl.fractal_lacunarity)
		print("Gain: ", fnl.fractal_gain)
	
	# Make Caverns

	for x in range(world_width):
		for y in range(world_height):
			%CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
			var noise = floor(fnl.get_noise_2d(x, y) * 5)
			if noise == 0:
				%CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(0, 1))
	
	# Put "Normal Asteroid Type" Ores
	#_on_time_to_put_ores_timeout()
	#Create safe Cube
	start_position()

# Procedural code from: https://www.youtube.com/watch?v=MU3u00f3GqQ | SupercraftD | 04/10/2024

func _on_music_timer_timeout() -> void:
	start_music()

func start_position():
	var spawn_cube_size = 3
	
	# Random Position to the player Spawn
	var player_position = Vector2(randi_range(2250,2750), 1500)
	
	$Player.position = player_position
	
	# Sets the tilemap position by getting player.P 
	var player_at_tilemap_position = $TileMap.local_to_map(player_position)
	
	# Makes the cube and offeset' it to the center the plater location
	for x in range(spawn_cube_size):
		x += player_at_tilemap_position.x -1
		for y in range(spawn_cube_size):
			y += player_at_tilemap_position.y -2
			%CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(0, 1))
			

func put_coal():
	# Coal Layers:
	var coal_ore_heigh_min = 0
	var coal_ore_height_max = 200
	
	for x in range(world_width):
		for y in range(coal_ore_heigh_min, coal_ore_height_max):
			var random = randi_range(0, 15) # Coal Spawn Chance
			if random == 1:
				var tile_pos = Vector2i(x, y)
				if %CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 0):
					%CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(1, 0))

func put_copper():
	# Copper Layers: 
	var copper_ore_height_min = 0
	var copper_ore_height_max = 500
	
	for x in range(world_width):
		for y in range(copper_ore_height_min, copper_ore_height_max):
			var random = randi_range(0, 15) # Copper Spawn Chance
			if random == 1:
				var tile_pos = Vector2i(x, y)
				if %CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 0):
					%CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(1, 2)) 
	
func put_iron():
		# Iron Layers:
	var iron_ore_height_min = 200
	var iron_ore_height_max = 600 
	
	for x in range(world_width):
		for y in range(iron_ore_height_min, iron_ore_height_max):
			var random = randi_range(0, 30) # Iron Spawn Chance
			if random == 1:
				var tile_pos = Vector2i(x, y)
				if %CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 0):
					%CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(2, 0))
	
func put_gold():
	# Gold Layers:
	var gold_ore_height_min = 500
	var gold_ore_height_max = 800 
	
	for x in range(world_width):
		for y in range(gold_ore_height_min, gold_ore_height_max):
			var random = randi_range(0, 100) # Gold Spawn Chance
			if random == 1:
				var tile_pos = Vector2i(x, y)
				if %CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 0):
					%CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(0, 2))

func put_diamond():
	# Diamond Layers:
	var diamond_ore_height_min = 925
	var diamond_ore_height_max = 1000
	
	for x in range(world_width):
		for y in range(diamond_ore_height_min, diamond_ore_height_max):
			var random = randi_range(0, 150) # Diamond Spawn Chance
			if random == 1:
				var tile_pos = Vector2i(x, y)
				if %CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 0):
					%CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(3, 0))

func put_gems():
# Gems Layers:
	var gems_height_min = 500
	var gems_ore_height_max = 1000
	
	for x in range(world_width):
		for y in range(gems_height_min, gems_ore_height_max):
			var random = randi_range(0, 300) # Gems Spawn Chance
			if random == 1:
				var random_gem = randi_range(0, 3)
				match random_gem:
					1:
						var tile_pos = Vector2i(x, y)
						if %CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 0):
							%CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(1, 1))
					2:
						var tile_pos = Vector2i(x, y)
						if %CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 0):
							%CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(2, 1))
					3:
						var tile_pos = Vector2i(x, y)
						if %CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 0):
							%CaveSystem.set_cell(Vector2i(x, y), 0, Vector2i(3, 1))

func _on_time_to_put_ores_timeout() -> void:
	put_coal()
	put_copper()
	put_iron()
	put_gold()
	put_diamond()
	put_gems()
