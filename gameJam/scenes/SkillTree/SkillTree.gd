extends CanvasLayer

var permanent_speed = 0
var permanent_shotgun_range = 0
var permanent_damage = 0
var permanent_fire_rate = 0
var double_shot = false
var permanent_health = 0
var skill_points = 1

signal stats_updated
func _ready():
	$SkillPoints.text = "Skill Points: " + String(skill_points)
	update_text()
func update_player_stats():
	$SkillPoints.text = "Skill Points: " + String(skill_points)
	emit_signal("stats_updated",permanent_damage,permanent_speed,permanent_shotgun_range,permanent_fire_rate,permanent_health,double_shot)
func update_text():
	if skill_points > 0 :
		get_parent().get_node("health_bar").get_node("SkillPoints").visible = true
	elif skill_points == 0:
		get_parent().get_node("health_bar").get_node("SkillPoints").visible = false

func _on_Button_damage_increased(damage):
	permanent_damage += damage
	skill_points -= 1
	update_player_stats()
	update_text()

func _on_Button2_double_shot_enabled(double_shot_enabled):
	double_shot = double_shot_enabled
	skill_points -= 1
	update_player_stats()
	update_text()

func _on_Button3_fire_range_increased(shotgun_range):
	permanent_shotgun_range += shotgun_range
	skill_points -= 1
	update_player_stats()
	update_text()

func _on_Button4_speed_increased(speed):
	permanent_speed += speed
	skill_points -= 1
	update_player_stats()
	update_text()


func _on_Button5_fire_rate_increased(fire_rate):
	permanent_fire_rate += fire_rate
	skill_points -= 1
	update_player_stats()
	update_text()


func _on_Button6_health_increased(health):
	permanent_health += health
	skill_points -= 1
	update_player_stats()
	update_text()

func _on_Bogdan_add_skill_point():
	skill_points += 1 
	update_text()
	update_player_stats()
