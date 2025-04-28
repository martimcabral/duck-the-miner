extends Node2D

var debug_info : bool = false

var speed : int = 50
var current_health : int = 100
var max_health : int = 100
var is_wandering : bool = false
var player_chase : bool = false
var attack_cooldown : bool = false
var velocity : Vector2 = Vector2.ZERO
var stop_smoothness : float = speed * 1.5
var was_enemy_atacked : bool = false
var player = null
var direction
var target_position : Vector2

func _ready() -> void:
	$AnimatedSprite2D.play("bat_flying")
	if debug_info == true:
		$DebugInfoLabel.visible = true

func _process(delta: float) -> void:
	update_debug_info()
	
	if current_health <= 0:
		queue_free()
	
	# Attack cooldown effects
	if $TimeToAttackAgain.time_left > 0:
		attack_cooldown = true
		speed = 65
	else:
		attack_cooldown = false
		speed = 50
	
	# Movement logic
	if player_chase and $"../Player".ghost_mode == false:
		if attack_cooldown:
			direction = (position - player.position).normalized()
		else:
			direction = (player.position - position).normalized()
		velocity = direction * speed
	else:
		if target_position != Vector2.ZERO:
			direction = (target_position - position).normalized()
			velocity = direction * speed
		else:
			velocity = velocity.move_toward(Vector2.ZERO, stop_smoothness * delta)
	
	# Update position
	position += velocity * delta

	# Stop wandering if close to the target
	if not player_chase and target_position != Vector2.ZERO and position.distance_to(target_position) < 5.0:
		target_position = Vector2.ZERO

	# Flip sprite based on movement
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body == $"../Player":
		player = body
		player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == $"../Player":
		player = null
		player_chase = false

func update_debug_info():
	var debug_text : String = ""
	debug_text += "Health: " + str(current_health) + "\n"
	debug_text += "Speed: " + str(speed) + "\n"
	debug_text += "Velocity: " + str(round(velocity)) + "\n"
	debug_text += "PlayerInArea: " + str(player_chase) + "\n"
	debug_text += "AttackCooldown: " +  str(round($TimeToAttackAgain.time_left)) + "\n"
	debug_text += "TimeToWander: " +  str(round($TimeToWander.time_left)) + "\n"
	$DebugInfoLabel.text = debug_text

func run_away():
	$TimeToAttackAgain.start()

func _on_enemy_hitbox_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Player attacked Enemie's Hitbox")
		was_enemy_atacked = true
		$"../Player".touched_enemy = self
		print($"../Player".touched_enemy)

func attacked():
	if was_enemy_atacked == true:
		print(was_enemy_atacked)
		print("Enemy Attacked")
		current_health -= 15
		was_enemy_atacked = false
		$AnimatedSprite2D.modulate = Color("ff0000")

func _on_reset_modulate_red_hit_timeout() -> void:
	$AnimatedSprite2D.modulate = Color("ffffff")

func _on_time_to_wander_timeout() -> void:
	$TimeToWander.wait_time = randi_range(8, 25)
	var random_offset = Vector2(
		randf_range(-200, 200),
		randf_range(-200, 200)
	)
	target_position = position + random_offset
