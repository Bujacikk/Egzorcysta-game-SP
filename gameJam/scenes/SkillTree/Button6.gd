extends Button


signal health_increased

var used = false

var health = 2

func _ready():
	get_parent().get_node("Label").text = "Hearth +"+String(health/2)
	
func _pressed():
	if used == false and get_parent().get_parent().skill_points > 0:
		emit_signal("health_increased",health)
		toggle_mode = true
		pressed = true
		toggle_mode = false
		used = true
