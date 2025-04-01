extends Control


@onready var TextDisplay = $Camera2D/HUD/TextDisplay
var current_text : String = "S1T1"
var fadein = -20
var year = Time.get_datetime_dict_from_system().year

var IntroCusceneTexts : Dictionary = {
	"NOTEXT": "",
	"S1T1": "In a near future, humanity’s misuse of Earth destroyed the planet and their chances of survival, after this disaster, only some animals could barely live.",
	"S1T2": "As Earth’s resources ran low, these clever animals started developing new ways to survive, with this, they started helping each other to restore Earth.",
	"S1T3": "Determined to survive, these animals began to replicate what humans once did, trying their best to mimic their behavior and rebuild what was lost.",
	"S1T4": "Over time, they developed rational thought and a deeper sense of consciousness, shaping a new Earth.",
	"S1T5": "1623 Years Later...",
	"S2T1": "Dan the Duck was a very happy duckling, having the best childhood, even though he didn’t do very well in school.",
	"S2T2": "Unfortunately, age caught up, and his grades were not very good. So, he decided that school just wasn’t his thing and dropped out.",
	"S2T3": "Financially, Dan the Duck was not in a good shape. After working multiple horrible jobs, he couldn’t even afford his nest rent or old rice.",
	"S2T4": "Over the years, he kept accumulating debt and debt after debt until he finally knew what he had to do.",
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
		"S2T5": $TextTimer.wait_time = 14; $".".get_tree().quit()
	fadein = -20
	update_bbcode()

func update_bbcode() -> void:
	TextDisplay.bbcode_text = "[fade lenght=10 start=" + str(fadein) + "]" + IntroCusceneTexts[current_text] + "[/fade]"

func _on_fade_timer_timeout() -> void:
	fadein += 1
	update_bbcode()
