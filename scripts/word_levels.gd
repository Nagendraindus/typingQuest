extends Control





func _on_foods_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/word based levels/WORD_FOODS/WORD_FOODS.tscn")


func _on_space_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/word based levels/WORD_SPACE/WORD_SPACE.tscn")


func _on_tech_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/word based levels/WORD_TECH LEVEL/WORD_TECH.tscn")


func _on_science_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/word based levels/WORD_SCIENCE/WORD_SCIENCE.tscn")


func _on_trees_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/word based levels/WORD_TREES/WORD_TREES.tscn")
	
