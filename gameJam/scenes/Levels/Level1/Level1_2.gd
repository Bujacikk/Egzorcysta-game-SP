extends Node2D

signal boss_killed

onready var camera = $Camera2D
onready var player = $YSort/Bogdan

var target = null
var rooms = []
var actual_room: CustomRoom

var video_scene = preload("res://scenes/outro_scene.tscn").instance()
var main_screen = preload("res://scenes/Menu/main_screen_menu.tscn").instance()

const MAIN_ROOM_NAME = "3_5"
const ROOMS = [
	{"name": "1_4", "enemies": 3, "doors": ["Bottom_base_door-2_4"]},
	{"name": "1_5", "enemies": 0, "doors": []}, #SECRET ROOM
	{"name": "2_1", "enemies": 1, "doors": []}, #BOSS ROOM
	{"name": "2_2", "enemies": 4, "doors": ["Left_Boss_door-2_1", "Right_base_door-2_3"]},
	{"name": "2_3", "enemies": 6, "doors": ["Left_base_door-2_2", "Right_base_door-2_4", "Bottom_base_door-3_3"]},
	{"name": "2_4", "enemies": 4, "doors": ["Left_base_door-2_3", "Top_base_door-1_4", "Right_base_door-2_5"]},
	{"name": "2_5", "enemies": 4, "doors": ["Left_base_door-2_4", "Bottom_base_door-3_5"]},
	{"name": "3_3", "enemies": 1, "doors": ["Top_base_door-2_3", "Bottom_base_door-4_3"]},
	{"name": "3_5", "enemies": 5, "doors": ["Top_base_door-2_5"]},
	{"name": "4_3", "enemies": 3, "doors": ["Top_base_door-3_3"]}
]

func _ready():
	self.room_builder()
	self.start_enemies()
	self.on_boss_killed()
	camera.set_position(Vector2(3130, 1470))
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
	if self.actual_room.name == "2_1":
		$BelzedubEnter.play()
		yield(get_tree().create_timer(3),"timeout")
		$BelzedubEnter.playing = false
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
		if "Belzedup" in node.name:
			node.connect("killed", self, "handle_boss_killed")

func handle_boss_killed():
	var this = self
	get_tree().get_root().add_child(video_scene)
	get_tree().get_root().remove_child(self)
	
