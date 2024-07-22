class_name CustomRoom
var enemies_count: int = 0
var enemies_dead: int = 0
var doors = []
var name = ''

func _init(e_c, name, doors):
	self.enemies_count = e_c
	self.name = name
	self.doors = doors
	
func is_done():
	return self.enemies_dead == self.enemies_count

func kill_enemy():
	self.enemies_dead += 1
	if self.is_done():
		for door in doors:
			door.open()
			

########################################
func set_enemies_count(count):
	self.enemies_count = count
	
func get_enemies_ount():
	return self.enemies_count

func set_name(name):
	self.name = name
	
func get_name():
	return name

func get_doors():
	return self.doors
