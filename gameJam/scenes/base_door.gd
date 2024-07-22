extends Area2D

var opened = false
var target: CustomRoom
signal player_ported
var door_unlocked_image = load("res://assets/Level_design/doorOpened.png")

func _on_base_door_body_entered(body: KinematicBody2D):
	if body and "Bogdan" in body.name and self.opened():
		if "Left" in self.name:
			body.position = Vector2(self.position.x - 120, self.position.y)
			emit_signal("player_ported", target)
		elif "Right" in self.name:
			body.position = Vector2(self.position.x + 130, self.position.y)
			emit_signal("player_ported", target)
		elif "Top" in self.name:
			body.position = Vector2(self.position.x, self.position.y - 120)
			emit_signal("player_ported", target)
		elif "Bottom" in self.name:
			body.position = Vector2(self.position.x, self.position.y + 120)
			emit_signal("player_ported", target)

func open():
	print(self.name, " - opened")
	$TextureRect.texture = door_unlocked_image
	self.opened = true
	
func opened():
	return self.opened
	
func close():
	self.opened = false
