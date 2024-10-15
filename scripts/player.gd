extends CharacterBody2D

var current_item = 1
var window_mode = 0

var speed = 100
const accel = 250
const friction = 375
const falling_speed = 150

const zoom_max = Vector2(9, 9)
const zoom_min = Vector2(3.05, 3.05)

var used_tiles = {}

@onready var block_selection = $"../WorldTileMap/BlockSelection"
@onready var player = $"../Player"

@onready var CaveSystem = $"../WorldTileMap/CaveSystem"
@onready var BreakingStages = $"../WorldTileMap/BreakingStages"

var cursor_texture_sword = preload("res://assets/textures/equipment/swords/debug_sword.png")
var cursor_texture_pickaxe = preload("res://assets/textures/equipment/pickaxes/debug_pickaxe.png")
var cursor_texture_light = preload("res://assets/textures/equipment/others/bulkhead_light.png")
var cursor_texture_flashlight = preload("res://assets/textures/equipment/others/flashlight_item.png")

var block_selection_default = preload("res://assets/textures/selected_block.png")
var block_selection_out = preload("res://assets/textures/selected_block_out_of_range.png")

func player_movement(input, delta):
	if input: 
		if Input.is_action_pressed("Agachar"):
			speed = 15
			velocity = velocity.move_toward(input * speed , delta * accel)
		elif Input.is_action_pressed("Run"):
			speed = 100
			velocity = velocity.move_toward(input * speed , delta * accel)
		else:
			speed = 60
			velocity = velocity.move_toward(input * speed , delta * accel)
	else: 
		velocity = velocity.move_toward(Vector2(0,0), delta * friction)
	velocity.y += falling_speed * delta

func _process(delta):
	var tile_pos = CaveSystem.local_to_map(CaveSystem.get_global_mouse_position())
	var tile_data = CaveSystem.get_cell_tile_data(tile_pos)
	var tile_id = CaveSystem.get_cell_atlas_coords(tile_pos)
	$"../Player/Player Sounds".position = tile_pos
		
	if Input.is_action_pressed("Destroy_Block"):
		var offset = Vector2i(-8, -8)
		var block_selection_position = (Vector2i(CaveSystem.get_global_mouse_position()) - offset)
		
		var tile_size = Vector2(16, 16)
		var mouse_pos = get_global_mouse_position()
		var local_mouse_pos = $BlockRange.to_local(mouse_pos)
		
		block_selection_position = block_selection_position.snapped(tile_size)
		$"../WorldTileMap/BlockSelection".position = block_selection_position
		
		var collision_shape = $BlockRange.get_node("CollisionShape2D").shape
		var radius = (collision_shape as CircleShape2D).radius
		
		if local_mouse_pos.length() <= radius:
			$"../WorldTileMap/BlockSelection".texture = block_selection_default
		else:
			$"../WorldTileMap/BlockSelection".texture = block_selection_out
	else:
		$"../WorldTileMap/BlockSelection".position = Vector2(-128, -128)
		$"../WorldTileMap/BlockSelection".texture = block_selection_default
		
	if (Input.is_action_just_pressed("Place_Block")):
		var mouse_pos = get_global_mouse_position()
		var local_mouse_pos = $BlockRange.to_local(mouse_pos)
		var collision_shape = $BlockRange.get_node("CollisionShape2D").shape
		var radius = (collision_shape as CircleShape2D).radius
		
		if local_mouse_pos.length() <= radius:
			if (CaveSystem.get_cell_atlas_coords(tile_pos) == Vector2i(0, 1)):
				print(tile_data, " ", tile_id)
				CaveSystem.set_cell(tile_pos, 0, Vector2i(0, 0))
				$"../Player/Player Sounds/PlaceBlock".play()
				print("Properties Changed on Tile: (x: ", tile_pos.x, ", y: ", tile_pos.y, ")")
				
				# Restart new Tile on Used Tiles Dictionary
				var tile_health = 12500
				used_tiles[tile_pos] = {"pos" : tile_pos}
				used_tiles[tile_pos] = {"health": tile_health} 
				used_tiles[tile_pos]["health"] = tile_health
	
	var input = Input.get_vector("Walk_Left","Walk_Right","Fly_Up","Fly_Down")
	player_movement(input, delta)
	move_and_slide()
	$AnimatedSprite2D.play()
	
	if not is_on_floor():
		$AnimatedSprite2D.animation = "flying"
	if not is_on_floor() and Input.is_action_pressed("Walk_Right"):
		$AnimatedSprite2D.flip_h = true
	elif not is_on_floor() and Input.is_action_pressed("Walk_Left"):
		$AnimatedSprite2D.flip_h = false
		
	if is_on_floor() and Input.is_action_pressed("Agachar"):
		$AnimatedSprite2D.animation = "squat"
		if Input.is_action_pressed("Walk_Left"):
			$AnimatedSprite2D.flip_h = false
		elif Input.is_action_pressed("Walk_Right"):
			$AnimatedSprite2D.flip_h = true
	elif is_on_floor():
		$AnimatedSprite2D.animation = "walking"
		if Input.is_action_pressed("Walk_Right"):
			$AnimatedSprite2D.flip_h = true
		elif Input.is_action_pressed("Walk_Left"):
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.stop()
	
	if Input.is_action_just_pressed("Zoom_In") or Input.is_action_pressed("Zoom_In"):
		if $Camera2D.zoom < zoom_max:
			$Camera2D.zoom += Vector2(0.1, 0.1)
	if Input.is_action_just_pressed("Zoom_Out") or Input.is_action_pressed("Zoom_Out"):
		if $Camera2D.zoom > zoom_min:
			$Camera2D.zoom -= Vector2(0.1, 0.1)
	
	# Mudar o Cursor dependendo do Item selecinado da Hotbar
	if Input.is_action_just_pressed("Hotbar_1"):
		current_item = 1
		Input.set_custom_mouse_cursor(cursor_texture_sword)
	if Input.is_action_just_pressed("Hotbar_2"):
		current_item = 2
		Input.set_custom_mouse_cursor(cursor_texture_pickaxe, Input.get_current_cursor_shape(), Vector2(9, 9))
	if Input.is_action_just_pressed("Hotbar_3"):
		current_item = 3
		Input.set_custom_mouse_cursor(cursor_texture_light)
	if Input.is_action_just_pressed("Hotbar_4"):
		current_item = 4
		Input.set_custom_mouse_cursor(cursor_texture_flashlight)
	
	# Fullscreen
	if Input.is_action_just_pressed("Fullscreen"):
		if window_mode == 0:
			window_mode = 1
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		elif window_mode == 1:
			window_mode = 0
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	$Camera2D/HUD/PlayerPosition.text = "X: " + str(int($".".position.x / 16)) + \
	"\nY: " + str(int($".".position.y / 16))

