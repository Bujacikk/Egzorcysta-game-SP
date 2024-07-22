extends AnimatedSprite

var aim = null

func _ready():
	play("walk")

func _process(delta):
	if (aim=="left"):
		flip_h=true
	else:
		flip_h=false


func _on_AnimatedSprite2_aim(look):
	self.aim = look
