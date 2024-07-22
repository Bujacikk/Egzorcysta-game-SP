extends AnimatedSprite


func _ready():
	look_at(get_global_mouse_position())

