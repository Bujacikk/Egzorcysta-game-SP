extends Button


signal fire_rate_increased

var used = false
var fire_rate = 10
func _ready():
	get_parent().get_node("Label").text = "FireRate +"+String(fire_rate)+"%"

func _pressed():
	if used == false and get_parent().get_parent().skill_points > 0:
		emit_signal("fire_rate_increased",fire_rate)
		toggle_mode = true
		pressed = true
		toggle_mode = false
		used = true
