extends CharacterBody2D

var current_item = 1
var window_mode = 0

var speed = 100
const accel = 250
const friction = 150
const falling_speed = 150

const zoom_max = Vector2(7, 7)
const zoom_min = Vector2(4.5, 4.5)

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

func _physics_process(delta):
	$BlockRangeRayCast.look_at(get_global_mouse_position())
	$BlockRangeRayCast.rotation -= deg_to_rad(90)
	
	if $BlockRangeRayCast.is_colliding():
		var collider = $BlockRangeRayCast.get_collider()
	
	var player_texture = preload("res://assets/textures/duck.png")
	var squat_texture = preload("res://assets/textures/duck_squat.png")
	
	var input = Input.get_vector("Walk_Left","Walk_Right","Fly_Up","Fly_Down")
	player_movement(input, delta)
	move_and_slide()
	
	if Input.is_action_pressed("Agachar"):
		$Sprite2D.texture = squat_texture
	else:
		$Sprite2D.texture = player_texture
		
	if Input.is_action_pressed("Walk_Right"):
		$Sprite2D.flip_h = true
	if Input.is_action_pressed("Walk_Left"):
		$Sprite2D.flip_h = false
		
	if Input.is_action_just_pressed("Zoom_In") or Input.is_action_pressed("Zoom_In"):
		if $Camera2D.zoom < zoom_max:
			$Camera2D.zoom += Vector2(0.1, 0.1)
	if Input.is_action_just_pressed("Zoom_Out") or Input.is_action_pressed("Zoom_Out"):
		if $Camera2D.zoom > zoom_min:
			$Camera2D.zoom -= Vector2(0.1, 0.1)
	
	# Mudar o Cursor dependendo do Item selecinado da Hotbar
	if Input.is_action_just_pressed("Hotbar_1"):
		current_item = 1
		var cursor_texture = preload("res://assets/textures/cursors/diamond_sword.png")
		Input.set_custom_mouse_cursor(cursor_texture)
	if Input.is_action_just_pressed("Hotbar_2"):
		current_item = 2
		var cursor_texture = preload("res://assets/textures/cursors/diamond_pickaxe.png")
		Input.set_custom_mouse_cursor(cursor_texture)
	if Input.is_action_just_pressed("Hotbar_3"):
		current_item = 3
		var cursor_texture = preload("res://assets/textures/cursors/torch.png")
		Input.set_custom_mouse_cursor(cursor_texture)
	if Input.is_action_just_pressed("Hotbar_4"):
		current_item = 4
		var cursor_texture = preload("res://assets/textures/cursors/flashlight_item.png")
		Input.set_custom_mouse_cursor(cursor_texture)
	
	# Fullscreen
	if Input.is_action_just_pressed("Fullscreen"):
		if window_mode == 0:
			window_mode = 1
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		elif window_mode == 1:
			window_mode = 0
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	$Camera2D/HUD/PlayerPosition.text = "X: " + str(int($".".position.x) / 16) + "\nY: " + str(int($".".position.y) / 16)
	
