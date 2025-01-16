extends Node2D

func _process(delta: float) -> void:
	rotate_solar_system(delta)

func rotate_solar_system(delta):
	$Sun.rotation -= delta * 0.1
	$Mercury.rotation -= delta * 0.05
	$Venus.rotation -= delta * 0.075
	
	$Earth.rotation -= delta * 0.1
	$Earth/Moon.rotation -= delta * 0.25
	
	$Mars.rotation -= delta * 0.125
	$Mars/Phobos.rotation -= delta * 0.3
	$Mars/Deimos.rotation -= delta * 0.5
	
	$Jupiter.rotation -= delta * 0.08
	$Jupiter/Io.rotation -= delta * 0.15
	$Jupiter/Europa.rotation -= delta * 0.25
	$Jupiter/Ganymede.rotation -= delta * 0.5
	$Jupiter/Callisto.rotation -= delta * 0.2
	
	$Saturn.rotation -= delta * 0.04
	$Saturn/Mimas.rotation -= delta * 0.4
	$Saturn/Rhea.rotation -= delta * 0.75
	$Saturn/Titan.rotation -= delta * 0.1
	
	$Uranus.rotation -= delta * 0.07
	$Uranus/Miranda.rotation -= delta * 0.33
	$Uranus/Titania.rotation -= delta * 0.25
	
	$Neptune.rotation -= delta * 0.01
	$Neptune/Proteus.rotation -= delta * 0.33
	$Neptune/Tritan.rotation += delta * 0.5
	
	$DeltaBelt.rotation += delta * 0.05
	$GammaField.rotation -= delta * 0.08
	$OmegaField.rotation -= delta * 0.08
	$KoppaBelt.rotation += delta * 0.03
