extends Node2D

func _input(event):
	if event is InputEventKey and event.scancode == KEY_SPACE:
		$VideoPlayer.stop()
		get_tree().change_scene("res://scenes/Levels/Level1/Level1_1.tscn")

func _on_VideoPlayer_finished():
	get_tree().change_scene("res://scenes/Levels/Level1/Level1_1.tscn")
