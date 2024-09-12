extends Control




func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_letter_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/letter based/game.tscn")


func _on_word_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/word based levels/WORD_LEVELS.tscn")
