extends Node3D
class_name PlayerControllerClass

var thisPawn = null
var targetPawn = null

var wait_time = 0

var is_joystick = false

var World : World = null
var gameCamera : CameraClass = null


var stage = 0

var ui_control : PlayerControllerClassUI = null


func configure(my_World : World, my_camera : CameraClass, my_control : PlayerControllerClassUI):
	World = my_World
	gameCamera = my_camera
	ui_control = my_control
	gameCamera.target = get_children().front()

	ui_control.get_act("Move").connect("pressed",Callable(self,"player_wants_to_move"))
	ui_control.get_act("Wait").connect("pressed",Callable(self,"player_wants_to_wait"))
	ui_control.get_act("Cancel").connect("pressed",Callable(self,"player_wants_to_cancel"))
	ui_control.get_act("Attack").connect("pressed",Callable(self,"player_wants_to_attack"))


func get_mouse_over_object(lmask):
	if ui_control.is_mouse_hover_button(): return
	var camera = get_viewport().get_camera_3d()
	var origin = get_viewport().get_mouse_position() if !is_joystick else get_viewport().size/2
	var from = camera.project_ray_origin(origin)
	var to = from + camera.project_ray_normal(origin)*1000000
	var ray_query = PhysicsRayQueryParameters3D.create(from, to, lmask, [])
	return get_world_3d().direct_space_state.intersect_ray(ray_query).get("collider")


func can_act():

	for pawn in get_children(): 
		if pawn.can_act(): return true 
	return stage > 0


func reset():
	for pawn in get_children(): 
		pawn.reset()



func player_wants_to_move(): stage = 2
func player_wants_to_cancel(): stage = 1 if stage > 1 else 0
func player_wants_to_wait(): 
	thisPawn.do_wait()
	stage = 0
func player_wants_to_attack(): stage = 5


func _aux_select_pawn():
	var pawn = get_mouse_over_object(2)
	var tile = get_mouse_over_object(1) if !pawn else pawn.get_tile()
	World.hoverMark(tile)
	return pawn if pawn else tile.get_object_above() if tile else null

func _aux_select_tile():
	var pawn = get_mouse_over_object(2)
	var tile = get_mouse_over_object(1) if !pawn else pawn.get_tile()
	World.hoverMark(tile)
	return tile

func select_pawn():
	World.reset()
	if thisPawn: thisPawn.display_pawn_stats(false)
	thisPawn = _aux_select_pawn()
	if !thisPawn : return
	thisPawn.display_pawn_stats(true)
	if Input.is_action_just_pressed("ui_accept") and thisPawn.can_act() and thisPawn in get_children():
		gameCamera.target = thisPawn
		stage = 1

func display_available_actions_for_pawn():
	thisPawn.display_pawn_stats(true)
	World.reset()
	World.hoverMark(thisPawn.get_tile())

func display_available_movements():
	World.reset()
	if !thisPawn: return
	gameCamera.target = thisPawn
	World.tileLink(thisPawn.get_tile(), thisPawn.jump_height, get_children())
	World.reachableTiles(thisPawn.get_tile(), thisPawn.move_radious)
	stage = 3

func display_attackable_targets():
	World.reset()
	if !thisPawn: return
	gameCamera.target = thisPawn
	World.tileLink(thisPawn.get_tile(), thisPawn.attack_radious)
	World.attackableTiles(thisPawn.get_tile(), thisPawn.attack_radious)
	stage = 6

func select_new_location():
	var tile = get_mouse_over_object(1)
	World.hoverMark(tile) 
	if Input.is_action_just_pressed("ui_accept"):
		if tile and tile.reachable:
			thisPawn.pathList = World.pathGen(tile)
			gameCamera.target = tile
			stage = 4

func select_pawn_to_attack():
	thisPawn.display_pawn_stats(true)
	if targetPawn: targetPawn.display_pawn_stats(false)
	var tile = _aux_select_tile()
	targetPawn = tile.get_object_above() if tile else null
	if targetPawn: targetPawn.display_pawn_stats(true)
	if Input.is_action_just_pressed("ui_accept") and tile and tile.attackable:
		gameCamera.target = targetPawn
		stage = 7

func move_pawn():
	thisPawn.display_pawn_stats(false)
	if thisPawn.pathList.is_empty(): 
		stage = 0 if !thisPawn.can_act() else 1

func attack_pawn(delta):
	if !targetPawn: thisPawn.can_attack = false
	else:
		if !thisPawn.do_attack(targetPawn, delta): return
		targetPawn.display_pawn_stats(false)
		gameCamera.target = thisPawn
	targetPawn = null
	stage = 0 if !thisPawn.can_act() else 1

func move_camera():
	var h = -Input.get_action_strength("camera_left")+Input.get_action_strength("camera_right")
	var v = Input.get_action_strength("camera_forward")-Input.get_action_strength("camera_backwards")
	gameCamera.move_camera(h, v, is_joystick)

func camera_rotation():
	if Input.is_action_just_pressed("camera_rotate_left"): gameCamera.y_rot -= 90
	if Input.is_action_just_pressed("camera_rotate_right"): gameCamera.y_rot += 90


func act(delta):
	move_camera()
	camera_rotation()
	ui_control.set_visibility_of_actions_menu(stage in [1,2,3,5,6], thisPawn)
	match stage:
		0: select_pawn()
		1: display_available_actions_for_pawn()
		2: display_available_movements()
		3: select_new_location()
		4: move_pawn()
		5: display_attackable_targets()
		6: select_pawn_to_attack()
		7: attack_pawn(delta)

func _process(_delta):
	Input.set_mouse_mode(is_joystick)
	pass

func _input(event):
	is_joystick = event is InputEventJoypadButton or event is InputEventJoypadMotion
	ui_control.is_joystick = is_joystick
