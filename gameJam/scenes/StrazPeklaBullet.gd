extends KinematicBody2D

var velocity = Vector2(0,1)
var speed = 200

var collision = null

func _physics_process(delta):
	collision = move_and_collide(velocity.normalized() * delta * speed)
	if (collision):
		if "Bogdan" in collision.collider.name:
			collision.collider.hit()
		queue_free()
