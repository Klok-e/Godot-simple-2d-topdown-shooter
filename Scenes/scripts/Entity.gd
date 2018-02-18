extends KinematicBody2D

onready var hp=1
onready var speed=0
onready var direction=Vector2(0,1)

func add_force(impulse):
	var vect=direction*speed
	vect+=impulse
	speed=vect.length()
	if speed!=0:
		direction=vect/speed
		
func get_damage(amount,dealer_pos,blow_powah):
	hp-=amount
	add_force((position-dealer_pos)*blow_powah)
	