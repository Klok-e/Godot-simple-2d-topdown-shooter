extends Node

const min_spawn_dist_from_player=1000
const enemy_wave_mult=2
const time_between_waves=20

var time_from_last_wave=0
var wave=1


onready var player=get_node('Player')
onready var enemy=preload("res://Scenes/Enemy.tscn")

var spawnpoints=[]
func create_enemy(pos):
	var en=enemy.instance()
	en.position=pos
	add_child(en)
	
func create_wave(num):
	var created=0
	while created<num:
		for point in spawnpoints:
			if (point.position-player.position).length()>min_spawn_dist_from_player:
				if not point.overlaps_anything():
					create_enemy(point.position)
					created+=1
		yield()
	return

func _ready():
	for child in get_children():
		if child.is_in_group('SpawnPoints'):
			spawnpoints.append(child)
var spawner=null
func _process(delta):
	if spawner!=null and spawner.is_valid():
		spawner.resume()
	if time_from_last_wave>time_between_waves:
		spawner=create_wave(wave*enemy_wave_mult)
		time_from_last_wave=0
		wave+=1
	time_from_last_wave+=delta
