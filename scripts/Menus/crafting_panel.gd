extends Panel

var Stone : int = 0
var Sandstone : int = 0
var Gypsum : int = 0
var Kaolinite : int = 0
var Ice : int = 0
var Coal : int = 0
var LavaCluster : int = 0
var DenseIce : int = 0
var Sulfur : int = 0
var Biomass : int = 0
var Copper : int = 0
var Iron : int = 0
var Magnetite : int = 0
var Bauxite : int = 0
var Galena : int = 0
var Silver : int = 0
var Pyrolusite : int = 0
var Wolframite : int = 0
var Nickel : int = 0
var Platinum : int = 0
var Uranium : int = 0
var Cobalt : int = 0
var Zirconium : int = 0
var Scheelite : int = 0
var Pitchblende : int = 0
var Phosphorite : int = 0
var Hematite : int = 0
var OilShale : int = 0
var Graphite : int = 0
var Gold : int = 0
var Emerald : int = 0
var Diamond : int = 0
var Ruby : int = 0
var Sapphire : int = 0
var Garnet : int = 0
var Topaz : int = 0
var Tsavorite : int = 0
var Ametrine : int = 0
var Apatite : int = 0
var Azurite : int = 0
var Charoite : int = 0
var Sugilite : int = 0
var Peridot : int = 0
var Vanadinite : int = 0
var Amazonite : int = 0
var Bloodstone : int = 0
var Chalcedony : int = 0
var Chrysocolla : int = 0
var Pietersite : int = 0
var Labradorite : int = 0
var FrozenDiamond : int = 0
var Jeremejevite : int = 0
var Water : int = 0
var SulfuricAcid : int = 0

var Oxygen : int = 0
var Hydrogen : int = 0

var CurrentPanel : int = 0

#@onready var Contract = $"../Contract"

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	hide_all_recipes()
	show_recipes()
	update_current_resources_amount()

func _on_crafting_icon_texture_button_pressed() -> void:
	$AnimationPlayer.play("grow")

func _on_close_crafting_tab_pressed() -> void:
	$AnimationPlayer.play_backwards("grow")

func _on_crafting_button_pressed() -> void:
	$Navbar/ButtonBackground.position = $Navbar/Icons/CraftingButton.position - Vector2(0, 9)
	reset_crafting_terminal(); CurrentPanel = 0; show_recipes()
	$Navbar/Icons/CraftingButton/Label.add_theme_color_override("font_color", Color.WHITE)

func _on_alloying_button_pressed() -> void:
	$Navbar/ButtonBackground.position = $Navbar/Icons/AlloyingButton.position - Vector2(0, 9)
	reset_crafting_terminal(); CurrentPanel = 1; show_recipes()
	$Navbar/Icons/AlloyingButton/Label.add_theme_color_override("font_color", Color.WHITE)

func _on_mettalurgic_button_pressed() -> void:
	$Navbar/ButtonBackground.position = $Navbar/Icons/MettalurgicButton.position - Vector2(0, 9)
	reset_crafting_terminal(); CurrentPanel = 2; show_recipes()
	$Navbar/Icons/MettalurgicButton/Label.add_theme_color_override("font_color", Color.WHITE)

func _on_fluids_refining_button_pressed() -> void:
	$Navbar/ButtonBackground.position = $Navbar/Icons/FluidsRefiningButton.position - Vector2(0, 9)
	reset_crafting_terminal(); CurrentPanel = 3; show_recipes()
	$Navbar/Icons/FluidsRefiningButton/Label.add_theme_color_override("font_color", Color.WHITE)

func _on_advanced_crafting_button_pressed() -> void:
	$Navbar/ButtonBackground.position = $Navbar/Icons/AdvancedCraftingButton.position - Vector2(0, 9)
	reset_crafting_terminal(); CurrentPanel = 4; show_recipes()
	$Navbar/Icons/AdvancedCraftingButton/Label.add_theme_color_override("font_color", Color.WHITE)

func _on_gem_polishing_button_pressed() -> void:
	$Navbar/ButtonBackground.position = $Navbar/Icons/GemPolishingButton.position - Vector2(0, 9)
	reset_crafting_terminal(); CurrentPanel = 5; show_recipes()
	$Navbar/Icons/GemPolishingButton/Label.add_theme_color_override("font_color", Color.WHITE)

func reset_crafting_terminal():
	$Navbar/Icons/CraftingButton/Label.add_theme_color_override("font_color", Color.BLACK)
	$Navbar/Icons/AlloyingButton/Label.add_theme_color_override("font_color", Color.BLACK)
	$Navbar/Icons/MettalurgicButton/Label.add_theme_color_override("font_color", Color.BLACK)
	$Navbar/Icons/FluidsRefiningButton/Label.add_theme_color_override("font_color", Color.BLACK)
	$Navbar/Icons/AdvancedCraftingButton/Label.add_theme_color_override("font_color", Color.BLACK)
	$Navbar/Icons/GemPolishingButton/Label.add_theme_color_override("font_color", Color.BLACK)
	hide_all_recipes()

