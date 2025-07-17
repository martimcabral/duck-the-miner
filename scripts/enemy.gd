extends Node2D

var debug_info : bool = false

var speed : int = 50
var current_health : int
var max_health : int
var is_wandering : bool = false
var player_chase : bool = false
var attack_cooldown : bool = false
var velocity : Vector2 = Vector2.ZERO
var stop_smoothness : float = speed * 1.5
var was_enemy_atacked : bool = false
var player = null
var direction
var target_position : Vector2

@onready var world = $".."

var difficulty_path : String = str("user://save/", GetSaveFile.save_being_used, "/player.cfg")
var difficulty_config = ConfigFile.new()
var current_difficulty : String = ""

var statistics_path : String = str("user://save/", GetSaveFile.save_being_used, "/statistics.cfg")
var statistics_config = ConfigFile.new()

# Este script inteiro é responsável por gerenciar o comportamento de um inimigo no jogo, especificamente um morcego.
# Ele lida com a detecção do jogador, movimento, ataque, saúde e efeitos sonoros.
# O morcego persegue o jogador quando este entra em sua área de detecção,
# e se o jogador atacar, o morcego recebe dano e pode morrer e dropar os seus itens.
func _ready() -> void:
	var scale_factor = randf_range(0.8, 1.2)
	self.scale = Vector2(scale_factor, scale_factor)
	
	difficulty_config.load(difficulty_path)
	current_difficulty = difficulty_config.get_value("difficulty", "current", "normal")
	match current_difficulty:
		"easy": max_health = 80
		"normal": max_health = 100
		"hard": max_health = 120
	@warning_ignore("narrowing_conversion")
	max_health *= scale.x
	current_health = max_health
	
	$AnimatedSprite2D.play("bat_flying")
	if debug_info == true: $DebugInfoLabel.visible = true
	else: $DebugInfoLabel.visible = false

func _process(delta: float) -> void:
	if $"../PauseMenu/GUI_Pause".visible == false:
		$AnimatedSprite2D.play("bat_flying")
		update_debug_info()
		if current_health <= 0: # Enemy Death Sequence
			$Sounds/Bat/Death.play()
			world.current_kill_enemies_amount += 1
			for i in randi_range(1, 3):
				var packed_scene = load("res://scenes/misc/items.tscn")
				var instance = packed_scene.instantiate()
				var biomass = instance.get_node("Biomass")
				biomass.get_parent().remove_child(biomass)
				biomass.owner = null
				biomass.linear_velocity = self.velocity
				biomass.position = self.position
				biomass.position += Vector2(randf_range(-0.05, 0.05), randf_range(-0.05, 0.05))
				biomass.rotation = randi_range(0, 360)
				world.add_child(biomass)
			statistics_config.load(statistics_path)
			statistics_config.set_value("statistics", "enemies", \
			statistics_config.get_value("statistics", "enemies") + 1)
			statistics_config.save(statistics_path)
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
	else:
		$AnimatedSprite2D.stop()

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
	debug_text += "Scale: " + str(scale) + "\n"
	debug_text += "Velocity: " + str(round(velocity)) + "\n"
	debug_text += "PlayerInArea: " + str(player_chase) + "\n"
	debug_text += "AttackCooldown: " +  str(round($TimeToAttackAgain.time_left)) + "\n"
	debug_text += "TimeToWander: " +  str(round($TimeToWander.time_left)) + "\n"
	$DebugInfoLabel.text = debug_text

func run_away():
	$TimeToAttackAgain.start()

func _on_enemy_hitbox_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#print("[enemy.gd] Player attacked Enemie's Hitbox")
		was_enemy_atacked = true
		$"../Player".touched_enemy = self
		#print("enemy.gd] Did Player touched enemy?: ", $"../Player".touched_enemy)

func attacked():
	if was_enemy_atacked == true:
		match randi_range(1, 3):
			1: $Sounds/Bat/Idle.pitch_scale = 0.95
			2: $Sounds/Bat/Idle.pitch_scale = 1
			3: $Sounds/Bat/Idle.pitch_scale = 1.05
		$Sounds/Bat/Idle.play()
		#print("[enemy.gd] Was enemy attacked?: ", was_enemy_atacked)
		#print("[enemy.gd] Enemy Attacked")
		var damage = $"../Player".sword_damage
		current_health -= damage
		was_enemy_atacked = false
		$AnimatedSprite2D.modulate = Color(2, 0, 0)
		
		statistics_config.load(statistics_path)
		statistics_config.set_value("statistics", "damage_dealt", \
		statistics_config.get_value("statistics", "damage_dealt") + damage)
		statistics_config.save(statistics_path)

func _on_reset_modulate_red_hit_timeout() -> void:
	$AnimatedSprite2D.modulate = Color("ffffff")

func _on_time_to_wander_timeout() -> void:
	$TimeToWander.wait_time = randi_range(8, 25)
	var random_offset = Vector2(
		randf_range(-200, 200),
		randf_range(-200, 200)
	)
	target_position = position + random_offset

func _on_time_to_sound_effect_timeout() -> void:
	if $"../PauseMenu/GUI_Pause".visible == false:
		match randi_range(1, 3):
			1: $Sounds/Bat/Idle.pitch_scale = 0.95
			2: $Sounds/Bat/Idle.pitch_scale = 1
			3: $Sounds/Bat/Idle.pitch_scale = 1.05
		$Sounds/Bat/Idle.play()
		$TimeToSoundEffect.wait_time = randf_range(3, 8)
