extends KinematicBody2D

var max_hp = 10
var hp = 10
var default_hp = 10
var bullets = 20
var ak47_damage = 8
var default_ak47_damage = 8
var shotgun_damage = 5
var default_shotgun_damage = 5
var died = false
var shotgun_range = 0.35
var key = false
var permanent_speed = 0
var permanent_shotgun_range = 0
var permanent_damage = 0
var permanent_fire_rate = 0
var double_shot = false
var permanent_health = 0
var default_speed = 300
var default_shotgun_range = 0.35
var skilltree = false
var lava = false
var hit_timer : Timer

signal animate
signal shot_bullet
signal hitted
signal rifle
signal reload
signal can_shoot
signal shotgun_reload
signal toReload
signal heal
signal damage_change
signal range_change
signal firerate_change
signal speed_change
signal change_gun
signal change_permanent_buff
signal add_skill_point
signal key_collected

var motion = Vector2(0,0)
const UP = Vector2(0,-1)


export var SPEED = 300
export var fire_rate = 1

var toAKreload = false
var stop = false
var can_fire = true
var gun = "shotgun"
var gun_change=false
var fire_rate_buff = 1
var fire_rate_default = 1
var killed_enemies = 0
var skill_point_limit = 5
var dead_scene = preload("res://scenes/Menu/dead_screen_menu.tscn")
func _ready():
	self.fire_rate= self.fire_rate_default * self.fire_rate_buff
	self.hit_timer = Timer.new()
	self.add_child(hit_timer)
	self.hit_timer.wait_time = 1
	self.hit_timer.one_shot = true
	
func _physics_process(delta):
	move_and_slide(motion, UP)
	animate()
	skilltree()
	if (self.died!=true and self.skilltree!=true):
		move()
	else:
		$AnimatedSprite.play("idle")
		motion.x = 0
		motion.y = 0
	lava(lava)

func skilltree():
	if Input.is_action_just_pressed("skilltree"):
		if (self.died!=true):
			if (self.skilltree==true):
				self.skilltree=false
			else:
				self.skilltree=true
			if $CanvasLayer.offset == Vector2(0,0):
				$CanvasLayer.offset = Vector2(-2000,-2000)
			elif $CanvasLayer.offset == Vector2(-2000,-2000):
				$CanvasLayer.offset = Vector2(0,0)

