extends KinematicBody2D

var WALK_SPEED = 50

var hp = 10
var hit_timer : Timer
onready var bogdan = get_parent().get_node("YSort/Bogdan")
var can_move = false

signal dead


func _ready():
	self.hit_timer = Timer.new()
	self.add_child(hit_timer)
	self.hit_timer.wait_time = 1
	self.hit_timer.one_shot = true


func _physics_process(delta):
	if bogdan and can_move:
		var direction = (bogdan.position - position).normalized()
		if (bogdan.isDead()!=true):
			move_and_slide(direction * WALK_SPEED)
		if (self.hp<=0):
			self.WALK_SPEED = 0
		for i in get_slide_count():
			if i:
				var collision = get_slide_collision(i)
				if "Bogdan" in collision.collider.name and self.hit_timer.is_stopped() and self.hp > 0:
					collision.collider.hit(1)
					self.hit_timer.start()


func shoot(damage):
	if self.hp > 0:
		self.hp -= damage
		if self.hp <= 0:
			$AnimatedSprite.play("death")
			yield($AnimatedSprite, "animation_finished")
			emit_signal("dead")
			queue_free()
		else:
			$AnimatedSprite.play("hit")
			yield($AnimatedSprite, "animation_finished")
			$AnimatedSprite.play("walk")
	
