extends StaticBody2D

onready var camera_capture = $camera_capture

signal capture
signal release


func _ready():
	pass 

func _on_camera_capture_body_entered(body):
	emit_signal("capture", self)

func _on_camera_capture_body_exited(body):
	emit_signal("release")