func move():
	emit_signal("rifle",gun)
	if (Input.is_action_pressed("fire")):
		if (self.stop==false):
			if (self.gun=="shotgun") and can_fire:
				$shotgun_fire.play()
				var bullet = load("res://scenes/bullet.tscn").instance()
				var bullet2 = load("res://scenes/bullet.tscn").instance()
				var bullet3 = load("res://scenes/bullet.tscn").instance()
				bullet.position = $AnimatedSprite/AnimatedSprite2.global_position
				bullet2.position = $AnimatedSprite/AnimatedSprite2.global_position
				bullet3.position = $AnimatedSprite/AnimatedSprite2.global_position
				
				bullet.damage = self.shotgun_damage
				bullet2.damage = self.shotgun_damage
				bullet3.damage = self.shotgun_damage
				
				bullet.shoot_range = self.shotgun_range
				bullet2.shoot_range = self.shotgun_range
				bullet3.shoot_range = self.shotgun_range
				
				bullet.velocity= get_global_mouse_position() - bullet.position 
				bullet2.velocity= get_global_mouse_position()  - bullet.position
				bullet3.velocity= get_global_mouse_position()  - bullet.position
				
				bullet2.velocity= bullet2.velocity.rotated(deg2rad(10))
				bullet3.velocity= bullet2.velocity.rotated(deg2rad(340))
				
				bullet.destroy=true
				bullet2.destroy=true
				bullet3.destroy=true
				
				get_tree().get_root().add_child(bullet)
				get_tree().get_root().add_child(bullet2)
				get_tree().get_root().add_child(bullet3)
				
				can_fire = false
				
				
				emit_signal("shotgun_reload")
				$shotgun_reload.play()
				yield(get_tree().create_timer(fire_rate), "timeout")
				$shotgun_reload.playing = false
				$shotgun_fire.playing = false
				can_fire = true
			if (self.gun=="ak47") and can_fire:
				if (self.bullets!=0):
					var bullet = load("res://scenes/bullet.tscn").instance()
					bullet.position = $AnimatedSprite/AnimatedSprite2.global_position
					bullet.velocity= get_global_mouse_position() - bullet.position
					bullet.damage = self.ak47_damage
					get_tree().get_root().add_child(bullet)
					self.bullets-=1
					emit_signal("change_gun","AK47",self.bullets)
					can_fire = false
					$ak47_fire.play()
					yield(get_tree().create_timer(fire_rate), "timeout")
					$ak47_fire.playing = false
					can_fire = true
			
	if Input.is_action_pressed("left") and Input.is_action_pressed("right"):
		motion.x = 0
		motion.y = 0
	elif Input.is_action_pressed("up") and Input.is_action_pressed("down"):
		motion.x = 0
		motion.y = 0
	elif Input.is_action_pressed("left") and Input.is_action_pressed("up"):
		motion.x = -SPEED*0.7
		motion.y = -SPEED*0.7
	elif Input.is_action_pressed("left") and Input.is_action_pressed("down"):
		motion.x = -SPEED*0.7
		motion.y = +SPEED*0.7
	elif Input.is_action_pressed("right") and Input.is_action_pressed("up"):
		motion.x = +SPEED*0.7
		motion.y = -SPEED*0.7
	elif Input.is_action_pressed("right") and Input.is_action_pressed("down"):
		motion.x = +SPEED*0.7
		motion.y = +SPEED*0.7
	elif Input.is_action_pressed("left"):
		motion.x = -SPEED
		motion.y = 0
	elif Input.is_action_pressed("right"):
		motion.x = SPEED
		motion.y = 0
	elif Input.is_action_pressed("up"):
		motion.y = -SPEED
		motion.x = 0
	elif Input.is_action_pressed("down"):
		motion.y = SPEED
		motion.x = 0
	else:
		motion.x = 0
		motion.y = 0
	
	if Input.is_action_pressed("shotgun"):
		if (self.stop==false):
			self.fire_rate_default = 1
			self.fire_rate= self.fire_rate_default * self.fire_rate_buff
			self.gun="shotgun"
			emit_signal("change_gun","shotgun",0)
	elif Input.is_action_pressed("ak47"):
		if (self.stop==false):
			self.fire_rate_default = 0.25
			self.fire_rate= self.fire_rate_default * self.fire_rate_buff
			self.gun="ak47"
			emit_signal("change_gun","AK47",self.bullets)
			if (self.toAKreload==true):
				emit_signal("rifle",gun)
				self.stop=true
				yield(get_tree().create_timer(1.3), "timeout")
				self.stop = false

func animate():
	emit_signal("animate", motion)

func cigarettes():
	self.shotgun_damage = default_shotgun_damage * 2 + default_shotgun_damage * permanent_damage
	self.ak47_damage = default_ak47_damage * 2 + default_ak47_damage * permanent_damage
	emit_signal("damage_change",100)
	yield(get_tree().create_timer(5), "timeout")
	self.ak47_damage = default_ak47_damage + default_ak47_damage * permanent_damage
	self.shotgun_damage = default_shotgun_damage + default_shotgun_damage * permanent_damage
	emit_signal("damage_change",-100)

func ammoAK47():
	if (self.bullets!=20):
		if self.gun=="ak47":
			self.stop = true
			emit_signal("reload")
			self.bullets=20
			yield(get_tree().create_timer(1.3), "timeout")
			self.stop = false
			emit_signal("change_gun","AK47",self.bullets)
			emit_signal("can_shoot")
		else:
			self.bullets=20
			self.toAKreload=true
			emit_signal("toReload")

func ammoShotgun():
	self.shotgun_range = default_shotgun_range * 2 + default_shotgun_range * permanent_shotgun_range
	emit_signal("range_change",100)
	yield(get_tree().create_timer(5), "timeout")
	emit_signal("range_change",-100)
	self.shotgun_range = default_shotgun_range + default_shotgun_range * permanent_shotgun_range

func vodka():
	self.hp = max_hp
	emit_signal("heal",hp)

func shot():
	if (self.hp!=max_hp):
		self.hp +=1
	emit_signal("heal",hp)
	

