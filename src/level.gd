extends Node3D
class_name LevelClass

var t_from = null
var t_to = null
var curr_t = null
var player : PlayerControllerClass = null
var enemy : EnemyControllerClass
var World : WorldClass
var camera : CameraClass
var ui_control : PlayerControllerClassUI


func _ready():
	player = $Player
	enemy = $Enemy
	World = $World
	camera = $CameraClass
	ui_control = $PlayerControllerUI
	player.configure(World, camera, ui_control)
	enemy.configure(World, camera)


func turn_handler(delta):
	if player.can_act() : player.act(delta)
	elif enemy.can_act() : enemy.act(delta)
	else:
		player.reset()
		enemy.reset()


func _physics_process(delta):
	turn_handler(delta)

