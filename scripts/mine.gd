extends TileMap

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
		if player.current_item == 2:
			print(tile_data, " ", tile_id)
			print("Properties Changed on Tile: (x: ", tile_pos.x, ", y: ", tile_pos.y, ")")
			
			if not ($CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 1)):
				var mining_sound_effect = randi_range(1,6)
				match mining_sound_effect:
					1:
						$"../Player/Player Sounds/Mining1".play()
					2:
						$"../Player/Player Sounds/Mining2".play()
					3:
						$"../Player/Player Sounds/Mining3".play()
					4:
						$"../Player/Player Sounds/Mining4".play()
					5:	
						$"../Player/Player Sounds/Mining5".play()
					6:
						$"../Player/Player Sounds/Mining6".play()
				
			if not ($CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(2, 2)):
				$CaveSystem.set_cell(tile_pos, 0, Vector2i(0, 1))
		
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
		$CaveSystem.set_cell(tile_pos, 0, Vector2i(3, 0))
		$"../Player/Player Sounds/PlaceBlock".play()
		print("Properties Changed on Tile: (x: ", tile_pos.x, ", y: ", tile_pos.y, ")")
