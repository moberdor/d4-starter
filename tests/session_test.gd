extends "res://tests/test_case.gd"


func test_a_tick_moves_the_dragon_head() -> void:
	var session := Session.new(Vector2i(10, 10))
	session.turn(Vector2i.RIGHT)
	session.tick()
	assert_eq(session.dragon.body[0], Vector2i(6, 5))


func test_the_dragon_starts_on_open_floor_inside_a_wall() -> void:
	var session := Session.new(Vector2i(10, 10))
	assert_true(session.board.is_solid(Vector2i(0, 0)))
	assert_true(not session.board.is_solid(session.dragon.body[0]))


func test_eating_a_firefly_scores_and_grows_two() -> void:
	var session := Session.new(Vector2i(20, 20))
	session.firefly = Vector2i(11, 10)
	session.turn(Vector2i.RIGHT)
	for i in 3:
		session.tick()
	assert_eq(session.score, 1)
	assert_eq(session.dragon.body.size(), 4 + Session.GROWTH)


func test_fireflies_never_land_on_the_body() -> void:
	var session := Session.new(Vector2i(8, 5))
	for i in 100:
		session.place_firefly()
		assert_true(session.firefly not in session.dragon.body)
		assert_true(not session.board.is_solid(session.firefly))


func test_same_seed_same_fireflies() -> void:
	var a := Session.new(Vector2i(20, 20), 7)
	var b := Session.new(Vector2i(20, 20), 7)
	assert_eq(a.firefly, b.firefly)


func test_nothing_moves_before_the_first_arrow_key() -> void:
	var session := Session.new(Vector2i(10, 10))
	var body := session.dragon.body.duplicate()
	for i in 5:
		session.tick()
	assert_eq(session.dragon.body, body)
	session.turn(Vector2i.UP)
	session.tick()
	assert_eq(session.dragon.body[0], Vector2i(5, 4))


func test_hitting_a_wall_ends_the_run() -> void:
	var session := Session.new(Vector2i(10, 10))
	session.turn(Vector2i.UP)
	for i in 5:
		session.tick()
	assert_true(session.over)
	var body := session.dragon.body.duplicate()
	session.tick()
	assert_eq(session.dragon.body, body)


func test_biting_the_body_ends_the_run() -> void:
	var session := _curled()
	session.dragon.body.append(Vector2i(4, 4))
	session.tick()
	assert_true(session.over)


func test_chasing_the_tail_is_safe() -> void:
	var session := _curled()
	session.tick()
	assert_true(not session.over)
	assert_eq(session.dragon.body[0], Vector2i(4, 5))


func _curled() -> Session:
	var session := Session.new(Vector2i(10, 10))
	var body: Array[Vector2i] = [Vector2i(5, 5), Vector2i(5, 6), Vector2i(4, 6), Vector2i(4, 5)]
	session.dragon.body = body
	session.dragon.heading = Vector2i.UP
	session.turn(Vector2i.LEFT)
	return session
