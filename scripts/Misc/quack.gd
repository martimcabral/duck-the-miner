extends Node2D

@onready var quack_subtitle : CPUParticles2D = $QuackSubtitle

# Este script é responsável por exibir a legenda de "quack" quando o jogador inicia o jogo.
# Ele utiliza um sistema de partículas para criar uma animação visual do som "quack".
func _ready() -> void:
	quack_subtitle.emitting = true

func _on_quack_subtitle_finished() -> void:
	queue_free()
