extends AnimatedSprite

onready var bogdan = null

signal aim


func _ready():
	bogdan = get_parent().get_parent().get_node("YSort/Bogdan")

func _process(delta):
	var mouse = bogdan.position
	if (mouse!=null):
		look_at(bogdan.position)
		if mouse.x > get_parent().position.x:
			emit_signal("aim","right")
			flip_v=false
		else:
			emit_signal("aim","left")
			flip_v=true
