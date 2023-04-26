const TILE_SRC = "res://src/tile.gd"

enum PAWN_CLASSES {Dante, Virgil, Angel, Priest, Slime_small, Slime_smallCPT, Eyeball_Demon}
enum PAWN_STRATEGIES {Tank, Flank, Support}
const Dante_model = "res://assets/sprites/characters/characterModel.escn"
const Virgil_model = "res://assets/sprites/characters/characterModel.escn"
const Angel_model = "res://assets/sprites/characters/characterModel.escn"
const Priest_model = "res://assets/sprites/characters/characterModel.escn"
const slime_big_model = "res://assets/sprites/characters/slimeModel.escn"
const Slime_small_model = "res://assets/sprites/characters/slimeModel.escn"
const Eyeball_Demon_model = "res://assets/sprites/characters/belenModel.escn"


static func convert_tiles_into_static_bodies(tiles_obj):


	for t in tiles_obj.get_children():
		t.create_trimesh_collision()
		var static_body = t.get_child(0)
		static_body.set_position(t.get_position())
		t.set_position(Vector3.ZERO)
		t.set_name("Tile")
		t.remove_child(static_body)
		tiles_obj.remove_child(t)
		static_body.add_child(t)
		static_body.set_script(load(TILE_SRC))
		static_body.configure_tile()
		static_body.set_process(true)
		tiles_obj.add_child(static_body)


static func create_material(color, texture=null, shaded_mode=0):
	var material = StandardMaterial3D.new()
	material.flags_transparent = true
	material.albedo_color = Color(color)
	material.albedo_texture = texture
	material.shading_mode = shaded_mode
	return material


static func get_pawn_sprite(pawn_class):
	match pawn_class:
		0: return load(Dante_model)
		1: return load(Virgil_model)
		2: return load(Angel_model)
		3: return load(Priest_model)
		4: return load(Slime_small_model)
		5: return load(slime_big_model)
		6: return load(Eyeball_Demon_model)
	

static func get_pawn_move_radious(pawn_class):
	match pawn_class:
		0: return 3
		1: return 5
		2: return 4
		3: return 4
		4: return 5
		5: return 3
		6: return 4


static func get_pawn_jump_height(pawn_class):
	match pawn_class:
		0: return 0.5
		1: return 3
		2: return 1
		3: return 1
		4: return 3
		5: return 0.5
		6: return 1


static func get_pawn_attack_radious(pawn_class):
	match pawn_class:
		0: return 1
		1: return 6
		2: return 3
		3: return 3
		4: return 6
		5: return 1
		6: return 3


static func get_pawn_attack_power(pawn_class):
	match pawn_class:
		0: return 20
		1: return 10
		2: return 12
		3: return 12
		4: return 10
		5: return 20
		6: return 12


static func get_pawn_health(pawn_class):
	match pawn_class:
		0: return 50
		1: return 35
		2: return 30
		3: return 25
		4: return 35
		5: return 50
		6: return 30


static func vector_remove_y(vector):
	return vector*Vector3(1,0,1)


static func vector_distance_without_y(b, a):
	return vector_remove_y(b).distance_to(vector_remove_y(a))
