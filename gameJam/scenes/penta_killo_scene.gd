extends Node2D

signal finished

func _on_VideoPlayer_finished():
	emit_signal("finished")
