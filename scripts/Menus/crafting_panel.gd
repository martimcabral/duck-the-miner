extends Panel

var CurrentPanel : String = "Crafting"

func _on_crafting_icon_texture_button_pressed() -> void:
	$AnimationPlayer.play("grow")

func _on_close_crafting_tab_pressed() -> void:
	$AnimationPlayer.play_backwards("grow")

func _on_crafting_button_pressed() -> void:
	$Navbar/ButtonBackground.position = $Navbar/Icons/CraftingButton.position - Vector2(0, 9)
	make_other_buttons_label_black(); CurrentPanel = "Crafting"
	$Navbar/Icons/CraftingButton/Label.add_theme_color_override("font_color", Color.WHITE)

func _on_alloying_button_pressed() -> void:
	$Navbar/ButtonBackground.position = $Navbar/Icons/AlloyingButton.position - Vector2(0, 9)
	make_other_buttons_label_black(); CurrentPanel = "Alloying"
	$Navbar/Icons/AlloyingButton/Label.add_theme_color_override("font_color", Color.WHITE)

func _on_mettalurgic_button_pressed() -> void:
	$Navbar/ButtonBackground.position = $Navbar/Icons/MettalurgicButton.position - Vector2(0, 9)
	make_other_buttons_label_black(); CurrentPanel = "Mettalurgic"
	$Navbar/Icons/MettalurgicButton/Label.add_theme_color_override("font_color", Color.WHITE)

func _on_fluids_refining_button_pressed() -> void:
	$Navbar/ButtonBackground.position = $Navbar/Icons/FluidsRefiningButton.position - Vector2(0, 9)
	make_other_buttons_label_black(); CurrentPanel = "FluidsRefining"
	$Navbar/Icons/FluidsRefiningButton/Label.add_theme_color_override("font_color", Color.WHITE)

func _on_advanced_crafting_button_pressed() -> void:
	$Navbar/ButtonBackground.position = $Navbar/Icons/AdvancedCraftingButton.position - Vector2(0, 9)
	make_other_buttons_label_black(); CurrentPanel = "AdvancedCrafting"
	$Navbar/Icons/AdvancedCraftingButton/Label.add_theme_color_override("font_color", Color.WHITE)

func _on_gem_polishing_button_pressed() -> void:
	$Navbar/ButtonBackground.position = $Navbar/Icons/GemPolishingButton.position - Vector2(0, 9)
	make_other_buttons_label_black(); CurrentPanel = "GemPolishing"
	$Navbar/Icons/GemPolishingButton/Label.add_theme_color_override("font_color", Color.WHITE)

func make_other_buttons_label_black():
	$Navbar/Icons/CraftingButton/Label.add_theme_color_override("font_color", Color.BLACK)
	$Navbar/Icons/AlloyingButton/Label.add_theme_color_override("font_color", Color.BLACK)
	$Navbar/Icons/MettalurgicButton/Label.add_theme_color_override("font_color", Color.BLACK)
	$Navbar/Icons/FluidsRefiningButton/Label.add_theme_color_override("font_color", Color.BLACK)
	$Navbar/Icons/AdvancedCraftingButton/Label.add_theme_color_override("font_color", Color.BLACK)
	$Navbar/Icons/GemPolishingButton/Label.add_theme_color_override("font_color", Color.BLACK)

func hide_all_recipes():
	for recipe in get_children():
		if recipe.is_in_group("Recipe"):
			print("a")
		
