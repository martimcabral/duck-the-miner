extends Area2D

@onready var Inventory = $"../HUD/ItemList"
@onready var World = $"../.." # Will be used to know what biome the player is at, to change the texture to the correct biome

func _process(_delta: float) -> void:
	if Inventory.get_item_count() > 0:
		$"../HUD/ItemList/EmptyLabel".visible = false

# Detetar qual o item que o jogador apanhou e adicioná-lo ao inventário.
func _on_body_entered(body : Node2D):
	if body.is_in_group("Pickable"):
		match body.editor_description:
			"Stone":
				var stoneIcon = load("res://assets/textures/items/ores/rock_and_stone.png")
				add_item_to_inventory("Stone", stoneIcon)
			"Coal":
				var coalIcon = load("res://assets/textures/items/ores/coal.png")
				add_item_to_inventory("Coal", coalIcon)
				World.current_more_infrastructure += 1
				World.current_power_future += 1
			"Copper":
				var copperIcon = load("res://assets/textures/items/ores/copper.png")
				add_item_to_inventory("Copper", copperIcon)
				World.current_power_future += 1
			"Iron":
				var ironIcon = load("res://assets/textures/items/ores/iron.png")
				add_item_to_inventory("Iron", ironIcon)
				World.current_more_infrastructure += 1
			"Gold":
				var goldIcon = load("res://assets/textures/items/ores/gold.png")
				add_item_to_inventory("Gold", goldIcon)
				World.current_power_future += 1
			"Emerald":
				var emeraldIcon = load("res://assets/textures/items/gems/emerald.png")
				add_item_to_inventory("Emerald", emeraldIcon)
				World.current_fine_jewelry += 1
			"Ruby":
				var rubyIcon = load("res://assets/textures/items/gems/ruby.png")
				add_item_to_inventory("Ruby", rubyIcon)
				World.current_fine_jewelry += 1
			"Sapphire":
				var sapphireIcon = load("res://assets/textures/items/gems/sapphire.png")
				add_item_to_inventory("Sapphire", sapphireIcon)
				World.current_fine_jewelry += 1
			"Diamond":
				var diamondIcon = load("res://assets/textures/items/gems/diamond.png")
				add_item_to_inventory("Diamond", diamondIcon)
				World.current_fine_jewelry += 1
			"Ice":
				var iceIcon = load("res://assets/textures/items/ores/ice.png")
				add_item_to_inventory("Ice", iceIcon)
				World.current_cold_extraction += 1
			"Magnetite":
				var magnetiteIcon = load("res://assets/textures/items/ores/magnetite.png")
				add_item_to_inventory("Magnetite", magnetiteIcon)
				World.current_more_infrastructure += 1
			"Bauxite":
				var bauxiteIcon = load("res://assets/textures/items/ores/bauxite.png")
				add_item_to_inventory("Bauxite", bauxiteIcon)
				World.current_more_infrastructure += 1
			"Topaz":
				var topazIcon = load("res://assets/textures/items/gems/topaz.png")
				add_item_to_inventory("Topaz", topazIcon)
				World.current_fine_jewelry += 1
			"Garnet":
				var garnetIcon = load("res://assets/textures/items/gems/garnet.png")
				add_item_to_inventory("Garnet", garnetIcon)
				World.current_fine_jewelry += 1
			"Tsavorite":
				var tsavoriteIcon = load("res://assets/textures/items/gems/tsavorite.png")
				add_item_to_inventory("Tsavorire", tsavoriteIcon)
				World.current_fine_jewelry += 1
			"LavaCluster":
				var lavaClusterIcon = load("res://assets/textures/items/ores/lava_cluster.png")
				add_item_to_inventory("Lava Cluster", lavaClusterIcon)
				World.current_heat_extraction += 1
			"DenseIce":
				var denseIceIcon = load("res://assets/textures/items/ores/dense_ice.png")
				add_item_to_inventory("Dense Ice", denseIceIcon)
				World.current_cold_extraction += 1
			"Amazonite":
				var amazoniteIcon = load("res://assets/textures/items/gems/amazonite.png")
				add_item_to_inventory("Amazonite", amazoniteIcon)
				World.current_fine_jewelry += 1
			"Ametrine":
				var ametrineIcon = load("res://assets/textures/items/gems/ametrine.png")
				add_item_to_inventory("Ametrine", ametrineIcon)
				World.current_fine_jewelry += 1
			"Apatite":
				var apatiteIcon = load("res://assets/textures/items/gems/apatite.png")
				add_item_to_inventory("Apatite", apatiteIcon)
				World.current_fine_jewelry += 1
			"FrozenDiamond":
				var frozenDiamondIcon = load("res://assets/textures/items/gems/frozen_diamond.png")
				add_item_to_inventory("Frozen Diamond", frozenDiamondIcon)
				World.current_fine_jewelry += 1
			"Galena":
				var galenaIcon = load("res://assets/textures/items/ores/galena.png")
				add_item_to_inventory("Galena", galenaIcon)
				World.current_power_future += 1
			"Silver":
				var silverIcon = load("res://assets/textures/items/ores/silver.png")
				add_item_to_inventory("Silver", silverIcon)
			"Wolframite":
				var wolframiteIcon = load("res://assets/textures/items/ores/wolframite.png")
				add_item_to_inventory("Wolframite", wolframiteIcon)
			"Pyrolusite":
				var pyrolusiteIcon = load("res://assets/textures/items/ores/pyrolusite.png")
				add_item_to_inventory("Pyrolusite", pyrolusiteIcon)
			"Nickel":
				var nickelIcon = load("res://assets/textures/items/ores/nickel.png")
				add_item_to_inventory("Nickel", nickelIcon)
				World.current_power_future += 1
			"Graphite":
				var graphiteIcon = load("res://assets/textures/items/ores/graphite.png")
				add_item_to_inventory("Graphite", graphiteIcon)
				World.current_fuel_company += 1
				World.current_power_future += 1
			"Cobalt":
				var cobaltIcon = load("res://assets/textures/items/ores/cobalt.png")
				add_item_to_inventory("Cobalt", cobaltIcon)
			"Uranium":
				var uraniumIcon = load("res://assets/textures/items/ores/uranium.png")
				add_item_to_inventory("Uranium", uraniumIcon)
				World.current_fuel_company += 1
			"Charoite":
				var charoiteIcon = load("res://assets/textures/items/gems/charoite.png")
				add_item_to_inventory("Charoite", charoiteIcon)
				World.current_fine_jewelry += 1
			"Sugilite":
				var sugiliteIcon = load("res://assets/textures/items/gems/sugilite.png")
				add_item_to_inventory("Sugilite", sugiliteIcon)
				World.current_fine_jewelry += 1
			"Peridot":
				var peridotIcon = load("res://assets/textures/items/gems/peridot.png")
				add_item_to_inventory("Peridot", peridotIcon)
				World.current_fine_jewelry += 1
			"Sulfur":
				var sulfurIcon = load("res://assets/textures/items/ores/sulfur.png")
				add_item_to_inventory("Sulfur", sulfurIcon)
				World.current_power_future += 1
			"Zirconium":
				var zirconiumIcon = load("res://assets/textures/items/ores/zirconium.png")
				add_item_to_inventory("Zirconium", zirconiumIcon)
				World.current_power_future += 1
			"Platinum":
				var platinumIcon = load("res://assets/textures/items/ores/platinum.png")
				add_item_to_inventory("Platinum", platinumIcon)
			"Sandstone":
				var sandstoneIcon = load("res://assets/textures/items/ores/sandstone.png")
				add_item_to_inventory("Sandstone", sandstoneIcon)
				World.current_build_future += 1
			"Azurite":
				var azuriteIcon = load("res://assets/textures/items/gems/azurite.png")
				add_item_to_inventory("Azurite", azuriteIcon)
				World.current_fine_jewelry += 1
			"Bloodstone":
				var bloodstoneIcon = load("res://assets/textures/items/gems/bloodstone.png")
				add_item_to_inventory("Bloodstone", bloodstoneIcon)
				World.current_fine_jewelry += 1
			"Chalcedony":
				var chalcedonyIcon = load("res://assets/textures/items/gems/chalcedony.png")
				add_item_to_inventory("Chalcedony", chalcedonyIcon)
				World.current_fine_jewelry += 1
			"OilShale":
				var oilshaleIcon = load("res://assets/textures/items/ores/oil_shale.png")
				add_item_to_inventory("Oil Shale", oilshaleIcon)
				World.current_fuel_company += 1
			"Gypsum":
				var gypsumIcon = load("res://assets/textures/items/ores/gypsum.png")
				add_item_to_inventory("Gypsum", gypsumIcon)
				World.current_build_future += 1
			"Kaolinite":
				var kaolitineIcon = load("res://assets/textures/items/ores/kaolinite.png")
				add_item_to_inventory("Kaolinite", kaolitineIcon)
				World.current_build_future += 1
			"Scheelite":
				var scheeliteIcon = load("res://assets/textures/items/ores/scheelite.png")
				add_item_to_inventory("Scheelite", scheeliteIcon)
			"Vanadinite":
				var vanadiniteIcon = load("res://assets/textures/items/ores/vanadinite.png")
				add_item_to_inventory("Vanadinite", vanadiniteIcon)
			"Biomass":
				var biomassIcon = load("res://assets/textures/items/misc/biomass.png")
				add_item_to_inventory("Biomass", biomassIcon)
				World.current_fuel_company += 1
			"Jeremejevite":
				var jeremejeviteIcon = load("res://assets/textures/items/gems/jeremejevite.png")
				add_item_to_inventory("Jeremejevite", jeremejeviteIcon)
				World.current_fine_jewelry += 1
			"Chrysocolla":
				var chrysocollaIcon = load("res://assets/textures/items/gems/chrysocolla.png")
				add_item_to_inventory("Chrysocolla", chrysocollaIcon)
				World.current_fine_jewelry += 1
			"Pietersite":
				var pietersiteIcon = load("res://assets/textures/items/gems/pietersite.png")
				add_item_to_inventory("Pietersite", pietersiteIcon)
				World.current_fine_jewelry += 1
			"Labradorite":
				var labradoriteIcon = load("res://assets/textures/items/gems/labradorite.png")
				add_item_to_inventory("Labradorite", labradoriteIcon)
				World.current_fine_jewelry += 1
			"Phosphorite":
				var phosphoriteIcon = load("res://assets/textures/items/ores/phosphorite.png")
				add_item_to_inventory("Phosphorite", phosphoriteIcon)
				World.current_fuel_company += 1
			"Pitchblende":
				var pitchblendeIcon = load("res://assets/textures/items/ores/pitchblende.png")
				add_item_to_inventory("Pitchblende", pitchblendeIcon)
				World.current_fuel_company += 1
			"Hematite":
				var hematiteIcon = load("res://assets/textures/items/ores/hematite.png")
				add_item_to_inventory("Hematite", hematiteIcon)
		body.queue_free()
		$PickupItem.play()

# Adicionar um item ao inventário.
func add_item_to_inventory(item_name: String, item_icon: Texture):
	World.current_goods_amount += 1

	# Verifica se o inventário está vazio
	if Inventory.get_item_count() == 0:
		Inventory.add_item(item_name + " 1", item_icon)  # Adiciona o primeiro item
	else:
		# Percorre o inventário para verificar se o item já existe
		for i in range(Inventory.get_item_count()):
			if Inventory.get_item_text(i).begins_with(item_name):
				# Se o item for encontrado, incrementa a quantidade
				var current_count = int(Inventory.get_item_text(i).split(" ")[1])  # Assume o formato "Item X"
				current_count += 1  # Incrementa a quantidade
				Inventory.set_item_text(i, item_name + " " + str(current_count))  # Atualiza o texto do item
				return  # Sai da função após atualizar a quantidade
		
		# Se nenhum item foi encontrado após o loop, adiciona um novo
		Inventory.add_item(item_name + " 1", item_icon)  # Adiciona como "Item 1"
