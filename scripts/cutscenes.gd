extends Node2D


@onready var TextDisplay = $TextDisplay
var current_text : String = "S1T1"
var fadein = -20
var year = Time.get_datetime_dict_from_system().year
var above_sign : bool = false
var lines_number : int = 0
var terms : String = "NaoRespondido"

func _ready() -> void:
	$ReadyButton.visible = false
	$RubberButton.visible = false

var IntroCusceneTexts : Dictionary = {
	"NOTEXT": "",
	"S1T1": "In a near future, humanity’s misuse of Earth destroyed the planet and their chances of survival, after this disaster, only some animals could barely live.",
	"S1T2": "As Earth’s resources ran low, these clever animals started developing new ways to survive, with this, they started helping each other to restore Earth.",
	"S1T3": "Determined to survive, these animals began to replicate what humans once did, trying their best to mimic their behavior and rebuild what was lost.",
	"S1T4": "Over time, they developed rational thought and a deeper sense of consciousness, shaping a new Earth.",
	"S1T5": "1623 Years Later...",
	"S2T1": "Dan the Duck was a very happy duckling, having the best childhood, even though he didn’t do very well in school.",
	"S2T2": "Unfortunately, age caught up, and his grades were not very good. So, he decided that school just wasn’t his thing and dropped out.",
	"S2T3": "Financially, Dan the Duck was not in a good way. After working multiple horrible jobs, he couldn’t even afford his nest rent or old rice.",
	"S2T4": "Over the years, he kept accumulating debt after debt after debt until he finally gave up and knew exactly what he had to do.",
	"S2T5": "Apply for the most life risking job. It was that or [shake rate=35 level=10]starve to death[/shake]."
}

func _on_timer_timeout() -> void:
	match current_text:
		"S1T1": TextDisplay.text = IntroCusceneTexts["S1T2"]; current_text = "S1T2"; $TextTimer.wait_time = 14
		"S1T2": TextDisplay.text = IntroCusceneTexts["S1T3"]; current_text = "S1T3"; $TextTimer.wait_time = 14
		"S1T3": TextDisplay.text = IntroCusceneTexts["S1T4"]; current_text = "S1T4"; $TextTimer.wait_time = 5
		"S1T4": TextDisplay.text = IntroCusceneTexts["S1T5"]; current_text = "S1T5"; $TextTimer.wait_time = 14
		"S1T5": TextDisplay.text = IntroCusceneTexts["S2T1"]; current_text = "S2T1"; $TextTimer.wait_time = 14
		"S2T1": TextDisplay.text = IntroCusceneTexts["S2T2"]; current_text = "S2T2"; $TextTimer.wait_time = 14
		"S2T2": TextDisplay.text = IntroCusceneTexts["S2T3"]; current_text = "S2T3"; $TextTimer.wait_time = 14
		"S2T3": TextDisplay.text = IntroCusceneTexts["S2T4"]; current_text = "S2T4"; $TextTimer.wait_time = 14
		"S2T4": TextDisplay.text = IntroCusceneTexts["S2T5"]; current_text = "S2T5"; $TextTimer.wait_time = 14
		"S2T5": fyction_contract()
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
	terms = "Aceitado"
	if toggled_on == true:
		$FyctionContract/AcceptButton.button_pressed = true
		$FyctionContract/RefuseButton.button_pressed = false

func _on_refuse_button_toggled(toggled_on: bool) -> void:
	terms = "Recusado"
	if toggled_on == true:
		$FyctionContract/AcceptButton.button_pressed = false
		$FyctionContract/RefuseButton.button_pressed = true

var _is_drawing := false 
var _current_line : Line2D = null 

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
	
	if terms != "NaoRespondido":
		for lines in $FyctionContract/Lines.get_children():
			if lines is Line2D:
				$ReadyButton.disabled = false

func _on_ready_button_pressed() -> void:
	$ReadyButton.visible = false
	$RubberButton.visible = false
	$FyctionContract/PrintingAnimation.play("deliver")
	$FyctionContract/WhooshSoundEffect.play()
	$GoToLobby.start()

func _on_go_to_lobby_timeout() -> void:
	match terms:
		"Recusado": $".".get_tree().quit()
		"Aceitado": get_tree().change_scene_to_packed(load("res://scenes/lobby.tscn"))

func _on_rubber_button_pressed() -> void:
	$ReadyButton.disabled = true
	for child in $FyctionContract/Lines.get_children():
		$FyctionContract/Lines.remove_child(child)
		child.queue_free()
