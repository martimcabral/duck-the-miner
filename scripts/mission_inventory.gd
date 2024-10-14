extends Node2D

var inventory = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

func _process(_delta: float) -> void:
	update_inventory()

func update_inventory():
	$"../Player/HUD/WorldMissionInventory/Stone/Amount".text = str(": ", inventory[0])
	$"../Player/HUD/WorldMissionInventory/Coal/Amount".text = str(": ", inventory[1])
	$"../Player/HUD/WorldMissionInventory/RawCopper/Amount".text = str(": ", inventory[2])
	$"../Player/HUD/WorldMissionInventory/RawIron/Amount".text = str(": ", inventory[3])
	$"../Player/HUD/WorldMissionInventory/RawGold/Amount".text = str(": ", inventory[4])
	################################################################################################
	$"../Player/HUD/WorldMissionInventory/Ice/Amount".text = str(": ", inventory[5])
	$"../Player/HUD/WorldMissionInventory/Emerald/Amount".text = str(": ", inventory[6])
	$"../Player/HUD/WorldMissionInventory/Ruby/Amount".text = str(": ", inventory[7])
	$"../Player/HUD/WorldMissionInventory/Sapphire/Amount".text = str(": ", inventory[8])
	$"../Player/HUD/WorldMissionInventory/Diamond/Amount".text = str(": ", inventory[9])
