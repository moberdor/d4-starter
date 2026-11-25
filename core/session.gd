## One run at the game: the board and the dragon on it, from the first tick until the
## run ends. Rules that involve more than the dragon (food, score, what the dragon can
## run into) belong here, so Dragon stays about movement and app/ only draws.
class_name Session
extends RefCounted

const GROWTH := 2

var board: Board
var dragon: Dragon
var firefly: Vector2i
var score := 0
var rng := RandomNumberGenerator.new()


func _init(grid_size: Vector2i, rng_seed := 0) -> void:
	board = Board.bordered(grid_size)
	dragon = Dragon.new(grid_size)
	rng.seed = rng_seed
	place_firefly()


## One step of the rules. TODO for D4: collisions with the dragon's own body and with
## solid tiles (board.is_solid). Each needs the dragon and something else, which is
## why they go here rather than in Dragon.tick.
func tick() -> void:
	dragon.tick()
	if dragon.body[0] == firefly:
		score += 1
		dragon.grow(GROWTH)
		place_firefly()


func place_firefly() -> void:
	var free: Array[Vector2i] = []
	for cell in board.tiles:
		if not board.is_solid(cell) and cell not in dragon.body:
			free.append(cell)
	if not free.is_empty():
		firefly = free[rng.randi_range(0, free.size() - 1)]
