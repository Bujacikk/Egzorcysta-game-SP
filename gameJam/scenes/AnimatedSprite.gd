extends AnimatedSprite

var aim = null
var hitted = false

func _on_Bogdan_animate(motion):
	if (hitted==true):
		play("hit")
		hitted=false
	elif motion.y < 0:
		play("walk")
	elif motion.y > 0:
		play("walk")
	elif motion.x > 0:
		play("walk")
	elif motion.x < 0:
		play("walk")
	else:
		play("idle")
	if (aim=="left"):
		flip_h=true
	else:
		flip_h=false

func _on_Bogdan_hitted(hp):
	self.hitted = true


func _on_AnimatedSprite2_aim(look):
	self.aim = look
