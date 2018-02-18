extends Node2D

export(AudioStream) var sound1
export(AudioStream) var sound2
export(AudioStream) var sound3
export (AudioStream)var sound4
export(AudioStream) var sound5
export (AudioStream)var sound6

onready var sounds=[sound1,sound2,sound3,sound4,sound5,sound6]

onready var timer=$Step_timer
var can_step=true

var sound_players=[]
func _ready():
	timer.one_shot=true
	timer.connect("timeout",self,'on_timeout')
	for i in range(len(sounds)):
		var player=AudioStreamPlayer2D.new()
		player.stream=sounds[i]
		player.volume_db=0
		add_child(player)
		sound_players.append(player)

func on_timeout():
	can_step=true

func play(index):
	if can_step:
		can_step=false
		timer.start()
		sound_players[index].play()
