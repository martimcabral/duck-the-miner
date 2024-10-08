extends CharacterBody2D

const speed = 80
const accel = 250
const friction = 200

var input = Vector2.ZERO

func _ready():
	pass
	
func _physics_process(delta):
	var player_texture = preload("res://assets/textures/duck.png")
	var squat_texture = preload("res://assets/textures/duck_squat.png")
	
	velocity = Vector2()

	# Handle movement input
	if Input.is_action_pressed("Walk_Right"):
		$Sprite2D.flip_h = true
		velocity.x += speed
		
		if Input.is_action_pressed("Run"):
			velocity.x += speed * 0.5
		if Input.is_action_pressed("Agachar"):
			velocity.x -= speed * 0.5
	
	if Input.is_action_pressed("Walk_Left"):
		$Sprite2D.flip_h = false
		velocity.x -= speed
		
		if Input.is_action_pressed("Run"):
			velocity.x -= speed * 0.5
		if Input.is_action_pressed("Agachar"):
			velocity.x += speed * 0.5
	
	# Change sprite texture based on crouching
	if Input.is_action_pressed("Agachar"):
		$Sprite2D.texture = squat_texture
	else:
		$Sprite2D.texture = player_texture
	
	# Handle vertical movement
	if Input.is_action_pressed("Fly_Up"):
		velocity.y -= speed * 2
	if Input.is_action_just_released("Fly_Up"):
		velocity.y -= speed * 2
	else:
		velocity.y += 50

	# Apply friction when no input is detected
	if not (Input.is_action_pressed("Walk_Right") or Input.is_action_pressed("Walk_Left")):
		if velocity.x > 0:
			velocity.x = max(velocity.x - friction * delta, 0)
		elif velocity.x < 0:
			velocity.x = min(velocity.x + friction * delta, 0)

	move_and_slide()
		
func print_player_location():
	print("Player Location: (x: ", abs($Sprite2D.global_position.x), ", y: ", abs($Sprite2D.global_position.y), ")")
