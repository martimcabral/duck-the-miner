extends TileMap

# Dictionary to hold tile data: {position: [tile_id, health]}
var used_tiles = {}
var safe_margin = 1.0

@onready var block_selection = $BlockSelection
@onready var raycast = $"../Player/RangeRayCast"
@onready var player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if Input.is_action_pressed("Destroy_Block"):
		var tile_position = raycast.get_collision_point() - raycast.get_collision_normal() * safe_margin
		$BlockSelection.position = tile_position
	else:
		var tile_position = Vector2(-1000, -1000)
		$BlockSelection.position = tile_position
		
	'''
	if raycast.get_collision_point().x < player.position.x:
		block_selection.position.x = ($CaveSystem.local_to_map(raycast.get_collision_point()).x * 16) - 8
	if raycast.get_collision_point().x > player.position.x:
		block_selection.position.x = ($CaveSystem.local_to_map(raycast.get_collision_point()).x * 16) + 8
		
	if raycast.get_collision_point().y < player.position.y:
		block_selection.position.y = ($CaveSystem.local_to_map(raycast.get_collision_point()).y * 16) - 8
	if raycast.get_collision_point().y > player.position.y:
		block_selection.position.y = ($CaveSystem.local_to_map(raycast.get_collision_point()).y * 16) + 8
	'''
		
	var tile_pos = $CaveSystem.local_to_map($CaveSystem.get_global_mouse_position())
	var tile_data = $CaveSystem.get_cell_tile_data(tile_pos)
	var tile_id = $CaveSystem.get_cell_atlas_coords(tile_pos)
	$"../Player/Player Sounds".position = tile_pos
		
	if (Input.is_action_just_pressed("Place_Torch")) and player.current_item == 3:
		if ($CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 1)):
			var torch_scene : PackedScene = preload("res://scenes/torch.tscn")
			var torch = torch_scene.instantiate()
		
			torch.position = $CaveSystem.map_to_local(tile_pos)
			add_child(torch)
			$"../Player/Player Sounds/PlaceBlock".play()
			print("Torch Placed: ", tile_pos)
	
	if (Input.is_action_just_pressed("Place_Block")):
		if ($CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 1)):
			print(tile_data, " ", tile_id)
			$CaveSystem.set_cell(tile_pos, 0, Vector2i(0, 0))
			$"../Player/Player Sounds/PlaceBlock".play()
			print("Properties Changed on Tile: (x: ", tile_pos.x, ", y: ", tile_pos.y, ")")
		
			# Reload Used Tiles Dictionary
			var tile_health = 1000
			used_tiles[tile_pos] = {"pos" : tile_pos}
			used_tiles[tile_pos] = {"health": tile_health} 
			used_tiles[tile_pos]["health"] = tile_health
		

func destroy_block():
	if raycast.is_colliding():
		var tile_pos = raycast.get_collision_point() - raycast.get_collision_normal() * safe_margin
		
		print("Block Position: ", block_selection.position)
		#block_selection.rotation = 0
		tile_pos /= 16
		tile_pos = floor(tile_pos)
		$BlockSelection.position = $CaveSystem.local_to_map(raycast.get_collision_point())
		
		# Issue fixed by Xrayez: https://github.com/godotengine/godot/issues/35344, dont know how
		
		# Using $CaveSystem.local_to_map($CaveSystem.get_global_mouse_position()) will break beacause,
		# where the mouse is, is not where the raycast is
		
		# Data of the tile
		var tile_data = $CaveSystem.get_cell_tile_data(tile_pos)
		# ID of the tile
		var tile_id = $CaveSystem.get_cell_atlas_coords(tile_pos)
	
		if player.current_item == 2:
			print("Data: ", used_tiles, " ", tile_id)
			# Get health
			var tile_health = tile_data.get_custom_data("health")
		
			# Initialize used_tiles entry if it doesn't exist
			if not used_tiles.has(tile_pos):
				used_tiles[tile_pos] = {"pos" : tile_pos}
				used_tiles[tile_pos] = {"health": tile_health}  # Store tile health in a dictionary
				used_tiles[tile_pos]["health"] = tile_health  # Update health if it exists
			
			# Check for specific tile ID
			if not (tile_id == Vector2i(0, 1)):
				var mining_sound_effect = randi_range(1, 4)  # Adjusted range to match sound clips
				match mining_sound_effect:
					1:
						$"../Player/Player Sounds/Mining1".play()
					2:
						$"../Player/Player Sounds/Mining2".play()
					3:
						$"../Player/Player Sounds/Mining3".play()
					4:
						$"../Player/Player Sounds/Mining4".play()
			
				# Reduce health of the tile
				if used_tiles[tile_pos]["health"] > 0:
					used_tiles[tile_pos]["health"] -= 350  # Reduce health

				# Check if the tile's health drops to 0 or below
				if used_tiles[tile_pos]["health"] <= 0:
					if not used_tiles[tile_pos]["health"] == -1:
						$CaveSystem.set_cell(tile_pos, 0, Vector2i(0, 1))  # Destroy the tile

func _on_mining_cooldown_timeout() -> void:
	if Input.is_action_pressed("Destroy_Block"):
		destroy_block()
