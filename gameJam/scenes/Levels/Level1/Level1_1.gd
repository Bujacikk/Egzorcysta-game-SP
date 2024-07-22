extends Node2D

signal boss_killed

onready var camera = $Camera2D
onready var player = $YSort/Bogdan

var target = null
var rooms = []
var actual_room: CustomRoom
var scene = preload("res://scenes/Levels/Level1/Level1_2.tscn").instance()

var this = null
var video_scene = load("res://scenes/penta_killo_scene.tscn").instance()
var bogdan = null

const MAIN_ROOM_NAME = "2_2"
const ROOMS = [
	{"name": "2_2", "enemies": 2 , "doors": ["Right_base_door-2_3", "Left_base_door-2_1", "Bottom_base_door-3_2"]},
	{"name": "1_1", "enemies": 1, "doors": []},
	{"name": "2_1", "enemies": 3, "doors": ["Right_base_door-2_2", "Top_Boss_door-1_1"]},
	{"name": "2_3", "enemies": 5, "doors": ["Left_base_door-2_2", "Bottom_base_door-3_3"]},
	{"name": "3_2", "enemies": 1, "doors": ["Top_base_door-2_2", "Bottom_base_door-4_2", "Right_base_door-3_3"]},
	{"name": "3_3", "enemies": 3, "doors": ["Left_base_door-3_2", "Top_base_door-2_3", "Right_base_door-3_4"]},
	{"name": "3_4", "enemies": 4, "doors": ["Left_base_door-3_3"]},
	{"name": "4_1", "enemies": 0, "doors": []},
	{"name": "4_2", "enemies": 2, "doors": ["Top_base_door-3_2", "Bottom_base_door-5_2"]},
	{"name": "5_2", "enemies": 1, "doors": ["Top_base_door-4_2"]}
]

func _ready():
	self.room_builder()
	self.start_enemies()
	self.on_boss_killed()
	
	target = player
	
	for iteration in get_tree().get_nodes_in_group("cluster_of_pentagrams"):
		iteration.connect("capture", self, "set_camera")
		iteration.connect("release", self, "release_camera")

func set_camera(cluster_of_pentagrams):
	target = cluster_of_pentagrams
	camera.set_position(target.get_position())
	
	
func release_camera():
	target = player

func _on_enemy_dead():
	actual_room.kill_enemy()
	player.count_enemies_killed()
	print_debug(actual_room.enemies_dead,actual_room.enemies_count)
	if actual_room.enemies_dead == actual_room.enemies_count:
		$room_clear_1.play()
		yield(get_tree().create_timer(1.2),"timeout")
		$room_clear_1.playing=false

func room_builder():
	for r in ROOMS:
		var room = CustomRoom.new(r.enemies, r.name, self.get_doors(r.doors))
		self.rooms.append(room)
		if r.name == MAIN_ROOM_NAME:
			self.actual_room = room
	self.build_doors_targets()
	
func get_doors(names):
	var arr = []
	var nodes = self.get_children()
	
	for node in nodes:
		for name in names:
			if name == node.name and not node in arr:
				arr.append(node)
				node.connect("player_ported", self, "handle_player_ported")
	
	return arr
	
func handle_player_ported(target: CustomRoom):
	self.actual_room = target
	if actual_room.name == "1_1":
		self.play_scene()
	else:
		self.start_enemies()
	
func build_doors_targets():
	for room in self.rooms:
		for door in room.get_doors():
			var target_name = door.name.split("-")[1]
			for r in self.rooms:
				if target_name == r.name and not door.target:
					door.target = r

func start_enemies():
	var enemies = get_tree().get_nodes_in_group(self.actual_room.get_name())
	for enemy in enemies:
		enemy.can_move = true
		
func on_boss_killed():
	var nodes = self.get_children()
	for node in nodes:
		if "Pentakilo" in node.name:
			node.connect("killed", self, "handle_boss_killed")

func handle_boss_killed():
	var ysort = self.get_node("YSort")
	var nodes = ysort.get_children()
	var bogdan = null
	for node in nodes:
		print(node)
		if "Bogdan" in node.name:
			bogdan = node

	if bogdan:
		yield(get_tree().create_timer(1), "timeout")
		ysort.remove_child(bogdan)
		bogdan.position = Vector2(3130, 1470)
		bogdan.key = false
		bogdan.get_node("health_bar").get_node("Key").visible=false
		scene.get_node("Camera2D").set_position(Vector2(3130, 1470))
		scene.get_node("YSort").add_child(bogdan)
		get_tree().get_root().add_child(scene)
		get_tree().get_root().remove_child(self)
	
func play_scene():
	var nodes = get_node("YSort").get_children()
	for node in nodes:
		print(node)
		if "Bogdan" in node.name:
			bogdan = node
	bogdan.z_index = -1
	bogdan.get_node("health_bar").offset.x = -2000
	bogdan.get_node("health_bar").offset.y = -2000
	self.this = self
	get_tree().get_root().add_child(video_scene)
	video_scene.z_index = 1000
	video_scene.connect("finished", self, "handle_finished_animation")

	
func handle_finished_animation():
	self.this.get_tree().get_root().add_child(this)
	bogdan.z_index = 1
	bogdan.get_node("health_bar").offset.x = 0
	bogdan.get_node("health_bar").offset.y = 0
	self.start_enemies()
	self.this.get_tree().get_root().remove_child(video_scene)
