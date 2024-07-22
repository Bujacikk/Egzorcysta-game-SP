extends KinematicBody2D

var WALK_SPEED = 50

var deelay = false
var fire = false
#50 hp deault
var hp = 5
var hit_timer : Timer
onready var bogdan = get_parent().get_node("YSort/Bogdan")

var can_move = false

var direction = Vector2(rand_range(250, -250),rand_range(250, -250)).normalized()

signal dead

func _ready():
	self.hit_timer = Timer.new()
	self.add_child(hit_timer)
	self.hit_timer.wait_time = 1
	self.hit_timer.one_shot = true


func _physics_process(delta):
	if bogdan and can_move:
		if (deelay==false):
			direction = Vector2(rand_range(250, -250),rand_range(250, -250)).normalized()
			deelay=true
			random_direction()
		if (bogdan.isDead()!=true):
			move_and_slide(direction * WALK_SPEED)
		if (self.hp<=0):
			self.WALK_SPEED = 0
		if (fire==false):
			if (bogdan.isDead()!=true):
				#bogdan = get_parent().get_node("YSort/Bogdan")
				var bullet = load("res://scenes/StrazPeklaBullet.tscn").instance()
				bullet.position = $AnimatedSprite2.global_position
				bullet.velocity= bogdan.get_node("AnimatedSprite").global_position - bullet.position
				bullet.look_at(bogdan.get_node("AnimatedSprite").global_position)
				get_tree().get_root().add_child(bullet)
			fire=true
			fire()
		for i in get_slide_count():
			if i:
				var collision = get_slide_collision(i)
				if "Bogdan" in collision.collider.name and self.hit_timer.is_stopped() and self.hp > 0:
					collision.collider.hit(1)
					self.hit_timer.start()
					
					

func random_direction():
	yield(get_tree().create_timer(3), "timeout")
	deelay=false

func shoot(damage):
	if self.hp > 0:
		self.hp -= damage
		if self.hp <= 0:
			emit_signal("dead")
			$AnimatedSprite.play("death")
			$AnimatedSprite2.hide()
			yield($AnimatedSprite, "animation_finished")
			queue_free()
		else:
			$AnimatedSprite.play("hit")
			yield($AnimatedSprite, "animation_finished")
			$AnimatedSprite.play("walk")
	
func fire():
	yield(get_tree().create_timer(1), "timeout")
	if (bogdan.isDead()!=true):
		fire = false





