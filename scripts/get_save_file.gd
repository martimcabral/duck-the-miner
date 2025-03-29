extends Node

var saves_config = ConfigFile.new()
var save_being_used

func _process(_delta: float) -> void:
	saves_config.load("res://save/saves.cfg")
	save_being_used = saves_config.get_value("saves", "selected", 0)
