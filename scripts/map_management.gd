extends TileMap

@onready var player = $"../Player"
@onready var block_range = $"../Player/BlockRange"
@onready var CaveSystem = $"../WorldTileMap/CaveSystem"

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

func drop_items():
	var packed_scene = load("res://scenes/items.tscn")
	var instance = packed_scene.instantiate()
	add_child(instance)
	
	var tile_pos = get_global_mouse_position() / 16
	print(get_global_mouse_position())
	var block = CaveSystem.get_cell_atlas_coords(tile_pos)
	
	match block:
		Vector2i(0, 0):
			var target_node = instance.get_node("Stone")
			target_node.position = CaveSystem.map_to_local(tile_pos)
		Vector2i(3, 0):
			var target_node = instance.get_node("Diamond")
			target_node.position = CaveSystem.map_to_local(tile_pos)
		Vector2i(3, 2):
			var target_node = instance.get_node("Ice")
			target_node.position = CaveSystem.map_to_local(tile_pos)
		Vector2i(1, 1):
			var target_node = instance.get_node("Emerald")
			target_node.position = CaveSystem.map_to_local(tile_pos)
		Vector2i(2, 1):
			var target_node = instance.get_node("Ruby")
			target_node.position = CaveSystem.map_to_local(tile_pos)
		Vector2i(3, 1):
			var target_node = instance.get_node("Sapphire")
			target_node.position = CaveSystem.map_to_local(tile_pos)
		Vector2i(1, 0):
			var target_node = instance.get_node("Coal")
			target_node.position = CaveSystem.map_to_local(tile_pos)
		Vector2i(2, 0):
			var target_node = instance.get_node("RawIron")
			target_node.position = CaveSystem.map_to_local(tile_pos)
		Vector2i(0, 2):
			var target_node = instance.get_node("RawGold")
			target_node.position = CaveSystem.map_to_local(tile_pos)
		Vector2i(1, 2):
			var target_node = instance.get_node("RawCopper")
			target_node.position = CaveSystem.map_to_local(tile_pos)
