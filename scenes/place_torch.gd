extends TileMap

@onready var player = $"../Player"
@onready var block_range = $"../Player/BlockRange"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var tile_pos = %CaveSystem.local_to_map(%CaveSystem.get_global_mouse_position())
	# 1. Get the global position of the mouse
	var mouse_pos = get_global_mouse_position()
		
	# 2. Convert the global mouse position to the local position of the Area2D
	var local_mouse_pos = block_range.to_local(mouse_pos)
		
	# 3. Get the CollisionShape2D's shape
	var collision_shape = block_range.get_node("CollisionShape2D").shape
		
	# 4. Get CollisionShape2D's size
	var radius = (collision_shape as CircleShape2D).radius
		
	# 5. If the mouse is within the Area2D/BlockRange than start to destroy EVERYTHING
	if local_mouse_pos.length() <= radius:
		if (Input.is_action_just_pressed("Place_Torch")) and player.current_item == 3:
			if (%CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 1)):
				var torch_scene : PackedScene = preload("res://scenes/torch.tscn")
				var torch = torch_scene.instantiate()
			
				torch.position = %CaveSystem.map_to_local(tile_pos)
				add_child(torch)
				$"../Player/Player Sounds/PlaceBlock".play()
				print("Torch Placed: ", tile_pos)
