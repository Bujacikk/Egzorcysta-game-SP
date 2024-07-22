extends Button

signal double_shot_enabled

var used = false
var double_shot = true
func _ready():
	get_parent().get_node("Label").text = "Double Shot"

func _pressed():
	if used == false and get_parent().get_parent().skill_points > 0:
		emit_signal("double_shot_enabled",double_shot)
		toggle_mode = true
		pressed = true
		toggle_mode = false
		used = true
