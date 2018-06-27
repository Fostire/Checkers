extends TileMap

var boardSize = 8
var grid = []
var halfTile = self.cell_size / 2
var mousePosition
var selectedMen
var menIsSelected = false
var startPositions = []
var men = preload("res://Men.tscn")
var canSkip = false
var canJumpBack = false
signal moved

func _ready():
	new_board()
	set_up_board()

func new_board():
	# for english checkers rules (8x8 board)
	for x in range(boardSize):
		grid.append([])
		for y in range(boardSize):
			grid[x].append(0)
			if y in [3, 4]:
				continue
			else:
				if y % 2 == 0 and x % 2 == 0:
					startPositions.append(Vector2(x, y))
				elif y % 2 != 0 and x % 2 != 0:
					startPositions.append(Vector2(x, y))

func set_up_board():
	# for english checkers rules (8x8 board)
	for pos in startPositions:
		var new_men = men.instance()
		new_men.position = map_to_world(pos) + halfTile
		if pos.y < 3:
			new_men.side = "black"
			grid[pos.x][pos.y] = new_men
		elif pos.y > 4:
			new_men.side = "white"
			grid[pos.x][pos.y] = new_men
		add_child(new_men)

func clear_board():
	for child in self.get_children():
		if child.has_method("deselect"):
			child.queue_free()
	for x in range(boardSize):
		for y in range(boardSize):
			grid[x][y] = 0

func reset_board():
	clear_board()
	set_up_board()

func men_has_valid_moves(menInTile):
	var currentTile = world_to_map(menInTile.position)
	var moveY = 1
	var canMove = false
	var newTile

	for moveX in [-2, -1, 1, 2]:
		if abs(moveX) == 1:
			for moveY in [-1, 1]:
				if menInTile.side == "white" and not menInTile.king and moveY == 1:
					canMove = false
				elif menInTile.side == "black" and not menInTile.king and moveY == -1:
					canMove = false
				else:
					newTile = currentTile + Vector2(moveX, moveY)
					if Rect2(Vector2(0,0), Vector2(boardSize,boardSize)).has_point(newTile):
						if typeof(grid[newTile.x][newTile.y]) == typeof(0):
							canMove = true
		else:
			for moveY in [-2, 2]:
				canMove = valid_skip(currentTile, Vector2(moveX, moveY))
	return canMove

func men_can_jump(menInTile):
	var currentTile = world_to_map(menInTile.position)
	var canJump = false
	for moveX in [-2, 2]:
		for moveY in [-2, 2]:
			if valid_skip(currentTile, Vector2(moveX, moveY)):
				canJump = true
	return canJump

func valid_skip(currentTile, moveVector):
	var oldX = currentTile.x
	var oldY = currentTile.y
	var skipX = oldX + (moveVector / 2).x
	var skipY = oldY + (moveVector / 2).y
	var valid = false
	var newTile = currentTile + moveVector
	var newX = newTile.x
	var newY = newTile.y
	
	if moveVector.abs() == Vector2(2,2):
		if Rect2(Vector2(0,0), Vector2(boardSize,boardSize)).has_point(newTile):
			if typeof(grid[newX][newY]) == typeof(0) and typeof(grid[skipX][skipY]) != typeof(0): #skip position is not empty
				if grid[skipX][skipY].side != grid[oldX][oldY].side:
					valid = true
		
		if not grid[oldX][oldY].king and not global.captureBackwards and not canJumpBack:
			if grid[oldX][oldY].side == "white" and newY > oldY:
				valid = false
			if grid[oldX][oldY].side == "black" and newY < oldY:
				valid = false
	else:
		valid = false
	
	return valid

func move_men(selected, newTile):
	var currentTile = world_to_map(selected.position)
	var skipped = false
	var newX = int(newTile.x)
	var newY = int(newTile.y)
	var oldX = currentTile.x
	var oldY = currentTile.y
	var moveVector = newTile - currentTile
	var skipX = oldX + (moveVector / 2).x
	var skipY = oldY + (moveVector / 2).y


	#check if it's in the board
	if Rect2(Vector2(0,0), Vector2(boardSize,boardSize)).has_point(newTile):
		#check if it's a red square:
		if (newY % 2 == 0 and newX % 2 == 0) or (newY % 2 != 0 and newX % 2 != 0):
			#check how much it's moving:
			if moveVector.abs() == Vector2(1,1) and not canSkip and not selected.mustJump:
				# 1-tile move
				# check if it's king:
				if selected.king:
					# check if it's an empty square:
					if grid[newX][newY] == 0:
						selected.position = map_to_world(newTile) + halfTile
						grid[newX][newY] = grid[oldX][oldY]
						grid[oldX][oldY] = 0
						emit_signal("moved")
				# check if it's moving forward:
				elif moveVector.y < 0 and selected.side == "white" or moveVector.y > 0 and selected.side == "black":
					# check if it's an empty square:
					if grid[newX][newY] == 0:
						selected.position = map_to_world(newTile) + halfTile
						grid[newX][newY] = grid[oldX][oldY]
						grid[oldX][oldY] = 0
						emit_signal("moved")
	
			elif moveVector.abs() == Vector2(2,2):
				# 2-tile move
				# check if it's a valid skip:
				if valid_skip(currentTile, moveVector):
					# move and capture:
					selected.position = map_to_world(newTile) + halfTile
					grid[newX][newY] = grid[oldX][oldY]
					grid[oldX][oldY] = 0
					grid[skipX][skipY].queue_free()
					grid[skipX][skipY] = 0
					currentTile = newTile
					canSkip = false
					canJumpBack = true
					for x in [-2, 2]:
						for y in [-2, 2]:
							if valid_skip(currentTile, Vector2(x, y)):
								canSkip = true
					if not canSkip:
						canJumpBack = false
						emit_signal("moved")


	return canSkip #returns true if a piece was captured




	

