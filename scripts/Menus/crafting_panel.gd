extends Panel

func _ready():
	pass

func _on_crafting_icon_texture_button_pressed() -> void:
	$AnimationPlayer.play("grow")
	
	
