const TILE_SRC = "res://src/tile.gd"

enum PAWN_CLASSES {Philosopher, Poet, priest, scientist, SlimeBg, SlimeSm, Demon}
enum PAWN_STRATEGIES {Tank, Flank, Support}
const Philosopher_Sprite = "res://assets/sprites/characters/chr_pawn_placeholder.png"
const Poet_Sprite = "res://assets/sprites/characters/chr_pawn_placeholder.png"
const Priest_Sprite = "res://assets/sprites/characters/chr_pawn_placeholder.png"
const Scientist_Sprite = "res://assets/sprites/characters/chr_pawn_placeholder.png"
const SlimeBg_Sprite = "res://assets/sprites/characters/chr_pawn_placeholder.png"
const SlimeSm_Sprite = "res://assets/sprites/characters/chr_pawn_placeholder.png"
const Demon_Sprite = "res://assets/sprites/characters/chr_pawn_placeholder.png"


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
		0: return load(Philosopher_Sprite)
		1: return load(Poet_Sprite)
		2: return load(Priest_Sprite)
		3: return load(Scientist_Sprite)
		4: return load(SlimeSm_Sprite)
		5: return load(SlimeBg_Sprite)
		6: return load(Demon_Sprite)
	

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
