extends Button

var used = false

signal fire_range_increased

var fire_rate = 10

func _ready():
	get_parent().get_node("Label").text = "Damage +"+String(fire_rate)+"%"

func _pressed():
	if used == false and get_parent().get_parent().skill_points > 0:
		emit_signal("fire_range_increased",fire_rate)
		toggle_mode = true
		pressed = true
		toggle_mode = false
		used = true
