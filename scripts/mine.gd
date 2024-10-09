extends TileMap

# Dictionary to hold tile data: {position: [tile_id, health]}
var used_tiles = {}

@onready var player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var tile_pos = $CaveSystem.local_to_map($CaveSystem.get_global_mouse_position())
	var tile_data = $CaveSystem.get_cell_tile_data(tile_pos)
	var tile_id = $CaveSystem.get_cell_atlas_coords(tile_pos)
	$"../Player/Player Sounds".position = tile_pos
	
	if (Input.is_action_just_pressed("Destroy_Block")):
		destroy_block()
		
	if (Input.is_action_just_pressed("Place_Torch")) and player.current_item == 3:
		if ($CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 1)):
			var torch_scene : PackedScene = preload("res://scenes/torch.tscn")
			var torch = torch_scene.instantiate()
		
			torch.position = $CaveSystem.map_to_local(tile_pos)
			add_child(torch)
			$"../Player/Player Sounds/PlaceBlock".play()
			print("Torch Placed: ", torch)
	
	if (Input.is_action_just_pressed("Place_Block")):
		print(tile_data, " ", tile_id)
		$CaveSystem.set_cell(tile_pos, 0, Vector2i(0, 0))
		$"../Player/Player Sounds/PlaceBlock".play()
		print("Properties Changed on Tile: (x: ", tile_pos.x, ", y: ", tile_pos.y, ")")

func destroy_block():
	# Position of the tile
	var tile_pos = $CaveSystem.local_to_map($CaveSystem.get_global_mouse_position())
	# Data of the tile
	var tile_data = $CaveSystem.get_cell_tile_data(tile_pos)
	# ID of the tile
	var tile_id = $CaveSystem.get_cell_atlas_coords(tile_pos)
	
	if player.current_item == 2:
		# Debug tile information
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
					$CaveSystem.set_cell(tile_pos, 0, Vector2i(0, 1))  # Destroy the tile
