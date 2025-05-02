extends Node2D

@onready var quack_subtitle : CPUParticles2D = $QuackSubtitle

func _ready() -> void:
	quack_subtitle.emitting = true

func _on_quack_subtitle_finished() -> void:
	queue_free()
