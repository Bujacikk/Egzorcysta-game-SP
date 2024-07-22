extends CanvasLayer
var base_health = 10
var health_points = 10
var health = [null,null,null,null,null]
var img_offset = 75
var hearth_full = preload("res://assets/Hud/hearth_full.png")
var hearth_half = preload("res://assets/Hud/hearth_half.png")
var hearth_empty = preload("res://assets/Hud/hearth_empty.png")
var speed = 0
var fire_range = 0
var fire_rate = 0
var damage = 0

var permanent_speed = 0
var permanent_shotgun_range = 0
var permanent_damage = 0
var permanent_fire_rate = 0
var double_shot = false
var permanent_health = 0

var shotgun_ammo = preload("res://assets/Bullet/shotgunAMMO.png")
var ak47_ammo = preload("res://assets/Bullet/ak47AMMO.png")

func _ready():
	$AnimatedSprite.play("idle")
	$Key.visible = false
	$Speed.text = String(speed) + "%"
	$Damage.text = String(damage) + "%"
	$FireRate.text = String(fire_rate) + "%"
	$Range.text = String(fire_range) + "%"
	for x in range((base_health + permanent_health)/2):
		health[x] = (preload("res://scenes/Hud/hearth.tscn").instance())
		health[x].rect_position.x = img_offset
		health[x].rect_position.y = 23
		img_offset += 25
		get_owner().get_node("health_bar").call_deferred("add_child",health[x])

func change_stats():
	$Speed.text = String(speed + permanent_speed) + "%"
	$Damage.text = String(damage + permanent_damage) + "%"
	$FireRate.text = String(fire_rate + permanent_fire_rate) + "%"
	$Range.text = String(fire_range + permanent_shotgun_range) + "%"
	
func change_hearths():
	for x in range(len(health),(base_health+permanent_health)/2):
		health.append(preload("res://scenes/Hud/hearth.tscn").instance())
		health[x].rect_position.y = 23
		health[x].rect_position.x = img_offset
		img_offset += 25
		health[x].texture =  hearth_empty
		get_owner().get_node("health_bar").call_deferred("add_child",health[x])
		
func _on_Bogdan_hitted(health_current):
	var a = health_points - health_current
	health_points = health_current
	var i = (base_health+permanent_health)/2-1
	print(i," ", typeof(i))
	while i > -1:
		if health[i].texture == hearth_full :
			health[i].texture = hearth_half
			a -= 1
			i += 1 
			if a == 0:
				break
		elif health[i].texture ==  hearth_half :
			health[i].texture =  hearth_empty
			a -= 1
			i += 1  
			if a == 0:
				break
		i -= 1
		
	$AnimatedSprite.play("hitted")
	yield($AnimatedSprite,"animation_finished")
	$AnimatedSprite.play("idle")



func _on_Bogdan_heal(health_current):
	var a = health_current - health_points
	health_points = health_current
	var i = 0
	while i < (base_health+permanent_health)/2:
		if health[i].texture == hearth_half :
			health[i].texture = hearth_full
			a -= 1
			i -= 1  
			if a == 0:
				break
		elif health[i].texture ==  hearth_empty :
			health[i].texture =  hearth_half
			a -= 1
			i -= 1 
			if a == 0:
				break
		i += 1
	$AnimatedSprite.play("healed")
	yield($AnimatedSprite,"animation_finished")
	$AnimatedSprite.play("idle")

func _on_Bogdan_change_gun(gun,count):
	if (gun=="AK47"):
		$Munition.text = String(count)
		$MunitionImage.texture=ak47_ammo
		$MunitionImage.rect_scale = Vector2(1,1)
	elif (gun=="shotgun"):
		$Munition.text = "--"
		$MunitionImage.texture=shotgun_ammo
		$MunitionImage.rect_scale = Vector2(1.2,1.2)

func _on_Bogdan_damage_change(damage_change):
	damage = damage + damage_change
	change_stats()

func _on_Bogdan_firerate_change(firerate_change):
	fire_rate = fire_rate + firerate_change
	change_stats()

func _on_Bogdan_range_change(range_change):
	fire_range = fire_range + range_change
	change_stats()
	
func _on_Bogdan_speed_change(speed_change):
	speed = speed + speed_change
	change_stats()


func _on_Bogdan_change_permanent_buff(permanent_damage,permanent_speed,permanent_shotgun_range,permanent_fire_rate,permanent_health,double_shot):
	self.permanent_damage = permanent_damage
	self.permanent_fire_rate = permanent_fire_rate
	self.permanent_speed = permanent_speed
	self.permanent_shotgun_range = permanent_shotgun_range
	self.permanent_health = permanent_health
	change_hearths()
	change_stats()


func _on_Bogdan_key_collected():
	$Key.visible = true
