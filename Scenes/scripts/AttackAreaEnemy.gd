extends Area2D

onready var p=get_parent()

func _ready():
	connect("body_entered",self,'on_enter')

func on_enter(object):
	if object.is_in_group('Players'):
		object.get_damage(p.DAMAGE,p.position,p.ATTACK_BLOW)