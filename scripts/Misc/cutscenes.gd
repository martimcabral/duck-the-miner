extends Node2D


@onready var TextDisplay = $TextDisplay
var current_text : String = "T1"
var fadein = -20
var year = Time.get_datetime_dict_from_system().year
var above_sign : bool = false
var lines_number : int = 0
var terms : String = "NaoRespondido"

var _is_drawing := false 
var _current_line : Line2D = null

func _ready() -> void:
	$ReadyButton.visible = false
	$RubberButton.visible = false
	$FyctionContract/PrintingAnimation.play("RESET")

var IntroCusceneTexts : Dictionary = {
	"T1": "In the near future, humanity’s abuse of Earth led to its downfall, leaving only a few resilient animals struggling to survive.",
	"T2": "Together, they developed new ways to live, gradually gaining consciousness and rebuilding a new Earth inspired by the ruins of human civilization.",
	"T3": "Dan the Duckling had a joyful childhood but struggled in school, eventually decided to drop out as his grades got worse.",
	"T4": "As an adult, he faced harsh realities: low paying jobs, mounting debts, and barely enough to pay rent or buy old rice.",
	"T5": "With no way out, Dan made a desperate choice: apply for the most life risking job he could find it was that or [shake rate=35 level=10]starve to death[/shake].",
	"EMPTY": "",
}

func _on_timer_timeout() -> void:
	match current_text:
		"T1": TextDisplay.text = IntroCusceneTexts["T2"]; current_text = "T2"
		"T2": TextDisplay.text = IntroCusceneTexts["T3"]; current_text = "T3"
		"T3": TextDisplay.text = IntroCusceneTexts["T4"]; current_text = "T4"
		"T4": TextDisplay.text = IntroCusceneTexts["T5"]; current_text = "T5"
		"T5": fyction_contract()
	fadein = -20
	update_bbcode()

func update_bbcode() -> void:
	TextDisplay.bbcode_text = "[fade lenght=10 start=" + str(fadein) + "]" + IntroCusceneTexts[current_text] + "[/fade]"

func _on_fade_timer_timeout() -> void:
	fadein += 1
	update_bbcode()

func fyction_contract():
	$TextDisplay.visible = false
	$FyctionContract/PrintingAnimation.play("go_up")
	$TextTimer.stop()
	$FyctionContract/PrintingSoundEffect.play()

func _on_accept_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		terms = "Aceitado"
		$FyctionContract/AcceptButton.button_pressed = true
		$FyctionContract/RefuseButton.button_pressed = false

func _on_refuse_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		terms = "Recusado"
		$FyctionContract/AcceptButton.button_pressed = false
		$FyctionContract/RefuseButton.button_pressed = true 

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and above_sign == true:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_is_drawing = true
				_current_line = Line2D.new()
				_current_line.default_color = Color("080808")
				_current_line.width = 6
				_current_line.joint_mode = Line2D.LINE_JOINT_ROUND
				_current_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
				_current_line.end_cap_mode = Line2D.LINE_CAP_ROUND
				_current_line.z_index = 10
				_current_line.set_meta("line", "line")
				_current_line.add_point(get_local_mouse_position()) 
				lines_number = 1
				$FyctionContract/Lines.add_child(_current_line)
			else:
				_is_drawing = false
				_current_line = null
	if event is InputEventMouseMotion:
		if _is_drawing and _current_line != null:
			_current_line.add_point(get_local_mouse_position())

func _on_block_range_mouse_entered() -> void:
	above_sign = true

func _on_block_range_mouse_exited() -> void:
	above_sign = false
	_is_drawing = false

func _on_printing_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "go_up":
		$ReadyButton.visible = true
		$RubberButton.visible = true

func _on_ready_button_mouse_entered() -> void:
	$ReadyButton/MouseEffectButton.play()

func _on_accept_button_mouse_entered() -> void:
	$ReadyButton/MouseEffectButton.play()

func _on_refuse_button_mouse_entered() -> void:
	$ReadyButton/MouseEffectButton.play()

func _on_rubber_button_mouse_entered() -> void:
	$ReadyButton/MouseEffectButton.play()

func _process(delta: float) -> void:
	if $SkipProgressLine.points[1].x >= 1:
		$SkipProgressLine.points[1].x -= delta * 700
	if Input.is_action_pressed("PauseMenu"):
		$SkipProgressLine.points[1].x += delta * 1500
	if $SkipProgressLine.points[1].x >= 1930:
		$TextDisplay.visible = false
		$SkipProgressLine.visible = false
		$FyctionContract/PrintingAnimation.play("go_up")
		$FyctionContract/PrintingSoundEffect.play()
		$TextTimer.stop()
		$FadeTimer.stop()
	
	if terms == "Aceitado" or terms == "Recusado":
		if $FyctionContract/AcceptButton.button_pressed == true or $FyctionContract/RefuseButton.button_pressed == true:
			for lines in $FyctionContract/Lines.get_children():
				if lines is Line2D:
					$ReadyButton.disabled = false
		else:
			$ReadyButton.disabled = true

func _on_ready_button_pressed() -> void:
	$ReadyButton.visible = false
	$RubberButton.visible = false
	$FyctionContract/PrintingAnimation.play("deliver")
	$FyctionContract/WhooshSoundEffect.play()
	$GoToLobby.start()

func _on_go_to_lobby_timeout() -> void:
	print("[cutscenes.gd] ", terms)
	match terms:
		"Recusado": $".".get_tree().quit()
		"Aceitado": get_tree().change_scene_to_packed(load("res://scenes/lobby.tscn"))

func _on_rubber_button_pressed() -> void:
	$ReadyButton.disabled = true
	for child in $FyctionContract/Lines.get_children():
		$FyctionContract/Lines.remove_child(child)
		child.queue_free()
