extends Button

signal speed_increased

var used = false

var speed = 5

func _ready():
	get_parent().get_node("Label").text = "Speed +"+String(speed)+"%"

func _pressed():
	if used == false and get_parent().get_parent().skill_points > 0:
		emit_signal("speed_increased",speed)
		toggle_mode = true
		pressed = true
		toggle_mode = false
		used = true
