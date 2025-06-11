extends Panel

var CurrentPanel : int = 0

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	hide_all_recipes()
	show_recipes()

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
