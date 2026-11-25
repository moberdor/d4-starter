## The dragon's rules on the grid: no Nodes, no engine callbacks, testable headless.
class_name Dragon
extends RefCounted

const MAX_QUEUED_TURNS := 2

var size: Vector2i
var body: Array[Vector2i] = []  # head first
var heading := Vector2i.RIGHT
var _turns: Array[Vector2i] = []  # turns wait here until the next tick (Command)
var _growing := 0


func _init(grid_size: Vector2i, length := 4) -> void:
	size = grid_size
	@warning_ignore("integer_division")  # the middle cell, rounded down, on purpose
	var start := grid_size / 2
	for i in length:
		body.append(start - heading * i)


## Queue a turn. Ignored if it would reverse into the neck or repeat the last turn,
## so two quick key presses within one tick still behave.
func turn(direction: Vector2i) -> void:
	var last: Vector2i = heading if _turns.is_empty() else _turns.back()
	if direction == last or direction == -last or _turns.size() >= MAX_QUEUED_TURNS:
		return
	_turns.append(direction)


func grow(cells: int) -> void:
	_growing += cells


## Advance one cell, taking the next queued turn first. Wrapping around the grid is a
## placeholder: once Session ends the run at solid tiles, the dragon never reaches an edge.
func tick() -> void:
	if not _turns.is_empty():
		heading = _turns.pop_front()
	body.push_front(body[0] + heading)
	if _growing > 0:
		_growing -= 1
	else:
		body.pop_back()
