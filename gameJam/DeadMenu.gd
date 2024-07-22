extends CanvasLayer



func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/new_game_cut_scene.tscn")


func _on_SettingsButton_pressed():
	pass # Replace with function body.


func _on_QuitButton_pressed():
	get_tree().quit()
