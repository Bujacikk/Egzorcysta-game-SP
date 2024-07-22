extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	$VBoxContainer/StartButton.grab_focus()


func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/new_game_cut_scene.tscn")
	


func _on_SettingsButton_pressed():
	pass
	#get_tree().change_scene("res://scenes/settings.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
