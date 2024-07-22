extends Area2D

var opened = false
var target
signal player_ported


func _on_Boss_door_body_entered(body):
	if body and "Bogdan" in body.name:
		if body.has_key():
			if "Top" in self.name:
				body.position = Vector2(self.position.x, self.position.y - 120)
			if "Left" in self.name:
				body.position = Vector2(self.position.x - 200, self.position.y)
			emit_signal("player_ported", self.target)

func open():
	self.opened = true
	
func opened():
	return self.opened
	
func close():
	self.opened = false
