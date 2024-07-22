extends KinematicBody2D

var velocity = Vector2(0,1)
var speed = 1000
var destroy = false
var damage = 20
var shoot_range = 0.35

var collision = null

func _ready():
	look_at(get_global_mouse_position())
	if (destroy==true):
		destroy()

func _physics_process(delta):
	collision = move_and_collide(velocity.normalized() * delta * speed)
	if (collision):
		if "Enemy" in collision.collider.name:
			collision.collider.shoot(damage)
		self.destroy=false
		queue_free()

func destroy():
	yield(get_tree().create_timer(shoot_range), "timeout")
	queue_free()
