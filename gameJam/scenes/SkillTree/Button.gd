extends Button

signal damage_increased

var used = false
var damage = 10

func _ready():
	get_parent().get_node("Label").text = "Damage +"+String(damage)+"%"
func _pressed():
	if used == false and get_parent().get_parent().skill_points > 0:
		emit_signal("damage_increased",damage)
		toggle_mode = true
		pressed = true
		toggle_mode = false
		used = true
