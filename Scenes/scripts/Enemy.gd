extends 'Entity.gd'

const SPEED_INCREASE=60
const FRICTION=0.14
const ATTACK_BLOW=20
const DAMAGE=0.1

var dead_scene=preload("res://Scenes/DeadEnemy.tscn")

onready var animator=$AnimationPlayer
onready var player=get_node('..//Player')
onready var death_timer=Timer.new()
var dead=false

var time_passed_from_death=0

func _on_ready():
	death_timer.one_shot=true
	death_timer.wait_time=5
	death_timer.connect('timeout',self,'delete')

func die():
	dead=true
	speed=0
	animator.play('death anim')
	death_timer.start()
	
func delete():
	var replacement=dead_scene.instance()
	replacement.transform=transform
	get_parent().add_child(replacement)
	queue_free()

func _process(delta):
	if not dead:
		if not animator.is_playing():
			animator.play('enemy_anim')
		if hp<0:
			die()

func _physics_process(delta):
	if not dead:
		var move=(player.position-position).normalized()
		
		# move it
		add_force(move*SPEED_INCREASE)
		# apply friction force
		add_force(-direction*speed*FRICTION)
		
		var angle=Vector2(cos(get_rotation()),sin(get_rotation())).angle_to(move)+deg2rad(90)
		rotate(lerp(0,angle,0.25))
		
		move_and_slide(direction*speed)
