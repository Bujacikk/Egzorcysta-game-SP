extends KinematicBody2D

var WALK_SPEED = 150

var hp = 100
var hit_timer : Timer
onready var bogdan = get_parent().get_node("YSort/Bogdan")

var creep_spawn = true

var can_move = false
signal killed

func _ready():
	self.hit_timer = Timer.new()
	self.add_child(hit_timer)
	self.hit_timer.wait_time = 1
	self.hit_timer.one_shot = true


func _physics_process(delta):
	if bogdan and can_move:
		var direction = (bogdan.position - position).normalized()
		
		var enemies = get_tree().get_nodes_in_group("2_1")
		if (len(enemies)==4):
			creep_spawn=false
		else:
			timer()
		if (creep_spawn==true):
			creep_spawn=false
			spawn()
		
		if not bogdan.isDead():
			move_and_slide(direction * WALK_SPEED)
			
		for i in get_slide_count():
			if i:
				var collision = get_slide_collision(i)
				if "Bogdan" in collision.collider.name and self.hit_timer.is_stopped() and self.hp > 0:
					collision.collider.hit(2)
					self.hit_timer.start()
					

func timer():
	yield(get_tree().create_timer(4), "timeout")
	creep_spawn=true

func spawn():
	var diabol = load("res://scenes/StrazPekla.tscn").instance()
	var spawn_point = get_parent().get_node("YSort").get_node("Pentagram")
	diabol.position = spawn_point.global_position
	diabol.position.x += rand_range(250, -250)
	diabol.position.y += rand_range(250, -250)
	diabol.can_move=true
	diabol.set_name("Enemy-Diabol")
	diabol.add_to_group('2_1')
	get_parent().add_child(diabol)
	yield(get_tree().create_timer(4), "timeout")
	creep_spawn=true

func shoot(damage):
	if self.hp > 0:
		self.hp -= damage
		if self.hp <= 0:
			$AnimatedSprite.play("death")
			self.can_move = false
			emit_signal("killed")
		else:
			$AnimatedSprite.play("hit")
			yield($AnimatedSprite, "animation_finished")
			if self.can_move:
				$AnimatedSprite.play("walk")
