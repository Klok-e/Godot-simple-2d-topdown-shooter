extends AudioStreamPlayer

func _process(delta):
	if not playing:
		play()