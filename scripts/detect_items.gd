extends Area2D

@onready var Mission : Node2D = $"../../MissionInventory"

func _on_body_entered(body : Node2D):
	if body.is_in_group("Pickable"):
		body.collect()
		$PickupItem.play()
		
	match body.name:
		"Stone":
			Mission.inventory[0] += 1
		"Coal":
			Mission.inventory[1] += 1
		"RawCopper":
			Mission.inventory[2] += 1
		"RawIron":
			Mission.inventory[3] += 1
		"RawGold":
			Mission.inventory[4] += 1
		"Emerald":
			Mission.inventory[6] += 1
		"Ruby":
			Mission.inventory[7] += 1
		"Sapphire":
			Mission.inventory[8] += 1
		"Diamond":
			Mission.inventory[9] += 1
		"Ice":
			Mission.inventory[5] += 1
# Inventory for [Stone, Coal, RawCopper, RawIron, RawGold, Emerald, Ruby, Sapphire, Diamond, Ice]