func hide_all_recipes():
	for recipe in get_children():
		if recipe.is_in_group("Recipe"):
			print("a")

func show_recipes():
	for recipe in $Recipes/FluidRefiningRecipes.get_children():
		if recipe is Button:
			if recipe.button_type == CurrentPanel: recipe.visible = true
			else: recipe.visible = false
		if recipe is Label:
			if int(recipe.editor_description) == CurrentPanel: recipe.visible = true
			else: recipe.visible = false

func update_current_resources_amount():
	var inventory_path : String = str("user://save/", GetSaveFile.save_being_used, "/inventory.cfg")
	var inventory := ConfigFile.new()
	inventory.load(inventory_path)
	
	if inventory.to_string() != "":
		# Natural Resources:
		Stone = inventory.get_value("raw", "Stone", 0)
		Sandstone = inventory.get_value("raw", "Sandstone", 0)
		Gypsum = inventory.get_value("raw", "Gypsum", 0) 
		Kaolinite = inventory.get_value("raw", "Kaolinite", 0)
		Ice = inventory.get_value("raw", "Ice", 0)
		Coal = inventory.get_value("raw", "Coal", 0)
		LavaCluster = inventory.get_value("raw", "Lava Cluster", 0)
		DenseIce = inventory.get_value("raw", "Dense Ice", 0)
		Sulfur = inventory.get_value("raw", "Sulfur", 0)
		Biomass = inventory.get_value("raw", "Biomass", 0)
		Copper = inventory.get_value("raw", "Copper", 0) 
		Iron = inventory.get_value("raw", "Iron", 0)
		Magnetite = inventory.get_value("raw", "Magnetite", 0)
		Bauxite = inventory.get_value("raw", "Bauxite", 0)
		Galena = inventory.get_value("raw", "Galena", 0)
		Silver = inventory.get_value("raw", "Silver", 0)
		Pyrolusite = inventory.get_value("raw", "Pyrolusite", 0)
		Wolframite = inventory.get_value("raw", "Wolframite", 0)
		Nickel = inventory.get_value("raw", "Nickel", 0)
		Platinum = inventory.get_value("raw", "Platinum", 0)
		Uranium = inventory.get_value("raw", "Uranium", 0)
		Cobalt = inventory.get_value("raw", "Cobalt", 0)
		Zirconium = inventory.get_value("raw", "Zirconium", 0)
		Scheelite = inventory.get_value("raw", "Scheelite", 0)
		Pitchblende = inventory.get_value("raw", "Pitchblende", 0)
		Phosphorite = inventory.get_value("raw", "Phosphorite", 0)
		Hematite = inventory.get_value("raw", "Hematite", 0)
		OilShale = inventory.get_value("raw", "Oil_Shale", 0)
		Graphite = inventory.get_value("raw", "Graphite", 0)
		Gold = inventory.get_value("raw", "Gold", 0)
		Emerald = inventory.get_value("raw", "Emerald", 0)
		Diamond = inventory.get_value("raw", "Diamond", 0)
		Ruby = inventory.get_value("raw", "Ruby", 0)
		Sapphire = inventory.get_value("raw", "Sapphire", 0)
		Garnet = inventory.get_value("raw", "Garnet", 0)
		Topaz = inventory.get_value("raw", "Topaz", 0)
		Tsavorite = inventory.get_value("raw", "Tsavorite", 0)
		Ametrine = inventory.get_value("raw", "Ametrine", 0)
		Apatite = inventory.get_value("raw", "Apatite", 0)
		Azurite = inventory.get_value("raw", "Azurite", 0)
		Charoite = inventory.get_value("raw", "Charoite", 0)
		Sugilite = inventory.get_value("raw", "Sugilite", 0)
		Peridot = inventory.get_value("raw", "Peridot", 0)
		Vanadinite = inventory.get_value("raw", "Vanadinite", 0)
		Amazonite = inventory.get_value("raw", "Amazonite", 0)
		Bloodstone = inventory.get_value("raw", "Bloodstone", 0)
		Chalcedony = inventory.get_value("raw", "Chalcedony", 0)
		Chrysocolla = inventory.get_value("raw", "Chrysocolla", 0)
		Pietersite = inventory.get_value("raw", "Pietersite", 0)
		Labradorite = inventory.get_value("raw", "Labradorite", 0)
		FrozenDiamond = inventory.get_value("raw", "Frozen Diamond", 0)
		Jeremejevite = inventory.get_value("raw", "Jeremejevite", 0)
		# Crafted Resources:
		Water = inventory.get_value("crafted", "Water", 0)
		SulfuricAcid = inventory.get_value("crafted", "Sulfuric Acid", 0)
		Oxygen = inventory.get_value("crafted", "Oxygen", 0)
		Hydrogen = inventory.get_value("crafted", "Hydrogen", 0)
		
		inventory.clear()
