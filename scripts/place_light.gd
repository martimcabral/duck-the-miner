extends TileMap

@onready var player = $"../Player"
@onready var block_range = $"../Player/BlockRange"
@onready var CaveSystem = $"../TileMap/CaveSystem"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var tile_pos = CaveSystem.local_to_map(CaveSystem.get_global_mouse_position())
	var mouse_pos = get_global_mouse_position()
	var local_mouse_pos = block_range.to_local(mouse_pos)
	var collision_shape = block_range.get_node("CollisionShape2D").shape
	var radius = (collision_shape as CircleShape2D).radius
		
	if local_mouse_pos.length() <= radius:
		if (Input.is_action_just_pressed("Place_Torch")) and player.current_item == 3:
			if (CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 1)):
				var torch_scene : PackedScene = preload("res://scenes/light.tscn")
				var torch = torch_scene.instantiate()
			
				torch.position = CaveSystem.map_to_local(tile_pos)
				add_child(torch)
				$"../Player/Player Sounds/PlaceBlock".play()
				print("Torch Placed: ", tile_pos)
