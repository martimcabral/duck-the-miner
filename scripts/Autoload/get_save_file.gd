extends Node

var saves_config = ConfigFile.new()
var save_being_used : int = 0

# Este script é responsável por obter no arquivo de configuração o arquivo de salvamento em uso.
func _process(_delta: float) -> void:
	saves_config.load("user://save/saves.cfg")
	save_being_used = saves_config.get_value("saves", "selected", 1)
