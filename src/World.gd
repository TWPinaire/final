extends Node3D
class_name WorldClass

const Utils = preload("res://src/utils.gd")


func tileLink(root, height, AllyList=null):
	var pq = [root]
	while !pq.is_empty():
		var thisTile : TileClass = pq.pop_front()
		for neighbor in thisTile.get_neighbors(height):
			if !neighbor.root and neighbor != root:
				if !(neighbor.is_taken() and AllyList and !neighbor.get_object_above() in AllyList):
					neighbor.root = thisTile
					neighbor.distance = thisTile.distance+1
					pq.push_back(neighbor)


func hoverMark(tile : TileClass):
	for t in $Tiles.get_children(): t.hover = false
	if tile: tile.hover = true


func reachableTiles(root : TileClass, distance):
	for t in $Tiles.get_children():
		t.reachable = t.distance > 0 and t.distance <= distance and !t.is_taken() or t == root


func attackableTiles(root : TileClass, distance):
	for t in $Tiles.get_children():
		t.attackable = t.distance > 0 and t.distance <= distance or t == root


func pathGen(to):
	var pathList = []
	while to:
		pathList.push_front(to.global_transform.origin)
		to = to.root
	return pathList


func reset():
	for t in $Tiles.get_children(): t.reset()


func _ready():
	$Tiles.visible = true
	Utils.convert_tiles_into_static_bodies($Tiles)


func nearestNeighbhor(pawn, pawnList):
	var nearest_t = null
	for p in pawnList:
		if p.curr_health <= 0: continue
		for n in p.get_tile().get_neighbors(pawn.jump_height):
			if (!nearest_t or n.distance < nearest_t.distance) and n.distance > 0 and !n.is_taken():
				nearest_t = n
	while nearest_t and !nearest_t.reachable: nearest_t = nearest_t.root
	return nearest_t if nearest_t else pawn.get_tile()


func getWeakest(pawnList):
	var weakest = null
	for p in pawnList:
		if (!weakest or p.curr_health < weakest.curr_health) and p.curr_health > 0 and p.get_tile().attackable:
			weakest = p
	return weakest