####################################################################################################################################################
####################################################################################################################################################
####################################################################################################################################################
func destroy_block():
		var tile_pos = CaveSystem.local_to_map(CaveSystem.get_global_mouse_position())
		var tile_data = CaveSystem.get_cell_tile_data(tile_pos)
		var tile_id = CaveSystem.get_cell_atlas_coords(tile_pos)

		if player.current_item == 2:
			#print("Data: ", used_tiles, " ", tile_id)
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
				
				# Detect percentage of the health of the Tile here:
				var percentage = float(used_tiles[tile_pos]["health"]) / tile_health * 100
				print(percentage, "%")
				if (percentage >= 76 and percentage <= 100):
					BreakingStages.set_cell(tile_pos, 0, Vector2i(0, 0))
				elif (percentage >= 50 and percentage <= 75):
					BreakingStages.set_cell(tile_pos, 0, Vector2i(1, 0))
				elif (percentage >= 25 and percentage <= 49):
					BreakingStages.set_cell(tile_pos, 0, Vector2i(2, 0))
				elif (percentage >= 1 and percentage <= 24):
					BreakingStages.set_cell(tile_pos, 0, Vector2i(3, 0))
				elif percentage < 1:
					BreakingStages.set_cell(tile_pos, 0, Vector2i(4, 0))
				
				# Check if the tile's health drops to 0 or below
				if used_tiles[tile_pos]["health"] <= 0:
					if not used_tiles[tile_pos]["health"] == -1:
						var drop_the_item = get_node("%WorldTileMap")
						drop_the_item.drop_items()
						CaveSystem.set_cell(tile_pos, 0, Vector2i(0, 1))  # Destroy the tile
##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################
func _on_minning_cooldown_timeout() -> void:
	if Input.is_action_pressed("Destroy_Block"):
		# 1. Get the global position of the mouse
		var mouse_pos = get_global_mouse_position()
		
		# 2. Convert the global mouse position to the local position of the Area2D
		var local_mouse_pos = $BlockRange.to_local(mouse_pos)
		
		# 3. Get the CollisionShape2D's shape
		var collision_shape = $BlockRange.get_node("CollisionShape2D").shape
		
		# 4. Get CollisionShape2D's size
		var radius = (collision_shape as CircleShape2D).radius
		
		# 5. If the mouse is within the Area2D/BlockRange than start to destroy EVERYTHING
		if local_mouse_pos.length() <= radius:
			destroy_block()
		else: 
			pass
			#print("[!] Trying to Destroy block outside BlockRange")
