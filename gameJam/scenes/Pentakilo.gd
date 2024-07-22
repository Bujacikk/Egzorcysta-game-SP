extends KinematicBody2D

signal killed

var WALK_SPEED = 150

var hp = 10
var hit_timer : Timer
onready var bogdan = get_parent().get_node("YSort/Bogdan")

var can_move = false
var deelay = false
var jumped = false

var direction = Vector2(rand_range(250, -250),rand_range(250, -250)).normalized()

func _ready():
	self.hit_timer = Timer.new()
	self.add_child(hit_timer)
	self.hit_timer.wait_time = 1
	self.hit_timer.one_shot = true


func _physics_process(delta):
	if bogdan and can_move:
		if (deelay==false and bogdan.isDead()!=true):
			self.WALK_SPEED = 150
			$AnimatedSprite.play("walk")
			direction = Vector2(rand_range(250, -250),rand_range(250, -250)).normalized()
			deelay=true
			random_direction()
		if (bogdan.isDead()!=true):
			move_and_slide(direction * WALK_SPEED)
		if (bogdan.isDead()):
			$AnimatedSprite.play("walk")
		for i in get_slide_count():
			if i:
				var collision = get_slide_collision(i)
				if "Bogdan" in collision.collider.name and self.hit_timer.is_stopped() and self.hp > 0:
					collision.collider.hit(2)
					self.hit_timer.start()

func random_direction():
	yield(get_tree().create_timer(0.5), "timeout")
	self.WALK_SPEED = 3
	if bogdan.position.x > self.position.x:
		$AnimatedSprite.flip_h=false
	else:
		$AnimatedSprite.flip_h=true
	self.jumped = true
	$AnimatedSprite.play("jump")
	self.direction = bogdan.getPosition() - $AnimatedSprite.global_position
	yield(get_tree().create_timer(1), "timeout")
	deelay=false
	self.jumped=false

func shoot(damage):
	if self.hp > 0:
		self.hp -= damage
		if self.hp <= 0:
			$AnimatedSprite.play("death")
			self.can_move = false
			$pentakill_died.play()
			yield(get_tree().create_timer(3),"timeout")
			emit_signal("killed")
			$pentakill_died.playing = false
		else:
			$AnimatedSprite.play("hit")
			yield($AnimatedSprite, "animation_finished")
			if self.can_move and self.jumped==false:
				$AnimatedSprite.play("walk")
			elif self.can_move and self.jumped==true:
				$AnimatedSprite.play("jump")