func beer():
	var buff = self.SPEED*0.3
	self.SPEED = default_speed + buff + default_speed*permanent_speed
	emit_signal("speed_change",30)
	yield(get_tree().create_timer(5), "timeout")
	emit_signal("speed_change",-30)
	self.SPEED = default_speed + default_speed*permanent_speed

func pizza():
	if (self.hp<=max_hp and self.hp>=max_hp-3):
		self.hp=max_hp
	else:
		self.hp+=3
	emit_signal("heal",hp)

func siberka():
	self.fire_rate_buff -= 0.5 
	self.fire_rate= self.fire_rate_default * self.fire_rate_buff - fire_rate_default*permanent_fire_rate
	emit_signal("firerate_change",50)
	yield(get_tree().create_timer(5), "timeout")
	self.fire_rate_buff += 0.5
	emit_signal("firerate_change",-50)
	self.fire_rate= self.fire_rate_default * self.fire_rate_buff - fire_rate_default*permanent_fire_rate

func kulo():
	self.fire_rate_buff += 0.5
	self.fire_rate= self.fire_rate_default * self.fire_rate_buff - fire_rate_default*permanent_fire_rate
	emit_signal("firerate_change",-50)
	yield(get_tree().create_timer(5), "timeout")
	self.fire_rate_buff -= 0.5
	emit_signal("firerate_change",50)
	self.fire_rate= self.fire_rate_default * self.fire_rate_buff - fire_rate_default*permanent_fire_rate

func hit(damage = 1):
	if hp > 0:
		self.hp -= damage
		print("HP ", self.hp)
		emit_signal("hitted",hp)
		$AnimatedSprite.play("hit")
		var random_number = int(rand_range(0, 6))
		print_debug(random_number)
		if self.hp <= 0:
			self.die()
		if random_number == 1:
			$hit1.play()
			yield(get_tree().create_timer(0.5), "timeout")
			$hit1.playing = false
		elif random_number == 2:
			$hit2.play()
			yield(get_tree().create_timer(0.5), "timeout")
			$hit2.playing = false
				

func lava(inLava=false):
	if (inLava==true):
		if self.hit_timer.is_stopped():
			self.hit(1)
			self.hit_timer.start()

func die():
	var random_die = int(rand_range(1, 3))
	self.died = true
	if random_die == 1:
		$die1.play()
		yield(get_tree().create_timer(2), "timeout")
		$die1.playing = false
		$DeadMenu.offset = Vector2(0,0)
	elif random_die == 2:
		$die2.play()
		yield(get_tree().create_timer(2), "timeout")
		$die2.playing = false
		$DeadMenu.offset = Vector2(0,0)
	elif random_die == 3:
		$die3.play()
		yield(get_tree().create_timer(2), "timeout")
		$die3.playing = false
		$DeadMenu.offset = Vector2(0,0)

func isDead():
	if self.died==true:
		return true

func _on_AnimatedSprite2_can_fire_again():
	self.can_fire=true


func _on_CanvasLayer_stats_updated(permanent_damage,permanent_speed,permanent_shotgun_range,permanent_fire_rate,permanent_health,double_shot):
	shotgun_damage = default_shotgun_damage*(permanent_damage/100+1)
	self.permanent_damage = permanent_damage/100
	SPEED = default_speed*(permanent_speed/100+1)
	self.permanent_speed = permanent_speed/100
	fire_rate = fire_rate_default - fire_rate_default*(permanent_fire_rate/100)
	self.permanent_fire_rate = permanent_fire_rate/100
	shotgun_range = shotgun_range*(permanent_shotgun_range/100+1)
	self.permanent_shotgun_range = permanent_shotgun_range/100
	max_hp = default_hp+permanent_health
	emit_signal("change_permanent_buff",permanent_damage,permanent_speed,permanent_shotgun_range,permanent_fire_rate,permanent_health,double_shot)

func getPosition():
	return $AnimatedSprite.global_position

func key():
	self.key = true
	emit_signal("key_collected")
	
func has_key():
	return self.key
	
func count_enemies_killed():
	killed_enemies +=1
	if killed_enemies >= skill_point_limit:
		skill_point_limit = skill_point_limit*2 + 5
		emit_signal("add_skill_point")
	
