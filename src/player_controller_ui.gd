extends Control
class_name TacticsPlayerControllerUI


@onready var layout_xbox
@onready var layout_pc 
var is_joystick = false


func _process(_delta):
	if is_joystick: $HBox/VBox/ControllerHints.texture = layout_xbox
	else: $HBox/VBox/ControllerHints.texture = layout_pc

func get_act(action : String = ""):
	if action == "": return $HBox/Actions
	return $HBox/Actions.get_node(action)


func is_mouse_hover_button():
	if $HBox/Actions.visible:
		for action in $HBox/Actions.get_children():
			if action.get_global_rect().has_point(get_viewport().get_mouse_position()): 
				return true
	return false


func set_visibility_of_actions_menu(v, p):
	if !$HBox/Actions.visible: $HBox/Actions/Move.grab_focus()
	$HBox/Actions.visible = v
	if !p : return
	$HBox/Actions/Move.disabled = !p.can_move
	$HBox/Actions/Attack.disabled = !p.can_attack
