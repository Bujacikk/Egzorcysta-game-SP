extends Node2D

onready var camera = $Camera2D
onready var player = $YSort/Bogdan

var target = null

func _ready():
	
	target = player
	
	for iteration in get_tree().get_nodes_in_group("cluster_of_pentagrams"):
		iteration.connect("capture", self, "set_camera")
		iteration.connect("release", self, "release_camera")
	
func _process(delta):
	camera.set_position(target.get_position())
	

func set_camera(cluster_of_pentagrams):
	target = cluster_of_pentagrams

func release_camera():
	target = player

