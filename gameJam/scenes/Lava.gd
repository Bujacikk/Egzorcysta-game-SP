extends Node2D

onready var bogdan = get_parent().get_node("YSort/Bogdan")

func _ready():
	pass


func _on_Area2D_body_entered(body):
	bogdan.lava = true

func _on_Area2D_body_exited(body):
	bogdan.lava = false
