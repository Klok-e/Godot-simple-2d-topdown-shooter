extends 'Entity.gd'

const ATTACK_BLOW=20
const DAMAGE=0.4
const SPEED_INCREASE=80
const FRICTION=0.14

export var undead=false

var bullet_scene=preload("res://Scenes/Bullet.tscn")
onready var game=get_parent()

onready var animator=$AnimationPlayer
onready var handgun_sound=$Handgun
onready var steps_sound=$StepsManager
onready var shoot_timer=$Shoot_timer

var step_count

var move=Vector2(0,0)
var dead=false

var can_shoot=true

func _ready():
	step_count=len(steps_sound.sounds)
	shoot_timer.one_shot=true
	shoot_timer.connect('timeout',self,'on_timeout')
	
func on_timeout():
	can_shoot=true
	
func spawn_bullet():
	var vct=get_global_mouse_position()-get_position()
	var bullet=bullet_scene.instance()
	bullet.initialize(DAMAGE,
		vct.normalized().rotated(rand_range(deg2rad(-5),deg2rad(5))),
		position,ATTACK_BLOW,speed*direction)
	game.add_child(bullet)
	handgun_sound.play()
	
func _process(delta):
	if animator.is_playing() == false:
		animator.play('run')
	if hp<0 and not undead:
		dead=true
	if not dead:
		if Input.is_action_pressed('attack'):
			if can_shoot:
				spawn_bullet()
				shoot_timer.start()
				can_shoot=false
			
		var horizontal=0
		if Input.is_action_pressed('ui_right'):
			horizontal=1
		elif Input.is_action_pressed('ui_left'):
			horizontal=-1
		var vertical=0
		if Input.is_action_pressed('ui_up'):
			vertical=-1
		elif Input.is_action_pressed('ui_down'):
			vertical=1
		move=Vector2(horizontal,vertical).normalized()
		if speed>SPEED_INCREASE*0.6:
			steps_sound.play(randi()%step_count)
			

func _physics_process(delta):
	if not dead:
		# move it
		add_force(move*SPEED_INCREASE)
		# apply friction force
		add_force(-direction*speed*FRICTION)
		
		var vct=get_global_mouse_position()-get_position()
		var angle=Vector2(cos(get_rotation()),sin(get_rotation())).angle_to(vct)+deg2rad(90)
		rotate(lerp(0,angle,0.25))
		
		move_and_slide(direction*speed)
		