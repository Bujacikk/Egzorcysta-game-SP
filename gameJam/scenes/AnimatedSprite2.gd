extends AnimatedSprite

signal aim

var rifle = "shotgun"
var reload = false
var shotgun_reload = false
var toReload= false

func _process(delta):
	if (get_parent().get_parent().isDead()!=true):
		if (self.rifle=="shotgun"):
			if (self.shotgun_reload==false):
				play("shotgun-idle")
			elif (self.shotgun_reload==true):
				shotgun_reloading()
		elif (self.rifle=="ak47"):
			if (self.reload == true):
				ak47_reloading()
			elif (self.reload==false and self.toReload==false):
				play("ak47-idle")
			elif self.toReload==true:
				ak47_reloading()
		var mouse = get_global_mouse_position()
		look_at(get_global_mouse_position())
		if mouse.x > get_parent().get_parent().position.x:
			emit_signal("aim","right")
			flip_v=false
		else:
			emit_signal("aim","left")
			flip_v=true

func ak47_reloading():
	play("ak47")
	look_at(get_global_mouse_position())
	yield(get_tree().create_timer(1.3), "timeout")
	self.reload = false
	if (self.toReload==true):
		self.toReload=false

func shotgun_reloading():
	play("shotgun")
	look_at(get_global_mouse_position())
	yield(get_tree().create_timer(0.4), "timeout")
	self.shotgun_reload = false

func _on_Bogdan_rifle(gun):
	self.rifle = gun


func _on_Bogdan_reload():
	self.reload = true


func _on_Bogdan_can_shoot():
	self.reload=false


func _on_Bogdan_shotgun_reload():
	self.shotgun_reload = true


func _on_Bogdan_toReload():
	toReload=true
